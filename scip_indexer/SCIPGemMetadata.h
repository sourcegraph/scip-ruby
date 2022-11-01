#ifndef SORBET_SCIP_GEM_METADATA
#define SORBET_SCIP_GEM_METADATA

#include <optional>
#include <string>
#include <utility>

#include "absl/strings/str_split.h"

#include "common/FileSystem.h"

namespace sorbet::scip_indexer {

struct GemMetadataError {
    enum class Kind { Error, Warning } kind;
    std::string message;

    template <typename H> friend H AbslHashValue(H h, const GemMetadataError &x) {
        return H::combine(std::move(h), x.kind, x.message);
    }

    bool operator==(const GemMetadataError &other) const {
        return this->kind == other.kind && this->message == other.message;
    }
};

extern GemMetadataError configNotFoundError, multipleGemspecWarning, failedToParseGemspecWarning,
    failedToParseGemspecWarning, failedToParseNameFromGemspecWarning, failedToParseVersionFromGemspecWarning,
    failedToParseGemfileLockWarning;

class GemMetadata final {
    std::string _name;
    std::string _version;

    GemMetadata(std::string name, std::string version) : _name(name), _version(version) {}

public:
    GemMetadata() = default;
    GemMetadata &operator=(const GemMetadata &) = default;

    // Don't call this method outside test code!
    static GemMetadata forTest(std::string name, std::string version) {
        return GemMetadata(name, version);
    }

    static std::optional<GemMetadata> tryParse(const std::string &nameAndVersion) {
        std::vector<std::string> v = absl::StrSplit(nameAndVersion, '@');
        if (v.size() != 2 || v[0].empty() || v[1].empty()) {
            return std::nullopt;
        }
        return GemMetadata{v[0], v[1]};
    }

    const std::string &name() const {
        return this->_name;
    }

    const std::string &version() const {
        return this->_version;
    }

    bool operator==(const GemMetadata &other) const {
        return this->name() == other.name() && this->version() == other.version();
    }

    // HACK: Do a best-effort parse of any config files to extract the name and version.
    static std::pair<GemMetadata, std::vector<GemMetadataError>> readFromConfig(const FileSystem &fs);

private:
    static std::pair<GemMetadata, std::vector<GemMetadataError>> readFromGemfileLock(const std::string &);
    static std::pair<GemMetadata, std::vector<GemMetadataError>> readFromGemspec(const std::string &);
};

} // namespace sorbet::scip_indexer

#endif // SORBET_SCIP_GEM_METADATA
