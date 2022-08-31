cc_library(
    name = "interface",
    hdrs = ["SCIPIndexer.h"],
    visibility = ["//visibility:public"],
    deps = [
        "//main/pipeline/semantic_extension:interface",
    ],
)

cc_library(
    name = "scip_utils",
    srcs = [
        "SCIPUtils.cc",
        "SCIPUtils.h",
    ],
    linkstatic = select({
        "@com_stripe_ruby_typer//tools/config:linkshared": 0,
        "//conditions:default": 1,
    }),
    visibility = ["//visibility:public"],
    deps = [
        "//proto",
        "@com_google_absl//absl/status",
        "@com_google_absl//absl/strings",
    ],
)

cc_library(
    name = "scip_indexer",
    srcs = [
        "SCIPIndexer.cc",
    ],
    linkstatic = select({
        "@com_stripe_ruby_typer//tools/config:linkshared": 0,
        "//conditions:default": 1,
    }),
    visibility = ["//visibility:public"],
    deps = [
        "interface",
        "scip_utils",
        "//ast",
        "//ast/treemap",
        "//cfg",
        "//common",
        "//core",
        "//main/lsp",
        "//proto",
        "//sorbet_version",
        "@com_google_absl//absl/status",
        "@com_google_absl//absl/status:statusor",
        "@com_google_absl//absl/synchronization",
        "@cxxopts",
        "@spdlog",
    ],
)
