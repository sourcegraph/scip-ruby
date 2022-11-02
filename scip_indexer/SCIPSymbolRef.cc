// NOTE: Protobuf headers should go first since they use poisoned functions.
#include "proto/SCIP.pb.h"

#include <optional>
#include <string>
#include <vector>

#include "absl/status/status.h"
#include "absl/strings/ascii.h"
#include "absl/strings/str_replace.h"
#include "spdlog/fmt/fmt.h"

#include "common/FileSystem.h"
#include "common/sort.h"
#include "core/Loc.h"
#include "main/lsp/LSPLoop.h"

#include "scip_indexer/Debug.h"
#include "scip_indexer/SCIPGemMetadata.h"
#include "scip_indexer/SCIPProtoExt.h"
#include "scip_indexer/SCIPSymbolRef.h"
#include "scip_indexer/SCIPUtils.h"

using namespace std;

namespace sorbet::scip_indexer {

string showRawRelationshipsMap(const core::GlobalState &gs, const RelationshipsMap &relMap) {
    return showMap(relMap, [&gs](const UntypedGenericSymbolRef &ugsr, const auto &result) -> string {
        return fmt::format(
            "{}: (inherited={}, mixins={})", ugsr.showRaw(gs), result.inherited.showFullName(gs),
            showVec(*result.mixedIn, [&gs](const auto &mixin) -> string { return mixin.showFullName(gs); }));
    });
}

// Try to compute a scip::Symbol for this value.
utils::Result UntypedGenericSymbolRef::symbolForExpr(const core::GlobalState &gs, const GemMapping &gemMap,
                                                     optional<core::Loc> loc, scip::Symbol &symbol) const {
    // Don't set symbol.scheme and package.manager here because
    // those are hard-coded to 'scip-ruby' and 'gem' anyways.
    scip::Package package;
    auto owningFile = this->selfOrOwner.loc(gs).file();
    // Synthetic symbols and built-in like constructs do not have a source location.
    if (!owningFile.exists()) {
        return utils::Result::skipValue();
    }
    auto metadata = gemMap.lookupGemForFile(gs, owningFile);
    ENFORCE(metadata.has_value(), "missing gem information for file {} which contains symbol {}",
            owningFile.data(gs).path(), this->showRaw(gs));
    if (metadata.has_value()) {
        package.set_name(metadata.value()->name());
        package.set_version(metadata.value()->version());
    } else {
        package.set_name("__scip-ruby-bug__");
        package.set_version("bug");
    }
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
                return utils::Result::statusValue(
                    absl::InvalidArgumentError("unexpected expr type for symbol computation"));
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
    return utils::Result::okValue();
}

string UntypedGenericSymbolRef::showRaw(const core::GlobalState &gs) const {
    if (this->name.exists()) {
        return fmt::format("UGSR({}.{})", absl::StripAsciiWhitespace(this->selfOrOwner.showFullName(gs)),
                           this->name.toString(gs));
    }
    return fmt::format("UGSR({})", absl::StripAsciiWhitespace(this->selfOrOwner.showFullName(gs)));
}

void UntypedGenericSymbolRef::saveRelationships(
    const core::GlobalState &gs, const RelationshipsMap &relationshipMap, SmallVec<scip::Relationship> &rels,
    const absl::FunctionRef<void(UntypedGenericSymbolRef, std::string &)> &saveSymbolString) const {
    auto it = relationshipMap.find(*this);
    if (it == relationshipMap.end()) {
        return;
    }
    auto saveSymbol = [&](core::ClassOrModuleRef klass, scip::Relationship &rel) {
        if (!this->name.exists()) {
            fmt::print(stderr, "problematic symbol {}\n", this->selfOrOwner.toStringFullName(gs));
        }
        saveSymbolString(UntypedGenericSymbolRef::field(klass, this->name), *rel.mutable_symbol());
        ENFORCE(!rel.symbol().empty());
        rels.push_back(move(rel));
    };

    auto result = it->second;

    if (core::SymbolRef(result.inherited) != this->selfOrOwner) {
        scip::Relationship rel;
        rel.set_is_definition(true);
        saveSymbol(result.inherited, rel);
    }

    for (auto mixin : *result.mixedIn) {
        scip::Relationship rel;
        rel.set_is_reference(true);
        saveSymbol(mixin, rel);
    }

    fast_sort(rels, [](const auto &r1, const auto &r2) -> bool { return scip::compareRelationship(r1, r2) < 0; });
}

string GenericSymbolRef::showRaw(const core::GlobalState &gs) const {
    switch (this->kind()) {
        case Kind::Field:
            return fmt::format("UndeclaredField(owner: {}, name: {})", this->selfOrOwner.showFullName(gs),
                               this->name.toString(gs));
        case Kind::ClassOrModule:
            return fmt::format("ClassOrModule {}", this->selfOrOwner.showFullName(gs));
        case Kind::Method:
            return fmt::format("Method {}", this->selfOrOwner.showFullName(gs));
    }
}

bool GenericSymbolRef::isSorbetInternal(const core::GlobalState &gs, core::SymbolRef sym) {
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

void GenericSymbolRef::saveDocStrings(const core::GlobalState &gs, core::TypePtr fieldType, core::Loc loc,
                                      SmallVec<string> &docs) const {
    auto checkType = [&gs, &loc](core::TypePtr ty, const std::string &name) {
        ENFORCE(ty, "missing type for {} in file {}\n{}\n", name, loc.file().data(gs).path(), loc.toString(gs));
    };

    string markdown = "";
    switch (this->kind()) {
        case Kind::Field: {
            auto name = this->name.show(gs);
            checkType(fieldType, name);
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
            checkType(resultType, fmt::format("result type for {}", ref.showFullName(gs)));
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
}

core::Loc GenericSymbolRef::symbolLoc(const core::GlobalState &gs) const {
    switch (this->kind()) {
        case Kind::Method: {
            auto method = this->selfOrOwner.asMethodRef().data(gs);
            if (!method->nameLoc.exists() || method->nameLoc.empty()) {
                return method->loc();
            }
            return method->nameLoc;
        }
        case Kind::ClassOrModule:
            return this->selfOrOwner.loc(gs);
        case Kind::Field:
            ENFORCE(false, "case UndeclaredField should not be triggered here");
            return core::Loc();
    }
}

} // namespace sorbet::scip_indexer
