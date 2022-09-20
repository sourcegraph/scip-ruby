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
#include "common/common.h"
#include "common/sort.h"
#include "core/Error.h"
#include "core/ErrorQueue.h"
#include "core/Loc.h"
#include "core/SymbolRef.h"
#include "core/Symbols.h"
#include "main/lsp/lsp.h"
#include "main/pipeline/semantic_extension/SemanticExtension.h"
#include "sorbet_version/sorbet_version.h"

#include "scip_indexer/Debug.h"
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
           n == Names::keepForCfgTemp() ||
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

bool isSorbetInternal(const core::GlobalState &gs, core::SymbolRef sym) {
    UnorderedSet<core::SymbolRef> visited;
    auto classT = core::Symbols::T().data(gs)->lookupSingletonClass(gs);
    while (sym.exists() && !visited.contains(sym)) {
        if (sym.isClassOrModule()) {
            auto klass = sym.asClassOrModuleRef();
            if (klass == core::Symbols::Sorbet_Private() || klass == core::Symbols::T() || klass == classT) {
                return true;
            }
            auto name = klass.data(gs)->name;
            if (name == core::Names::Constants::Opus()) {
                return true;
            }
        }
        visited.insert(sym);
        sym = sym.owner(gs);
    }
    return false;
}

// A wrapper type to handle both top-level symbols (like classes) as well as
// "inner symbols" like fields (@x). In a statically typed language, field
// symbols are like any other symbols, but in Ruby, they aren't (necessarily)
// declared ahead-of-time (you can declare them with @x = T.let(…, …) though).
// So Sorbet represents them with a separate name on the side.
//
// Structurally, this is similar to the Alias instruction. One key difference
// is that the SymbolRef may refer to the owner in some situations.
class NamedSymbolRef final {
    core::SymbolRef selfOrOwner;

    /// Name of the symbol, which may or may not exist.
    core::NameRef name;

