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

string FieldQueryResult::showRaw(const core::GlobalState &gs) const {
    if (this->mixedIn->empty()) {
        return fmt::format("FieldQueryResult(inherited: {})", this->inherited.showFullName(gs));
    }
    return fmt::format(
        "FieldQueryResult(inherited: {}, mixins: {})", this->inherited.showFullName(gs),
        showVec(*this->mixedIn.get(), [&gs](const auto &mixin) -> string { return mixin.showFullName(gs); }));
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
                                                          vector<core::ClassOrModuleRef> &out) {
    this->mixinQueue.clear();
    for (auto mixin : query.start.data(gs)->mixins()) {
        this->mixinQueue.push_back(mixin);
    }
    auto field = query.field;
    while (auto m = this->mixinQueue.try_pop_front()) {
        auto mixin = m.value();
        auto sym = mixin.data(gs)->findMember(gs, field);
        if (sym.exists()) {
            out.push_back(mixin);
            continue;
        }
        auto it = gs.unresolvedFields.find(mixin);
        if (it != gs.unresolvedFields.end() && it->second.contains(field)) {
            out.push_back(mixin);
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

core::ClassOrModuleRef FieldResolver::findUnresolvedFieldInInheritanceChain(const core::GlobalState &gs, core::Loc loc,
                                                                            FieldQuery query) {
    auto start = query.start;
    auto field = query.field;

    auto fieldText = query.field.shortName(gs);
    auto isInstanceVar = fieldText.size() >= 2 && fieldText[0] == '@' && fieldText[1] != '@';
    auto isClassInstanceVar = isInstanceVar && start.data(gs)->isSingletonClass(gs);
    // Class instance variables are not inherited, unlike ordinary instance
    // variables or class variables.
    if (isClassInstanceVar) {
        return start;
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
        return start;
    }

    auto best = start;
    auto cur = start;
    while (cur.exists()) {
        auto klass = cur.data(gs);
        auto sym = klass->findMember(gs, field);
        if (sym.exists()) { // TODO(varun): Is this early exit justified?
                            // Maybe it is possible to hit this in multiple ancestors?
            return cur;
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
    return best;
}

pair<FieldQueryResult, bool> FieldResolver::findUnresolvedFieldTransitive(const core::GlobalState &gs, core::Loc loc,
                                                                          FieldQuery query) {
    ENFORCE(query.field.exists());
    auto cacheIt = this->cache.find(query);
    if (cacheIt != this->cache.end()) {
        return {cacheIt->second, true};
    }
    auto inherited = this->findUnresolvedFieldInInheritanceChain(gs, loc, query);
    vector<core::ClassOrModuleRef> mixins;
    findUnresolvedFieldInMixinsTransitive(gs, query, mixins);
    auto [it, inserted] =
        this->cache.insert({query, FieldQueryResult{inherited, make_shared<decltype(mixins)>(move(mixins))}});
    ENFORCE(inserted);
    return {it->second, false};
}

} // namespace sorbet::scip_indexer