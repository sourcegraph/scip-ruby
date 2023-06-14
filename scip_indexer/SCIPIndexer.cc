// NOTE: Protobuf headers should go first since they use poisoned functions.
#include "proto/SCIP.pb.h"

#include <algorithm>
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
#include "absl/strings/str_replace.h"
#include "absl/strings/str_split.h"
#include "absl/synchronization/mutex.h"
#include "spdlog/fmt/fmt.h"

#include "ast/Trees.h"
#include "ast/treemap/treemap.h"
#include "cfg/CFG.h"
#include "common/EarlyReturnWithCode.h"
#include "common/common.h"
#include "common/sort/sort.h"
#include "core/Error.h"
#include "core/ErrorQueue.h"
#include "core/Loc.h"
#include "core/SymbolRef.h"
#include "core/Symbols.h"
#include "core/errors/scip_ruby.h"
#include "sorbet_version/sorbet_version.h"

#include "scip_indexer/Debug.h"
#include "scip_indexer/SCIPFieldResolve.h"
#include "scip_indexer/SCIPGemMetadata.h"
#include "scip_indexer/SCIPIndexer.h"
#include "scip_indexer/SCIPProtoExt.h"
#include "scip_indexer/SCIPSymbolRef.h"
#include "scip_indexer/SCIPUtils.h"

using namespace std;

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

const char scip_ruby_version[] = "0.3.4";

// Last updated: https://github.com/sourcegraph/scip-ruby/pull/175
const char scip_ruby_sync_upstream_sorbet_sha[] = "0f6fd90cdf20d507f20dcbe928431dc16d3e1793";

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
           n == Names::blkArg() || n == Names::blockCall() || n == Names::blockBreakAssign() ||
           n == Names::argPresent() || n == Names::forTemp() || n == Names::keepForCfgTemp() ||
           // Insert checks because sometimes temporaries are initialized with a 0 unique value. 😬
           n == Names::finalReturn() || n == NameRef::noName() || n == Names::blockCall() || n == Names::selfLocal() ||
           n == Names::unconditional();
}

/// Utility type for carrying a local variable along with its owner.
struct OwnedLocal {
    /// Parent method.
    const core::SymbolRef owner;
    /// Counter corresponding to the local's definition, unique within a method.
    uint32_t counter;
    /// Location for the occurrence.
    core::LocOffsets offsets;

    /// Display the OwnedLocal, suitable for use inside a SCIP index.
    string toSCIPString(const core::GlobalState &gs, core::FileRef file) {
        // 32-bits => if there are 10k methods in a single file, the chance of at least one
        // colliding pair is about 1.1%, assuming even distribution. That seems OK.
        return fmt::format("local {}~#{}", counter, ::fnv1a_32(owner.name(gs).show(gs)));
    }
};

