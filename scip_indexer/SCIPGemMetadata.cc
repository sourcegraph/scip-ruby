#include <filesystem>
#include <memory>
#include <optional>
#include <regex>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

#include "absl/strings/str_replace.h"

#include "common/FileSystem.h"
#include "common/common.h"
#include "core/FileRef.h"
#include "core/errors/scip_ruby.h"

// Uses ENFORCE as defined by common/common.h, so put this later
#include "rapidjson/document.h"

#include "scip_indexer/SCIPGemMetadata.h"

using namespace std;

namespace sorbet::scip_indexer {

using GMEKind = GemMetadataError::Kind;
GemMetadataError configNotFoundError =
    GemMetadataError{GMEKind::Error, "Failed to find .gemspec file for identifying gem version"};
GemMetadataError multipleGemspecWarning = GemMetadataError{
    GMEKind::Warning, "Found multiple .gemspec files when trying to infer Gem name and version; picking the first one "
                      "lexicographically. Consider passing --gem-metadata name@version explicitly instead"};
GemMetadataError failedToParseGemspecWarning = GemMetadataError{
    GMEKind::Warning, "Failed to parse .gemspec file for inferring gem name and version. Consider passing "
                      "--gem-metadata name@version explicitly instead"};
GemMetadataError failedToParseNameFromGemspecWarning = GemMetadataError{
    GMEKind::Warning, "Failed to parse gem name from .gemspec file; using the .gemspec's base name as a proxy"};
GemMetadataError failedToParseVersionFromGemspecWarning =
    GemMetadataError{GMEKind::Warning, "Failed to parse gem version from .gemspec file"};
GemMetadataError failedToParseGemfileLockWarning{GMEKind::Warning,
                                                 "Failed to extract name and version from Gemfile.lock"};

pair<GemMetadata, vector<GemMetadataError>> GemMetadata::readFromGemfileLock(const string &contents) {
    istringstream lines(contents);
    bool sawPATH = false;
    bool sawSpecs = false;
    optional<string> name;
    optional<string> version;
    vector<GemMetadataError> errors;
    // PATH
    //   remote: .
    //   specs:
    //     my_gem_name (M.N.P)
    for (string line; getline(lines, line);) {
        if (absl::StartsWith(line, "PATH")) {
            sawPATH = true;
            continue;
        }
        if (sawPATH && absl::StrContains(line, "specs:")) {
            sawSpecs = true;
            continue;
        }
        if (sawSpecs) {
            std::regex specLineRegex(R"END(\s+([A-Za-z0-9_\-]+)\s*\((.+)\)\s*)END");
            std::smatch matches;
            if (std::regex_match(line, matches, specLineRegex)) {
                name = matches[1].str();
                version = matches[2].str();
            }
            break;
        }
    }
    if (!name.has_value()) {
        errors.push_back(failedToParseGemfileLockWarning);
    }
    return {GemMetadata{name.value_or(""), version.value_or("")}, errors};
}

pair<GemMetadata, vector<GemMetadataError>> GemMetadata::readFromGemspec(const string &contents) {
    optional<string> name;
    optional<string> version;
    vector<GemMetadataError> errors;

    std::regex stringKeyRegex(R"END(\s*["'](.+)["'](.freeze)?)END");
    const auto readValue = [&](const string_view line) -> string {
        vector<string> entries = absl::StrSplit(line, '=');
        if (entries.size() != 2) {
            return "";
        }
        std::smatch matches;
        if (std::regex_match(entries[1], matches, stringKeyRegex)) {
            return matches[1].str();
        }
        return "";
    };
    istringstream lines(contents);
    for (string line; std::getline(lines, line);) {
        if (name.has_value() && version.has_value()) {
            break;
        }
        if (!name.has_value() && absl::StrContains(line, ".name =")) {
            name = readValue(line);
            if (name->empty()) {
                errors.push_back(failedToParseNameFromGemspecWarning);
                continue;
            }
        }
        // NOTE: In some cases, the version may be stored symbolically,
        // in which case this parsing will fail.
        if (!version.has_value() && absl::StrContains(line, ".version =")) {
            version = readValue(line);
            if (version->empty()) {
                errors.push_back(failedToParseVersionFromGemspecWarning);
                continue;
            }
        }
    }
    if (!name.has_value() || !version.has_value()) {
        errors.push_back(failedToParseGemspecWarning);
    }
    return {GemMetadata{name.value_or(""), version.value_or("")}, errors};
}

