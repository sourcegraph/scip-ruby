
#include <string>

#include "core/GlobalState.h"
#include "core/Loc.h"

#include "scip_indexer/Debug.h"

namespace sorbet::scip_indexer {

constexpr sorbet::core::ErrorClass SCIPRubyDebug{25900, sorbet::core::StrictLevel::False};

void _log_debug(const sorbet::core::GlobalState &gs, sorbet::core::Loc loc, std::string s) {
    if (auto e = gs.beginError(loc, SCIPRubyDebug)) {
        auto lines = absl::StrSplit(s, '\n');
        for (auto line = lines.begin(); line != lines.end(); line++) {
            auto text = std::string(line->begin(), line->length());
            if (line == lines.begin()) {
                e.setHeader("[scip-ruby] {}", text);
            } else {
                e.addErrorNote("{}", text);
            }
        }
    }
}
} // namespace sorbet::scip_indexer
