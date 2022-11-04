#ifndef SORBET_SCIP_UTILS
#define SORBET_SCIP_UTILS

#include <string>

#include "absl/status/status.h"
#include "proto/SCIP.pb.h"

namespace sorbet::scip_indexer::utils {

class Result {
    bool skip_;
    absl::Status status_;

    Result(bool sk, absl::Status st) : skip_(sk), status_(st) {}

public:
    static Result skipValue() {
        return Result(true, absl::OkStatus());
    }
    static Result okValue() {
        return Result(false, absl::OkStatus());
    }
    static Result statusValue(absl::Status status) {
        return Result(false, status);
    }
    bool skip() const {
        return this->skip_;
    }
    bool ok() const {
        return !this->skip() && this->status().ok();
    }
    absl::Status status() const {
        return this->status_;
    }
};

absl::Status emitDescriptorString(const scip::Descriptor &descriptor, std::string &out);

absl::Status emitSymbolString(const scip::Symbol &symbol, std::string &out);

} // namespace sorbet::scip_indexer::utils

#endif // SORBET_SCIP_UTILS