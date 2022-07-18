// NOTE: Protobuf headers should go first since they use poisoned functions.
#include "proto/SCIP.pb.h"

#include <fstream>
#include <iterator>
#include <memory>
#include <optional>
#include <string>

#include <cxxopts.hpp>

#include "absl/hash/hash.h"
#include "absl/status/status.h"
#include "absl/status/statusor.h"
#include "absl/strings/str_cat.h"
#include "absl/strings/str_split.h"
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
    if (var.isSyntheticTemporary()) {
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

class GemMetadata final {
    string _name;
    string _version;

    GemMetadata(string name, string version) : _name(name), _version(version) {}

public:
    GemMetadata &operator=(const GemMetadata &) = default;

    static GemMetadata tryParseOrDefault(string metadata) {
        vector<string> v = absl::StrSplit(metadata, '@');
        if (v.size() != 2 || v[0].empty() || v[1].empty()) {
            return GemMetadata{"TODO", "TODO"};
        }
        return GemMetadata{v[0], v[1]};
    }

    const std::string &name() const {
        return this->_name;
    }

    const std::string &version() const {
        return this->_version;
    }
};

// A wrapper type to handle both top-level symbols (like classes) as well as
// "inner symbols" like fields (@x). In a statically typed language, field
// symbols are like any other symbols, but in Ruby, they aren't declared
// ahead-of-time. So Sorbet represents them with a separate name on the side.
//
// Structurally, this is similar to the Alias instruction. One key difference
// is that the SymbolRef may refer to the owner in some situations.
class NamedSymbolRef final {
    core::SymbolRef selfOrOwner;
    core::NameRef name;

public:
    enum class Kind {
        ClassOrModule,
        UndeclaredField,
        StaticField,
        Method,
    };

private:
    NamedSymbolRef(core::SymbolRef s, core::NameRef n, Kind k) : selfOrOwner(s), name(n) {
        switch (k) {
            case Kind::ClassOrModule:
                ENFORCE(s.isClassOrModule());
                ENFORCE(!n.exists());
                return;
            case Kind::StaticField:
                ENFORCE(s.isFieldOrStaticField());
                ENFORCE(!n.exists());
                return;
            case Kind::UndeclaredField:
                ENFORCE(n.exists());
                return;
            case Kind::Method:
                ENFORCE(s.isMethod());
                ENFORCE(!n.exists());
        }
    }

public:
    NamedSymbolRef(const NamedSymbolRef &) = default;
    NamedSymbolRef(NamedSymbolRef &&) = default;
    NamedSymbolRef &operator=(const NamedSymbolRef &) = default;
    NamedSymbolRef &operator=(NamedSymbolRef &&) = default;

    friend bool operator==(const NamedSymbolRef &lhs, const NamedSymbolRef &rhs) {
        return lhs.selfOrOwner == rhs.selfOrOwner && lhs.name == rhs.name;
    }

    template <typename H> friend H AbslHashValue(H h, const NamedSymbolRef &c) {
        return H::combine(std::move(h), c.selfOrOwner, c.name);
    }

    static NamedSymbolRef classOrModule(core::SymbolRef self) {
        return NamedSymbolRef(self, {}, Kind::ClassOrModule);
    }

    static NamedSymbolRef undeclaredField(core::SymbolRef owner, core::NameRef name) {
        return NamedSymbolRef(owner, name, Kind::UndeclaredField);
    }

    static NamedSymbolRef staticField(core::SymbolRef self) {
        return NamedSymbolRef(self, {}, Kind::StaticField);
    }

    static NamedSymbolRef method(core::SymbolRef self) {
        return NamedSymbolRef(self, {}, Kind::Method);
    }

    Kind kind() const {
        if (this->name.exists()) {
            return Kind::UndeclaredField;
        }
        if (this->selfOrOwner.isFieldOrStaticField()) {
            return Kind::StaticField;
        }
        return Kind::ClassOrModule;
    }

    core::SymbolRef asSymbolRef() const {
        ENFORCE(this->kind() != Kind::UndeclaredField);
        return this->selfOrOwner;
    }

    // Returns OK if we were able to compute a symbol for the expression.
    absl::Status symbolForExpr(const core::GlobalState &gs, const GemMetadata &metadata, scip::Symbol &symbol) const {
        // Don't set symbol.scheme and package.manager here because those are hard-coded to 'scip-ruby' and 'gem'
        // anyways.
        scip::Package package;
        package.set_name(metadata.name());
        package.set_version(metadata.version());
        *symbol.mutable_package() = move(package);

        InlinedVector<scip::Descriptor, 4> descriptors;
        auto cur = this->selfOrOwner;
        while (cur != core::Symbols::root()) {
            // NOTE:(varun) The current scheme will cause multiple 'definitions' for the same
            // entity if it is present in different files, because the path is not encoded
            // in the descriptor whose parent is the root. This matches the semantics of
            // RubyMine, but we may want to revisit this if it is problematic for classes
            // that are extended in lots of places.
            scip::Descriptor descriptor;
            *descriptor.mutable_name() = cur.name(gs).show(gs);
            ENFORCE(!descriptor.name().empty());
            // TODO: Are the scip descriptor kinds correct?
            switch (cur.kind()) {
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
            descriptors.push_back(move(descriptor));
            cur = cur.owner(gs);
        }
        while (!descriptors.empty()) {
            *symbol.add_descriptors() = move(descriptors.back());
            descriptors.pop_back();
        }
        if (this->name != core::NameRef::noName()) {
            scip::Descriptor descriptor;
            descriptor.set_suffix(scip::Descriptor::Term);
            *descriptor.mutable_name() = this->name.shortName(gs);
            ENFORCE(!descriptor.name().empty());
            *symbol.add_descriptors() = move(descriptor);
        }
        return absl::OkStatus();
    }

    core::Loc symbolLoc(const core::GlobalState &gs) const {
        // FIXME(varun): For methods, this returns the full line!
        ENFORCE(this->name == core::NameRef::noName());
        return this->selfOrOwner.loc(gs);
    }
};

InlinedVector<int32_t, 4> fromSorbetLoc(const core::GlobalState &gs, core::Loc loc) {
    ENFORCE_NO_TIMER(!loc.empty());
    auto [start, end] = loc.position(gs);
    ENFORCE_NO_TIMER(start.line <= INT32_MAX && start.column <= INT32_MAX);
    ENFORCE(end.line <= INT32_MAX && end.column <= INT32_MAX);
    InlinedVector<int32_t, 4> r;
    r.push_back(start.line - 1);
    r.push_back(start.column - 1);
    if (start.line != end.line) {
        ENFORCE(false, "None of the occurrence types we emit currently should have multiline ranges");
        r.push_back(end.line - 1);
    } else {
        ENFORCE(start.column < end.column);
    }
    r.push_back(end.column - 1);
    return r;
}

core::Loc trimColonColonPrefix(const core::GlobalState &gs, core::Loc baseLoc) {
    ENFORCE(!baseLoc.empty());
    auto source = baseLoc.source(gs);
    if (!source.has_value()) {
        return baseLoc;
    }
    auto colonColonOffsetFromRangeStart = source.value().rfind("::"sv);
    if (colonColonOffsetFromRangeStart == std::string::npos) {
        return baseLoc;
    }
    auto occLen = source.value().length() - (colonColonOffsetFromRangeStart + 2);
    ENFORCE(occLen < baseLoc.endPos());
    auto newBeginLoc = baseLoc.endPos() - uint32_t(occLen);
    ENFORCE(newBeginLoc > baseLoc.beginPos());
    return core::Loc(baseLoc.file(), {.beginLoc = newBeginLoc, .endLoc = baseLoc.endPos()});
}

class SCIPState {
    string symbolScratchBuffer;
    UnorderedMap<NamedSymbolRef, string> symbolStringCache;
    GemMetadata gemMetadata;

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
    SCIPState(GemMetadata metadata) : symbolScratchBuffer(), symbolStringCache(), gemMetadata(metadata) {}
    ~SCIPState() = default;
    SCIPState(SCIPState &&) = default;
    SCIPState &operator=(SCIPState &&other) = default;
    // Make move-only to avoid accidental copy of large Documents/maps.
    SCIPState(const SCIPState &) = delete;
    SCIPState &operator=(const SCIPState &other) = delete;

    // If the returned value is as success, the pointer is non-null.
    //
    // The argument symbol is used instead of recomputing from scratch if it is non-null.
    absl::StatusOr<string *> saveSymbolString(const core::GlobalState &gs, NamedSymbolRef symRef,
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
            status = symRef.symbolForExpr(gs, this->gemMetadata, symbol);
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
        ENFORCE(!symbolString.empty());
        occLoc = trimColonColonPrefix(gs, occLoc);
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
                                   core::LocOffsets occLocOffsets, int32_t symbol_roles) {
        ENFORCE(!symbolString.empty());
        auto occLoc = trimColonColonPrefix(gs, core::Loc(file, occLocOffsets));
        scip::Occurrence occurrence;
        occurrence.set_symbol(symbolString);
        occurrence.set_symbol_roles(symbol_roles);
        for (auto val : sorbet::scip_indexer::fromSorbetLoc(gs, occLoc)) {
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
    // TODO(varun): Should we always pass in the location instead of sometimes only?
    absl::Status saveDefinition(const core::GlobalState &gs, core::FileRef file, NamedSymbolRef symRef,
                                std::optional<core::LocOffsets> loc = std::nullopt) {
        // TODO:(varun) Should we cache here too to avoid emitting duplicate definitions?
        scip::Symbol symbol;
        auto status = symRef.symbolForExpr(gs, this->gemMetadata, symbol);
        if (!status.ok()) {
            return status;
        }
        absl::StatusOr<string *> valueOrStatus(this->saveSymbolString(gs, symRef, &symbol));
        if (!valueOrStatus.ok()) {
            return valueOrStatus.status();
        }
        string &symbolString = *valueOrStatus.value();

        auto occLoc = loc.has_value() ? core::Loc(file, loc.value()) : symRef.symbolLoc(gs);

        return this->saveDefinitionImpl(gs, file, symbolString, occLoc);
    }

    absl::Status saveReference(const core::GlobalState &gs, core::FileRef file, OwnedLocal occ, int32_t symbol_roles) {
        if (this->cacheOccurrence(gs, file, occ, symbol_roles)) {
            return absl::OkStatus();
        }
        return this->saveReferenceImpl(gs, file, occ.toString(gs, file), occ.offsets, symbol_roles);
    }

    absl::Status saveReference(const core::GlobalState &gs, core::FileRef file, NamedSymbolRef symRef,
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

std::string format_ancestry(const core::GlobalState &gs, core::SymbolRef sym) {
    UnorderedSet<core::SymbolRef> visited;
    auto i = 0;
    std::ostringstream out;
    while (sym.exists() && !visited.contains(sym)) {
        out << fmt::format("#{}{}{}\n", std::string(i * 2, ' '), i == 0 ? "" : "<- ", sym.name(gs).toString(gs));
        visited.insert(sym);
        sym = sym.owner(gs);
        i++;
    }
    return out.str();
}

// Loosely inspired by AliasesAndKeywords in IREmitterContext.cc
class AliasMap final {
public:
    using Impl = UnorderedMap<cfg::LocalRef, std::tuple<NamedSymbolRef, core::LocOffsets, /*emitted*/ bool>>;

private:
    Impl map;

    AliasMap(const AliasMap &) = delete;
    AliasMap &operator=(const AliasMap &) = delete;

public:
    AliasMap() = default;

    void populate(const core::Context &ctx, const cfg::CFG &cfg) {
        this->map = {};
        auto &gs = ctx.state;
        auto method = ctx.owner;
        auto klass = method.owner(gs);
        for (auto &bb : cfg.basicBlocks) {
            for (auto &bind : bb->exprs) {
                auto *instr = cfg::cast_instruction<cfg::Alias>(bind.value);
                if (!instr) {
                    continue;
                }
                ENFORCE(this->map.find(bind.bind.variable) == this->map.end(),
                        "Overwriting an entry in the aliases map");
                auto sym = instr->what;
                if (!sym.exists() || sym == core::Symbols::Magic()) {
                    continue;
                }
                if (sym == core::Symbols::Magic_undeclaredFieldStub()) {
                    ENFORCE(!bind.loc.empty());
                    this->map.insert(
                        {bind.bind.variable, {NamedSymbolRef::undeclaredField(klass, instr->name), bind.loc, false}});
                    continue;
                }
                if (sym.isStaticField(gs)) {
                    this->map.insert({bind.bind.variable, {NamedSymbolRef::staticField(instr->what), bind.loc, false}});
                    continue;
                }
                // Outside of definition contexts for classes & modules,
                // we emit a reference directly at the alias instruction
                // instead of relying on usages. The reason for this is that
                // in some cases, there may not be any usages.
                //
                // For example, if you have access to M::K, there will be no usage
                // for the alias to M. I'm not 100% sure if this is a Sorbet bug
                // where it is missing a keep_for_ide call (which we can rely on
                // in definition contexts) of if this is deliberate.
                if (sym.isClassOrModule()) {
                    auto loc = bind.loc;
                    if (!loc.exists() || loc.empty()) { // For special classes like Sorbet::Private::Static
                        continue;
                    }
                    this->map.insert({bind.bind.variable, {NamedSymbolRef::classOrModule(sym), loc, false}});
                }
            }
        }
    }

    optional<std::pair<NamedSymbolRef, core::LocOffsets>> try_consume(cfg::LocalRef localRef) {
        auto it = this->map.find(localRef);
        if (it == this->map.end()) {
            return nullopt;
        }
        auto &[namedSym, loc, emitted] = it->second;
        emitted = true;
        return {{namedSym, loc}};
    }

    void extract(Impl &out) {
        out = std::move(this->map);
    }
};

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
    AliasMap aliasMap;

    // Local variable counter that is reset for every function.
    uint32_t counter = 0;
    SCIPState &scipState;
    core::Context ctx;

public:
    CFGTraversal(SCIPState &scipState, core::Context ctx)
        : blockLocals(), functionLocals(), aliasMap(), scipState(scipState), ctx(ctx) {}

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
        auto symRef = this->aliasMap.try_consume(localRef);
        if (!symRef.has_value() && isTemporary(ctx.state, localVar)) {
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
        absl::Status status;
        auto loc = local.loc;
        if (symRef.has_value()) {
            auto [namedSym, _] = symRef.value();
            if (isDefinition) {
                status = this->scipState.saveDefinition(this->ctx.state, this->ctx.file, namedSym, loc);
            } else {
                status = this->scipState.saveReference(this->ctx.state, this->ctx.file, namedSym, loc, referenceRole);
            }
        } else {
            uint32_t localId = this->functionLocals[localRef];
            if (isDefinition) {
                status = this->scipState.saveDefinition(this->ctx.state, this->ctx.file,
                                                        OwnedLocal{this->ctx.owner, localId, loc});
            } else {
                status = this->scipState.saveReference(this->ctx.state, this->ctx.file,
                                                       OwnedLocal{this->ctx.owner, localId, loc}, referenceRole);
            }
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
        this->aliasMap.populate(this->ctx, cfg);
        auto &gs = this->ctx.state;
        auto file = this->ctx.file;
        auto method = this->ctx.owner;
        auto isMethodFileStaticInit = method == gs.lookupStaticInitForFile(file);

        // Returns true if the caller should not process the binding further.
        auto skipProcessing = [&](const cfg::Binding &binding) -> bool {
            if (binding.loc.exists() && !binding.loc.empty()) {
                return false;
            }
            if (binding.value.tag() != cfg::Tag::Send) {
                return true;
            }
            auto send = cfg::cast_instruction<cfg::Send>(binding.value);
            if (send->fun != core::Names::keepForIde()) {
                return true;
            }
            ENFORCE(send->args.size() == 1);
            auto &arg = send->args[0];
            auto symRef = this->aliasMap.try_consume(arg.variable);
            ENFORCE(symRef.has_value());
            auto [namedSym, _] = symRef.value();
            auto check =
                isMethodFileStaticInit ||
                method == gs.lookupStaticInitForClass(namedSym.asSymbolRef().asClassOrModuleRef().data(gs)->owner,
                                                      /*allowMissing*/ true);
            ENFORCE(check);
            auto status = this->scipState.saveDefinition(gs, file, namedSym, arg.loc);
            ENFORCE(status.ok());
            return true;
        };

        // I don't fully understand the doc comment for forwardsTopoSort; it seems backwards in practice.
        for (auto it = cfg.forwardsTopoSort.rbegin(); it != cfg.forwardsTopoSort.rend(); ++it) {
            cfg::BasicBlock *bb = *it;
            this->copyLocalsFromParents(bb, cfg);
            for (auto &binding : bb->exprs) {
                if (skipProcessing(binding)) {
                    continue;
                }
                // For aliases, don't emit an occurrence for the LHS; it will be emitted
                // when the alias is used or separately at the end. See NOTE[alias-handling].
                //
                // For ArgPresent instructions (which come up with default arguments), we will
                // emit defs/refs for direct usages, so don't emit a local for the temporary here.
                if (binding.value.tag() != cfg::Tag::Alias && binding.value.tag() != cfg::Tag::ArgPresent) {
                    // Emit occurrence information for the LHS
                    auto occ = cfg::LocalOccurrence{binding.bind.variable, lhsLocIfPresent(binding)};
                    this->emitLocalOccurrence(cfg, bb, occ, ValueCategory::LValue);
                }
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

                        // Emit reference for the method being called
                        auto recvType = send->recv.type;
                        // TODO(varun): When is the isTemporary check going to succeed?
                        if (recvType && send->fun.exists() && send->funLoc.exists() && !send->funLoc.empty() &&
                            !isTemporary(gs, core::LocalVariable(send->fun, 1))) {
                            core::ClassOrModuleRef recv{};
                            // NOTE(varun): Based on core::Types::getRepresentedClass. Trying to use it directly didn't
                            // quite work properly, but we might want to consolidate the implementation. I didn't quite
                            // understand the bit about attachedClass.
                            if (core::isa_type<core::ClassType>(recvType)) {
                                recv = core::cast_type_nonnull<core::ClassType>(recvType).symbol;
                            } else if (core::isa_type<core::AppliedType>(send->recv.type)) {
                                // Triggered for a module nested inside a class
                                recv = core::cast_type_nonnull<core::AppliedType>(send->recv.type).klass;
                            }
                            if (recv.exists()) {
                                auto funSym = gs.lookupMethodSymbol(recv, send->fun);
                                if (funSym.exists()) {
                                    // TODO:(varun) For arrays, hashes etc., try to identify if the function
                                    // matches a known operator (e.g. []=), and emit an appropriate 'WriteAccess'
                                    // symbol role for it.
                                    auto status = this->scipState.saveReference(
                                        gs, file, NamedSymbolRef::method(funSym), send->funLoc, 0);
                                    ENFORCE(status.ok());
                                }
                            }
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
                    case cfg::Tag::Alias:
                        // NOTE[alias-handling]: Aliases are handled in two ways.
                        // 1. We create an alias map and when emitting a local occurrence, we de-alias if
                        //    that makes sense. Based on the usage, we emit a def or a ref.
                        //    For example, if you have a method with an assignment to a field for the first
                        //    time in the body of that method, we'll emit a definition.
                        //    (This matches the Go to Definition behavior of RubyMine.)
                        // 2. For nested classes, sometimes, there is no usage at all in the method body
                        //    (in some cases, there is a keep_for_ide send instruction, which we special-case).
                        //    In such a situation, we emit unused aliases after processing the CFG.
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

        // See NOTE[alias-handling].
        AliasMap::Impl map;
        this->aliasMap.extract(map);
        using SymbolWithLoc = std::pair<NamedSymbolRef, core::LocOffsets>;
        std::vector<SymbolWithLoc> todo;
        for (auto &[_, value] : map) {
            auto &[namedSym, loc, emitted] = value;
            if (!emitted) {
                todo.emplace_back(namedSym, loc);
            }
        }
        // Sort for determinism
        fast_sort(todo, [](const SymbolWithLoc &p1, const SymbolWithLoc &p2) -> bool {
            ENFORCE(p1.second.beginPos() != p2.second.beginPos(),
                    "Different alias instructions should correspond to different start offsets");
            return p1.second.beginPos() < p2.second.beginPos();
        });
        // NOTE:(varun) Not 100% sure if emitting a reference here. Here's why it's written this
        // way right now. This code path is hit in two different kinds of situations:
        // - You have a reference to a nested class etc. inside a method body.
        // - You have a 'direct' definition of a nested class
        //     class M::C
        //       # blah
        //     end
        //   In this situation, M should count as a reference if we're mimicking RubyMine.
        //   Specifically, Go to Definition for modules seems to go to 'module M' even
        //   when other forms like 'class M::C' are present.
        for (auto &[namedSym, loc] : todo) {
            auto status = this->scipState.saveReference(gs, file, namedSym, loc, 0);
            ENFORCE(status.ok());
        }
    }
};

} // end namespace sorbet::scip_indexer

namespace sorbet::pipeline::semantic_extension {

using LocalSymbolTable = UnorderedMap<core::LocalVariable, core::Loc>;

class SCIPSemanticExtension : public SemanticExtension {
public:
    string indexFilePath;
    scip_indexer::GemMetadata gemMetadata;

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
                       shared_ptr<SCIPState>(new SCIPState(gemMetadata), [](SCIPState *) {});
        }
    }

    void emitSymbol(const core::GlobalState &gs, core::FileRef file, ast::ClassDef *cd) const {
        auto classLoc = core::Loc(file, cd->name.loc());
    }

    bool doNothing() const {
        return this->indexFilePath.empty();
    }

    void run(core::MutableContext &ctx, ast::ClassDef *cd) const override {
        if (this->doNothing()) {
            return;
        }
        // FIXME:(varun) This is a no-op???
        emitSymbol(ctx.state, ctx.file, cd);
    };
    virtual void finishTypecheckFile(const core::GlobalState &gs, const core::FileRef &file) const override {
        if (this->doNothing()) {
            return;
        }
        getSCIPState()->saveDocument(gs, file);
    };
    virtual void finishTypecheck(const core::GlobalState &gs) const override {
        if (this->doNothing()) {
            return;
        }
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
        if (this->doNothing()) {
            return;
        }
        auto scipState = this->getSCIPState();
        if (methodDef.name != core::Names::staticInit()) {
            auto status = scipState->saveDefinition(gs, file, scip_indexer::NamedSymbolRef::method(methodDef.symbol));
            ENFORCE(status.ok());
        }

        // It is not useful to emit occurrences for method bodies that are synthesized.
        if (methodDef.flags.isRewriterSynthesized) {
            return;
        }

        // It looks like Sorbet only stores symbols at the granularity of classes and methods
        // So we need to recompute local variable information from scratch. The LocalVarFinder
        // which is used by the LSP implementation is tailored for finding the local variable
        // specific to a range, so directly using that would lead to recomputing local variable
        // information repeatedly for each occurrence.

        sorbet::scip_indexer::CFGTraversal traversal(*scipState.get(), core::Context(gs, methodDef.symbol, file));
        traversal.traverse(cfg);
    }

    virtual unique_ptr<SemanticExtension> deepCopy(const core::GlobalState &from, core::GlobalState &to) override {
        return make_unique<SCIPSemanticExtension>(this->indexFilePath, this->gemMetadata);
    };
    virtual void merge(const core::GlobalState &from, core::GlobalState &to, core::NameSubstitution &subst) override{};

    SCIPSemanticExtension(string indexFilePath, scip_indexer::GemMetadata metadata)
        : indexFilePath(indexFilePath), gemMetadata(metadata), mutableState() {}
    ~SCIPSemanticExtension() {}
};

class SCIPSemanticExtensionProvider : public SemanticExtensionProvider {
public:
    void injectOptions(cxxopts::Options &optsBuilder) const override {
        optsBuilder.add_options("indexer")("index-file", "Output SCIP index to a directory, which must already exist",
                                           cxxopts::value<string>());
        optsBuilder.add_options("name@version")(
            "gem-metadata", "Name and version pair to be used for cross-repository code navigation.",
            cxxopts::value<string>());
    };
    unique_ptr<SemanticExtension> readOptions(cxxopts::ParseResult &providedOptions) const override {
        if (providedOptions.count("index-file") > 0) {
            return make_unique<SCIPSemanticExtension>(
                providedOptions["index-file"].as<string>(),
                scip_indexer::GemMetadata::tryParseOrDefault(
                    providedOptions.count("gem-metadata") > 0 ? providedOptions["gem-metadata"].as<string>() : ""));
        }
        return this->defaultInstance();
    };
    virtual unique_ptr<SemanticExtension> defaultInstance() const override {
        return make_unique<SCIPSemanticExtension>("", scip_indexer::GemMetadata::tryParseOrDefault(""));
    };
    static vector<SemanticExtensionProvider *> getProviders();
    virtual ~SCIPSemanticExtensionProvider() = default;
};

vector<SemanticExtensionProvider *> SemanticExtensionProvider::getProviders() {
    static SCIPSemanticExtensionProvider scipExtension;
    return {&scipExtension};
}
} // namespace sorbet::pipeline::semantic_extension