InlinedVector<int32_t, 4> fromSorbetLoc(const core::GlobalState &gs, core::Loc loc) {
    ENFORCE(!loc.empty());
    auto [start, end] = loc.position(gs);
    ENFORCE(start.line <= INT32_MAX && start.column <= INT32_MAX);
    ENFORCE(end.line <= INT32_MAX && end.column <= INT32_MAX);
    InlinedVector<int32_t, 4> r;
    r.push_back(start.line - 1);
    r.push_back(start.column - 1);
    if (start.line != end.line) {
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
    if (colonColonOffsetFromRangeStart == string::npos) {
        return baseLoc;
    }
    auto occLen = source.value().length() - (colonColonOffsetFromRangeStart + 2);
    ENFORCE(occLen < baseLoc.endPos());
    auto newBeginLoc = baseLoc.endPos() - uint32_t(occLen);
    ENFORCE(newBeginLoc > baseLoc.beginPos());
    return core::Loc(baseLoc.file(), {.beginLoc = newBeginLoc, .endLoc = baseLoc.endPos()});
}

enum class Emitted {
    Now,
    Earlier,
};

/// Per-thread state storing information to be emitting in a SCIP index.
///
/// The states are implicitly merged at the time of emitting the index.
///
/// WARNING: A SCIPState value will in general be reused across files,
/// so caches should generally directly or indirectly include a FileRef
/// as part of key (e.g. via core::Loc).
class SCIPState {
    UnorderedMap<UntypedGenericSymbolRef, string> symbolStringCache;

    /// Cache of occurrences for locals that have been emitted in this function.
    ///
    /// Note that the SymbolRole is a part of the key too, because we can
    /// have a read-reference and write-reference at the same location
    /// (we don't merge those for now).
    UnorderedMap<pair<core::LocOffsets, /*SymbolRole*/ int32_t>, uint32_t> localOccurrenceCache;
    // ^ The 'value' in the map is purely for sanity-checking. It's a bit
    // cumbersome to conditionalize the type to be a set in non-debug and
    // map in debug, so keeping it a map.

    /// Analogous to localOccurrenceCache but for symbols.
    ///
    /// This is mainly present to avoid emitting duplicate occurrences
    /// for DSL-like constructs like prop/def_delegator.
    UnorderedSet<tuple<GenericSymbolRef, core::Loc, /*SymbolRole*/ int32_t>> symbolOccurrenceCache;

    /// Map to keep track of symbols which lack a direct definition,
    /// and are indirectly defined by another symbol through a Relationship.
    ///
    /// Ideally, 'UntypedGenericSymbolRef' would not be duplicated across files
    /// but we keep these separate per file to avoid weirdness where logically
    /// different but identically named classes exist in different files.
    UnorderedMap<core::FileRef, UnorderedSet<UntypedGenericSymbolRef>> potentialRefOnlySymbols;

    // ^ Naively, I would think that that shouldn't happen because we don't traverse
    // rewriter-synthesized method bodies, but it does seem to happen.
    //
    // Also, you would think that emittedSymbols below would handle this.
    // But it doesn't, for some reason... 🤔
    //
    // FIXME(varun): This seems redundant, get rid of it.

    GemMapping gemMap;

public:
    UnorderedMap<core::FileRef, vector<scip::Occurrence>> occurrenceMap;

    /// Set containing symbols that have been emitted.
    ///
    /// For every (f, s) in emittedSymbols, symbolMap[f] = SymbolInfo{s, ... other stuff}
    /// and vice-versa. This is present to avoid emitting multiple SymbolInfos
    /// for the same local variable if there are multiple definitions.
    UnorderedSet<pair<core::FileRef, string>> emittedSymbols;
    UnorderedMap<core::FileRef, vector<scip::SymbolInformation>> symbolMap;

    /// Stores the relationships that apply to a field or a method.
    ///
    /// Ideally, 'UntypedGenericSymbolRef' would not be duplicated across files
    /// but we keep these separate per file to avoid weirdness where logically
    /// different but identically named classes exist in different files.
    UnorderedMap<core::FileRef, RelationshipsMap> relationshipsMap;

    FieldResolver fieldResolver;

    vector<scip::Document> documents;
    vector<scip::SymbolInformation> externalSymbols;

public:
    SCIPState(GemMapping gemMap)
        : symbolStringCache(), localOccurrenceCache(), symbolOccurrenceCache(), potentialRefOnlySymbols(),
          gemMap(gemMap), occurrenceMap(), emittedSymbols(), symbolMap(), documents(), externalSymbols() {}
    ~SCIPState() = default;
    SCIPState(SCIPState &&) = default;
    SCIPState &operator=(SCIPState &&other) = default;
    // Make move-only to avoid accidental copy of large Documents/maps.
    SCIPState(const SCIPState &) = delete;
    SCIPState &operator=(const SCIPState &other) = delete;

    void clearFunctionLocalCaches() {
        this->localOccurrenceCache.clear();
    }

    /// If the returned value is as success, the pointer is non-null.
    ///
    /// The argument symbol is used instead of recomputing from scratch if it is non-null.
    utils::Result saveSymbolString(const core::GlobalState &gs, UntypedGenericSymbolRef symRef,
                                   const scip::Symbol *symbol, std::string &output) {
        auto pair = this->symbolStringCache.find(symRef);
        if (pair != this->symbolStringCache.end()) {
            // Yes, there is a "redundant" string copy here when we could "just"
            // optimize it to return an interior pointer into the cache. However,
            // that creates a footgun where this method cannot be safely called
            // across invocations to non-const method calls on SCIPState.
            output = pair->second;
            return utils::Result::okValue();
        }

        absl::Status status;
        if (symbol) {
            status = utils::emitSymbolString(*symbol, output);
        } else {
            scip::Symbol symbol;
            auto result = symRef.symbolForExpr(gs, this->gemMap, {}, symbol);
            if (!result.ok()) {
                return result;
            }
            status = utils::emitSymbolString(symbol, output);
        }
        if (!status.ok()) {
            return utils::Result::statusValue(status);
        }
        symbolStringCache.insert({symRef, output});

        return utils::Result::okValue();
    }

private:
    bool alreadyEmittedSymbolInfo(core::FileRef file, const string &symbolString) {
        return this->emittedSymbols.contains({file, symbolString});
    }

    Emitted saveSymbolInfo(core::FileRef file, const string &symbolString, const SmallVec<string> &docs,
                           const SmallVec<scip::Relationship> &rels) {
        if (this->alreadyEmittedSymbolInfo(file, symbolString)) {
            return Emitted::Earlier;
        }
        scip::SymbolInformation symbolInfo;
        symbolInfo.set_symbol(symbolString);
        for (auto &doc : docs) {
            symbolInfo.add_documentation(doc);
        }
        for (auto &rel : rels) {
            *symbolInfo.add_relationships() = rel;
        }
        this->symbolMap[file].push_back(symbolInfo);
        return Emitted::Now;
    }

    absl::Status saveDefinitionImpl(const core::GlobalState &gs, core::FileRef file, const string &symbolString,
                                    core::Loc occLoc, const SmallVec<string> &docs,
                                    const SmallVec<scip::Relationship> &rels) {
        ENFORCE(!symbolString.empty());

        auto emitted = this->saveSymbolInfo(file, symbolString, docs, rels);

        occLoc = trimColonColonPrefix(gs, occLoc);
        scip::Occurrence occurrence;
        occurrence.set_symbol(symbolString);
        occurrence.set_symbol_roles(scip::SymbolRole::Definition);
        for (auto val : sorbet::scip_indexer::fromSorbetLoc(gs, occLoc)) {
            occurrence.add_range(val);
        }
        switch (emitted) {
            case Emitted::Now:
                break;
            case Emitted::Earlier:
                for (auto &doc : docs) {
                    *occurrence.add_override_documentation() = doc;
                }
        }
        this->occurrenceMap[file].push_back(occurrence);
        // TODO(varun): When should we fill out the diagnostics and override_docs fields?
        return absl::OkStatus();
    }

    void saveReferenceImpl(const core::GlobalState &gs, core::FileRef file, const string &symbolString,
                           const SmallVec<string> &overrideDocs, core::LocOffsets occLocOffsets, int32_t symbol_roles) {
        ENFORCE(!symbolString.empty());
        auto occLoc = trimColonColonPrefix(gs, core::Loc(file, occLocOffsets));
        scip::Occurrence occurrence;
        occurrence.set_symbol(symbolString);
        occurrence.set_symbol_roles(symbol_roles);
        for (auto val : sorbet::scip_indexer::fromSorbetLoc(gs, occLoc)) {
            occurrence.add_range(val);
        }
        for (auto &doc : overrideDocs) {
            occurrence.add_override_documentation(doc);
        }
        this->occurrenceMap[file].push_back(occurrence);
        // TODO(varun): When should we fill out the diagnostics field?
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
        ENFORCE(occ.counter == savedCounter, "found distinct local variable {} at same location in {}:\n{}",
                (symbolRoles & scip::SymbolRole::Definition) ? "definitions" : "references", file.data(gs).path(),
                core::Loc(file, occ.offsets).toString(gs));

        return true;
    }

    bool cacheOccurrence(const core::GlobalState &gs, core::Loc loc, GenericSymbolRef sym, int32_t symbolRoles) {
        // Optimization:
        //   Avoid emitting duplicate def/refs for symbols.
        // This can happen with constructs like:
        //   prop :foo, String
        // Without this optimization, there are 4 occurrences for String
        // emitted for the same source range.
        auto [_, inserted] = this->symbolOccurrenceCache.insert({sym, loc, symbolRoles});
        return !inserted;
    }

    void saveRelationships(const core::GlobalState &gs, core::FileRef file, UntypedGenericSymbolRef untypedSymRef,
                           SmallVec<scip::Relationship> &rels) {
        untypedSymRef.saveRelationships(gs, this->relationshipsMap[file], rels,
                                        [this, &gs](UntypedGenericSymbolRef sym, std::string &out) {
                                            auto status = this->saveSymbolString(gs, sym, nullptr, out);
                                            ENFORCE(status.skip() || status.ok());
                                        });
    }

public:
    absl::Status saveDefinition(const core::GlobalState &gs, core::FileRef file, OwnedLocal occ, core::TypePtr type) {
        if (this->cacheOccurrence(gs, file, occ, scip::SymbolRole::Definition)) {
            return absl::OkStatus();
        }
        SmallVec<string> docStrings;
        auto loc = core::Loc(file, occ.offsets);
        if (type) {
            auto var = loc.source(gs);
            ENFORCE(var.has_value(), "Failed to find source text for definition of local variable");
            docStrings.push_back(fmt::format("```ruby\n{} ({})\n```", var.value(), type.show(gs)));
        }
        return this->saveDefinitionImpl(gs, file, occ.toSCIPString(gs, file), loc, docStrings, {});
    }

    // Save definition when you have a sorbet Symbol.
    // Meant for methods, fields etc., but not local variables.
    // TODO(varun): Should we always pass in the location instead of sometimes only?
    absl::Status saveDefinition(const core::GlobalState &gs, core::FileRef file, GenericSymbolRef symRef,
                                optional<core::LocOffsets> loc = nullopt) {
        // In practice, there doesn't seem to be any situation which triggers
        // a duplicate definition being emitted, so skip calling cacheOccurrence here.
        auto occLoc = loc.has_value() ? core::Loc(file, loc.value()) : symRef.symbolLoc(gs);
        scip::Symbol symbol;
        auto untypedSymRef = symRef.withoutType();
        auto result = untypedSymRef.symbolForExpr(gs, this->gemMap, occLoc, symbol);
        if (result.skip()) {
            return absl::OkStatus();
        }
        if (!result.ok()) {
            return result.status();
        }
        std::string symbolString;
        result = this->saveSymbolString(gs, untypedSymRef, &symbol, symbolString);
        ENFORCE(!result.skip(), "Should've skipped earlier");
        if (!result.ok()) {
            return result.status();
        }

        SmallVec<string> docs;
        symRef.saveDocStrings(gs, symRef.definitionType(), occLoc, docs);

        SmallVec<scip::Relationship> rels;
        this->saveRelationships(gs, file, symRef.withoutType(), rels);

        return this->saveDefinitionImpl(gs, file, symbolString, occLoc, docs, rels);
    }

    absl::Status saveReference(const core::GlobalState &gs, core::FileRef file, OwnedLocal occ,
                               optional<core::TypePtr> overrideType, int32_t symbol_roles) {
        if (this->cacheOccurrence(gs, file, occ, symbol_roles)) {
            return absl::OkStatus();
        }
        SmallVec<string> overrideDocs;
        auto loc = core::Loc(file, occ.offsets);
        if (overrideType.has_value()) {
            ENFORCE(overrideType.value(), "forgot to fold type to nullopt earlier: {}\n{}\n", file.data(gs).path(),
                    core::Loc(file, occ.offsets).toString(gs));
            auto var = loc.source(gs);
            ENFORCE(var.has_value(), "Failed to find source text for definition of local variable");
            overrideDocs.push_back(fmt::format("```ruby\n{} ({})\n```", var.value(), overrideType->show(gs)));
        }
        this->saveReferenceImpl(gs, file, occ.toSCIPString(gs, file), overrideDocs, occ.offsets, symbol_roles);
        return absl::OkStatus();
    }

    absl::Status saveReference(const core::Context &ctx, GenericSymbolRef symRef, optional<core::TypePtr> overrideType,
                               core::LocOffsets occLoc, int32_t symbol_roles) {
        // HACK: Reduce noise due to <static-init> in snapshots.
        if (ctx.owner.name(ctx) == core::Names::staticInit()) {
            if (symRef.isSorbetInternalClassOrMethod(ctx)) {
                return absl::OkStatus();
            }
        }
        auto loc = core::Loc(ctx.file, occLoc);
        if (this->cacheOccurrence(ctx, loc, symRef, symbol_roles)) {
            return absl::OkStatus();
        }
        auto &gs = ctx.state;
        auto file = ctx.file;
        std::string symbolString;
        auto result = this->saveSymbolString(gs, symRef.withoutType(), nullptr, symbolString);
        if (result.skip()) {
            return absl::OkStatus();
        }
        if (!result.ok()) {
            return result.status();
        }

        SmallVec<string> overrideDocs{};
        using Kind = GenericSymbolRef::Kind;
        switch (symRef.kind()) {
            case Kind::ClassOrModule:
            case Kind::Method:
                break;
            case Kind::Field:
                if (overrideType.has_value()) {
                    symRef.saveDocStrings(gs, overrideType.value(), loc, overrideDocs);
                }
        }

        // If we haven't emitted a SymbolInfo yet, record that we may want to emit
        // a SymbolInfo in the future, if it isn't emitted later in this file.
        if (!this->emittedSymbols.contains({file, symbolString})) {
            auto &rels = this->relationshipsMap[file];
            if (rels.contains(symRef.withoutType())) {
                this->potentialRefOnlySymbols[file].insert(symRef.withoutType());
            }
        }

        this->saveReferenceImpl(gs, file, symbolString, overrideDocs, occLoc, symbol_roles);
        return absl::OkStatus();
    }

    void finalizeRefOnlySymbolInfos(const core::GlobalState &gs, core::FileRef file) {
        auto &potentialSyms = this->potentialRefOnlySymbols[file];

        std::string symbolString;
        for (auto symRef : potentialSyms) {
            if (!this->saveSymbolString(gs, symRef, nullptr, symbolString).ok()) {
                continue;
            }
            // Avoid calling saveRelationships if we already emitted this.
            // saveSymbolInfo does this check too, so it isn't strictly needed.
            if (this->alreadyEmittedSymbolInfo(file, symbolString)) {
                continue;
            }
            SmallVec<scip::Relationship> rels;
            this->saveRelationships(gs, file, symRef, rels);
            this->saveSymbolInfo(file, symbolString, {}, rels);
        }
    }

    void saveDocument(const core::GlobalState &gs, const core::FileRef file) {
        scip::Document document;
        // TODO(varun): Double-check the path code and maybe document it,
        // to make sure its guarantees match what SCIP expects.
        ENFORCE(file.exists());
        auto path = file.data(gs).path();
        ENFORCE(!path.empty());
        if (path.front() == '/') {
            document.set_relative_path(filesystem::path(path).lexically_relative(filesystem::current_path()));
        } else {
            document.set_relative_path(string(path));
        }

        auto occurrences = this->occurrenceMap.find(file);
        if (occurrences != this->occurrenceMap.end()) {
            for (auto &occurrence : occurrences->second) {
                *document.add_occurrences() = move(occurrence);
            }
            fast_sort(*document.mutable_occurrences(),
                      [](const auto &o1, const auto &o2) -> bool { return scip::compareOccurrence(o1, o2) < 0; });
            this->occurrenceMap.erase(file);
        }

        auto symbols = this->symbolMap.find(file);
        if (symbols != this->symbolMap.end()) {
            for (auto &symbol : symbols->second) {
                *document.add_symbols() = move(symbol);
            }
            fast_sort(*document.mutable_symbols(), [](const auto &s1, const auto &s2) -> bool {
                return scip::compareSymbolInformation(s1, s2) < 0;
            });
            this->symbolMap.erase(file);
        }

        this->documents.push_back(move(document));
    }
};

string format_ancestry(const core::GlobalState &gs, core::SymbolRef sym) {
    UnorderedSet<core::SymbolRef> visited;
    auto i = 0;
    std::ostringstream out;
    while (sym.exists() && !visited.contains(sym)) {
        out << fmt::format("#{}{}{}\n", string(i * 2, ' '), i == 0 ? "" : "<- ", sym.name(gs).toString(gs));
        visited.insert(sym);
        sym = sym.owner(gs);
        i++;
    }
    return out.str();
}

// Loosely inspired by AliasesAndKeywords in IREmitterContext.cc
class AliasMap final {
public:
    using Impl = UnorderedMap<cfg::LocalRef, tuple<GenericSymbolRef, core::LocOffsets, /*emitted*/ bool>>;

private:
    Impl map;

    AliasMap(const AliasMap &) = delete;
    AliasMap &operator=(const AliasMap &) = delete;

public:
    AliasMap() = default;

    void populate(const core::Context &ctx, const cfg::CFG &cfg, FieldResolver &fieldResolver,
                  RelationshipsMap &relMap) {
        this->map = {};
        auto &gs = ctx.state;
        auto method = ctx.owner;
        const auto klass = method.owner(gs);
        // Make sure that the offsets we store here match the offsets we use
        // in saveDefinition/saveReference.
        auto trim = [&](core::LocOffsets loc) -> core::LocOffsets {
            return trimColonColonPrefix(gs, core::Loc(ctx.file, loc)).offsets();
        };
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
                    ENFORCE(klass.isClassOrModule());
                    auto fieldName = instr->name.shortName(gs);
                    if (!fieldName.empty() && fieldName[0] == '$') {
                        auto klass = core::Symbols::rootSingleton();
                        this->map.insert( // no trim(...) because globals can't have a :: prefix
                            {bind.bind.variable,
                             {GenericSymbolRef::field(klass, instr->name, bind.bind.type), bind.loc, false}});
                        continue;
                    }
                    // There are 4 possibilities here.
                    // 1. This is an undeclared field logically defined by `klass`.
                    // 2. This is declared in one of the modules transitively included by `klass`.
                    // 3. This is an undeclared field logically defined by one of `klass`'s ancestor classes.
                    // 4. This is an undeclared field logically defined by one of the modules transitively included by
                    //    `klass`.
                    auto normalizedKlass = FieldResolver::normalizeParentForClassVar(gs, klass.asClassOrModuleRef(),
                                                                                     instr->name.shortName(gs));
                    auto namedSymRef = GenericSymbolRef::field(normalizedKlass, instr->name, bind.bind.type);
                    if (!relMap.contains(namedSymRef.withoutType())) {
                        auto result = fieldResolver.findUnresolvedFieldTransitive(
                            ctx, {ctx.file, klass.asClassOrModuleRef(), instr->name}, ctx.locAt(bind.loc));
                        ENFORCE(result.inherited.exists(),
                                "Returned non-existent class from findUnresolvedFieldTransitive with start={}, "
                                "field={}, file={}, loc={}",
                                klass.exists() ? klass.toStringFullName(gs) : "<non-existent>",
                                instr->name.exists() ? instr->name.toString(gs) : "<non-existent>",
                                ctx.file.data(gs).path(), ctx.locAt(bind.loc).showRawLineColumn(gs))
                        relMap.insert({namedSymRef.withoutType(), result});
                    }
                    // no trim(...) because undeclared fields shouldn't have ::
                    ENFORCE(trim(bind.loc) == bind.loc);
                    this->map.insert({bind.bind.variable, {namedSymRef, bind.loc, false}});
                    continue;
                }
                if (sym.isFieldOrStaticField()) {
                    // There are 3 possibilities here.
                    // 1. This is a reference to a non-instance non-class variable.
                    // 2. This is a reference to an instance or class variable declared by `klass`.
                    // 3. This is a reference to an instance or class variable declared by one of `klass`'s ancestor
                    //    classes.
                    //
                    // For case 3, we want to emit a scip::Symbol that uses `klass`, not the ancestor.
                    ENFORCE(!bind.loc.empty());
                    auto name = instr->what.name(gs);
                    std::string_view nameText = name.shortName(gs);
                    auto symRef = GenericSymbolRef::field(instr->what.owner(gs), name, bind.bind.type);
                    if (!nameText.empty() && nameText[0] == '@') {
                        auto normalizedKlass =
                            FieldResolver::normalizeParentForClassVar(gs, klass.asClassOrModuleRef(), nameText);
                        symRef = GenericSymbolRef::field(normalizedKlass, name, bind.bind.type);
                        // Mimic the logic from the Magic_undeclaredFieldStub branch so that we don't
                        // miss out on relationships for declared symbols.
                        if (!relMap.contains(symRef.withoutType())) {
                            auto result = fieldResolver.findUnresolvedFieldTransitive(
                                ctx, {ctx.file, klass.asClassOrModuleRef(), name}, ctx.locAt(bind.loc));
                            result.inherited =
                                FieldResolver::normalizeParentForClassVar(gs, result.inherited, nameText);
                            relMap.insert({symRef.withoutType(), result});
                        }
                    }
                    this->map.insert({bind.bind.variable, {symRef, trim(bind.loc), false}});
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
                    if (!loc.exists() || loc.empty() || sym == core::Symbols::root() ||
                        sym == core::Symbols::T_Sig_WithoutRuntime()) {
                        // TODO(varun): Should we go through the list of all symbols and filter out
                        // all the 'internal' stuff here?
                        continue;
                    }
                    this->map.insert({bind.bind.variable, {GenericSymbolRef::classOrModule(sym), trim(loc), false}});
                }
            }
        }
    }

    optional<pair<GenericSymbolRef, core::LocOffsets>> try_consume(cfg::LocalRef localRef) {
        auto it = this->map.find(localRef);
        if (it == this->map.end()) {
            return nullopt;
        }
        auto &[namedSym, loc, emitted] = it->second;
        emitted = true;
        return {{namedSym, loc}};
    }

    string showRaw(const core::GlobalState &gs, core::FileRef file, const cfg::CFG &cfg) const {
        return showMap(this->map, [&](const cfg::LocalRef &local, const auto &data) -> string {
            auto symRef = get<0>(data);
            auto offsets = get<1>(data);
            auto emitted = get<2>(data);
            return fmt::format("(local: {}) -> (symRef: {}, emitted: {}, loc: {})", local.toString(gs, cfg),
                               symRef.showRaw(gs), emitted ? "true" : "false", core::Loc(file, offsets).showRaw(gs));
        });
    }

    void extract(Impl &out) {
        out = std::move(this->map);
    }
};

