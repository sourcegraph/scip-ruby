#include <vector>

#include "absl/strings/ascii.h"

#include "common/common.h"
#include "core/GlobalState.h"
#include "core/SymbolRef.h"
#include "core/Symbols.h"

#include "scip_indexer/Debug.h"
#include "scip_indexer/SCIPFieldResolve.h"

using namespace std;

namespace sorbet::scip_indexer {

string FieldQueryResult::Data::showRaw(const core::GlobalState &gs) const {
    switch (this->kind()) {
        case Kind::FromDeclared:
            return this->originalSymbol().showRaw(gs);
        case Kind::FromUndeclared:
            return fmt::format("In({})", absl::StripAsciiWhitespace(this->originalClass().showFullName(gs)));
    }
}

string FieldQueryResult::showRaw(const core::GlobalState &gs) const {
    if (this->mixedIn->empty()) {
        return fmt::format("FieldQueryResult(inherited: {})", this->inherited.showRaw(gs));
    }
    return fmt::format("FieldQueryResult(inherited: {}, mixins: {})", this->inherited.showRaw(gs),
                       showVec(*this->mixedIn.get(), [&gs](const auto &mixin) -> string { return mixin.showRaw(gs); }));
}

void FieldResolver::resetMixins() {
    this->mixinQueue.clear();
}

// Compute all transitively included modules which mention the field being queried.
//
// If an include chain for a field looks like class C.@f <- module M2.@f <- module M1.@f,
// both M1 and M2 will be included in the results (this avoids any kind of postprocessing
// of a transitive closure of relationships at the cost of a larger index).
void FieldResolver::findUnresolvedFieldInMixinsTransitive(const core::GlobalState &gs, FieldQuery query,
                                                          vector<FieldQueryResult::Data> &out) {
    this->mixinQueue.clear();
    for (auto mixin : query.start.data(gs)->mixins()) {
        this->mixinQueue.push_back(mixin);
    }
    auto field = query.field;
    using Data = FieldQueryResult::Data;
    while (auto m = this->mixinQueue.try_pop_front()) {
        auto mixin = m.value();
        auto sym = mixin.data(gs)->findMember(gs, field);
        if (sym.exists()) {
            out.push_back(Data(sym));
            continue;
        }
        auto it = gs.unresolvedFields.find(mixin);
        if (it != gs.unresolvedFields.end() && it->second.contains(field)) {
            out.push_back(Data(mixin));
        }
    }
}

core::ClassOrModuleRef FieldResolver::normalizeParentForClassVar(const core::GlobalState &gs,
                                                                 core::ClassOrModuleRef klass, std::string_view name) {
    auto isClassVar = name.size() >= 2 && name[0] == '@' && name[1] == '@';
    if (isClassVar && !klass.data(gs)->isSingletonClass(gs)) {
        // Triggered when undeclared class variables are accessed from instance methods.
        return klass.data(gs)->lookupSingletonClass(gs);
    }
    return klass;
}

FieldQueryResult::Data FieldResolver::findUnresolvedFieldInInheritanceChain(const core::GlobalState &gs, core::Loc loc,
                                                                            FieldQuery query) {
    auto start = query.start;
    auto field = query.field;

    auto fieldText = query.field.shortName(gs);
    auto isInstanceVar = fieldText.size() >= 2 && fieldText[0] == '@' && fieldText[1] != '@';
    auto isClassInstanceVar = isInstanceVar && start.data(gs)->isSingletonClass(gs);
    // Class instance variables are not inherited, unlike ordinary instance
    // variables or class variables.
    if (isClassInstanceVar) {
        return FieldQueryResult::Data(start);
    }
    start = FieldResolver::normalizeParentForClassVar(gs, start, fieldText);

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
        return FieldQueryResult::Data(start);
    }

    auto best = start;
    auto cur = start;
    while (cur.exists()) {
        auto klass = cur.data(gs);
        auto sym = klass->findMember(gs, field);
        if (sym.exists()) { // TODO(varun): Is this early exit justified?
                            // Maybe it is possible to hit this in multiple ancestors?
            return FieldQueryResult::Data(sym);
        }
        auto it = gs.unresolvedFields.find(cur);
        if (it != gs.unresolvedFields.end() && it->second.contains(field)) {
            best = cur;
        }

        if (cur == klass->superClass()) {
            break;
        }
        cur = klass->superClass();
    }
    return FieldQueryResult::Data(best);
}

pair<FieldQueryResult, bool> FieldResolver::findUnresolvedFieldTransitive(const core::GlobalState &gs, core::Loc loc,
                                                                          FieldQuery query) {
    auto cacheIt = this->cache.find(query);
    if (cacheIt != this->cache.end()) {
        return {cacheIt->second, true};
    }
    auto inherited = this->findUnresolvedFieldInInheritanceChain(gs, loc, query);
    using Data = FieldQueryResult::Data;
    vector<Data> mixins;
    findUnresolvedFieldInMixinsTransitive(gs, query, mixins);
    auto [it, inserted] =
        this->cache.insert({query, FieldQueryResult{inherited, make_shared<vector<Data>>(move(mixins))}});
    ENFORCE(inserted);
    return {it->second, false};
}

} // namespace sorbet::scip_indexer