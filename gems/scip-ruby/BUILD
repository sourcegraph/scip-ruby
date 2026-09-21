load(":build_gems.bzl", "build_gems", "setup_standalone_ruby", "version")

version(
    name = "version",
    # Don't set this to 0.0.0, that crashes some versions of Bundler.
    # See https://github.com/rubygems/rubygems/pull/5116
    build_setting_default = "1993.5.16",
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
        "@platforms//os:linux": "linux",
        "@platforms//os:osx": "darwin",
    }),
    visibility = ["//visibility:public"],
)
