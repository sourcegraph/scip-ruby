#ifndef SORBET_SCIP_DEBUG
#define SORBET_SCIP_DEBUG

#include <sstream>
#include <string>
#include <vector>

#include "absl/strings/str_split.h"

#include "common/common.h"
#include "core/Error.h"

template <typename K, typename V, typename Fn> std::string map_to_string(const sorbet::UnorderedMap<K, V> m, Fn f) {
    std::ostringstream out;
    out << "{";
    auto i = -1;
    for (auto &[k, v] : m) {
        i++;
        out << f(k, v);
        if (i != m.size() - 1) {
            out << ", ";
        }
    }
    out << "}";
    return out.str();
}

template <typename T, typename Fn> std::string set_to_string(const sorbet::UnorderedSet<T> s, Fn f) {
    std::ostringstream out;
    out << "{";
    auto i = -1;
    for (auto &x : s) {
        i++;
        out << f(x);
        if (i != s.size() - 1) {
            out << ", ";
        }
    }
    out << "}";
    return out.str();
}

template <typename T, typename Fn> std::string vec_to_string(const std::vector<T> v, Fn f) {
    std::ostringstream out;
    out << "[";
    for (auto i = 0; i < v.size(); ++i) {
        out << f(v[i]);
        if (i != v.size() - 1) {
            out << ", ";
        }
    }
    out << "]";
    return out.str();
}

namespace sorbet::scip_indexer {

constexpr sorbet::core::ErrorClass SCIPRubyDebug{400, sorbet::core::StrictLevel::False};

void _log_debug(const sorbet::core::GlobalState &gs, sorbet::core::Loc loc, std::string s);
} // namespace sorbet::scip_indexer

#ifndef NDEBUG
#define LOG_DEBUG(__gs, __loc, __s) sorbet::scip_indexer::_log_debug(__gs, __loc, __s)
#else
#define LOG_DEBUG(__gs, __s)
#endif

#endif // SORBET_SCIP_DEBUG