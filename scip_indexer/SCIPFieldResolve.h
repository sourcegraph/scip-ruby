
#ifndef SORBET_SCIP_FIELD_RESOLVE
#define SORBET_SCIP_FIELD_RESOLVE

#include <memory>
#include <optional>
#include <vector>

#include "core/NameRef.h"
#include "core/SymbolRef.h"

namespace sorbet::scip_indexer {

struct FieldQuery final {
    sorbet::core::ClassOrModuleRef start;
    sorbet::core::NameRef field;

    bool operator==(const FieldQuery &other) const noexcept {
        return this->start == other.start && this->field == other.field;
    }
};

template <typename H> H AbslHashValue(H h, const FieldQuery &q) {
    return H::combine(std::move(h), q.start, q.field);
}

struct FieldQueryResult final {
    core::ClassOrModuleRef inherited;
    std::shared_ptr<std::vector<core::ClassOrModuleRef>> mixedIn;

    std::string showRaw(const core::GlobalState &gs) const;
};

// Non-shrinking queue for cheap-to-copy types.
template <typename T> class BasicQueue final {
    std::vector<T> storage;
    size_t current;

public:
    BasicQueue() = default;
    BasicQueue(BasicQueue &&) = default;
    BasicQueue &operator=(BasicQueue &&) = default;
    BasicQueue(const BasicQueue &) = delete;
    BasicQueue &operator=(const BasicQueue &) = delete;

    void clear() {
        this->storage.clear();
        this->current = 0;
    }
    void push_back(T val) {
        this->storage.push_back(val);
    }
    std::optional<T> try_pop_front() {
        if (this->current >= this->storage.size()) {
            return {};
        }
        auto ret = this->storage[this->current];
        this->current++;
        return ret;
    }
};

class FieldResolver final {
    sorbet::UnorderedMap<FieldQuery, FieldQueryResult> cache;
    BasicQueue<sorbet::core::ClassOrModuleRef> mixinQueue;

public:
    std::pair<FieldQueryResult, /*cacheHit*/ bool> findUnresolvedFieldTransitive(const core::GlobalState &gs,
                                                                                 core::Loc loc, FieldQuery query);

    static core::ClassOrModuleRef normalizeParentForClassVar(const core::GlobalState &gs, core::ClassOrModuleRef klass,
                                                             std::string_view name);

private:
    void resetMixins();

    void findUnresolvedFieldInMixinsTransitive(const sorbet::core::GlobalState &gs, FieldQuery query,
                                               std::vector<core::ClassOrModuleRef> &out);

    core::ClassOrModuleRef findUnresolvedFieldInInheritanceChain(const core::GlobalState &gs, core::Loc loc,
                                                                 FieldQuery query);
};

} // namespace sorbet::scip_indexer

#endif // SORBET_SCIP_FIELD_RESOLVE