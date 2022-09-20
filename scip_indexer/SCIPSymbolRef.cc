// NOTE: Protobuf headers should go first since they use poisoned functions.
#include "proto/SCIP.pb.h"

#include <optional>
#include <string>
#include <vector>

#include "absl/status/status.h"

#include "core/Loc.h"

#include "scip_indexer/SCIPSymbolRef.h"

using namespace std;

namespace sorbet::scip_indexer {

// Try to compute a scip::Symbol for this value.
absl::Status UntypedGenericSymbolRef::symbolForExpr(const core::GlobalState &gs, const GemMetadata &metadata,
                                                    optional<core::Loc> loc, scip::Symbol &symbol) const {
    // Don't set symbol.scheme and package.manager here because
    // those are hard-coded to 'scip-ruby' and 'gem' anyways.
    scip::Package package;
    package.set_name(metadata.name());
    package.set_version(metadata.version());
    *symbol.mutable_package() = move(package);

    InlinedVector<scip::Descriptor, 4> descriptors;
    auto cur = this->selfOrOwner;
    while (cur != core::Symbols::root()) {
        // NOTE(varun): The current scheme will cause multiple 'definitions' for the same
        // entity if it is present in different files, because the path is not encoded
        // in the descriptor whose parent is the root. This matches the semantics of
        // RubyMine, but we may want to revisit this if it is problematic for classes
        // that are extended in lots of places.
        scip::Descriptor descriptor;
        *descriptor.mutable_name() = cur.name(gs).show(gs);
        ENFORCE(!descriptor.name().empty());
        // TODO(varun): Are the scip descriptor kinds correct?
        switch (cur.kind()) {
            case core::SymbolRef::Kind::Method:
                // NOTE(varun): There is a separate isOverloaded field in the flags field,
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
} // namespace sorbet::scip_indexer