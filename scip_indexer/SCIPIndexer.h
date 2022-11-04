#ifndef SORBET_SCIP_INDEXER
#define SORBET_SCIP_INDEXER

#include <string>

#include "main/pipeline/semantic_extension/SemanticExtension.h"

namespace sorbet::scip_indexer {

// Indexer configuration options unrelated to I/O
struct Config {
    // Argument to --gem-metadata, missing state folded to ""
    std::string gemMetadata;
    // Argument to --gem-map-path, missing state folded to ""
    std::string gemMapPath;
};

} // namespace sorbet::scip_indexer

#endif