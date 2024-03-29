#include "doctest/doctest.h"
#include "proto/SCIP.pb.h"
#include <cxxopts.hpp>
// has to go first as it violates our requirements

// has to go first, as it violates poisons

#include <filesystem>
#include <fstream>
#include <memory>
#include <sstream>
#include <string>
#include <sys/types.h>
#include <vector>

#include "absl/strings/match.h"
#include "absl/strings/str_replace.h"
#include "absl/strings/str_split.h"
#include "spdlog/sinks/stdout_color_sinks.h"

#include "ast/ast.h"
#include "ast/desugar/Desugar.h"
#include "ast/treemap/treemap.h"
#include "cfg/CFG.h"
#include "cfg/builder/builder.h"
#include "class_flatten/class_flatten.h"
#include "common/FileOps.h"
#include "common/common.h"
#include "common/sort/sort.h"
#include "common/strings/formatting.h"
#include "common/web_tracer_framework/tracing.h"
#include "core/Error.h"
#include "core/ErrorCollector.h"
#include "core/ErrorQueue.h"
#include "core/Unfreeze.h"
#include "core/serialize/serialize.h"
#include "definition_validator/validator.h"
#include "infer/infer.h"
#include "local_vars/local_vars.h"
#include "main/autogen/autogen.h"
#include "namer/namer.h"
#include "parser/parser.h"
#include "payload/binary/binary.h"
#include "resolver/resolver.h"
#include "rewriter/rewriter.h"
#include "scip_indexer/Debug.h"
#include "scip_indexer/SCIPGemMetadata.h"
#include "scip_indexer/SCIPIndexer.h"
#include "test/helpers/MockFileSystem.h"
#include "test/helpers/expectations.h"
#include "test/helpers/position_assertions.h"

namespace sorbet::scip_indexer {
using namespace std;

struct GemMetadataInferenceTestCase {
    string fileName;
    string content;
    GemMetadata expectedMetadata;
    std::vector<GemMetadataError> expectedErrors;

    GemMetadataInferenceTestCase(string fileName, GemMetadata metadata, std::vector<GemMetadataError> expectedErrors,
                                 string content)
        : fileName(fileName), content(content), expectedMetadata(metadata), expectedErrors(expectedErrors) {}
};
} // namespace sorbet::scip_indexer

