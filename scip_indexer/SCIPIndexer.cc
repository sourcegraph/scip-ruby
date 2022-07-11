// NOTE: Protobuf headers should go first since they use poisoned functions.
#include "proto/SCIP.pb.h"

#include <fstream>
#include <iterator>
#include <memory>
#include <optional>
#include <string>

#include <cxxopts.hpp>

#include "absl/status/status.h"
#include "absl/status/statusor.h"
#include "absl/strings/str_cat.h"
#include "absl/synchronization/mutex.h"
#include "spdlog/fmt/fmt.h"

#include "ast/Trees.h"
#include "ast/treemap/treemap.h"
#include "cfg/CFG.h"
#include "common/common.h"
#include "common/sort.h"
#include "core/ErrorQueue.h"
#include "core/Loc.h"
#include "core/SymbolRef.h"
#include "core/Symbols.h"
#include "main/pipeline/semantic_extension/SemanticExtension.h"
#include "sorbet_version/sorbet_version.h"

#include "scip_indexer/SCIPUtils.h"

using namespace std;

// Wrapper for quickly commenting out print lines.
template <typename... T> FMT_INLINE static void print_dbg(fmt::format_string<T...> fmt, T &&...args) {
    return;
}

template <typename... T> FMT_INLINE static void print_err(fmt::format_string<T...> fmt, T &&...args) {
    return fmt::print(fmt, args...);
}

template <typename K, typename V, typename Fn> static string map_to_string(const sorbet::UnorderedMap<K, V> m, Fn f) {
    ostringstream out;
    out << "{";
    auto i = -1;
    for (auto &[k, v] : m) {
        i++;
        out << f(k, v);
        if (i != m.size() - 1) {
            out << ", ";
        }
    }
    out << "}";
    return out.str();
}

template <typename T, typename Fn> static string vec_to_string(const vector<T> v, Fn f) {
    ostringstream out;
    out << "[";
    for (auto i = 0; i < v.size(); ++i) {
        out << f(v[i]);
        if (i != v.size() - 1) {
            out << ", ";
        }
    }
    out << "]";
    return out.str();
}

template <typename T> static void drain(vector<T> &input, vector<T> &output) {
    output.reserve(output.size() + input.size());
    for (auto &v : input) {
        output.push_back(move(v));
    }
    input.clear();
}

/** 32-bit FNV-1a hash function.

  Technically, these hashes are only used for local variables, so if they change
  from run-to-run, that is fine from a code navigation perspective. (It would be a
  problem if they were use for cross-file navigation, but that's not applicable here.)

  However, having stable hashes is useful for snapshot testing. Normally, we'd use
  absl::Hash but it isn't guaranteed to be stable across runs.
*/
static uint32_t fnv1a_32(const string &s) {
    uint32_t h = 2166136261;
    for (auto c : s) {
        h ^= uint32_t(c);
        h *= 16777619;
    }
    return h;
}

namespace sorbet::scip_indexer {

// TODO(varun): This is an inline workaround for https://github.com/sorbet/sorbet/issues/5925
// I've not changed the main definition because I didn't bother to rerun the tests with the change.
static bool isTemporary(const core::GlobalState &gs, const core::LocalVariable &var) {
    using namespace sorbet::core;
    if (var.isSyntheticTemporary(gs)) {
        return true;
    }
    auto n = var._name;
    return n == Names::blockPreCallTemp() || n == Names::blockTemp() || n == Names::blockPassTemp() ||
           n == Names::blkArg() || n == Names::blockCall() || n == Names::blockBreakAssign() || n == Names::forTemp() ||
           // Insert checks because sometimes temporaries are initialized with a 0 unique value. 😬
           n == Names::finalReturn() || n == NameRef::noName() || n == Names::blockCall() || n == Names::selfLocal() ||
           n == Names::unconditional();
}

struct OwnedLocal {
    /// Parent method.
    const core::SymbolRef owner;
    /// Counter corresponding to the local's definition, unique within a method.
    uint32_t counter;
    /// Location for the occurrence.
    core::LocOffsets offsets;