optional<core::TypePtr> computeOverrideType(core::TypePtr definitionType, core::TypePtr newType) {
    if (!newType ||
        // newType can be empty if an assignment is unreachable.
        // Normally, someone would not commit unreachable code (because Sorbet would
        // flag it as a hard error in CI), but it is better to be more permissive here.
        definitionType == newType
        // For definitions, this can happen if a variable is initialized to different
        // types along different code paths. For references, this can happen through
        // type-changing assignment.
    ) {
        return nullopt;
    }
    return {newType};
}

/// Convenience type to handle CFG traversal and recording info in SCIPState.
///
/// Any caches that are not specific to a traversal should be added to SCIPState.
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

    // Map for storing the type at the original site of definition for a local variable.
    //
    // Performs the role of definitionType on GenericSymbolRef but for locals.
    //
    // NOTE: Subsequent references may have different types.
    UnorderedMap<uint32_t, core::TypePtr> localDefinitionType;
    AliasMap aliasMap;

    // Local variable counter that is reset for every function.
    uint32_t counter = 0;
    SCIPState &scipState;
    core::Context ctx;

public:
    CFGTraversal(SCIPState &scipState, core::Context ctx)
        : blockLocals(), functionLocals(), aliasMap(), scipState(scipState), ctx(ctx) {}

