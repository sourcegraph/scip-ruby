#include "doctest.h"
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
#include "spdlog/sinks/stdout_color_sinks.h"

#include "ast/ast.h"
#include "ast/desugar/Desugar.h"
#include "ast/treemap/treemap.h"
#include "cfg/CFG.h"
#include "cfg/builder/builder.h"
#include "class_flatten/class_flatten.h"
#include "common/FileOps.h"
#include "common/common.h"
#include "common/formatting.h"
#include "common/sort.h"
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
#include "scip_indexer/SCIPIndexer.h"
#include "test/helpers/expectations.h"
#include "test/helpers/position_assertions.h"

// NOTE: This code in this file is largely copied from parser_test_runner.cc.

namespace sorbet::test {
using namespace std;

bool update;
vector<string> inputs;
string output;

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

void formatSnapshot(const scip::Document &document, std::ostream &out) {
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
        return symbol; // FIXME(varun): Add customization here!
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
        while (occ_i < occurrences.size() && occurrences[occ_i].range()[0] == lineNumber - 1) {
            auto occ = occurrences[occ_i];
            auto range = SCIPRange(occ.range());
            if (range.isMultiline()) { // FIXME(varun): Handle multiline occurrences.
                occ_i++;
                continue;
            }
            bool isDefinition = ((unsigned(occ.symbol_roles()) & unsigned(scip::SymbolRole::Definition)) > 0);

            string symbolRole = "";
            if (!isDefinition && (occ.symbol_roles() & scip::SymbolRole::WriteAccess)) {
                symbolRole = (occ.symbol_roles() & scip::SymbolRole::ReadAccess) ? "(read+write) " : "(write) ";
            }

            ENFORCE(range.start.column < range.end.column, "We shouldn't be emitting empty ranges 🙅");

            out << '#' << string(range.start.column - 1, ' ') << string(range.end.column - range.start.column, '^')
                << ' ' << string(isDefinition ? "definition" : "reference") << ' ' << symbolRole
                << formatSymbol(occ.symbol());
            if (!(isDefinition && symbolTable.contains(occ.symbol()))) {
                out << '\n';
                occ_i++;
                continue;
            }
            auto &symbolInfo = symbolTable[occ.symbol()];
            string prefix = "\n#" + string(range.start.column - 1, ' ');
            for (auto &doc : symbolInfo.documentation()) {
                out << prefix << "documentation ";
                auto iter = std::find(doc.begin(), doc.end(), '\n');
                if (iter != doc.end()) {
                    // TODO: Use the constructor with two iterators with C++20.
                    out << string_view(doc.data(), std::distance(doc.begin(), doc.end()));
                } else {
                    out << doc;
                }
            }
            relationships.clear();
            relationships.reserve(symbolInfo.relationships_size());
            for (auto &rel : symbolInfo.relationships()) {
                relationships.push_back(rel);
            }
            fast_sort(relationships, [](const scip::Relationship &r1, const scip::Relationship &r2) -> bool {
                return r1.symbol() < r2.symbol();
            });
            for (auto &rel : relationships) {
                out << prefix << "relation " << formatSymbol(rel.symbol());
                if (rel.is_implementation()) {
                    out << " implementation";
                }
                if (rel.is_reference()) {
                    out << " reference";
                }
                if (rel.is_type_definition()) {
                    out << " type_definition";
                }
            }
            out << '\n';
            occ_i++;
        }
    }
}

string snapshot_path(string rb_path) {
    ENFORCE(absl::EndsWith(rb_path, ".rb"));
    rb_path.erase(rb_path.size() - 3, 3);
    return rb_path + ".snapshot.rb";
}

void updateSnapshots(const scip::Index &index, const std::filesystem::path &outputDir) {
    for (auto &doc : index.documents()) {
        auto outputFilePath = snapshot_path(doc.relative_path());
        ofstream out(outputFilePath);
        if (!out.is_open()) {
            FAIL(fmt::format("failed to open snapshot output file at {}", outputFilePath));
        }
        formatSnapshot(doc, out);
    }
}

void compareSnapshots(const scip::Index &index, const std::filesystem::path &snapshotDir) {
    for (auto &doc : index.documents()) {
        auto filePath = snapshot_path(doc.relative_path()); // TODO: Separate out folders!
        ifstream inputStream(filePath);
        if (!inputStream.is_open()) {
            FAIL(fmt::format("failed to open snapshot file at {}", filePath));
        }
        ostringstream input;
        input << inputStream.rdbuf();

        ostringstream out;
        formatSnapshot(doc, out);
        auto result = out.str();

        CHECK_EQ_DIFF(input.str(), result,
                      "snapshot comparison failed; did you forget to run `./bazel test //test/scip:update`?");
    }
}

TEST_CASE("SCIPTest") {
    // FIXME(varun): Add support for multifile tests.
    ENFORCE(inputs.size() == 1);
    Expectations test = Expectations::getExpectations(inputs[0]);

    vector<unique_ptr<core::Error>> errors;
    auto inputPath = test.folder + test.basename;

    auto logger = spdlog::stderr_color_mt("fixtures: " + inputPath);
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
    indexFilePath.append(test.basename + ".scip"); // FIXME(varun): Update for folder tests with multiple files?

    auto providers = Provider::getProviders();
    ENFORCE(providers.size() == 1);
    auto scipProvider = providers[0];

    cxxopts::Options options{"scip-ruby-snapshot-test"};
    scipProvider->injectOptions(options);
    std::vector<const char *> argv = {"scip-ruby-snapshot-test", "--index-file", indexFilePath.c_str(), nullptr};
    auto parseResult = options.parse(3, argv.data());

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

        trees = move(namer::Namer::run(gs, move(trees), *workers).result());
        trees = move(resolver::Resolver::run(gs, move(trees), *workers).result());
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
        updateSnapshots(index, test.folder);
    } else {
        compareSnapshots(index, test.folder);
    }

    MESSAGE("PASS");
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
    options.allow_unrecognised_options().add_options()("output", "path to output file or directory",
                                                       cxxopts::value<std::string>()->default_value(""),
                                                       "path")("update-snapshots", "");
    //("--update-snapshots", "should the snapshot files be overwritten if there are changes");
    auto res = options.parse(argc, argv);

    for (auto &input : res.unmatched()) {
        if (!ends_with(input, ".rb")) {
            printf("error: input files must have .rb extension");
            return 1;
        }
    }

    sorbet::test::update = res.count("update-snapshots") > 0;
    sorbet::test::inputs = res.unmatched();
    sorbet::test::output = res["output"].as<std::string>();

    doctest::Context context(argc, argv);
    return context.run();
}