    string toString(const core::GlobalState &gs, core::FileRef file) {
        // 32-bits => if there are 10k methods in a single file, the chance of at least one
        // colliding pair is about 1.1%, assuming even distribution. That seems OK.
        return fmt::format("local {:x}~#{}", counter, ::fnv1a_32(owner.name(gs).show(gs)));
    }
};

// Returns true if we were able to compute a symbol for the expression.
absl::Status symbolForExpr(const core::GlobalState &gs, core::SymbolRef symRef, scip::Symbol &symbol) {
    // Don't set symbol.scheme and package.manager here because those are hard-coded to 'scip-ruby' and 'gem' anyways.
    scip::Package package;
    package.set_name("TODO");
    package.set_version("TODO");
    *symbol.mutable_package() = move(package);

    scip::Descriptor descriptor;
    *descriptor.mutable_name() = symRef.name(gs).show(gs);

    // TODO: Are the scip descriptor kinds correct?
    switch (symRef.kind()) {
        case core::SymbolRef::Kind::Method:
            // NOTE: There is a separate isOverloaded field in the flags field,
            // despite SO/docs saying that Ruby doesn't support method overloading,
            // Technically, we should better understand how this works and set the
            // disambiguator based on that. However, right now, an extension's
            // type-checking function is not run if a method is overloaded,
            // (see pipeline.cc), so it's unclear if we need to care about that.
            descriptor.set_suffix(scip::Descriptor::Method);
            break;
        case core::SymbolRef::Kind::ClassOrModule:
            descriptor.set_suffix(scip::Descriptor::Type);
            break;
        case core::SymbolRef::Kind::TypeArgument:
            descriptor.set_suffix(scip::Descriptor::TypeParameter);
            break;
        case core::SymbolRef::Kind::FieldOrStaticField:
            descriptor.set_suffix(scip::Descriptor::Term);
            break;
        case core::SymbolRef::Kind::TypeMember: // TODO: What does TypeMember mean?
            descriptor.set_suffix(scip::Descriptor::Type);
            break;
        default:
            return absl::InvalidArgumentError("unexpected expr type for symbol computation");
    }
    *symbol.add_descriptors() = move(descriptor);
    return absl::OkStatus();
}

InlinedVector<int32_t, 4> fromSorbetLoc(const core::GlobalState &gs, core::Loc loc) {
    ENFORCE_NO_TIMER(!loc.empty());
    auto [start, end] = loc.position(gs);
    ENFORCE_NO_TIMER(start.line <= INT32_MAX && start.column <= INT32_MAX);
    ENFORCE(end.line <= INT32_MAX && end.column <= INT32_MAX);
    InlinedVector<int32_t, 4> r;
    r.push_back(start.line - 1);
    r.push_back(start.column - 1);
    if (start.line != end.line) {
        r.push_back(end.line - 1);
    }
    r.push_back(end.column - 1);
    return r;
}

absl::StatusOr<core::Loc> occurrenceLoc(const core::GlobalState &gs, const core::SymbolRef symRef) {
    // FIXME(varun): For methods, this returns the full line!
    return symRef.loc(gs);
}

class SCIPState {
    string symbolScratchBuffer;
    UnorderedMap<core::SymbolRef, string> symbolStringCache;

public:
    UnorderedMap<core::FileRef, vector<scip::Occurrence>> occurrenceMap;
    UnorderedMap<core::FileRef, vector<scip::SymbolInformation>> symbolMap;
    // Cache of occurrences for locals that have been emitted in this function.
    //
    // Note that the SymbolRole is a part of the key too, because we can
    // have a read-reference and write-reference at the same location
    // (we don't merge those for now).
    //
    // The 'value' in the map is purely for sanity-checking. It's a bit
    // cumbersome to conditionalize the type to be a set in non-debug and
    // map in debug, so keeping it a map.
    UnorderedMap<std::pair<core::LocOffsets, /*SymbolRole*/ int32_t>, uint32_t> localOccurrenceCache;
    vector<scip::Document> documents;
    vector<scip::SymbolInformation> externalSymbols;

public:
    SCIPState() = default;
    ~SCIPState() = default;
    SCIPState(SCIPState &&) = default;
    SCIPState &operator=(SCIPState &&other) = default;
    // Make move-only to avoid accidental copy of large Documents/maps.
    SCIPState(const SCIPState &) = delete;
    SCIPState &operator=(const SCIPState &other) = delete;