private:
    uint32_t addLocal(const cfg::BasicBlock *bb, cfg::LocalRef localRef) {
        this->counter++;
        this->blockLocals[bb].insert(localRef);
        this->functionLocals[localRef] = this->counter;
        return this->counter;
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
    //
    // The type should be provided if we have an lvalue.
    bool emitLocalOccurrence(const cfg::CFG &cfg, const cfg::BasicBlock *bb, cfg::LocalOccurrence local,
                             ValueCategory category, core::TypePtr type) {
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
                    // If we're seeing this for the first time in topological order,
                    // The current block must have a definition for the variable.
                    isDefinition = true;
                    auto id = this->addLocal(bb, localRef);
                    this->localDefinitionType[id] = type;
                } else if (!this->blockLocals[bb].contains(localRef)) {
                    // The variable wasn't passed in as an argument, and hasn't already been recorded
                    // as a local in the block. So this must be a definition line.
                    isDefinition = true;
                    this->blockLocals[bb].insert(localRef);
                }
                break;
            }
            case ValueCategory::RValue: {
                referenceRole = scip::SymbolRole::ReadAccess;

                // Ill-formed code where we're trying to access a variable
                // without setting it first. Emit a local as a best-effort.
                // TODO(varun): Will Sorbet error out before we get here?
                if (!this->functionLocals.contains(localRef)) {
                    this->addLocal(bb, localRef);
                } else if (!this->blockLocals[bb].contains(localRef)) {
                    this->blockLocals[bb].insert(localRef);
                }
                break;
            }
        }
        ENFORCE(this->functionLocals.contains(localRef), "should've added local earlier if it was missing");
        absl::Status status;
        auto loc = local.loc;
        auto &gs = this->ctx.state;
        auto file = this->ctx.file;
        if (symRef.has_value()) {
            auto [namedSym, _] = symRef.value();
            if (isDefinition) {
                status = this->scipState.saveDefinition(gs, file, namedSym, loc);
            } else {
                auto overrideType = computeOverrideType(namedSym.definitionType(), type);
                status = this->scipState.saveReference(ctx, namedSym, overrideType, loc, referenceRole);
            }
        } else {
            uint32_t localId = this->functionLocals[localRef];
            auto it = this->localDefinitionType.find(localId);
            optional<core::TypePtr> overrideType;
            if (it != this->localDefinitionType.end()) {
                overrideType = computeOverrideType(it->second, type);
            } else {
                LOG_DEBUG(
                    gs, core::Loc(file, loc),
                    fmt::format(
                        "failed to find type info; are you using a code pattern unsupported by Sorbet?\ndebugging "
                        "information: aliasMap: {}",
                        this->aliasMap.showRaw(gs, file, cfg)));
                overrideType = type;
            }
            if (isDefinition) {
                status = this->scipState.saveDefinition(gs, file, OwnedLocal{this->ctx.owner, localId, loc}, type);
            } else {
                status = this->scipState.saveReference(gs, file, OwnedLocal{this->ctx.owner, localId, loc},
                                                       overrideType, referenceRole);
            }
        }

        ENFORCE(status.ok());
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
        this->aliasMap.populate(this->ctx, cfg, this->scipState.fieldResolver,
                                this->scipState.relationshipsMap[ctx.file]);
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
            absl::Status status;
            string kind;
            if (check) {
                status = this->scipState.saveDefinition(gs, file, namedSym, arg.loc);
                kind = "definition";
            } else {
                status = this->scipState.saveReference(ctx, namedSym, nullopt, arg.loc, 0);
                kind = "reference";
            }
            ENFORCE(status.ok(), "failed to save {} for {}\ncontext:\ninstruction: {}\nlocation: {}\n", kind,
                    namedSym.showRaw(gs), binding.value.showRaw(gs, cfg), core::Loc(file, arg.loc).showRaw(gs));
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
                    this->emitLocalOccurrence(cfg, bb, occ, ValueCategory::LValue, binding.bind.type);
                }
                // Emit occurrence information for the RHS
                auto emitLocal = [this, &cfg, &bb, &binding](cfg::LocalRef local) -> void {
                    (void)this->emitLocalOccurrence(cfg, bb, cfg::LocalOccurrence{local, binding.loc},
                                                    ValueCategory::RValue, binding.bind.type);
                };
                switch (binding.value.tag()) {
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
                            this->emitLocalOccurrence(cfg, bb, send->recv.occurrence(), ValueCategory::RValue,
                                                      send->recv.type);
                        }

                        // Emit reference for the method being called
                        auto recvType = send->recv.type;
                        // TODO(varun): When is the isTemporary check going to succeed?
                        if (recvType && send->fun.exists() && send->funLoc.exists() && !send->funLoc.empty() &&
                            !isTemporary(gs, core::LocalVariable(send->fun, 1))) {
                            core::ClassOrModuleRef recv{};
                            // NOTE(varun): Based on core::Types::getRepresentedClass. Trying to use it directly
                            // didn't quite work properly, but we might want to consolidate the implementation. I
                            // didn't quite understand the bit about attachedClass.
                            if (core::isa_type<core::ClassType>(recvType)) {
                                recv = core::cast_type_nonnull<core::ClassType>(recvType).symbol;
                            } else if (core::isa_type<core::AppliedType>(send->recv.type)) {
                                // Triggered for a module nested inside a class
                                recv = core::cast_type_nonnull<core::AppliedType>(send->recv.type).klass;
                            }
                            if (recv.exists()) {
                                auto funSym = recv.data(gs)->findMethodTransitive(gs, send->fun);
                                if (funSym.exists()) {
                                    // TODO(varun): For arrays, hashes etc., try to identify if the function
                                    // matches a known operator (e.g. []=), and emit an appropriate
                                    // 'WriteAccess' symbol role for it.
                                    auto status = this->scipState.saveReference(ctx, GenericSymbolRef::method(funSym),
                                                                                nullopt, send->funLoc, 0);
                                    ENFORCE(status.ok());
                                }
                            }
                        }

                        // Emit references for arguments
                        for (auto &arg : send->args) {
                            if (arg.loc == send->receiverLoc) { // See NOTE[implicit-arg-passing].
                                continue;
                            }
                            // NOTE: For constructs like a += b, the instruction sequence ends up being:
                            //   $tmp = $a
                            //   $a = $tmp.+($b)
                            // The location for $tmp will point to $a in the source. However, the second one is a read,
                            // and the first one is a write. Instead of emitting two occurrences, it'd be nice to emit
                            // a combined read-write occurrence. However, that would require complicating the code a
                            // bit, so let's leave it as-is for now.
                            this->emitLocalOccurrence(cfg, bb, arg.occurrence(), ValueCategory::RValue, arg.type);
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
                    case cfg::Tag::Literal:
                    case cfg::Tag::KeepAlive:
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
        using SymbolWithLoc = pair<GenericSymbolRef, core::LocOffsets>;
        vector<SymbolWithLoc> todo;
        for (auto &[_, value] : map) {
            auto &[namedSym, loc, emitted] = value;
            if (!emitted) {
                todo.emplace_back(namedSym, loc);
            }
        }
        bool foundDupes = false;
        // Sort for determinism
        fast_sort(todo, [&](const SymbolWithLoc &p1, const SymbolWithLoc &p2) -> bool {
            if (p1.second.beginPos() == p2.second.beginPos()) {
                if (p1.first == p2.first) {
                    foundDupes = true;
                    return false;
                } else {
                    // This code path is hit when trying to use encrypted_prop -- that creates two
                    // classes ::Opus and ::Opus::DB::Model with the same source locations as the declaration.
                    //
                    // It is also hit when a module_function is on top of sig, in which case,
                    // the 'T' and the 'X' in 'T::X' end up with two occurrences each. This latter
                    // example seems like a bug though.
                    return p1.first < p2.first;
                }
            }
            return p1.second.beginPos() < p2.second.beginPos();
        });
        if (foundDupes) {
            auto last = unique(todo.begin(), todo.end());
            todo.erase(last, todo.end());
        }
        // NOTE(varun): Not 100% sure if emitting a reference here is always correct.
        // Here's why it's written this way right now. This code path is hit in two
        // different kinds of situations:
        // - You have a reference to a nested class etc. inside a method body.
        // - You have a 'direct' definition of a nested class
        //     class M::C
        //       # blah
        //     end
        //   In this situation, M should count as a reference if we're mimicking RubyMine.
        //   Specifically, Go to Definition for modules seems to go to 'module M' even
        //   when other forms like 'class M::C' are present.
        for (auto &[namedSym, loc] : todo) {
            auto status = this->scipState.saveReference(ctx, namedSym, nullopt, loc, 0);
            ENFORCE(status.ok(), "status: {}\n", status.message());
        }
    }
};

} // end namespace sorbet::scip_indexer