pair<GemMetadata, vector<GemMetadataError>> GemMetadata::readFromConfig(const FileSystem &fs) {
    UnorderedSet<string> extensions{".lock", ".gemspec"};
    auto paths = fs.listFilesInDir(".", extensions, /*recursive*/ false, {}, {});
    vector<GemMetadataError> errors;
    auto currentDirName = [&fs]() -> std::string {
        auto currentDirPath = fs.getCurrentDir();
        ENFORCE(!currentDirPath.empty());
        while (currentDirPath.back() == '/') {
            currentDirPath.pop_back();
            ENFORCE(!currentDirPath.empty());
        }
        return std::filesystem::path(move(currentDirPath)).filename();
    };
    if (paths.empty()) {
        errors.push_back(configNotFoundError);
        return {GemMetadata(currentDirName(), "latest"), errors};
    }
    optional<std::string> name{};
    optional<std::string> version{};
    auto copyState = [&](auto &m, auto &errs) {
        name = m.name().empty() ? name : m.name();
        version = m.version().empty() ? version : m.version();
        absl::c_copy(errs, std::back_inserter(errors));
    };
    for (auto &path : paths) {
        if (!absl::EndsWith(path, "Gemfile.lock")) {
            continue;
        }
        auto [gemMetadata, parseErrors] = GemMetadata::readFromGemfileLock(fs.readFile(path));
        if (!gemMetadata.name().empty() && !gemMetadata.version().empty()) {
            return {gemMetadata, {}};
        }
        copyState(gemMetadata, parseErrors);
        break;
    }
    string gemspecPath{};
    for (auto &filename : paths) {
        if (!absl::EndsWith(filename, ".gemspec")) {
            continue;
        }
        gemspecPath = filename;
        auto [gemMetadata, parseErrors] = GemMetadata::readFromGemspec(fs.readFile(filename));
        if (!gemMetadata.name().empty() && !gemMetadata.version().empty()) {
            return {gemMetadata, {}};
        }
        copyState(gemMetadata, parseErrors);
        break;
    }
    if (name.has_value() && version.has_value()) {
        errors.clear();
    }
    if (!name.has_value() && !gemspecPath.empty()) {
        vector<string_view> components = absl::StrSplit(gemspecPath, '/');
        name = string(absl::StripSuffix(components.back(), ".gemspec"));
    }
    return {GemMetadata(name.value_or(currentDirName()), version.value_or("latest")), errors};
}

// The 'ruby' namespace is reserved by RubyGems.org, so we won't run into any
// actual gem called 'ruby', so we use that here. 'stdlib' would not be appropriate
// as Sorbet contains RBIs for both core and stdlib modules.
// For the version, we're not really doing any versioning for core & stdlib RBIs,
// (e.g. handling both 2.7 and 3) so let's stick to latest for now.
GemMapping::GemMapping()
    : currentGem(), map(), stdlibGem(make_shared<GemMetadata>(GemMetadata::tryParse("ruby@latest").value())),
      globalPlaceholderGem(make_shared<GemMetadata>(GemMetadata::tryParse("_global_@latest").value())) {}

optional<shared_ptr<GemMetadata>> tryParseFilepath(std::string_view filepath) {
    auto filenameStartIndex = filepath.find_last_of('/') + 1;
    // E.g. foo/bar,
    //      0123456 ; startIndex = 4, size = 7
    auto filename = filepath.substr(filenameStartIndex, filepath.size() - filenameStartIndex);
    auto dotIndex = filename.find_last_of('.');
    if (dotIndex == std::string::npos) {
        // Should have .rbi files here
        return nullopt;
    }
    auto basename = filename.substr(0, dotIndex);
    if (absl::StrContains(basename, '@')) {
        auto metadata = GemMetadata::tryParse(basename);
        ENFORCE(metadata.has_value());
        return make_shared<GemMetadata>(metadata.value());
    }
    // TODO: Can we do better here by getting dependency versions from somewhere
    // else, like Gemfile.lock? In practice, it looks like files under gems/ have associated
    // versions, whereas files under annotations/ and gems/ do not have versions.
    // Another potential option is to do two passes over the list of files; first collecting
    // all external gem names+versions based on sorbet/rbi/gems, and then checking
    // if the name here matches any known external gem name.
    return make_shared<GemMetadata>(GemMetadata::forTest(string(basename), "latest"));
}