    // If the returned value is as success, the pointer is non-null.
    //
    // The argument symbol is used instead of recomputing from scratch if it is non-null.
    absl::StatusOr<string *> saveSymbolString(const core::GlobalState &gs, core::SymbolRef symRef,
                                              const scip::Symbol *symbol) {
        auto pair = this->symbolStringCache.find(symRef);
        if (pair != this->symbolStringCache.end()) {
            return &pair->second;
        }

        this->symbolScratchBuffer.clear();

        absl::Status status;
        if (symbol) {
            status = scip::utils::emitSymbolString(*symbol, this->symbolScratchBuffer);
        } else {
            scip::Symbol symbol;
            status = symbolForExpr(gs, symRef, symbol);
            if (!status.ok()) {
                return status;
            }
            status = scip::utils::emitSymbolString(symbol, this->symbolScratchBuffer);
        }
        if (!status.ok()) {
            return status;
        }
        symbolStringCache.insert({symRef, this->symbolScratchBuffer});
        return &symbolStringCache[symRef];
    }

private:
    absl::Status saveDefinitionImpl(const core::GlobalState &gs, core::FileRef file, const string &symbolString,
                                    core::Loc occLoc) {
        scip::SymbolInformation symbolInfo;
        symbolInfo.set_symbol(symbolString);
        this->symbolMap[file].push_back(symbolInfo);

        scip::Occurrence occurrence;
        occurrence.set_symbol(symbolString);
        occurrence.set_symbol_roles(scip::SymbolRole::Definition);
        for (auto val : sorbet::scip_indexer::fromSorbetLoc(gs, occLoc)) {
            occurrence.add_range(val);
        }
        this->occurrenceMap[file].push_back(occurrence);
        // TODO(varun): When should we fill out the diagnostics and override_docs fields?
        return absl::OkStatus();
    }

    absl::Status saveReferenceImpl(const core::GlobalState &gs, core::FileRef file, const string &symbolString,
                                   core::LocOffsets occLoc, int32_t symbol_roles) {
        scip::Occurrence occurrence;
        occurrence.set_symbol(symbolString);
        occurrence.set_symbol_roles(symbol_roles);
        for (auto val : sorbet::scip_indexer::fromSorbetLoc(gs, core::Loc(file, occLoc))) {
            occurrence.add_range(val);
        }
        this->occurrenceMap[file].push_back(occurrence);
        // TODO(varun): When should we fill out the diagnostics field?
        return absl::OkStatus();
    }

    // Returns true if there was a cache hit.
    //
    // Otherwise, inserts the location into the cache and returns false.
    bool cacheOccurrence(const core::GlobalState &gs, core::FileRef file, OwnedLocal occ, int32_t symbolRoles) {
        // Optimization:
        //   Avoid emitting duplicate defs/refs for locals.
        //   This can happen with constructs like:
        //     z = if cond then expr else expr end
        //   When this is lowered to a CFG, we will end up with
        //   multiple bindings with the same LHS location.
        //
        //   Repeated reads for the same occurrence can happen for rvalues too.
        //   If the compiler has proof that a scrutinee variable is not modified,
        //   each comparison in a case will perform a read.
        //     case x
        //       when 0 then <stuff>
        //       when 1 then <stuff>
        //       else <stuff>
        //     end
        //   The CFG for this involves two reads for x in calls to ==.
        //   (This wouldn't have happened if x was always stashed away into
        //    a temporary first, but the temporary only appears in the CFG if
        //    evaluating one of the cases has a chance to modify x.)
        auto [it, inserted] = this->localOccurrenceCache.insert({{occ.offsets, symbolRoles}, occ.counter});
        if (inserted) {
            return false;
        }
        auto savedCounter = it->second;
        ENFORCE(occ.counter == savedCounter, "cannot have distinct local variable {} at same location {}",
                (symbolRoles & scip::SymbolRole::Definition) ? "definitions" : "references",
                core::Loc(file, occ.offsets).showRaw(gs));
        return true;
    }

public:
    absl::Status saveDefinition(const core::GlobalState &gs, core::FileRef file, OwnedLocal occ) {
        if (this->cacheOccurrence(gs, file, occ, scip::SymbolRole::Definition)) {
            return absl::OkStatus();
        }
        return this->saveDefinitionImpl(gs, file, occ.toString(gs, file), core::Loc(file, occ.offsets));
    }

