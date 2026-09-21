
#include <string>

#include "core/GlobalState.h"
#include "core/Loc.h"
#include "core/errors/scip_ruby.h"

#include "scip_indexer/Debug.h"

namespace sorbet::scip_indexer {

void _log_debug(const sorbet::core::GlobalState &gs, sorbet::core::Loc loc, std::string s) {
    if (auto e = gs.beginError(loc, errors::SCIPRubyDebug)) {
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
