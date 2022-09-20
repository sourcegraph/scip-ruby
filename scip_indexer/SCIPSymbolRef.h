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

namespace scip { // Avoid needlessly including protobuf header here.
class Symbol;
}

namespace sorbet::scip_indexer {

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

    static UntypedGenericSymbolRef declared(sorbet::core::SymbolRef sym) {
        ENFORCE(sym.exists());
        return UntypedGenericSymbolRef(sym, {});
    }

    static UntypedGenericSymbolRef undeclared(sorbet::core::ClassOrModuleRef klass, sorbet::core::NameRef name) {
        ENFORCE(klass.exists());
        ENFORCE(name.exists())
        return UntypedGenericSymbolRef(klass, name);
    }

    // Try to compute a scip::Symbol for this value.
    absl::Status symbolForExpr(const core::GlobalState &gs, const GemMetadata &metadata, std::optional<core::Loc> loc,
                               scip::Symbol &symbol) const;
};

} // namespace sorbet::scip_indexer

#endif // SORBET_SCIP_SYMBOL_REF