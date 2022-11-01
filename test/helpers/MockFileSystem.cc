#include <vector>

#include "absl/strings/match.h"
#include "absl/strings/strip.h"

#include "test/helpers/MockFileSystem.h"

using namespace std;

namespace sorbet::test {
MockFileSystem::MockFileSystem(string_view rootPath) : rootPath(string(rootPath)) {}

string makeAbsolute(string_view rootPath, string_view path) {
    if (path[0] == '/') {
        return string(path);
    } else {
        return fmt::format("{}/{}", rootPath, path);
    }
}

void MockFileSystem::writeFiles(const vector<pair<string, string>> &initialFiles) {
    for (auto &pair : initialFiles) {
        writeFile(pair.first, pair.second);
    }
}

string MockFileSystem::readFile(string_view path) const {
    auto file = contents.find(makeAbsolute(rootPath, path));
    if (file == contents.end()) {
        throw sorbet::FileNotFoundException(fmt::format("Cannot find file `{}`", path));
    } else {
        return file->second;
    }
}

void MockFileSystem::writeFile(string_view filename, string_view text) {
    contents[makeAbsolute(rootPath, filename)] = text;
}

void MockFileSystem::deleteFile(string_view filename) {
    auto file = contents.find(makeAbsolute(rootPath, filename));
    if (file == contents.end()) {
        throw sorbet::FileNotFoundException(fmt::format("Cannot find file `{}`", filename));
    } else {
        contents.erase(file);
    }
}

std::string MockFileSystem::getCurrentDir() const {
    return rootPath;
}

vector<string> MockFileSystem::listFilesInDir(string_view path, const UnorderedSet<string> &extensions, bool recursive,
                                              const vector<string> &absoluteIgnorePatterns,
                                              const vector<string> &relativeIgnorePatterns) const {
    if (path != "." || !absoluteIgnorePatterns.empty() || !relativeIgnorePatterns.empty() || recursive) {
        Exception::raise("Not implemented full support for all parameters in MockFileSystem::listFilesInDir");
    }
    vector<string> out{};
    for (auto &[filePath, _] : contents) {
        auto relativePath = absl::StripPrefix(absl::StripPrefix(filePath, rootPath), "/");
        if (absl::StrContains(relativePath, '/')) {
            continue;
        }
        for (auto &ext : extensions) {
            if (absl::EndsWith(relativePath, ext)) {
                out.push_back(std::string(relativePath));
            }
        }
    }
    return out;
}
} // namespace sorbet::test
