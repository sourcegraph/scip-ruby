load(":build_gems.bzl", "build_gems", "version")

version(
    name = "version",
    build_setting_default = "0.0.0",
)

build_gems(
    name = "scip-ruby",
    visibility = ["//visibility:public"],
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
    scip_ruby_target = "//main:scip-ruby",
)