    /// The type of the symbol at its definition, if applicable.
    ///
    /// References to this symbol may have a different type,
    /// because you can change the type of a field, including within
    /// the same basic block.
    core::TypePtr _definitionType;

public:
    enum class Kind {
        ClassOrModule,
        UndeclaredField,
        DeclaredField,
        Method,
    };

private:
    NamedSymbolRef(core::SymbolRef s, core::NameRef n, core::TypePtr t, Kind k)
        : selfOrOwner(s), name(n), _definitionType(t) {
        switch (k) {
            case Kind::ClassOrModule:
                ENFORCE(s.isClassOrModule());
                ENFORCE(!n.exists());
                return;
            case Kind::DeclaredField:
                ENFORCE(s.isFieldOrStaticField());
                ENFORCE(!n.exists());
                return;
            case Kind::UndeclaredField:
                ENFORCE(s.isClassOrModule());
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

    friend bool operator<(const NamedSymbolRef &lhs, const NamedSymbolRef &rhs) {
        return lhs.selfOrOwner.rawId() < rhs.selfOrOwner.rawId() ||
               (lhs.selfOrOwner == rhs.selfOrOwner && lhs.name.rawId() < rhs.name.rawId());
    }

    template <typename H> friend H AbslHashValue(H h, const NamedSymbolRef &c) {
        return H::combine(std::move(h), c.selfOrOwner, c.name);
    }

    static NamedSymbolRef classOrModule(core::SymbolRef self) {
        return NamedSymbolRef(self, {}, {}, Kind::ClassOrModule);
    }

    static NamedSymbolRef undeclaredField(core::SymbolRef owner, core::NameRef name, core::TypePtr type) {
        return NamedSymbolRef(owner, name, type, Kind::UndeclaredField);
    }

    static NamedSymbolRef declaredField(core::SymbolRef self, core::TypePtr type) {
        return NamedSymbolRef(self, {}, type, Kind::DeclaredField);
    }

    static NamedSymbolRef method(core::SymbolRef self) {
        return NamedSymbolRef(self, {}, {}, Kind::Method);
    }

    core::TypePtr definitionType() const {
        return this->_definitionType;
    }

    Kind kind() const {
        if (this->name.exists()) {
            return Kind::UndeclaredField;
        }
        if (this->selfOrOwner.isFieldOrStaticField()) {
            return Kind::DeclaredField;
        }
        if (this->selfOrOwner.isMethod()) {
            return Kind::Method;
        }
        return Kind::ClassOrModule;
    }

    UntypedGenericSymbolRef withoutType() const {
        switch (this->kind()) {
            case Kind::UndeclaredField:
                ENFORCE(this->selfOrOwner.isClassOrModule());
                return UntypedGenericSymbolRef::undeclared(this->selfOrOwner.asClassOrModuleRef(), this->name);
            case Kind::Method:
            case Kind::ClassOrModule:
            case Kind::DeclaredField:
                return UntypedGenericSymbolRef::declared(this->selfOrOwner);
        }
    }

    /// Display a NamedSymbolRef for debugging.
    string showRaw(const core::GlobalState &gs) const {
        switch (this->kind()) {
            case Kind::UndeclaredField:
                return fmt::format("UndeclaredField(owner: {}, name: {})", this->selfOrOwner.showFullName(gs),
                                   this->name.toString(gs));
            case Kind::DeclaredField:
                return fmt::format("DeclaredField {}", this->selfOrOwner.showFullName(gs));
            case Kind::ClassOrModule:
                return fmt::format("ClassOrModule {}", this->selfOrOwner.showFullName(gs));
            case Kind::Method:
                return fmt::format("Method {}", this->selfOrOwner.showFullName(gs));
        }
        ENFORCE(false, "impossible");
    }

    core::SymbolRef asSymbolRef() const {
        ENFORCE(this->kind() != Kind::UndeclaredField);
        return this->selfOrOwner;
    }

    bool isSorbetInternalClassOrMethod(const core::GlobalState &gs) const {
        switch (this->kind()) {
            case Kind::UndeclaredField:
            case Kind::DeclaredField:
                return false;
            case Kind::ClassOrModule:
            case Kind::Method:
                return isSorbetInternal(gs, this->asSymbolRef());
        }
        ENFORCE(false, "impossible");
    }

    vector<string> docStrings(const core::GlobalState &gs, core::TypePtr fieldType, core::Loc loc) {
#define CHECK_TYPE(type, name) \
    ENFORCE(type, "missing type for {} in file {}\n{}\n", name, loc.file().data(gs).path(), loc.toString(gs))

        vector<string> docs;
        string markdown = "";
        switch (this->kind()) {
            case Kind::UndeclaredField: {
                auto name = this->name.show(gs);
                CHECK_TYPE(fieldType, name);
                markdown = fmt::format("{} ({})", name, fieldType.show(gs));
                break;
            }
            case Kind::DeclaredField: {
                auto fieldRef = this->selfOrOwner.asFieldRef();
                auto name = fieldRef.showFullName(gs);
                CHECK_TYPE(fieldType, name);
                markdown = fmt::format("{} ({})", name, fieldType.show(gs));
                break;
            }
            case Kind::ClassOrModule: {
                auto ref = this->selfOrOwner.asClassOrModuleRef();
                auto classOrModule = ref.data(gs);
                if (classOrModule->isClass()) {
                    auto super = classOrModule->superClass();
                    if (super.exists() && super != core::Symbols::Object()) {
                        markdown = fmt::format("class {} < {}", ref.show(gs), super.show(gs));
                    } else {
                        markdown = fmt::format("class {}", ref.show(gs));
                    }
                } else {
                    markdown = fmt::format("module {}", ref.show(gs));
                }
                break;
            }
            case Kind::Method: {
                auto ref = this->selfOrOwner.asMethodRef();
                auto resultType = ref.data(gs)->owner.data(gs)->resultType;
                CHECK_TYPE(resultType, fmt::format("result type for {}", ref.showFullName(gs)));
                markdown = realmain::lsp::prettyTypeForMethod(gs, ref, resultType, nullptr, nullptr);
                // FIXME(varun): For some reason, it looks like a bunch of public methods
                // get marked as private here. Avoid printing misleading info until we fix that.
                // https://github.com/sourcegraph/scip-ruby/issues/33
                markdown = absl::StrReplaceAll(markdown, {{"private def", "def"}, {"; end", ""}});
                break;
            }
        }
        if (!markdown.empty()) {
            docs.push_back(fmt::format("```ruby\n{}\n```", markdown));
        }
        auto whatFile = loc.file();
        if (whatFile.exists()) {
            if (auto doc = realmain::lsp::findDocumentation(whatFile.data(gs).source(), loc.beginPos())) {
                docs.push_back(doc.value());
            }
        }
        return docs;
#undef CHECK_TYPE
    }

    core::Loc symbolLoc(const core::GlobalState &gs) const {
        switch (this->kind()) {
            case Kind::Method: {
                auto method = this->selfOrOwner.asMethodRef().data(gs);
                if (!method->nameLoc.exists() || method->nameLoc.empty()) {
                    return method->loc();
                }
                return method->nameLoc;
            }
            case Kind::ClassOrModule:
            case Kind::DeclaredField:
                return this->selfOrOwner.loc(gs);
            case Kind::UndeclaredField:
                ENFORCE(false, "case UndeclaredField should not be triggered here");
                return core::Loc();
        }
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

using OccurrenceCache = UnorderedMap<pair<core::LocOffsets, /*SymbolRole*/ int32_t>, uint32_t>;

/// Per-thread state storing information to be emitting in a SCIP index.
///
/// The states are implicitly merged at the time of emitting the index.
class SCIPState {
    string symbolScratchBuffer;
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
    UnorderedSet<tuple<NamedSymbolRef, core::Loc, /*SymbolRole*/ int32_t>> symbolOccurrenceCache;
    // ^ Naively, I would think that that shouldn't happen because we don't traverse
    // rewriter-synthesized method bodies, but it does seem to happen.
    //
    // Also, you would think that emittedSymbols below would handle this.
    // But it doesn't, for some reason... 🤔
    //
    // FIXME(varun): This seems redundant, get rid of it.

    GemMetadata gemMetadata;

public:
    UnorderedMap<core::FileRef, vector<scip::Occurrence>> occurrenceMap;

    /// Set containing symbols that have been emitted.
    ///
    /// For every (f, s) in emittedSymbols, symbolMap[f] = SymbolInfo{s, ... other stuff}
    /// and vice-versa. This is present to avoid emitting multiple SymbolInfos
    /// for the same local variable if there are multiple definitions.
    UnorderedSet<pair<core::FileRef, string>> emittedSymbols;
    UnorderedMap<core::FileRef, vector<scip::SymbolInformation>> symbolMap;

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

    void clearFunctionLocalCaches() {
        this->localOccurrenceCache.clear();
    }

    /// If the returned value is as success, the pointer is non-null.
    ///
    /// The argument symbol is used instead of recomputing from scratch if it is non-null.
    absl::StatusOr<const string *> saveSymbolString(const core::GlobalState &gs, UntypedGenericSymbolRef symRef,
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
            status = symRef.symbolForExpr(gs, this->gemMetadata, {}, symbol);
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
    Emitted saveSymbolInfo(core::FileRef file, const string &symbolString, const vector<string> &docs) {
        if (this->emittedSymbols.contains({file, symbolString})) {
            return Emitted::Earlier;
        }
        scip::SymbolInformation symbolInfo;
        symbolInfo.set_symbol(symbolString);
        for (auto &doc : docs) {
            symbolInfo.add_documentation(doc);
        }
        this->symbolMap[file].push_back(symbolInfo);
        return Emitted::Now;
    }

    absl::Status saveDefinitionImpl(const core::GlobalState &gs, core::FileRef file, const string &symbolString,
                                    core::Loc occLoc, const vector<string> &docs) {
        ENFORCE(!symbolString.empty());

        auto emitted = this->saveSymbolInfo(file, symbolString, docs);

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
                           const vector<string> &overrideDocs, core::LocOffsets occLocOffsets, int32_t symbol_roles) {
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

    bool cacheOccurrence(const core::GlobalState &gs, core::Loc loc, NamedSymbolRef sym, int32_t symbolRoles) {
        // Optimization:
        //   Avoid emitting duplicate def/refs for symbols.
        // This can happen with constructs like:
        //   prop :foo, String
        // Without this optimization, there are 4 occurrences for String
        // emitted for the same source range.
        auto [_, inserted] = this->symbolOccurrenceCache.insert({sym, loc, symbolRoles});
        return !inserted;
    }

public:
    absl::Status saveDefinition(const core::GlobalState &gs, core::FileRef file, OwnedLocal occ, core::TypePtr type) {
        if (this->cacheOccurrence(gs, file, occ, scip::SymbolRole::Definition)) {
            return absl::OkStatus();
        }
        vector<string> docStrings;
        auto loc = core::Loc(file, occ.offsets);
        if (type) {
            auto var = loc.source(gs);
            ENFORCE(var.has_value(), "Failed to find source text for definition of local variable");
            docStrings.push_back(fmt::format("```ruby\n{} ({})\n```", var.value(), type.show(gs)));
        }
        return this->saveDefinitionImpl(gs, file, occ.toSCIPString(gs, file), loc, docStrings);
    }

    // Save definition when you have a sorbet Symbol.
    // Meant for methods, fields etc., but not local variables.
    // TODO(varun): Should we always pass in the location instead of sometimes only?
    absl::Status saveDefinition(const core::GlobalState &gs, core::FileRef file, NamedSymbolRef symRef,
                                optional<core::LocOffsets> loc = nullopt) {
        // In practice, there doesn't seem to be any situation which triggers
        // a duplicate definition being emitted, so skip calling cacheOccurrence here.

        auto occLoc = loc.has_value() ? core::Loc(file, loc.value()) : symRef.symbolLoc(gs);
        scip::Symbol symbol;
        auto status = symRef.withoutType().symbolForExpr(gs, this->gemMetadata, occLoc, symbol);
        if (!status.ok()) {
            return status;
        }
        absl::StatusOr<const string *> valueOrStatus(this->saveSymbolString(gs, symRef.withoutType(), &symbol));
        if (!valueOrStatus.ok()) {
            return valueOrStatus.status();
        }
        const string &symbolString = *valueOrStatus.value();
        return this->saveDefinitionImpl(gs, file, symbolString, occLoc,
                                        symRef.docStrings(gs, symRef.definitionType(), occLoc));
    }

    absl::Status saveReference(const core::GlobalState &gs, core::FileRef file, OwnedLocal occ,
                               optional<core::TypePtr> overrideType, int32_t symbol_roles) {
        if (this->cacheOccurrence(gs, file, occ, symbol_roles)) {
            return absl::OkStatus();
        }
        vector<string> overrideDocs;
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

    absl::Status saveReference(const core::Context &ctx, NamedSymbolRef symRef, optional<core::TypePtr> overrideType,
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
        absl::StatusOr<const string *> valueOrStatus(this->saveSymbolString(gs, symRef.withoutType(), nullptr));
        if (!valueOrStatus.ok()) {
            return valueOrStatus.status();
        }
        const string &symbolString = *valueOrStatus.value();

        vector<string> overrideDocs{};
        using Kind = NamedSymbolRef::Kind;
        switch (symRef.kind()) {
            case Kind::ClassOrModule:
            case Kind::Method:
                break;
            case Kind::UndeclaredField:
            case Kind::DeclaredField:
                if (overrideType.has_value()) {
                    overrideDocs = symRef.docStrings(gs, overrideType.value(), loc);
                }
        }
        this->saveReferenceImpl(gs, file, symbolString, overrideDocs, occLoc, symbol_roles);
        return absl::OkStatus();
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

static absl::variant</*owner*/ core::ClassOrModuleRef, core::SymbolRef>
findUnresolvedFieldTransitive(const core::GlobalState &gs, core::Loc loc, core::ClassOrModuleRef start,
                              core::NameRef field) {
    auto fieldText = field.shortName(gs);
    auto isInstanceVar = fieldText.size() >= 2 && fieldText[0] == '@' && fieldText[1] != '@';
    auto isClassInstanceVar = isInstanceVar && start.data(gs)->isSingletonClass(gs);
    // Class instance variables are not inherited, unlike ordinary instance
    // variables or class variables.
    if (isClassInstanceVar) {
        return start;
    }
    auto isClassVar = fieldText.size() >= 2 && fieldText[0] == '@' && fieldText[1] == '@';
    if (isClassVar && !start.data(gs)->isSingletonClass(gs)) {
        // Triggered when undeclared class variables are accessed from instance methods.
        start = start.data(gs)->lookupSingletonClass(gs);
    }

    // TODO(varun): Should we add a cache here? It seems wasteful to redo
    // work for every occurrence.
    if (gs.unresolvedFields.find(start) == gs.unresolvedFields.end() ||
        !gs.unresolvedFields.find(start)->second.contains(field)) {
        // Triggered by code patterns like:
        //   # top-level
        //   def MyClass.method
        //     # blah
        //   end
        // which is not supported by Sorbet.
        LOG_DEBUG(gs, loc,
                  fmt::format("couldn't find field {} in class {};\n"
                              "are you using a code pattern like def MyClass.method which is unsupported by Sorbet?",
                              field.exists() ? field.toString(gs) : "<non-existent>",
                              start.exists() ? start.showFullName(gs) : "<non-existent>"));
        // As a best-effort guess, assume that the definition is
        // in this class but we somehow missed it.
        return start;
    }

    auto best = start;
    auto cur = start;
    while (cur.exists()) {
        auto klass = cur.data(gs);
        auto sym = klass->findMember(gs, field);
        if (sym.exists()) {
            return sym;
        }
        auto it = gs.unresolvedFields.find(cur);
        if (it != gs.unresolvedFields.end() && it->second.contains(field)) {
            best = cur;
        }
        if (cur == klass->superClass()) { // FIXME(varun): Handle mix-ins
            break;
        }
        cur = klass->superClass();
    }
    return best;
}

// Loosely inspired by AliasesAndKeywords in IREmitterContext.cc
class AliasMap final {
public:
    using Impl = UnorderedMap<cfg::LocalRef, tuple<NamedSymbolRef, core::LocOffsets, /*emitted*/ bool>>;

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
                    auto result = findUnresolvedFieldTransitive(ctx, ctx.locAt(bind.loc), klass.asClassOrModuleRef(),
                                                                instr->name);
                    if (absl::holds_alternative<core::ClassOrModuleRef>(result)) {
                        auto klass = absl::get<core::ClassOrModuleRef>(result);
                        if (klass.exists()) {
                            this->map.insert( // no trim(...) because undeclared fields shouldn't have ::
                                {bind.bind.variable,
                                 {NamedSymbolRef::undeclaredField(klass, instr->name, bind.bind.type), bind.loc,
                                  false}});
                        }
                    } else if (absl::holds_alternative<core::SymbolRef>(result)) {
                        auto fieldSym = absl::get<core::SymbolRef>(result);
                        if (fieldSym.exists()) {
                            this->map.insert(
                                {bind.bind.variable,
                                 {NamedSymbolRef::declaredField(fieldSym, bind.bind.type), trim(bind.loc), false}});
                        }
                    } else {
                        ENFORCE(false, "Should've handled all cases of variant earlier");
                    }
                    continue;
                }
                if (sym.isFieldOrStaticField()) {
                    ENFORCE(!bind.loc.empty());
                    this->map.insert(
                        {bind.bind.variable,
                         {NamedSymbolRef::declaredField(instr->what, bind.bind.type), trim(bind.loc), false}});
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
                    this->map.insert({bind.bind.variable, {NamedSymbolRef::classOrModule(sym), trim(loc), false}});
                }
            }
        }
    }

    optional<pair<NamedSymbolRef, core::LocOffsets>> try_consume(cfg::LocalRef localRef) {
        auto it = this->map.find(localRef);
        if (it == this->map.end()) {
            return nullopt;
        }
        auto &[namedSym, loc, emitted] = it->second;
        emitted = true;
        return {{namedSym, loc}};
    }

    string showRaw(const core::GlobalState &gs, core::FileRef file, const cfg::CFG &cfg) const {
        return map_to_string(this->map, [&](const cfg::LocalRef &local, auto &data) -> string {
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
    // Performs the role of definitionType on NamedSymbolRef but for locals.
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
            default:
                ENFORCE(false, "unhandled case of ValueCategory")
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
                                    auto status = this->scipState.saveReference(ctx, NamedSymbolRef::method(funSym),
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
        using SymbolWithLoc = pair<NamedSymbolRef, core::LocOffsets>;
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

            // We will move the state out later, so use a no-op deleter.
            return mutableState.states[this_thread::get_id()] =
                       shared_ptr<SCIPState>(new SCIPState(gemMetadata), [](SCIPState *) {});
        }
    }

    bool doNothing() const {
        return this->indexFilePath.empty();
    }

    void run(core::MutableContext &ctx, ast::ClassDef *cd) const override {}

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

        auto &scipStateRef = *scipState.get();
        sorbet::scip_indexer::CFGTraversal traversal(scipStateRef, core::Context(gs, methodDef.symbol, file));
        traversal.traverse(cfg);
        scipStateRef.clearFunctionLocalCaches();
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
                                           cxxopts::value<string>())(
            "gem-metadata", "Metadata in 'name@version' format to be used for cross-repository code navigation.",
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