    // Save definition when you have a sorbet Symbol.
    // Meant for methods, fields etc., but not local variables.
    absl::Status saveDefinition(const core::GlobalState &gs, core::FileRef file, core::SymbolRef symRef) {
        // TODO:(varun) Should we cache here too to avoid emitting duplicate definitions?
        scip::Symbol symbol;
        auto status = symbolForExpr(gs, symRef, symbol);
        if (!status.ok()) {
            return status;
        }
        absl::StatusOr<string *> valueOrStatus(this->saveSymbolString(gs, symRef, &symbol));
        if (!valueOrStatus.ok()) {
            return valueOrStatus.status();
        }
        string &symbolString = *valueOrStatus.value();
        auto occLocStatus = occurrenceLoc(gs, symRef);
        if (!occLocStatus.ok()) {
            return occLocStatus.status();
        }
        return this->saveDefinitionImpl(gs, file, symbolString, occLocStatus.value());
    }

    absl::Status saveReference(const core::GlobalState &gs, core::FileRef file, OwnedLocal occ, int32_t symbol_roles) {
        if (this->cacheOccurrence(gs, file, occ, symbol_roles)) {
            return absl::OkStatus();
        }
        return this->saveReferenceImpl(gs, file, occ.toString(gs, file), occ.offsets, symbol_roles);
    }

    absl::Status saveReference(const core::GlobalState &gs, core::FileRef file, core::SymbolRef symRef,
                               core::LocOffsets occLoc, int32_t symbol_roles) {
        // TODO:(varun) Should we cache here to to avoid emitting duplicate references?
        absl::StatusOr<string *> valueOrStatus(this->saveSymbolString(gs, symRef, nullptr));
        if (!valueOrStatus.ok()) {
            return valueOrStatus.status();
        }
        string &symbolString = *valueOrStatus.value();
        return this->saveReferenceImpl(gs, file, symbolString, occLoc, symbol_roles);
    }

    void saveDocument(const core::GlobalState &gs, const core::FileRef file) {
        scip::Document document;
        // TODO(varun): Double-check the path code and maybe document it,
        // to make sure its guarantees match what SCIP expects.
        document.set_relative_path(string(file.data(gs).path()));

        auto occurrences = this->occurrenceMap.find(file);
        if (occurrences != this->occurrenceMap.end()) {
            for (auto &occurrence : occurrences->second) {
                *document.add_occurrences() = move(occurrence);
            }
            this->occurrenceMap.erase(file);
        }

        auto symbols = this->symbolMap.find(file);
        if (symbols != this->symbolMap.end()) {
            for (auto &symbol : symbols->second) {
                *document.add_symbols() = move(symbol);
            }
            this->symbolMap.erase(file);
        }

        this->documents.push_back(move(document));
    }
};

core::SymbolRef lookupRecursive(const core::GlobalState &gs, const core::SymbolRef owner, core::NameRef name) {
    if (!owner.exists()) {
        return core::SymbolRef();
    }
    ENFORCE(name.exists(), "non-existent name passed for lookup 😧")
    string ownerNameString = owner.name(gs).exists() ? owner.name(gs).toString(gs) : "<no name>";
    print_dbg("# looking up {} in {}\n", name.toString(gs), ownerNameString);
    if (owner.isClassOrModule()) {
        auto symRef = gs.lookupSymbol(owner.asClassOrModuleRef(), name);
        if (symRef.exists()) {
            return symRef;
        }
        if (owner.owner(gs) == owner) {
            return core::SymbolRef();
        }
        return lookupRecursive(gs, owner.owner(gs), name);
    }
    return lookupRecursive(gs, owner.enclosingClass(gs), name);
}

class CFGTraversal final {
    // A map from each basic block to the locals in it.
    //
    // The locals may be coming from the parents, or they may be defined in the
    // block. Locals coming from the parents may be in the form of basic block
    // arguments or they may be "directly referenced."
    //
    // For example, if you have code like:
    //
    //     def f(x):
    //         y = 0
    //         if cond:
    //             y = x + $z
    //
    // Then x and $z will be passed as arguments to the basic block for the
    // true branch, whereas 'y' won't be. However, 'y' is still technically
    // coming from the parent basic block, otherwise we'd end up marking the
    // assignment as a definition instead of a (write) reference.
    //
    // At the start of the traversal of a basic block, the entry for a basic
    // block is populated with the locals coming from the parents. Then,
    // we traverse each instruction and populate it with the locals defined
    // in the block.
    UnorderedMap<const cfg::BasicBlock *, UnorderedSet<cfg::LocalRef>> blockLocals;
    UnorderedMap<cfg::LocalRef, uint32_t> functionLocals;

