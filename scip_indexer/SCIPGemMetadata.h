#ifndef SORBET_SCIP_GEM_METADATA
#define SORBET_SCIP_GEM_METADATA

#include <memory>
#include <optional>
#include <string>
#include <string_view>
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

class GemDependencies;
class GemMapping;

class GemMetadata final {
    std::string _name;
    std::string _version;

    GemMetadata(std::string name, std::string version) : _name(name), _version(version) {}

    friend GemDependencies;
    friend GemMapping;

public:
    GemMetadata() = default;
    GemMetadata(GemMetadata &&) = default;
    GemMetadata &operator=(GemMetadata &&) = default;
    GemMetadata(const GemMetadata &) = default;
    GemMetadata &operator=(const GemMetadata &) = default;

    // Don't call this method outside test code!
    static GemMetadata forTest(std::string name, std::string version) {
        return GemMetadata(name, version);
    }

    static std::optional<GemMetadata> tryParse(const std::string_view nameAndVersion) {
        std::vector<std::string_view> v = absl::StrSplit(nameAndVersion, '@');
        if (v.size() != 2 || v[0].empty() || v[1].empty()) {
            return std::nullopt;
        }
        return GemMetadata{std::string(v[0]), std::string(v[1])};
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
};

class GemDependencies {
    // Mapping of gem name -> version for dependencies
    UnorderedMap<std::string, std::string> versionMap;

public:
    GemMetadata currentGem;

    GemDependencies() = default;

    // Parse Gemfile.lock and .gemspec on a best-effort basis to extract dependency names and versions.
    std::vector<GemMetadataError> populateFromConfig(const FileSystem &);

private:
    std::vector<GemMetadataError> populateFromGemfileLock(const std::string &fileContents);
    std::vector<GemMetadataError> populateFromGemspec(const std::string &fileContents);

    void addDependency(std::string &&name, std::string &&version) {
        this->versionMap.insert({std::string(name), std::string(version)});
    }

    void modifyCurrentGem(std::optional<std::string> name, std::optional<std::string> version);
};

// Type carrying gem information for each file, which is used during
// symbol emission to ensure correct symbol names for cross-repo.
class GemMapping final {
    GemDependencies gemDeps;
    std::optional<std::shared_ptr<GemMetadata>> currentGem;
    UnorderedMap<core::FileRef, std::shared_ptr<GemMetadata>> map;
    std::shared_ptr<GemMetadata> stdlibGem;

public:
    std::shared_ptr<GemMetadata> globalPlaceholderGem;

    GemMapping();

    std::optional<std::shared_ptr<GemMetadata>> lookupGemForFile(const core::GlobalState &gs, core::FileRef file) const;

    // Record gem metadata for the file based on the externally specified file.
    void populateFromNDJSON(const core::GlobalState &, const FileSystem &fs, const std::string &ndjsonPath);

    // Record gem metadata for the file based on the filepath
    void populateCache(core::FileRef, std::shared_ptr<core::File> file);

    void addGemDependencies(GemDependencies &&deps) {
        if (!deps.currentGem.name().empty()) {
            auto metadata = GemMetadata(deps.currentGem.name(), deps.currentGem.version());
            this->currentGem = std::make_shared<GemMetadata>(std::move(metadata));
        }
        this->gemDeps = deps;
    }

private:
    std::optional<std::shared_ptr<GemMetadata>> identifyGem(std::string_view filepath) const;
};

} // namespace sorbet::scip_indexer

#endif // SORBET_SCIP_GEM_METADATA