optional<shared_ptr<GemMetadata>> GemMapping::lookupGemForFile(const core::GlobalState &gs, core::FileRef file) const {
    ENFORCE(file.exists());
    auto it = this->map.find(file);
    if (it != this->map.end()) {
        return it->second;
    }
    auto filepath = file.data(gs).path();
    if (absl::StartsWith(filepath, core::File::URL_PREFIX)) {
        return this->stdlibGem;
    }
    // See https://sorbet.org/docs/rbi#quickref for description of the standard layout.
    // Based on some Sourcegraph searches, it looks like RBI files can be named either
    // gem_name.rbi or gem_name@version.rbi.
    if (absl::StrContains(filepath, "sorbet/rbi/")) {
        if (absl::StrContains(filepath, "sorbet/rbi/gems/") || absl::StrContains(filepath, "sorbet/rbi/annotations/") ||
            absl::StrContains(filepath, "sorbet/rbi/dsl/")) {
            auto metadata = tryParseFilepath(filepath);
            if (metadata.has_value()) {
                return metadata;
            }
        }
        // hidden-definitions and todo.rbi get treated as part of the current gem
    }
    if (this->currentGem.has_value()) {
        // TODO Should we enforce here in debug builds?
        // Fallback to this if set, to avoid collisions with other gems.
        return this->currentGem.value();
    }
    return nullopt;
}

void GemMapping::populateFromNDJSON(const core::GlobalState &gs, const FileSystem &fs, const std::string &ndjsonPath) {
    istringstream input(fs.readFile(ndjsonPath));
    auto currentDir = filesystem::path(fs.getCurrentDir());
    unsigned errorCount = 0;
    for (string line; getline(input, line);) {
        auto jsonLine = std::string(absl::StripAsciiWhitespace(line));
        if (jsonLine.empty()) {
            continue;
        }
        rapidjson::Document document;
        document.Parse(jsonLine);
        if (document.HasParseError() || !document.IsObject()) {
            continue;
        }
        if (document.HasMember("path") && document["path"].IsString() && document.HasMember("gem") &&
            document["gem"].IsString()) {
            auto jsonPath = document["path"].GetString();
            auto fileRef = gs.findFileByPath(jsonPath);
            if (!fileRef.exists()) {
                vector<string> alternatePaths;
                auto path = filesystem::path(jsonPath);
                // [NOTE: scip-ruby-path-normalization]
                // We normalize paths upon entry into GlobalState, so it is sufficient to only check
                // different normalized combinations here. One common situation where normalization is
                // necessary is if you pass '.' as the directory argument, without normalization,
                // the entered paths would be './'-prefixed, but you could reasonably forget to add
                // the same in the JSON file.
                auto normalizedPath = path.lexically_normal();
                if (normalizedPath != path) {
                    alternatePaths.push_back(normalizedPath);
                }
                if (normalizedPath.is_absolute()) {
                    alternatePaths.push_back(string(normalizedPath.lexically_relative(currentDir).lexically_normal()));
                } else {
                    alternatePaths.push_back(string((currentDir / normalizedPath).lexically_normal()));
                }
                bool foundFile = absl::c_any_of(alternatePaths, [&](auto &altPath) -> bool {
                    fileRef = gs.findFileByPath(altPath);
                    return fileRef.exists();
                });
                if (!foundFile) {
                    errorCount++;
                    if (errorCount < 5) {
                        if (auto e = gs.beginError(core::Loc(), errors::SCIPRuby)) {
                            e.setHeader("File path in JSON map doesn't match known paths: {}", jsonPath);
                            e.addErrorNote("Use --debug-log-filepaths to check the paths being recorded by scip-ruby");
                        }
                    }
                    continue;
                }
            }
            auto gemMetadata = GemMetadata::tryParse(document["gem"].GetString());
            if (!gemMetadata.has_value()) {
                continue;
            }
            this->map[fileRef] = make_shared<GemMetadata>(move(gemMetadata.value()));
        }
    }
}

void GemMapping::markCurrentGem(GemMetadata gem) {
    this->currentGem = make_shared<GemMetadata>(gem);
}

} // namespace sorbet::scip_indexer