    // Local variable counter that is reset for every function.
    uint32_t counter = 0;
    SCIPState &scipState;
    core::Context ctx;

public:
    CFGTraversal(SCIPState &scipState, core::Context ctx)
        : blockLocals(), functionLocals(), scipState(scipState), ctx(ctx) {}

private:
    void addLocal(const cfg::BasicBlock *bb, cfg::LocalRef localRef) {
        this->blockLocals[bb].insert(localRef);
        this->functionLocals[localRef] = ++this->counter;
    }

    static core::LocOffsets lhsLocIfPresent(const cfg::Binding &binding) {
        auto lhsLoc = binding.bind.loc;
        // FIXME(varun): Right now, the locations aren't being propagated for arguments correctly,
        // so fallback instead of crashing.
        return lhsLoc.exists() ? lhsLoc : binding.loc;
    }

    enum class ValueCategory : bool {
        LValue,
        RValue,
    };

    // Emit an occurrence for a local variable if applicable.
    //
    // Returns true if an occurrence was emitted.
    bool emitLocalOccurrence(const cfg::CFG &cfg, const cfg::BasicBlock *bb, cfg::LocalOccurrence local,
                             ValueCategory category) {
        auto localRef = local.variable;
        auto localVar = localRef.data(cfg);
        if (isTemporary(ctx.state, localVar)) {
            return false;
        }
        scip::SymbolRole referenceRole;
        bool isDefinition = false;
        switch (category) {
            case ValueCategory::LValue: {
                referenceRole = scip::SymbolRole::WriteAccess;
                if (!this->functionLocals.contains(localRef)) {
                    isDefinition = true; // If we're seeing this for the first time in topological order,
                                         // The current block must have a definition for the variable.
                    this->addLocal(bb, localRef);
                }
                // The variable wasn't passed in as an argument, and hasn't already been recorded
                // as a local in the block. So this must be a definition line.
                isDefinition = isDefinition || !this->blockLocals[bb].contains(localRef);
                break;
            }
            case ValueCategory::RValue: {
                referenceRole = scip::SymbolRole::ReadAccess;

                if (!this->functionLocals.contains(localRef)) {
                    // Ill-formed code where we're trying to access a variable
                    // without setting it first. Emit a local as a best-effort.
                    // TODO(varun): Will Sorbet error out before we get here?
                    this->addLocal(bb, localRef);
                }
                // TODO(varun): Will Sorbet error out before we get here?
                // It's possible that we have ill-formed code where the variable
                // is defined in some other basic block, and tried to access it
                // here even though it's not available in this block. In such
                // a case, perhaps we should emit a diagnostic instead of a reference?
                if (!this->blockLocals[bb].contains(localRef)) {
                    print_dbg("# ill-formed code where variable is accessed before use");
                }
                break;
            }
            default:
                ENFORCE(false, "unhandled case of ValueCategory")
        }
        ENFORCE(this->functionLocals.contains(localRef), "should've added local earlier if it was missing");
        uint32_t localId = this->functionLocals[localRef];
        absl::Status status;
        if (isDefinition) {
            status = this->scipState.saveDefinition(this->ctx.state, this->ctx.file,
                                                    OwnedLocal{this->ctx.owner, localId, local.loc});
        } else {
            status = this->scipState.saveReference(this->ctx.state, this->ctx.file,
                                                   OwnedLocal{this->ctx.owner, localId, local.loc}, referenceRole);
        }
        ENFORCE_NO_TIMER(status.ok());
        return true;
    }

