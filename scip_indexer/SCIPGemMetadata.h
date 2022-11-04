#ifndef SORBET_SCIP_GEM_METADATA
#define SORBET_SCIP_GEM_METADATA

#include <memory>
#include <optional>
#include <string>
#include <utility>

#include "absl/strings/str_split.h"

#include "common/FileSystem.h"
#include "common/common.h"
#include "core/FileRef.h"
#include "core/GlobalState.h"

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

// Type carrying gem information for each file, which is used during
// symbol emission to ensure correct symbol names for cross-repo.
class GemMapping final {
    std::optional<std::shared_ptr<GemMetadata>> currentGem;
    UnorderedMap<core::FileRef, std::shared_ptr<GemMetadata>> map;
    std::shared_ptr<GemMetadata> stdlibGem;

public:
    std::shared_ptr<GemMetadata> globalPlaceholderGem;

    GemMapping();

    std::optional<std::shared_ptr<GemMetadata>> lookupGemForFile(const core::GlobalState &gs, core::FileRef file) const;

    void populateFromNDJSON(const core::GlobalState &, const FileSystem &fs, const std::string &ndjsonPath);

    void markCurrentGem(GemMetadata gem);
};

} // namespace sorbet::scip_indexer

#endif // SORBET_SCIP_GEM_METADATA