namespace sorbet::pipeline::semantic_extension {

using LocalSymbolTable = UnorderedMap<core::LocalVariable, core::Loc>;

class SCIPSemanticExtension : public SemanticExtension {
    string indexFilePath;
    scip_indexer::Config config;
    scip_indexer::GemMapping gemMap;

    using SCIPState = sorbet::scip_indexer::SCIPState;

public:
    using StateMap = UnorderedMap<thread::id, shared_ptr<SCIPState>>;

private:
    mutable struct {
        StateMap states;
        absl::Mutex mtx;
    } mutableState;

public:
    SCIPSemanticExtension(string indexFilePath, scip_indexer::Config config, scip_indexer::GemMapping gemMap,
                          StateMap states)
        : indexFilePath(indexFilePath), config(config), gemMap(gemMap), mutableState{states, {}} {}

    ~SCIPSemanticExtension() {}

    virtual unique_ptr<SemanticExtension> deepCopy(const core::GlobalState &from, core::GlobalState &to) override {
        // FIXME: Technically, this would copy the state too, but we haven't implemented
        // deep-copying for it because it doesn't matter for scip-ruby.
        StateMap map;
        return make_unique<SCIPSemanticExtension>(this->indexFilePath, this->config, this->gemMap, map);
    };
    virtual void merge(const core::GlobalState &from, core::GlobalState &to, core::NameSubstitution &subst) override{};

private:
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

