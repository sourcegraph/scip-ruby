#ifndef SORBET_NAMER_NAMER_H
#define SORBET_NAMER_NAMER_H
#include "ast/ast.h"
#include "core/FileHash.h"
#include <memory>

namespace sorbet {
class WorkerPool;
}

namespace sorbet::namer {

class Namer final {
public:
    static ast::ParsedFilesOrCancelled
    symbolizeTreesBestEffort(const core::GlobalState &gs, std::vector<ast::ParsedFile> trees, WorkerPool &workers);

    // Note: foundDefinitionHashes is an optional out parameter.
    //
    // Setting it to a non-nullptr requests that Namer compute a fingerprint of the FoundDefinitions
    // it found while running. (Thus, it's usually nullptr except when pipeline::resolve is called
    // for the purpose of computing a FileHash.)
    static ast::ParsedFilesOrCancelled run(core::GlobalState &gs, std::vector<ast::ParsedFile> trees,
                                           WorkerPool &workers, core::FoundDefinitionHashes *foundDefinitionHashesOut);

    // Version of Namer that accepts the old FoundDefinitionHashes for each file to run Namer, which
    // it uses to figure out how to mutate the already-populated GlobalState into the right shape
    // when considering that only the files in `trees` were edited.
    //
    // `trees` and `foundDefinitionHashesForFiles` should have the same number of elements, and
    // `foundDefinitionHashesForFiles[i]` should be the `FoundDefinitionHashes` for `trees[i]`.
    // (Done this way, instead of using something like a `std::pair`, to avoid intermidiate
    // allocations for phases that don't actually need to operate on the `FoundDefinitionHashes`.)
    static ast::ParsedFilesOrCancelled
    runIncremental(core::GlobalState &gs, std::vector<ast::ParsedFile> trees,
                   UnorderedMap<core::FileRef, core::FoundDefinitionHashes> &&oldFoundDefinitionHashesForFiles,
                   WorkerPool &workers);

    Namer() = delete;
};

} // namespace sorbet::namer

#endif
