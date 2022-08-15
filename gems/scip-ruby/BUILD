load(":build_gems.bzl", "build_gems", "setup_standalone_ruby", "version")

version(
    name = "version",
    build_setting_default = "0.0.0",
)

setup_standalone_ruby(
    name = "standalone-ruby",
    visibility = ["//visibility:public"],
)

build_gems(
    name = "scip-ruby",
    srcs = [
        "bin/scip-ruby",
        "scip-ruby.template.gemspec",
    ],
    gem_name = select({
        "//tools/config:dbg": "scip-ruby-debug",
        "//conditions:default": "scip-ruby",
    }),
    gem_target_os = select({
        "//tools/config:linux": "linux",
        "//tools/config:darwin": "darwin",
    }),
    visibility = ["//visibility:public"],
)
