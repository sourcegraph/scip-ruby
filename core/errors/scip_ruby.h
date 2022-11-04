#ifndef SORBET_CORE_ERRORS_SCIP_RUBY_H
#define SORBET_CORE_ERRORS_SCIP_RUBY_H
#include "core/Error.h"

namespace sorbet::scip_indexer::errors {
constexpr sorbet::core::ErrorClass SCIPRubyDebug{25900, sorbet::core::StrictLevel::False};
constexpr sorbet::core::ErrorClass SCIPRuby{25901, sorbet::core::StrictLevel::False};
} // namespace sorbet::scip_indexer::errors

#endif // SORBET_CORE_ERRORS_SCIP_RUBY_H