// NOTE: This code in this file is largely copied from parser_test_runner.cc.
namespace sorbet::test {
using namespace std;

bool update;
string inputFileOrDir;
bool onlyRunUnitTests;

TEST_CASE("GemMetadataInference") {
    if (!onlyRunUnitTests) {
        return;
    }
    using namespace scip_indexer;
    auto metadata = [](auto &name, auto &version) { return GemMetadata::forTest(name, version); };
    // TODO: Create a MockFilesystem here, add a file to that, and then test readFromConfig instead.
    std::vector<GemMetadataInferenceTestCase> testCases{
        GemMetadataInferenceTestCase("Gemfile.lock", metadata("sciptest", "0.2"), {}, R"(
PATH
  remote: .
    specs:
      sciptest (0.2)
            )"),
        GemMetadataInferenceTestCase("sciptest.gemspec", metadata("sciptest", "0.2"), {}, R"(
  spec.name = "sciptest"
  spec.version = "0.2"
            )"),
        // Check different fallback codepaths.
        GemMetadataInferenceTestCase("Gemfile.lock", metadata("lolz", "latest"), {failedToParseGemfileLockWarning}, ""),
        GemMetadataInferenceTestCase("sciptest.gemspec", metadata("sciptest", "0.1"),
                                     {failedToParseNameFromGemspecWarning}, R"(
  s.name = NOT_A_LITERAL_OOPS
  s.version = "0.1"
            )"),
        GemMetadataInferenceTestCase("sciptest.gemspec", metadata("sciptest", "latest"),
                                     {failedToParseVersionFromGemspecWarning}, R"(
  s.name = "sciptest"
  s.version = NOT_A_LITERAL_OOPS
            )")};
    for (auto &testCase : testCases) {
        MockFileSystem fs("/lolz");
        fs.writeFile(testCase.fileName, testCase.content);
        auto [metadata, actualErrors] = GemMetadata::readFromConfig(fs);
        UnorderedSet<GemMetadataError> actualErrorSet(actualErrors.begin(), actualErrors.end());
        UnorderedSet<GemMetadataError> expectedErrorSet(testCase.expectedErrors.begin(), testCase.expectedErrors.end());
        auto showError = [](const auto &err) -> string { return err.message + "\n"; };
        ENFORCE(actualErrorSet == expectedErrorSet, "expected errors = {}\nobtained errors = {}\n",
                showSet(expectedErrorSet, showError), showSet(actualErrorSet, showError));
        ENFORCE(metadata == testCase.expectedMetadata, "\nexpected metadata = {}@{}\nobtained metadata = {}@{}\n",
                testCase.expectedMetadata.name(), testCase.expectedMetadata.version(), metadata.name(),
                metadata.version());
    }
}

TEST_CASE("GemMapParsing") {
    if (!onlyRunUnitTests) {
        return;
    }
    vector<unique_ptr<core::Error>> errors;

    auto logger = spdlog::stderr_color_mt("file-to-gem-map-test");
    auto errorCollector = make_shared<core::ErrorCollector>();
    auto errorQueue = make_shared<core::ErrorQueue>(*logger, *logger, errorCollector);
    core::GlobalState gs(errorQueue);
    gs.initEmpty(); // needed for proper file table access

    core::FileRef nested, flippedOrder, missing, absolute1, absolute2, absolute3, unnormalized1, unnormalized2;
    {
        core::UnfreezeFileTable fileTableAccess(gs);
        nested = gs.enterFile("nes/ted", "");
        flippedOrder = gs.enterFile("flippedOrder", "");
        missing = gs.enterFile("missing", "");
        absolute1 = gs.enterFile("/gem-map/absolute1", "");
        absolute2 = gs.enterFile("/gem-map/absolute2", "");
        absolute3 = gs.enterFile("absolute3", "");
        unnormalized1 = gs.enterFile("./unnormalized1", "");
        unnormalized2 = gs.enterFile("unnormalized2", "");
    }

    std::string testJSON = R"(
{"path": "nes/ted", "gem": "start@0"}
{"gem": "blah@1.1", "path": "flippedOrder"}
{"path": "/gem-map/absolute1", "gem": "abs@0"}
{"path": "absolute2", "gem": "abs@0"}
{"path": "/gem-map/absolute3", "gem": "abs@0"}
{"path": "unnormalized1", "gem": "un@0"}
{"path": "./unnormalized2", "gem": "un@0"}
)";

    scip_indexer::GemMapping gemMap{};

    MockFileSystem fs("/gem-map");
    fs.writeFile("gem-map.json", testJSON);
    gemMap.populateFromNDJSON(gs, fs, "gem-map.json");

    auto nestedGem = gemMap.lookupGemForFile(gs, nested);
    ENFORCE(nestedGem.has_value());
    ENFORCE(*nestedGem->get() == scip_indexer::GemMetadata::forTest("start", "0"));

    auto flippedOrderGem = gemMap.lookupGemForFile(gs, flippedOrder);
    ENFORCE(flippedOrderGem.has_value());
    ENFORCE(*flippedOrderGem->get() == scip_indexer::GemMetadata::forTest("blah", "1.1"));

    ENFORCE(!gemMap.lookupGemForFile(gs, missing).has_value());

    ENFORCE(gemMap.lookupGemForFile(gs, absolute1).has_value());
    ENFORCE(gemMap.lookupGemForFile(gs, absolute2).has_value());
    ENFORCE(gemMap.lookupGemForFile(gs, absolute3).has_value());
    ENFORCE(gemMap.lookupGemForFile(gs, unnormalized1).has_value());
    ENFORCE(gemMap.lookupGemForFile(gs, unnormalized2).has_value());
}

// This test might feel a little redundant since we also have a similar integration test.
// However, the integration test is making sure that the emitted index has the right
// gem info, which is not checked by this test.
TEST_CASE("GemInference") {
    if (!onlyRunUnitTests) {
        return;
    }
    vector<unique_ptr<core::Error>> errors;

    auto logger = spdlog::stderr_color_mt("gem-inference-test");
    auto errorCollector = make_shared<core::ErrorCollector>();
    auto errorQueue = make_shared<core::ErrorQueue>(*logger, *logger, errorCollector);
    core::GlobalState gs(errorQueue);
    gs.initEmpty(); // needed for proper file table access

    core::FileRef externalGemRBI, annotationsRBI, dslRBI, todoRBI, hiddenDefsRBI, notSorbetRBI;
    {
        core::UnfreezeFileTable fileTableAccess(gs);
        externalGemRBI = gs.enterFile("./sorbet/rbi/gems/extgem@0.rbi", "");
        annotationsRBI = gs.enterFile("./sorbet/rbi/annotations/myannot.rbi", "");
        dslRBI = gs.enterFile("sorbet/rbi/dsl/myrails.rbi", "");
        todoRBI = gs.enterFile("./sorbet/rbi/todo.rbi", "");
        hiddenDefsRBI = gs.enterFile("./sorbet/rbi/hidden-definitions/hidden.rbi", "");
        notSorbetRBI = gs.enterFile("myproject/x.rbi", "");
    }

    scip_indexer::GemMapping gemMap{};
    gemMap.markCurrentGem(scip_indexer::GemMetadata::forTest("mygem", "33"));

    auto checkGem = [&](core::FileRef file, string name, string version) {
        auto gem = gemMap.lookupGemForFile(gs, file);
        ENFORCE(gem.has_value());
        ENFORCE(*gem->get() == scip_indexer::GemMetadata::forTest(name, version),
                "\nexpected: name {}, version {}\nobtained: name {}, version {}", name, version, gem->get()->name(),
                gem->get()->version());
    };

    checkGem(externalGemRBI, "extgem", "0");
    checkGem(annotationsRBI, "myannot", "latest");
    checkGem(dslRBI, "myrails", "latest");
    checkGem(todoRBI, "mygem", "33");
    checkGem(hiddenDefsRBI, "mygem", "33");
    checkGem(notSorbetRBI, "mygem", "33");
}

// Copied from pipeline_test_runner.cc
class CFGCollectorAndTyper { // TODO(varun): Copy this over to scip_test_runner.cc
public:
    vector<unique_ptr<cfg::CFG>> cfgs;
    void preTransformMethodDef(core::Context ctx, ast::ExpressionPtr &tree) {
        auto &m = ast::cast_tree_nonnull<ast::MethodDef>(tree);

        if (m.symbol.data(ctx)->flags.isOverloaded) {
            return;
        }
        auto cfg = cfg::CFGBuilder::buildFor(ctx.withOwner(m.symbol), m);
        auto symbol = cfg->symbol;
        cfg = infer::Inference::run(ctx.withOwner(symbol), move(cfg));
        if (cfg) {
            for (auto &extension : ctx.state.semanticExtensions) {
                extension->typecheck(ctx, ctx.file, *cfg, m);
            }
        }
        cfgs.push_back(move(cfg));
    }
};

/** Converts a Sorbet Error object into an equivalent LSP Diagnostic object. */
unique_ptr<Diagnostic> errorToDiagnostic(const core::GlobalState &gs, const core::Error &error) {
    if (!error.loc.exists()) {
        return nullptr;
    }
    return make_unique<Diagnostic>(Range::fromLoc(gs, error.loc), error.header);
}

template <typename K, typename V, typename Fn> static string map_to_string(const sorbet::UnorderedMap<K, V> m, Fn f) {
    ostringstream out;
    out << "{";
    auto i = -1;
    for (auto &[k, v] : m) {
        i++;
        out << f(k, v);
        if (i != m.size() - 1) {
            out << ", ";
        }
    }
    out << "}";
    return out.str();
}

template <typename T> using Repeated = google::protobuf::RepeatedField<T>;
using Range = Repeated<int32_t>;

bool isSCIPRangeLess(const Range &a, const Range &b) {
    if (a[0] != b[0]) { // start line
        return a[0] < b[0];
    }
    if (a[1] != b[1]) { // start column
        return a[1] < b[1];
    }
    if (a.size() != b.size()) { // is one of these multiline
        return a.size() < b.size();
    }
    if (a[2] != b[2]) { // end line
        return a[2] < b[2];
    }
    if (a.size() == 4) {
        return a[3] < b[3];
    }
    return false;
}

struct SCIPPosition final {
    int32_t line;
    int32_t column;
};

struct SCIPRange final {
    SCIPPosition start;
    SCIPPosition end;