    void copyLocalsFromParents(cfg::BasicBlock *bb, const cfg::CFG &cfg) {
        UnorderedSet<cfg::LocalRef> bbLocals{};
        for (auto parentBB : bb->backEdges) {
            if (!this->blockLocals.contains(parentBB)) { // e.g. loops
                continue;
            }
            auto &parentLocals = this->blockLocals[parentBB];
            if (bbLocals.size() + parentLocals.size() > bbLocals.capacity()) {
                bbLocals.reserve(bbLocals.size() + parentLocals.size());
            }
            for (auto local : parentLocals) {
                bbLocals.insert(local);
            }
        }
        ENFORCE(!this->blockLocals.contains(bb));
        this->blockLocals[bb] = std::move(bbLocals);
    }

public:
    void traverse(const cfg::CFG &cfg) {
        auto &gs = this->ctx.state;
        auto method = this->ctx.owner;

        // I don't fully understand the doc comment for forwardsTopoSort; it seems backwards in practice.
        for (auto it = cfg.forwardsTopoSort.rbegin(); it != cfg.forwardsTopoSort.rend(); ++it) {
            cfg::BasicBlock *bb = *it;
            print_dbg("# Looking at block id: {} ptr: {}\n", bb->id, (void *)bb);
            this->copyLocalsFromParents(bb, cfg);
            for (auto &binding : bb->exprs) {
                if (!binding.loc.exists() || binding.loc.empty()) { // TODO(varun): When can each case happen?
                    continue;
                }
                // Emit occurrence information for the LHS
                this->emitLocalOccurrence(cfg, bb,
                                          cfg::LocalOccurrence{binding.bind.variable, lhsLocIfPresent(binding)},
                                          ValueCategory::LValue);
                // Emit occurrence information for the RHS
                auto emitLocal = [this, &cfg, &bb, &binding](cfg::LocalRef local) -> void {
                    (void)this->emitLocalOccurrence(cfg, bb, cfg::LocalOccurrence{local, binding.loc},
                                                    ValueCategory::RValue);
                };
                switch (binding.value.tag()) {
                    case cfg::Tag::Literal: {
                        // RHS is a literal, not occurrence information needed.
                        break;
                    }
                    case cfg::Tag::Ident: {
                        auto ident = cfg::cast_instruction<cfg::Ident>(binding.value);
                        emitLocal(ident->what);
                        break;
                    }
                    case cfg::Tag::Send: {
                        // emit occurrence for function
                        auto send = cfg::cast_instruction<cfg::Send>(binding.value);

                        // Emit reference for the receiver, if present.
                        if (send->recv.loc.exists() && !send->recv.loc.empty()) {
                            this->emitLocalOccurrence(cfg, bb, send->recv.occurrence(), ValueCategory::RValue);
                        }

                        // TODO:(varun) For arrays, hashes etc., try to identify if the function
                        // matches a known operator (e.g. []=), and emit an appropriate 'WriteAccess'
                        // symbol role for it.

                        // Emit reference for the method being called
                        if (send->fun.exists() && !isTemporary(gs, core::LocalVariable(send->fun, 1))) {
                            // HACK(varun): We should probably add a helper function to check
                            // for names corresponding to temporaries? Making up a fake local
                            // variable seems a little gross.
                            auto funSym = lookupRecursive(gs, method, send->fun);
                            if (funSym.exists()) {
                                ENFORCE(send->funLoc.exists() && !send->funLoc.empty());
                                auto status =
                                    this->scipState.saveReference(gs, this->ctx.file, funSym, send->funLoc, 0);
                                ENFORCE(status.ok());
                            }
                            print_err("# lookup for fun symbol {} failed\n", send->fun.shortName(gs));
                        }

                        // Emit references for arguments
                        for (auto &arg : send->args) {
                            // NOTE: For constructs like a += b, the instruction sequence ends up being:
                            //   $tmp = $a
                            //   $a = $tmp.+($b)
                            // The location for $tmp will point to $a in the source. However, the second one is a read,
                            // and the first one is a write. Instead of emitting two occurrences, it'd be nice to emit
                            // a combined read-write occurrence. However, that would require complicating the code a
                            // bit, so let's leave it as-is for now.
                            this->emitLocalOccurrence(cfg, bb, arg.occurrence(), ValueCategory::RValue);
                        }

                        break;
                    }
                    case cfg::Tag::Alias: {
                        auto alias = cfg::cast_instruction<cfg::Alias>(binding.value);
                        auto aliasedSym = alias->what;
                        if (!aliasedSym.exists()) {
                            if (!alias->name.exists()) {
                                print_dbg("# alias name doesn't exist @ {}, what = {}\n",
                                          core::Loc(this->ctx.file, binding.loc).showRaw(gs), alias->what.showRaw(gs));
                                break;
                            }
                            print_dbg("# missing symbol for RHS {}\n", alias->name.shortName(gs));
                            break;
                        } else if (aliasedSym == core::Symbols::Magic()) {
                            break;
                        }
                        absl::Status status =
                            this->scipState.saveReference(gs, this->ctx.file, aliasedSym, binding.loc, 0);
                        print_err("# emitted ref for\n{}@ {}\n------------------\n", aliasedSym.toString(gs),
                                  core::Loc(this->ctx.file, binding.loc).showRaw(gs));
                        ENFORCE(status.ok());
                        this->addLocal(bb, binding.bind.variable);
                        break;
                    }
                    case cfg::Tag::Return: {
                        auto return_ = cfg::cast_instruction<cfg::Return>(binding.value);
                        emitLocal(return_->what.variable);
                        break;
                    }
                    case cfg::Tag::BlockReturn: {
                        auto blockReturn = cfg::cast_instruction<cfg::BlockReturn>(binding.value);
                        emitLocal(blockReturn->what.variable); // TODO(varun): When are BlockReturns generated?
                        break;
                    }
                    case cfg::Tag::Cast: {
                        auto cast = cfg::cast_instruction<cfg::Cast>(binding.value);
                        emitLocal(cast->value.variable); // TODO(varun): What is this generated?
                        break;
                    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-fallthrough"
                    case cfg::Tag::SolveConstraint:
                    case cfg::Tag::TAbsurd:
                    case cfg::Tag::LoadSelf:
                    case cfg::Tag::YieldLoadArg:
                    case cfg::Tag::GetCurrentException:
                    case cfg::Tag::LoadArg:
                    case cfg::Tag::ArgPresent:
                    case cfg::Tag::LoadYieldParams:
#pragma clang diagnostic pop
                    case cfg::Tag::YieldParamPresent: {
                        break;
                    }
                }
            }
        }
    }
};

} // end namespace sorbet::scip_indexer

namespace sorbet::pipeline::semantic_extension {

using LocalSymbolTable = UnorderedMap<core::LocalVariable, core::Loc>;

class SCIPSemanticExtension : public SemanticExtension {
public:
    string indexFilePath;