            // We will move the state out later, so use a no-op deleter.
            return mutableState.states[this_thread::get_id()] =
                       shared_ptr<SCIPState>(new SCIPState(gemMap), [](SCIPState *) {});
        }
    }

    bool doNothing() const {
        return this->indexFilePath.empty();
    }

public:
    void run(core::MutableContext &ctx, ast::ClassDef *cd) const override {}

    virtual void prepareForTypechecking(const core::GlobalState &gs) override {
        auto maybeMetadata = scip_indexer::GemMetadata::tryParse(this->config.gemMetadata);
        scip_indexer::GemMetadata currentGem;
        if (maybeMetadata.has_value()) {
            currentGem = maybeMetadata.value();
        } // TODO: Issue error for incorrect format in string...
        if (currentGem.name().empty() || currentGem.version().empty()) {
            auto [gem, errors] = scip_indexer::GemMetadata::readFromConfig(OSFileSystem());
            currentGem = gem;
            for (auto &error : errors) {
                if (auto e = gs.beginError(core::Loc(), scip_indexer::errors::SCIPRubyDebug)) {
                    e.setHeader("{}: {}",
                                error.kind == scip_indexer::GemMetadataError::Kind::Error ? "error" : "warning",
                                error.message);
                }
            }
        }
        this->gemMap.markCurrentGem(currentGem);
        if (!this->config.gemMapPath.empty()) {
            this->gemMap.populateFromNDJSON(gs, OSFileSystem(), this->config.gemMapPath);
        }
    };

    virtual void finishTypecheckFile(const core::GlobalState &gs, const core::FileRef &file) const override {
        if (this->doNothing()) {
            return;
        }
        auto scipState = this->getSCIPState();
        scipState->finalizeRefOnlySymbolInfos(gs, file);
        scipState->saveDocument(gs, file);
    };
    virtual void finishTypecheck(const core::GlobalState &gs) const override {
        if (this->doNothing()) {
            return;
        }
        scip::ToolInfo toolInfo;
        toolInfo.set_name("scip-ruby");
        toolInfo.set_version(scip_ruby_version);
        *toolInfo.add_arguments() = "FIXME"; // FIXME(varun): GlobalState doesn't have access to CLI arguments. 🙁

        scip::Metadata metadata;
        metadata.set_version(scip::UnspecifiedProtocolVersion);
        *metadata.mutable_tool_info() = toolInfo;
        // NOTE: We are not respecting the path prefix option here. Should we do that?
        // FIXME(varun): filesystem::current_path() returns the path in 'native' format,
        // so this won't work on Windows.
        metadata.set_project_root("file:/" + filesystem::current_path().string());
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
        auto drain = [](auto &input, auto &output) {
            output.reserve(output.size() + input.size());
            for (auto &v : input) {
                output.push_back(move(v));
            }
            input.clear();
        };

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
            auto status = scipState->saveDefinition(gs, file, scip_indexer::GenericSymbolRef::method(methodDef.symbol));
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

        auto &scipStateRef = *scipState.get();
        sorbet::scip_indexer::CFGTraversal traversal(scipStateRef, core::Context(gs, methodDef.symbol, file));
        traversal.traverse(cfg);
        scipStateRef.clearFunctionLocalCaches();
    }
};

