
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
    enum class Kind : bool {
        FromDeclared,
        FromUndeclared,
    };

    class Data {
        union Storage {
            core::ClassOrModuleRef owner;
            core::SymbolRef symbol;
            Storage() {
                memset(this, 0, sizeof(Storage));
            }
        } storage;
        Kind _kind;

    public:
        Data(Data &&) = default;
        Data(const Data &) = default;
        Kind kind() const {
            return this->_kind;
        }
        core::ClassOrModuleRef originalClass() const {
            ENFORCE(this->kind() == Kind::FromUndeclared);
            return this->storage.owner;
        }
        core::SymbolRef originalSymbol() const {
            ENFORCE(this->kind() == Kind::FromUndeclared);
            return this->storage.symbol;
        }
        Data(core::ClassOrModuleRef klass) : _kind(Kind::FromUndeclared) {
            this->storage.owner = klass;
        }
        Data(core::SymbolRef sym) : _kind(Kind::FromDeclared) {
            this->storage.symbol = sym;
        }

        std::string showRaw(const core::GlobalState &) const;
    };

    Data inherited;
    std::shared_ptr<std::vector<Data>> mixedIn;

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

private:
    void resetMixins();

    void findUnresolvedFieldInMixinsTransitive(const sorbet::core::GlobalState &gs, FieldQuery query,
                                               std::vector<FieldQueryResult::Data> &out);

    FieldQueryResult::Data findUnresolvedFieldInInheritanceChain(const core::GlobalState &gs, core::Loc loc,
                                                                 FieldQuery query);
};

} // namespace sorbet::scip_indexer

#endif // SORBET_SCIP_FIELD_RESOLVE