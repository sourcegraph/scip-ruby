#include "core/Errors.h"
#include "core/serialize/serialize.h"
#include "main/FileFlatMapper.h"
#include "main/realmain.h"
#include "rang.hpp"
#include "version/version.h"

namespace spd = spdlog;
using namespace std;
namespace ruby_typer {
namespace realmain {
struct PrintOptions {
    std::string option;
    bool Printers::*flag;
    bool supportsCaching = false;
};

const std::vector<PrintOptions> print_options({
    {"parse-tree", &Printers::ParseTree},
    {"parse-tree-json", &Printers::ParseTreeJSON},
    {"ast", &Printers::Desugared},
    {"ast-raw", &Printers::DesugaredRaw},
    {"dsl-tree", &Printers::DSLTree, true},
    {"dsl-tree-raw", &Printers::DSLTreeRaw, true},
    {"name-table", &Printers::NameTable, true},
    {"name-table-json", &Printers::NameTableJson, true},
    {"name-table-full", &Printers::NameTableFull, true},
    {"name-tree", &Printers::NameTree, true},
    {"name-tree-raw", &Printers::NameTreeRaw, true},
    {"cfg", &Printers::CFG, true},
    {"cfg-raw", &Printers::CFGRaw, true},
    {"typed-source", &Printers::TypedSource, true},
});

struct StopAfterOptions {
    std::string option;
    Phase flag;
};

StopAfterOptions stop_after_options[] = {
    {"init", Phase::INIT},   {"parser", Phase::PARSER}, {"desugarer", Phase::DESUGARER},   {"dsl", Phase::DSL},
    {"namer", Phase::NAMER}, {"cfg", Phase::CFG},       {"inferencer", Phase::INFERENCER},
};

cxxopts::Options buildOptions() {
    cxxopts::Options options("ruby_typer", "Typechecker for Ruby");

    // Common user options in order of use
    options.add_options()("e", "Parse an inline ruby string", cxxopts::value<string>()->default_value(""), "string");
    options.add_options()("files", "Input files", cxxopts::value<vector<string>>());
    options.add_options()("q,quiet", "Silence all non-critical errors");
    options.add_options()("P,progress", "Draw progressbar");
    options.add_options()("v,verbose", "Verbosity level [0-3]");
    options.add_options()("h,help", "Show long help");
    options.add_options()("version", "Show version");
    options.add_options()("color", "Use color output", cxxopts::value<string>()->default_value("auto"),
                          "{always,never,[auto]}");

    stringstream all_prints;
    all_prints << "Print: [";
    for (auto &pr : print_options) {
        if (&pr != &print_options[0]) {
            all_prints << ", ";
        }
        all_prints << pr.option;
    }
    all_prints << "]";

    stringstream all_stop_after;
    all_stop_after << "Stop After: [";
    for (auto &pr : stop_after_options) {
        if (&pr != &stop_after_options[0]) {
            all_stop_after << ", ";
        }
        all_stop_after << pr.option;
    }
    all_stop_after << "]";

    // Advanced options
    options.add_options("advanced")("configatron-dir", "Path to configatron yaml folders",
                                    cxxopts::value<vector<string>>(), "path");
    options.add_options("advanced")("configatron-file", "Path to configatron yaml files",
                                    cxxopts::value<vector<string>>(), "path");

    // Developer options
    options.add_options("dev")("p,print", all_prints.str(), cxxopts::value<vector<string>>(), "type");
    options.add_options("dev")("stop-after", all_stop_after.str(),
                               cxxopts::value<string>()->default_value("inferencer"), "phase");
    options.add_options("dev")("no-stdlib", "Do not load included rbi files for stdlib");
    options.add_options("dev")("typed", "Run full checks and report errors on all/no/only @typed code",
                               cxxopts::value<string>()->default_value("auto"), "{always,never,[auto]}");
    options.add_options("dev")("store-state", "Store state into file", cxxopts::value<string>()->default_value(""),
                               "file");
    options.add_options("dev")("typed-source", "Print the specified file with type annotations",
                               cxxopts::value<string>()->default_value(""), "file");
    options.add_options("dev")("cache-dir", "Use the specified folder to cache data",
                               cxxopts::value<string>()->default_value(""), "dir");
    options.add_options("dev")("suppress-non-critical", "Exit 0 unless there was a critical error");
    options.add_options("dev")("trace", "Trace phases");

    int defaultThreads = std::thread::hardware_concurrency();
    if (defaultThreads == 0) {
        defaultThreads = 2;
    }

    options.add_options("dev")("max-threads", "Set number of threads",
                               cxxopts::value<int>()->default_value(to_string(defaultThreads)), "int");
    options.add_options("dev")("counter", "Print internal counter", cxxopts::value<vector<string>>(), "counter");
    options.add_options("dev")("statsd-host", "StatsD sever hostname", cxxopts::value<string>()->default_value(""),
                               "host");
    options.add_options("dev")("counters", "Print all internal counters");
    options.add_options("dev")("suggest-typed", "Suggest which files to add @typed to");
    options.add_options("dev")("statsd-prefix", "StatsD prefix",
                               cxxopts::value<string>()->default_value("ruby_typer.unknown"), "prefix");
    options.add_options("dev")("statsd-port", "StatsD sever port", cxxopts::value<int>()->default_value("8200"),
                               "port");
    options.add_options("dev")("metrics-file", "File to export metrics to", cxxopts::value<string>()->default_value(""),
                               "file");
    options.add_options("dev")("metrics-prefix", "Prefix to use in metrics",
                               cxxopts::value<string>()->default_value("ruby_typer.unknown."), "file");
    options.add_options("dev")("metrics-branch", "Branch to report in metrics export",
                               cxxopts::value<string>()->default_value("none"), "branch");
    options.add_options("dev")("metrics-sha", "Sha1 to report in metrics export",
                               cxxopts::value<string>()->default_value("none"), "sha1");
    options.add_options("dev")("metrics-repo", "Repo to report in metrics export",
                               cxxopts::value<string>()->default_value("none"), "repo");

    // Positional params
    options.parse_positional("files");
    options.positional_help("<file1.rb> <file2.rb> ...");
    return options;
}

bool extractPrinters(cxxopts::ParseResult &raw, Options &opts) {
    if (raw.count("print") == 0) {
        return true;
    }
    vector<string> printOpts = raw["print"].as<vector<string>>();
    for (auto opt : printOpts) {
        bool found = false;
        for (auto &known : print_options) {
            if (known.option == opt) {
                opts.print.*(known.flag) = true;
                if (!known.supportsCaching) {
                    if (!opts.cacheDir.empty()) {
                        console_err->error("--print={} is incompatible with --cacheDir. Ignoring cache", opt);
                        opts.cacheDir = "";
                    }
                }
                found = true;
                break;
            }
        }
        if (!found) {
            stringstream all;
            for (auto &known : print_options) {
                if (&known != &print_options[0]) {
                    all << ", ";
                }
                all << known.option;
            }
            console_err->error("Unknown --print option: {}\nValid values: {}", opt, all.str());
            return false;
        }
    }
    return true;
}

Phase extractStopAfter(cxxopts::ParseResult &raw) {
    string opt = raw["stop-after"].as<string>();
    for (auto &known : stop_after_options) {
        if (known.option == opt) {
            return known.flag;
        }
    }
    stringstream all;
    for (auto &known : stop_after_options) {
        if (&known != &stop_after_options[0]) {
            all << ", ";
        }
        all << known.option;
    }
    console_err->error("Unknown --stop-after option: {}\nValid values: {}", opt, all.str());
    return Phase::INIT;
}

Options readOptions(int argc, const char *argv[]) throw(EarlyReturnWithCode) {
    Options opts;
    FileFlatMapper flatMapper(argc, argv);

    cxxopts::Options options = buildOptions();
    try {
        cxxopts::ParseResult raw = options.parse(argc, argv);

        if (raw.count("files") > 0) {
            opts.inputFileNames = raw["files"].as<vector<string>>();
        }

        opts.cacheDir = raw["cache-dir"].as<string>();
        if (!extractPrinters(raw, opts)) {
            throw EarlyReturnWithCode(1);
        }
        opts.stopAfterPhase = extractStopAfter(raw);
        opts.noStdlib = raw["no-stdlib"].as<bool>();

        opts.threads = min(raw["max-threads"].as<int>(), int(opts.inputFileNames.size() / 2));
        if (opts.threads == 0) {
            opts.threads = 1;
        }

        if (raw["h"].as<bool>()) {
            console->info("{}", options.help({"", "advanced", "dev"}));
            throw EarlyReturnWithCode(0);
        }
        if (raw["version"].as<bool>()) {
            if (Version::isReleaseBuild) {
                console->info("Ruby Typer{}{} git {}{} built on {}", Version::version, Version::codename,
                              Version::build_scm_revision, Version::build_scm_status, Version::build_timestamp_string);
            } else {
                console->info("Ruby Typer non-release build. Binary format version {}",
                              core::serialize::Serializer::VERSION);
            }
            throw EarlyReturnWithCode(0);
        }
        if (raw.count("e") == 0 && opts.inputFileNames.empty()) {
            console->info("You must pass either `-e` or at least one ruby file.\n\n{}", options.help());
            throw EarlyReturnWithCode(1);
        }

        switch (raw.count("v")) {
            case 0:
                break;
            case 1:
                spd::set_level(spd::level::debug);
                console->debug("Debug logging enabled");
                break;
            default:
                spd::set_level(spd::level::trace);
                console->trace("Trace logging enabled");
                break;
        }

        if (raw.count("q") != 0) {
            console->set_level(spd::level::critical);
        }

        if (raw.count("trace") != 0) {
            tracer->set_level(spd::level::trace);
        }

        string typed = raw["typed"].as<string>();
        opts.forceTyped = typed == "always";
        opts.forceUntyped = typed == "never";
        opts.showProgress = raw.count("P") != 0;
        if (raw.count("configatron-dir") > 0) {
            opts.configatronDirs = raw["configatron-dir"].as<vector<string>>();
        }
        if (raw.count("configatron-file")) {
            opts.configatronFiles = raw["configatron-file"].as<vector<string>>();
        }
        opts.storeState = raw["store-state"].as<string>();
        opts.suggestTyped = raw.count("suggest-typed") != 0;
        opts.silenceErrors = raw.count("q") != 0;
        opts.enableCounters = raw.count("counters") != 0;
        opts.statsdHost = raw["statsd-host"].as<string>();
        opts.statsdPort = raw["statsd-port"].as<int>();
        opts.statsdPrefix = raw["statsd-prefix"].as<string>();
        opts.metricsSha = raw["metrics-sha"].as<string>();
        opts.metricsFile = raw["metrics-file"].as<string>();
        opts.metricsRepo = raw["metrics-repo"].as<string>();
        opts.metricsBranch = raw["metrics-branch"].as<string>();
        opts.metricsPrefix = raw["metrics-prefix"].as<string>();
        if (typed != "always" && typed != "never" && typed != "auto") {
            console->error("Invalid value for `--typed`: {}", typed);
        }
        opts.typedSource = raw["typed-source"].as<string>();
        if (!opts.typedSource.empty()) {
            if (opts.print.TypedSource) {
                console_err->error("`--typed-source " + opts.typedSource +
                                   "` and `-p typed-source` are incompatible. Either print out one file or all files.");
                throw EarlyReturnWithCode(1);
            }
            auto found = any_of(opts.inputFileNames.begin(), opts.inputFileNames.end(),
                                [&](string &path) { return path.find(opts.typedSource) != string::npos; });
            if (!found) {
                console_err->error("`--typed-source " + opts.typedSource + "`: No matching files found.");
                throw EarlyReturnWithCode(1);
            }
        }

        if (raw["color"].as<string>() == "auto") {
            if (rang::rang_implementation::isTerminal(std::cerr.rdbuf())) {
                core::ErrorColors::enableColors();
            }
        } else if (raw["color"].as<string>() == "always") {
            core::ErrorColors::enableColors();
        } else if (raw["color"].as<string>() == "never") {
            core::ErrorColors::disableColors();
        }
        if (opts.suggestTyped && !opts.forceTyped) {
            console_err->error("--suggest-typed requires --typed=always.");
            throw EarlyReturnWithCode(1);
        }

        opts.inlineInput = raw["e"].as<string>();
        opts.supressNonCriticalErrors = raw.count("suppress-non-critical") > 0;
    } catch (cxxopts::OptionParseException &e) {
        console->info("{}\n\n{}", e.what(), options.help({"", "advanced", "dev"}));
        throw EarlyReturnWithCode(1);
    }
    return opts;
}

} // namespace realmain
} // namespace ruby_typer
