#ifndef SORBET_SCIP_UTILS
#define SORBET_SCIP_UTILS

#include <string>

#include "absl/status/status.h"

#include "proto/SCIP.pb.h"

namespace scip::utils {

absl::Status emitDescriptorString(const scip::Descriptor &descriptor, std::string &out);

absl::Status emitSymbolString(const scip::Symbol &symbol, std::string &out);

} // end namespace scip::utils

#endif // SORBET_SCIP_UTILS