class SCIPSemanticExtensionProvider : public SemanticExtensionProvider {
public:
    void injectOptions(cxxopts::Options &optsBuilder) const override {
        optsBuilder.add_options("indexer")("index-file", "Output SCIP index to a directory, which must already exist",
                                           cxxopts::value<string>());
        optsBuilder.add_options("indexer")(
            "gem-metadata",
            "Metadata in 'name@version' format to be used for cross-repository code navigation. For repositories which "
            "index every commit, the SHA should be used for the version instead of a git tag (or equivalent).",
            cxxopts::value<string>());
        optsBuilder.add_options("indexer")(
            "gem-map-path",
            "Path to newline-delimited JSON file which describes how to map paths to gem name and versions. See the"
            " scip-ruby docs on GitHub for information about the JSON schema.",
            cxxopts::value<string>());
    };
    unique_ptr<SemanticExtension> readOptions(cxxopts::ParseResult &providedOptions) const override {
        if (providedOptions.count("version") > 0) {
            // HACK: Just modify the version in place instead of duplicating the logic in sorbet_version.c
            // There is some 'sed' replacement going on in that file.
            fmt::print("scip-ruby {}\nBased on Sorbet {} {}\n",
                       absl::StrReplaceAll(sorbet_full_version_string,
                                           {{sorbet_version, scip_ruby_version},
                                            {fmt::format(".{}", sorbet_build_scm_commit_count), ""}}),
                       sorbet_version, scip_ruby_sync_upstream_sorbet_sha);
            throw sorbet::EarlyReturnWithCode(0);
        }
        string indexFilePath{};
        if (providedOptions.count("index-file") > 0) {
            indexFilePath = providedOptions["index-file"].as<string>();
        } else {
            indexFilePath = "index.scip";
        }
        scip_indexer::Config config{};
        if (providedOptions.count("gem-map-path") > 0) {
            config.gemMapPath = providedOptions["gem-map-path"].as<string>();
        }
        if (providedOptions.count("gem-metadata") > 0) {
            config.gemMetadata = providedOptions["gem-metadata"].as<string>();
        }
        scip_indexer::GemMapping gemMap{};
        SCIPSemanticExtension::StateMap stateMap;
        return make_unique<SCIPSemanticExtension>(indexFilePath, config, gemMap, stateMap);
    };
    virtual unique_ptr<SemanticExtension> defaultInstance() const override {
        scip_indexer::GemMapping gemMap{};
        scip_indexer::Config config{};
        SCIPSemanticExtension::StateMap stateMap;
        return make_unique<SCIPSemanticExtension>("index.scip", config, gemMap, stateMap);
    };
    static vector<SemanticExtensionProvider *> getProviders();
    virtual ~SCIPSemanticExtensionProvider() = default;
};

vector<SemanticExtensionProvider *> SemanticExtensionProvider::getProviders() {
    static SCIPSemanticExtensionProvider scipExtension;
    return {&scipExtension};
}
} // namespace sorbet::pipeline::semantic_extension
