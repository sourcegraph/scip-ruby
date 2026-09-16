#include <string>
#include <string_view>

#include "absl/status/status.h"
#include "absl/strings/match.h"
#include "absl/strings/str_replace.h"

#include "proto/SCIP.pb.h"
#include "common/common.h"
#include "rapidjson/encodings.h"
#include "rapidjson/memorystream.h"

namespace sorbet::scip_indexer::utils {

using namespace std;

string escapeInvalidUtf8(string_view text) {
    string result;
    result.reserve(text.size());
    for (size_t offset = 0; offset < text.size();) {
        auto byte = static_cast<unsigned char>(text[offset]);
        if (byte < 0x80) {
            result.push_back(text[offset++]);
            continue;
        }
        rapidjson::MemoryStream input(text.data() + offset, text.size() - offset);
        unsigned codepoint;
        if (rapidjson::UTF8<>::Decode(input, &codepoint)) {
            result.append(text.substr(offset, input.Tell()));
            offset += input.Tell();
        } else {
            // Escape one byte at a time so a malformed prefix cannot consume valid following text.
            result.push_back('\\');
            result.push_back('0' + ((byte >> 6) & 7));
            result.push_back('0' + ((byte >> 3) & 7));
            result.push_back('0' + (byte & 7));
            ++offset;
        }
    }
    return result;
}

void addEscaped(string &out, const string &in) {
    bool needsEscape = false;
    bool needsBacktickEscape = false;
    for (auto &c : in) {
        if (('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') || ('0' <= c && c <= '9') || c == '+' || c == '-' ||
            c == '$' || c == '_') {
            continue;
        }
        needsBacktickEscape = c == '`';
        needsEscape = true;
    }
    if (needsEscape) {
        if (needsBacktickEscape) {
            absl::StrAppend(&out, "`", absl::StrReplaceAll(in, {{"`", "``"}}), "`");
            return;
        }
        absl::StrAppend(&out, "`", in, "`");
        return;
    }
    out.append(in);
}

void addSpaceEscaped(string &out, const string &in) {
    if (absl::StrContains(in, " ")) {
        out.append(absl::StrReplaceAll(in, {{" ", "  "}}));
        return;
    }
    out.append(in);
}

absl::Status emitDescriptorString(const scip::Descriptor &descriptor, string &out) {
    switch (descriptor.suffix()) {
        case scip::Descriptor::Namespace: // module
            addEscaped(out, descriptor.name());
            out.push_back('/');
            return absl::OkStatus();
        case scip::Descriptor::Type:
            addEscaped(out, descriptor.name());
            out.push_back('#');
            return absl::OkStatus();
        case scip::Descriptor::Term:
            addEscaped(out, descriptor.name());
            out.push_back('.');
            return absl::OkStatus();
        case scip::Descriptor::Meta:
            addEscaped(out, descriptor.name());
            out.push_back(':');
            return absl::OkStatus();
        case scip::Descriptor::Method:
            addEscaped(out, descriptor.name());
            out.push_back('(');
            addEscaped(out, descriptor.disambiguator());
            out.append(").");
            return absl::OkStatus();
        case scip::Descriptor::TypeParameter:
            out.push_back('[');
            addEscaped(out, descriptor.name());
            out.push_back(']');
            return absl::OkStatus();
        case scip::Descriptor::Parameter:
            out.push_back('(');
            addEscaped(out, descriptor.name());
            out.push_back(')');
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
            addSpaceEscaped(out, package.name());
            out.push_back(' ');
        } else {
            out.append(". ");
        }
        if (!package.version().empty()) {
            addSpaceEscaped(out, package.version());
            out.push_back(' ');
        } else {
            out.append(". ");
        }
    } else {
        out.append(". . ");
    }
    if (symbol.descriptors_size() == 0) {
        return absl::InvalidArgumentError("expected symbol to have at least 1 descriptor");
    }
    for (auto i = 0; i < symbol.descriptors_size(); ++i) {
        auto status = emitDescriptorString(symbol.descriptors()[i], out);
        if (!status.ok()) {
            return status;
        }
    }
    return absl::OkStatus();
}

}; // namespace sorbet::scip_indexer::utils
