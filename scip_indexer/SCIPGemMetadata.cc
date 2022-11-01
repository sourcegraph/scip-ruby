#include <filesystem>
#include <memory>
#include <optional>
#include <regex>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

#include "absl/strings/str_replace.h"
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

} // namespace sorbet::scip_indexer
