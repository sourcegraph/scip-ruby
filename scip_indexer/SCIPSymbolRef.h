#ifndef SORBET_SCIP_SYMBOL_REF
#define SORBET_SCIP_SYMBOL_REF

#include <optional>
#include <string>
#include <vector>

#include "absl/status/status.h"
#include "absl/strings/str_split.h"

#include "common/common.h"
#include "core/Loc.h"
#include "core/NameRef.h"
#include "core/SymbolRef.h"
#include "core/Symbols.h"
#include "core/TypePtr.h"

#include "scip_indexer/SCIPFieldResolve.h"

namespace scip { // Avoid needlessly including protobuf header here.
class Symbol;
class Relationship;
} // namespace scip

namespace sorbet::scip_indexer {

template <typename T> using SmallVec = InlinedVector<T, 2>;

class GemMetadata final {
    std::string _name;
    std::string _version;

    GemMetadata(std::string name, std::string version) : _name(name), _version(version) {}

public:
    GemMetadata &operator=(const GemMetadata &) = default;

    static GemMetadata tryParseOrDefault(std::string metadata) {
        std::vector<std::string> v = absl::StrSplit(metadata, '@');
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

class UntypedGenericSymbolRef;

using RelationshipsMap = UnorderedMap<UntypedGenericSymbolRef, FieldQueryResult>;

std::string showRawRelationshipsMap(const core::GlobalState &gs, const RelationshipsMap &relMap);

// Simplified version of GenericSymbolRef that doesn't care about types.
//
// Primarily for use in storing/looking up information in maps/sets,
// as type information for fields can be refined based on control flow.
class UntypedGenericSymbolRef final {
    sorbet::core::SymbolRef selfOrOwner;
    sorbet::core::NameRef name;

    UntypedGenericSymbolRef(sorbet::core::SymbolRef selfOrOwner, sorbet::core::NameRef name)
        : selfOrOwner(selfOrOwner), name(name) {}

public:
    bool operator==(const UntypedGenericSymbolRef &other) const {
        return this->selfOrOwner == other.selfOrOwner && this->name == other.name;
    }

    template <typename H> friend H AbslHashValue(H h, const UntypedGenericSymbolRef &x) {
        return H::combine(std::move(h), x.selfOrOwner, x.name);
    }

    static UntypedGenericSymbolRef methodOrClassOrModule(sorbet::core::SymbolRef sym) {
        ENFORCE(sym.exists());
        return UntypedGenericSymbolRef(sym, {});
    }

    static UntypedGenericSymbolRef field(sorbet::core::ClassOrModuleRef klass, sorbet::core::NameRef name) {
        ENFORCE(klass.exists());
        ENFORCE(name.exists())
        return UntypedGenericSymbolRef(klass, name);
    }

    // Try to compute a scip::Symbol for this value.
    absl::Status symbolForExpr(const core::GlobalState &gs, const GemMetadata &metadata, std::optional<core::Loc> loc,
                               scip::Symbol &symbol) const;

    void
    saveRelationships(const core::GlobalState &gs, const RelationshipsMap &relationshipMap,
                      SmallVec<scip::Relationship> &rels,
                      const absl::FunctionRef<void(UntypedGenericSymbolRef, std::string &)> &saveSymbolString) const;

    std::string showRaw(const core::GlobalState &gs) const;
};

// A wrapper type to handle both top-level symbols (like classes) as well as
// "inner symbols" like fields (@x). In a statically typed language, field
// symbols are like any other symbols, but in Ruby, they aren't (necessarily)
// declared ahead-of-time (you can declare them with @x = T.let(…, …) though).
// So Sorbet represents them with a separate name on the side.
//
// Structurally, this is similar to the Alias instruction. One key difference
// is that a GenericSymbolRef may refer to the owner in some situations.
class GenericSymbolRef final {
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
        Field,
        Method,
    };

private:
    GenericSymbolRef(core::SymbolRef s, core::NameRef n, core::TypePtr t, Kind k)
        : selfOrOwner(s), name(n), _definitionType(t) {
        switch (k) {
            case Kind::ClassOrModule:
                ENFORCE(s.isClassOrModule());
                ENFORCE(!n.exists());
                return;
            case Kind::Field:
                ENFORCE(s.isClassOrModule());
                ENFORCE(n.exists());
                return;
            case Kind::Method:
                ENFORCE(s.isMethod());
                ENFORCE(!n.exists());
        }
    }

public:
    GenericSymbolRef(const GenericSymbolRef &) = default;
    GenericSymbolRef(GenericSymbolRef &&) = default;
    GenericSymbolRef &operator=(const GenericSymbolRef &) = default;
    GenericSymbolRef &operator=(GenericSymbolRef &&) = default;

    friend bool operator==(const GenericSymbolRef &lhs, const GenericSymbolRef &rhs) {
        return lhs.selfOrOwner == rhs.selfOrOwner && lhs.name == rhs.name;
    }

    friend bool operator<(const GenericSymbolRef &lhs, const GenericSymbolRef &rhs) {
        return lhs.selfOrOwner.rawId() < rhs.selfOrOwner.rawId() ||
               (lhs.selfOrOwner == rhs.selfOrOwner && lhs.name.rawId() < rhs.name.rawId());
    }

    template <typename H> friend H AbslHashValue(H h, const GenericSymbolRef &c) {
        return H::combine(std::move(h), c.selfOrOwner, c.name);
    }

    static GenericSymbolRef classOrModule(core::SymbolRef self) {
        return GenericSymbolRef(self, {}, {}, Kind::ClassOrModule);
    }

    static GenericSymbolRef field(core::SymbolRef owner, core::NameRef name, core::TypePtr type) {
        return GenericSymbolRef(owner, name, type, Kind::Field);
    }

    static GenericSymbolRef method(core::SymbolRef self) {
        return GenericSymbolRef(self, {}, {}, Kind::Method);
    }

    core::TypePtr definitionType() const {
        return this->_definitionType;
    }

    Kind kind() const {
        if (this->name.exists()) {
            return Kind::Field;
        }
        if (this->selfOrOwner.isMethod()) {
            return Kind::Method;
        }
        return Kind::ClassOrModule;
    }

    UntypedGenericSymbolRef withoutType() const {
        switch (this->kind()) {
            case Kind::Field:
                ENFORCE(this->selfOrOwner.isClassOrModule());
                return UntypedGenericSymbolRef::field(this->selfOrOwner.asClassOrModuleRef(), this->name);
            case Kind::Method:
            case Kind::ClassOrModule:
                return UntypedGenericSymbolRef::methodOrClassOrModule(this->selfOrOwner);
        }
    }

    /// Display a GenericSymbolRef for debugging.
    std::string showRaw(const core::GlobalState &gs) const;

    core::SymbolRef asSymbolRef() const {
        ENFORCE(this->kind() != Kind::Field);
        return this->selfOrOwner;
    }

private:
    static bool isSorbetInternal(const core::GlobalState &gs, core::SymbolRef sym);

public:
    bool isSorbetInternalClassOrMethod(const core::GlobalState &gs) const {
        switch (this->kind()) {
            case Kind::Field:
                return false;
            case Kind::ClassOrModule:
            case Kind::Method:
                return isSorbetInternal(gs, this->asSymbolRef());
        }
    }

    void saveDocStrings(const core::GlobalState &gs, core::TypePtr fieldType, core::Loc loc,
                        SmallVec<std::string> &docs) const;

    core::Loc symbolLoc(const core::GlobalState &gs) const;
};

} // namespace sorbet::scip_indexer

#endif // SORBET_SCIP_SYMBOL_REF