    using SCIPState = sorbet::scip_indexer::SCIPState;

    mutable struct {
        UnorderedMap<thread::id, shared_ptr<SCIPState>> states;
        absl::Mutex mtx;
    } mutableState;

    // Return a shared_ptr here as we need a stable address to avoid an invalid reference
    // on table resizing, and we need to maintain at least two pointers,
    // an "owning ref" from the table and a mutable borrow from the caller.
    shared_ptr<SCIPState> getSCIPState() const {
        {
            absl::ReaderMutexLock lock(&mutableState.mtx);
            if (mutableState.states.contains(this_thread::get_id())) {
                return mutableState.states.at(this_thread::get_id());
            }
        }
        {
            absl::WriterMutexLock lock(&mutableState.mtx);
            //
            // We will move the state out later, so use a no-op deleter.
            return mutableState.states[this_thread::get_id()] =
                       shared_ptr<SCIPState>(new SCIPState(), [](SCIPState *) {});
        }
    }

    void emitSymbol(const core::GlobalState &gs, core::FileRef file, ast::ClassDef *cd) const {
        auto classLoc = core::Loc(file, cd->name.loc());
    }

    void run(core::MutableContext &ctx, ast::ClassDef *cd) const override {
        // FIXME:(varun) This is a no-op???
        emitSymbol(ctx.state, ctx.file, cd);
    };
    virtual void finishTypecheckFile(const core::GlobalState &gs, const core::FileRef &file) const override {
        getSCIPState()->saveDocument(gs, file);
    };
    virtual void finishTypecheck(const core::GlobalState &gs) const override {
        scip::ToolInfo toolInfo;
        toolInfo.set_name("scip-ruby");
        toolInfo.set_version(sorbet_version);
        *toolInfo.add_arguments() = "FIXME"; // FIXME(varun): GlobalState doesn't have access to CLI arguments. 🙁

        scip::Metadata metadata;
        metadata.set_version(scip::UnspecifiedProtocolVersion);
        *metadata.mutable_tool_info() = toolInfo;
        metadata.set_project_root("file://Users/varun/Code/scip-ruby"); // FIXME(varun): Remove hard-coded string
        metadata.set_text_document_encoding(scip::TextEncoding::UTF8);

        vector<SCIPState> allStates;
        {
            absl::WriterMutexLock lock(&this->mutableState.mtx);
            for (auto &[_, state] : this->mutableState.states) {
                // OK to do because the shared_ptr has a no-op deleter.
                allStates.push_back(move(*state.get()));
            }
            this->mutableState.states.clear();
        }

        vector<scip::Document> allDocuments;
        vector<scip::SymbolInformation> allExternalSymbols;
        for (auto &state : allStates) {
            drain(state.documents, allDocuments);
            drain(state.externalSymbols, allExternalSymbols);
        }
        // Sort for fully deterministic output.
        fast_sort(allDocuments, [](const scip::Document &d1, const scip::Document &d2) -> bool {
            return d1.relative_path() < d2.relative_path();
        });
        fast_sort(allExternalSymbols, [](const scip::SymbolInformation &s1, const scip::SymbolInformation &s2) -> bool {
            return s1.symbol() < s2.symbol();
        });

        scip::Index index;
        *index.mutable_metadata() = metadata;
        for (auto &document : allDocuments) {
            *index.add_documents() = move(document);
        }
        for (auto &symbol : allExternalSymbols) {
            *index.add_external_symbols() = move(symbol);
        }

        ofstream out(indexFilePath);
        // TODO: Is it OK to do I/O here? Or should it be elsewhere?
        index.SerializeToOstream(&out);
        out.close();
    };