    SCIPRange(SCIPPosition start, SCIPPosition end) : start(start), end(end) {}

    SCIPRange(const google::protobuf::RepeatedField<int32_t> &protoRange) {
        auto &r = protoRange;
        if (r.size() == 4) {
            *this = SCIPRange(SCIPPosition{r[0] + 1, r[1] + 1}, SCIPPosition{r[2] + 1, r[3] + 1});
        }
        *this = SCIPRange(SCIPPosition{r[0] + 1, r[1] + 1}, SCIPPosition{r[0] + 1, r[2] + 1});
    }

    bool isMultiline() const {
        return start.line != end.line;
    }

    string toString() const {
        auto &r = *this;
        return fmt::format("{}:{}-{}:{}", r.start.line, r.start.column, r.end.line, r.end.column);
    }
};

struct FormatOptions {
    bool showDocs;
};

void formatSnapshot(const scip::Document &document, FormatOptions options, std::ostream &out) {
    UnorderedMap<string, scip::SymbolInformation> symbolTable{};
    symbolTable.reserve(document.symbols_size());
    for (auto &symbolInfo : document.symbols()) {
        symbolTable.insert({symbolInfo.symbol(), symbolInfo});
    }
    vector<scip::Occurrence> occurrences;
    occurrences.reserve(document.occurrences_size());
    for (auto &occ : document.occurrences()) {
        occurrences.push_back(occ);
    }
    fast_sort(occurrences, [](const scip::Occurrence &occ1, const scip::Occurrence &occ2) -> bool {
        return isSCIPRangeLess(occ1.range(), occ2.range());
    });
    auto formatSymbol = [](const std::string &symbol) -> string {
        // Strip out repeating information for cleaner snapshots.
        return absl::StrReplaceAll(symbol, {{"scip-ruby gem ", ""},                           // indexer prefix
                                            {"placeholder_name placeholder_version", "[..]"}, // test placeholder
                                            {"ruby latest", "[..]"},                          // core and stdlib
                                            {"_global_ latest", "[global]"}});
    };
    size_t occ_i = 0;
    std::ifstream input(document.relative_path());
    ENFORCE(input.is_open(), "failed to open document to read source code");
    int32_t lineNumber = 1;
    vector<scip::Relationship> relationships;
    for (string line; getline(input, line); lineNumber++) {
        if (!line.empty() && line.back() == '\r') {
            line.pop_back();
        }
        out << ' '; // For '#'
        out << absl::StrReplaceAll(line, {{"\t", " "}});
        out << '\n';
        for (; occ_i < occurrences.size() && occurrences[occ_i].range()[0] == lineNumber - 1; occ_i++) {
            auto occ = occurrences[occ_i];
            auto range = SCIPRange(occ.range());
            if (range.isMultiline()) { // FIXME(varun): Handle multiline occurrences.
                continue;
            }
            bool isDefinition = ((unsigned(occ.symbol_roles()) & unsigned(scip::SymbolRole::Definition)) > 0);

            string symbolRole = "";
            if (!isDefinition && (occ.symbol_roles() & scip::SymbolRole::WriteAccess)) {
                symbolRole = (occ.symbol_roles() & scip::SymbolRole::ReadAccess) ? "(read+write) " : "(write) ";
            }

            ENFORCE(range.start.column < range.end.column, "We shouldn't be emitting empty ranges 🙅");

            auto lineStart = absl::StrCat("#", string(range.start.column - 1, ' '));

            out << lineStart << string(range.end.column - range.start.column, '^') << ' '
                << string(isDefinition ? "definition" : "reference") << ' ' << symbolRole << formatSymbol(occ.symbol())
                << '\n';

            auto printDocs = [&](auto docs, string header) -> void {
                if (!options.showDocs)
                    return;
                for (auto &doc : docs) {
                    out << lineStart << header << '\n';
                    auto docstream = istringstream(doc);
                    for (string docline; getline(docstream, docline);) {
                        out << lineStart << "| " << docline << '\n';
                    }
                }
            };
            printDocs(occ.override_documentation(), "override_documentation");
            if (!symbolTable.contains(occ.symbol())) {
                continue;
            }
            auto &symbolInfo = symbolTable[occ.symbol()];
            bool isDefinedByAnother =
                absl::c_any_of(symbolInfo.relationships(), [](const auto &rel) -> bool { return rel.is_definition(); });
            if (!isDefinition && !isDefinedByAnother) {
                continue;
            }
            printDocs(symbolInfo.documentation(), "documentation");

            relationships.clear();
            relationships.reserve(symbolInfo.relationships_size());
            for (auto &rel : symbolInfo.relationships()) {
                relationships.push_back(rel);
            }
            fast_sort(relationships, [](const scip::Relationship &r1, const scip::Relationship &r2) -> bool {
                return r1.symbol() < r2.symbol();
            });
            if (!relationships.empty()) {
                out << lineStart << "relation ";
                for (auto i = 0; i < relationships.size(); ++i) {
                    auto &rel = relationships[i];
                    if (rel.is_implementation()) {
                        out << "implementation=";
                    }
                    if (rel.is_reference()) {
                        out << "reference=";
                    }
                    if (rel.is_type_definition()) {
                        out << "type_definition=";
                    }
                    if (rel.is_definition()) {
                        out << "definition=";
                    }
                    out << formatSymbol(rel.symbol());
                    if (i != relationships.size() - 1) {
                        out << ' ';
                    }
                }
                out << '\n';
            }
        }
    }
}

string snapshot_path(string source_file_path) {
    ENFORCE(absl::EndsWith(source_file_path, ".rb") || absl::EndsWith(source_file_path, ".rbi"));
    auto dot_pos = source_file_path.rfind('.');
    source_file_path.insert(dot_pos, ".snapshot");
    return source_file_path;
}

struct TestSettings {
    scip_indexer::Config config;
    UnorderedMap</*root-relative path*/ string, FormatOptions> formatOptions;
};

void updateSnapshots(const scip::Index &index, const TestSettings &settings, const std::filesystem::path &outputDir) {
    for (auto &doc : index.documents()) {
        auto outputFilePath = snapshot_path(doc.relative_path());
        ofstream out(outputFilePath);
        if (!out.is_open()) {
            FAIL(fmt::format("failed to open snapshot output file at {}", outputFilePath));
        }
        auto it = settings.formatOptions.find(doc.relative_path());
        ENFORCE(it != settings.formatOptions.end(),
                fmt::format("missing path {} as key in formatOptions map", doc.relative_path()));
        formatSnapshot(doc, it->second, out);
    }
}

void compareSnapshots(const scip::Index &index, const TestSettings &settings,
                      const std::filesystem::path &snapshotDir) {
    for (auto &doc : index.documents()) {
        auto filePath = snapshot_path(doc.relative_path()); // TODO: Separate out folders!
        ifstream inputStream(filePath);
        if (!inputStream.is_open()) {
            FAIL(fmt::format("failed to open snapshot file at {}", filePath));
        }
        ostringstream input;
        input << inputStream.rdbuf();

        ostringstream out;
        auto it = settings.formatOptions.find(doc.relative_path());
        ENFORCE(it != settings.formatOptions.end(),
                fmt::format("missing path {} as key in formatOptions map", doc.relative_path()));
        formatSnapshot(doc, it->second, out);
        auto result = out.str();

        CHECK_EQ_DIFF(input.str(), result,
                      "snapshot comparison failed; did you forget to run `./bazel test //test/scip:update`?");
    }
}

pair<scip_indexer::Config, FormatOptions> readMagicComments(string_view path) {
    scip_indexer::Config config;
    FormatOptions options{.showDocs = false};
    ifstream input(path);
    for (string line; getline(input, line);) {
        if (absl::StrContains(line, "# gem-metadata: ")) {
            auto s = absl::StripPrefix(line, "# gem-metadata: ");
            ENFORCE(!s.empty());
            config.gemMetadata = s;
        } else if (absl::StrContains(line, "# gem-map: ")) {
            auto s = absl::StripPrefix(line, "# gem-map: ");
            ENFORCE(!s.empty());
            config.gemMapPath = s;
        } else if (absl::StrContains(line, "# options: ")) {
            auto s = absl::StripPrefix(line, "# options: ");
            ENFORCE(!s.empty());
            if (absl::StrContains(s, "showDocs")) {
                options.showDocs = true;
            }
        }
    }
    return {config, options};
}

void test_one_gem(Expectations &test, const TestSettings &settings) {
    vector<unique_ptr<core::Error>> errors;

    auto logger =
        spdlog::stderr_color_mt("fixtures: " + (test.isFolderTest ? test.folder + test.basename : test.folder));
    auto errorCollector = make_shared<core::ErrorCollector>();
    auto errorQueue = make_shared<core::ErrorQueue>(*logger, *logger, errorCollector);
    core::GlobalState gs(errorQueue);

    gs.censorForSnapshotTests = true; // TODO(varun): Not 100% sure if this is needed?
    // TODO(varun): Should we add the no-stdlib branch here?
    core::serialize::Serializer::loadGlobalState(gs, getNameTablePayload);

    vector<core::FileRef> files;
    {
        core::UnfreezeFileTable fileTableAccess(gs);
        for (auto &sourceFile : test.sourceFiles) {
            auto fref = gs.enterFile(test.sourceFileContents[test.folder + sourceFile]);
            files.emplace_back(fref);
        }
    }

    using Provider = pipeline::semantic_extension::SemanticExtensionProvider;

    auto indexFilePath = filesystem::temp_directory_path();
    indexFilePath.append(test.basename + ".scip");

    auto providers = Provider::getProviders();
    ENFORCE(providers.size() == 1);
    auto scipProvider = providers[0];

    cxxopts::Options options{"scip-ruby-snapshot-test"};
    scipProvider->injectOptions(options);
    std::vector<const char *> argv = {"scip-ruby-snapshot-test", "--index-file", indexFilePath.c_str()};
    auto &cfg = settings.config;
    auto gemMetadata = cfg.gemMetadata.empty() ? "placeholder_name@placeholder_version" : cfg.gemMetadata;
    argv.push_back("--gem-metadata");
    argv.push_back(gemMetadata.c_str());
    if (!cfg.gemMapPath.empty()) {
        argv.push_back("--gem-map-path");
        argv.push_back(cfg.gemMapPath.c_str());
    }
    argv.push_back(nullptr);
    auto parseResult = options.parse(argv.size() - 1, argv.data());

    gs.semanticExtensions.push_back(scipProvider->readOptions(parseResult));
    {
        sorbet::core::UnfreezeNameTable nt(gs);
        vector<ast::ParsedFile> trees;
        for (auto file : files) {
            auto settings = parser::Parser::Settings{};
            auto ast = parser::Parser::run(gs, file, settings);
            sorbet::core::MutableContext ctx(gs, core::Symbols::root(), file);
            auto tree = ast::ParsedFile{ast::desugar::node2Tree(ctx, move(ast)), file};
            tree.tree = rewriter::Rewriter::run(ctx, move(tree.tree));
            tree = local_vars::LocalVars::run(ctx, move(tree));
            trees.emplace_back(move(tree));
        }

        auto workers = WorkerPool::create(0, gs.tracer());
        sorbet::core::UnfreezeSymbolTable st(gs);

        trees = move(namer::Namer::run(gs, move(trees), *workers, nullptr).result());
        trees = move(resolver::Resolver::run(gs, move(trees), *workers).result());

        for (auto &extension : gs.semanticExtensions) {
            extension->prepareForTypechecking(gs);
        }
        for (auto &resolvedTree : trees) {
            sorbet::core::MutableContext ctx(gs, core::Symbols::root(), resolvedTree.file);
            resolvedTree = class_flatten::runOne(ctx, move(resolvedTree));
            CFGCollectorAndTyper collector;
            ast::ShallowWalk::apply(ctx, collector, resolvedTree.tree);
            for (auto &extension : ctx.state.semanticExtensions) {
                extension->finishTypecheckFile(ctx, resolvedTree.file);
            }
        }
        for (auto &extension : gs.semanticExtensions) {
            extension->finishTypecheck(gs);
        }
        // TODO(varun): Should we be collecting these errors/what should we do with them?
        errorQueue->flushAllErrors(gs);
        auto newErrors = errorCollector->drainErrors();
        errors.insert(errors.end(), make_move_iterator(newErrors.begin()), make_move_iterator(newErrors.end()));
    }

    auto s = map_to_string(test.expectations, [](const auto &s, const auto &m) -> std::string {
        return fmt::format("{}: {}", s, map_to_string(m, [](const auto &k, const auto &v) -> std::string {
                               return fmt::format("{}: {}", k, v);
                           }));
    });

    ifstream indexFile(indexFilePath, ios::in | ios::binary);
    if (!indexFile.is_open()) {
        FAIL("Failed to open index file");
    }

    scip::Index index;
    index.ParseFromIstream(&indexFile);

    if (update) {
        updateSnapshots(index, settings, test.folder);
    } else {
        compareSnapshots(index, settings, test.folder);
    }

    MESSAGE("PASS");
}

// There are several different kinds of tests that we are potentially
// interested in here:
//
// 1. Testing single files for language features.
// 2. Testing multiple files within the same Gem to see if/when defs/refs work.
// 3. Testing usage of the --gem-metadata flag, because not all Ruby Gems
//    contain a .gemspec file (e.g. if it's an application), which means
//    that we do not have a reliable way of inferring the name/version.
// 4. Testing usage of Gem-internal RBI files.
// 5. Testing usage of RBI files coming from external gems. This uses
//    a standardized project structure with a sorbet/ folder.
//    (See https://sorbet.org/docs/rbi)
// 6. Testing usage of multiple local Gems defined within the same repo.
//
// Right now, the testing is set up to handle use cases 1, 2, 3, and 4.
// It should hopefully be straightforward to extend this support for 5.
//
// For 6, I'd like to gather more information about project setups first
// (the directory layout, any expectations of ordering, how Sorbet is run)
// before setting up testing infrastructure and explicit feature support.
TEST_CASE("SCIPTest") {
    if (onlyRunUnitTests) {
        return;
    }
    if (std::filesystem::is_directory(inputFileOrDir)) {
        std::filesystem::current_path(inputFileOrDir);
        inputFileOrDir = ".";
    } else {
        auto inputPath = std::filesystem::path(inputFileOrDir);
        std::filesystem::current_path(inputPath.parent_path());
        inputFileOrDir = inputPath.filename();
    }
    Expectations test = Expectations::getExpectations(inputFileOrDir);

    TestSettings settings;
    if (test.isFolderTest) {
        auto argsFilePath = test.folder + "scip-ruby-args.rb";
        if (FileOps::exists(argsFilePath)) {
            settings.config = readMagicComments(argsFilePath).first;
        }
        ENFORCE(test.sourceFiles.size() > 0);
        for (auto &sourceFile : test.sourceFiles) {
            auto path = test.folder + sourceFile;
            auto [_, inserted] = settings.formatOptions.insert({path, readMagicComments(path).second});
            ENFORCE(inserted, "duplicate source file in Expectations struct?");
        }
    } else {
        ENFORCE(test.sourceFiles.size() == 1);
        auto path = test.folder + test.sourceFiles[0];
        auto &options = settings.formatOptions[path];
        std::tie(settings.config, options) = readMagicComments(path);
    }

    test_one_gem(test, settings);
}

} // namespace sorbet::test

