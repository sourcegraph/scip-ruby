workspace(name = "com_stripe_ruby_typer")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//third_party:externals.bzl", "register_scip_ruby_dependencies", "register_sorbet_dependencies")

register_sorbet_dependencies()

load("@rules_foreign_cc//foreign_cc:repositories.bzl", "rules_foreign_cc_dependencies")

# We need to explicitly pull in make here for rules_foreign_cc
# to be able to build in CI.
http_archive(
    name = "gnumake_src",
    build_file_content = """\
filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)
""",
    sha256 = "581f4d4e872da74b3941c874215898a7d35802f03732bdccee1d4a7979105d18",
    strip_prefix = "make-4.4",
    urls = ["https://mirror.bazel.build/ftpmirror.gnu.org/gnu/make/make-4.4.tar.gz"],
)

rules_foreign_cc_dependencies()

register_scip_ruby_dependencies()

load("@com_grail_bazel_compdb//:deps.bzl", "bazel_compdb_deps")

bazel_compdb_deps()

load("@toolchains_llvm//toolchain:deps.bzl", "bazel_toolchain_dependencies")

bazel_toolchain_dependencies()

# bazel_features is used by rules_cc and toolchains_llvm to detect Bazel version
# capabilities. bazel_features_deps() sets up the @bazel_features_version repository
# which is needed by bazel_features internally.
load("@bazel_features//:deps.bzl", "bazel_features_deps")

bazel_features_deps()

# rules_cc 0.2.14+ requires the @cc_compatibility_proxy repository to be set up
# for WORKSPACE builds. This provides compatibility shims for native cc_* rules.
load("@rules_cc//cc:extensions.bzl", "compatibility_proxy_repo")

compatibility_proxy_repo()

load("@toolchains_llvm//toolchain:rules.bzl", "llvm_toolchain")

llvm_toolchain(
    name = "llvm_toolchain_15_0_6",
    # absolute_paths = False (the default) creates symlinks for tools like
    # llvm-libtool-darwin -> libtool in the toolchain bin directory, which is
    # required for proper tool resolution on macOS.
    alternative_llvm_sources = [
        "https://github.com/llvm/llvm-project/releases/download/llvmorg-{llvm_version}/{basename}",
    ],
    llvm_version = "15.0.6",
    # The sysroots are needed for cross-compiling
    sysroot = {
        "": "",
        "darwin-x86_64": "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk",
        "darwin-aarch64": "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk",
    },
)

load("@llvm_toolchain_15_0_6//:toolchains.bzl", "llvm_register_toolchains")

llvm_register_toolchains()

load("@emsdk//:deps.bzl", emsdk_deps = "deps")

emsdk_deps()

load("@emsdk//:emscripten_deps.bzl", emsdk_emscripten_deps = "emscripten_deps")

emsdk_emscripten_deps(emscripten_version = "3.1.59")

load("@emsdk//:toolchains.bzl", "register_emscripten_toolchains")

register_emscripten_toolchains()

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains(version = "1.20.7")

load("@rules_ragel//ragel:ragel.bzl", "ragel_register_toolchains")

ragel_register_toolchains()

load("@rules_m4//m4:m4.bzl", "m4_register_toolchains")

m4_register_toolchains()

load("@rules_bison//bison:bison.bzl", "bison_register_toolchains")

bison_register_toolchains(
    # Clang 12+ introduced this flag. All versions of Bison at time of writing
    # (up to 3.7.6) include code flagged by this warning.
    extra_copts = ["-Wno-implicit-const-int-float-conversion"],
)

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

load("@rules_rust//rust:repositories.bzl", "rules_rust_dependencies", "rust_register_toolchains")

rules_rust_dependencies()

rust_register_toolchains(
    edition = "2021",
    versions = [
        "1.58.1",
    ],
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

load("@aspect_bazel_lib//lib:repositories.bzl", "aspect_bazel_lib_dependencies")

aspect_bazel_lib_dependencies()

BAZEL_INSTALLER_VERSION_LINUX_X86_64_SHA = "7e749f59fa4c4430fbc49ea38b0bc0a41dd1f460e8671c90978d70c2166bf0c4"

# Bazel for linux-arm64 doesn't have an installer at the moment.
# We have a workaround in `./bazel` to download the binary directly.
BAZEL_INSTALLER_VERSION_LINUX_ARM64_SHA = "8d404f7a266ead50be0918f913df1449a4880f5c8ef36c88d09d6204e67f114d"

BAZEL_INSTALLER_VERSION_DARWIN_X86_64_SHA = "6a0a89a1c0b75e6c1d02fd881adf30f52ea921ea00feaf77a4e14331c488b56e"

BAZEL_INSTALLER_VERSION_DARWIN_ARM64_SHA = "8167011977bffd577cb4c8e9b2100f89134aa83c419a543914568f39a6b1c410"