    virtual void typecheck(const core::GlobalState &gs, core::FileRef file, cfg::CFG &cfg,
                           ast::MethodDef &methodDef) const override {
        if (methodDef.flags.isRewriterSynthesized) { // TODO: What should we do for these?
            return;
        }

        auto scipState = this->getSCIPState();
        auto status = scipState->saveDefinition(gs, file, core::SymbolRef(methodDef.symbol));
        ENFORCE(status.ok());
        // It looks like Sorbet only stores symbols at the granularity of classes and methods
        // So we need to recompute local variable information from scratch. The LocalVarFinder
        // which is used by the LSP implementation is tailored for finding the local variable
        // specific to a range, so directly using that would lead to recomputing local variable
        // information repeatedly for each occurrence.

        sorbet::scip_indexer::CFGTraversal traversal(*scipState.get(), core::Context(gs, methodDef.symbol, file));
        traversal.traverse(cfg);
    }

    virtual unique_ptr<SemanticExtension> deepCopy(const core::GlobalState &from, core::GlobalState &to) override {
        return make_unique<SCIPSemanticExtension>(this->indexFilePath);
    };
    virtual void merge(const core::GlobalState &from, core::GlobalState &to, core::NameSubstitution &subst) override{};

    SCIPSemanticExtension(string indexFilePath) : indexFilePath(indexFilePath), mutableState() {}
    ~SCIPSemanticExtension() {}
};

class SCIPSemanticExtensionProvider : public SemanticExtensionProvider {
public:
    void injectOptions(cxxopts::Options &optsBuilder) const override {
        optsBuilder.add_options("indexer")("index-file", "Output SCIP index to a directory, which must already exist",
                                           cxxopts::value<string>());
    };
    unique_ptr<SemanticExtension> readOptions(cxxopts::ParseResult &providedOptions) const override {
        if (providedOptions.count("index-file") > 0) {
            return make_unique<SCIPSemanticExtension>(providedOptions["index-file"].as<string>());
        }
        return this->defaultInstance();
    };
    virtual unique_ptr<SemanticExtension> defaultInstance() const override {
        return make_unique<SCIPSemanticExtension>("index.scip");
    };
    static vector<SemanticExtensionProvider *> getProviders();
    virtual ~SCIPSemanticExtensionProvider() = default;
};

vector<SemanticExtensionProvider *> SemanticExtensionProvider::getProviders() {
    static SCIPSemanticExtensionProvider scipExtension;
    return {&scipExtension};
}
} // namespace sorbet::pipeline::semantic_extension
