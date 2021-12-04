cc_library(
    name = "statsd",
    srcs = select({
        "//tools/config:wasm": ["statsd-emscripten.cc"],
        "//conditions:default": ["statsd.cc"],
    }),
    hdrs = [
        "statsd.h",
    ],
    linkstatic = select({
        "//tools/config:linkshared": 0,
        "//conditions:default": 1,
    }),
    visibility = ["//visibility:public"],
    deps = [
        "//common",
        "//core",
        "//sorbet_version",
    ] + select({
        "//tools/config:wasm": [],
        "//conditions:default": ["@statsd"],
    }),
)
