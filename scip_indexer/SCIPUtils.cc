#include <string>

#include "absl/status/status.h"

#include "proto/SCIP.pb.h"

namespace scip::utils {

using namespace std;

absl::Status emitDescriptorString(const scip::Descriptor &descriptor, string &out) {
    switch (descriptor.suffix()) {
        case scip::Descriptor::Namespace: // module
            absl::StrAppend(&out, descriptor.name(), "/");
            return absl::OkStatus();
        case scip::Descriptor::Type:
            absl::StrAppend(&out, descriptor.name(), "#");
            return absl::OkStatus();
        case scip::Descriptor::Term:
            absl::StrAppend(&out, descriptor.name(), ".");
            return absl::OkStatus();
        case scip::Descriptor::Meta:
            absl::StrAppend(&out, descriptor.name(), ":");
            return absl::OkStatus();
        case scip::Descriptor::Method:
            absl::StrAppend(&out, descriptor.name(), "(", descriptor.disambiguator(), ").");
            return absl::OkStatus();
        case scip::Descriptor::TypeParameter:
            absl::StrAppend(&out, "[", descriptor.name(), "]");
            return absl::OkStatus();
        case scip::Descriptor::Parameter:
            absl::StrAppend(&out, "(", descriptor.name(), ")");
            return absl::OkStatus();
        default:
            return absl::InvalidArgumentError(
                absl::StrCat("unexpected descriptor suffix %s", scip::Descriptor::Suffix_Name(descriptor.suffix())));
    }
}

absl::Status emitSymbolString(const scip::Symbol &symbol, string &out) {
    out.append("scip-ruby gem "); // scheme manager
    if (symbol.has_package()) {
        auto &package = symbol.package();
        if (!package.name().empty()) {
            absl::StrAppend(&out, package.name(), " "); // FIXME(varun): handle escaping
        } else {
            out.append(". ");
        }
        if (!package.version().empty()) {
            absl::StrAppend(&out, package.version(), " "); // FIXME(varun): handle escaping
        } else {
            out.append(". ");
        }
    } else {
        out.append(". . ");
    }
    if (symbol.descriptors_size() == 1) {
        return emitDescriptorString(symbol.descriptors()[0], out);
    }
    // FIXME(varun): Are we going to emit multiple descriptors per symbol?
    return absl::InvalidArgumentError(
        absl::StrCat("expected symbol to have 1 descriptor but found %d", symbol.descriptors_size()));
}

}; // end namespace scip::utils