// TODO: Use string.ends_with with C++20.
bool ends_with(const std::string &s, const std::string &suffix) {
    ENFORCE(suffix.size() > 0);
    if (suffix.size() > s.size()) {
        return false;
    }
    for (size_t i = 0; i < suffix.size(); i++) {
        if (s[(s.size() - suffix.size()) + i] != suffix[i]) {
            return false;
        }
    }
    return true;
}

int main(int argc, char *argv[]) {
    cxxopts::Options options("test_corpus_scip", "SCIP test corpus for Sorbet typechecker");
    options.allow_unrecognised_options();
    options.add_options()("input", "path to input file to directory", cxxopts::value<std::string>());
    options.add_options()("update-snapshots", "should the snapshot files be overwritten if there are changes");
    options.add_options()("only-unit-tests", "only run unit tests, skip snapshot tests");
    auto res = options.parse(argc, argv);

    auto unmatched = res.unmatched();
    if (!unmatched.empty()) {
        fmt::print(stderr, "error: unexpected arguments passed to test runner {}",
                   sorbet::scip_indexer::showVec(unmatched, [](auto &s) { return s; }));
        return 1;
    }

    if (res.count("only-unit-tests") > 0) {
        sorbet::test::onlyRunUnitTests = true;
        doctest::Context context(argc, argv);
        return context.run();
    }

    ENFORCE(res.count("input") == 1);
    sorbet::test::update = res.count("update-snapshots") > 0;
    sorbet::test::inputFileOrDir = res["input"].as<std::string>();
    doctest::Context context(argc, argv);
    return context.run();
}
