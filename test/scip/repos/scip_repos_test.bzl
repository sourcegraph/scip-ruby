load("//third_party:test_gem_data.bzl", "gem_build_info")

def scip_repos_test_suite(name):
    test_names = []
    for gem_data in gem_build_info:
        gem_name = gem_data["repo_name"]
        archive = "@{}_zip//file".format(gem_name)
        project_subdir = gem_data.get("gem_subdir", ".")
        gem_metadata = gem_data.get("gem_metadata", "{}@{}".format(gem_name, gem_data["ref"]))
        index_args = gem_data.get("index_args", ["."])
        common_env = {
            "GEM_METADATA": gem_metadata,
            "INDEX_ARGS": " ".join(index_args),
            "PROJECT_SUBDIR": project_subdir,
            "REPO_ARCHIVE": "$(location {})".format(archive),
            "REPO_NAME": gem_name,
            "SCIP_RUBY": "$(location //main:scip-ruby)",
            "STRIP_PREFIX": gem_data["strip_prefix"],
        }
        darwin_env = dict(common_env)
        darwin_env["LLVM_LIBUNWIND"] = "$(location @llvm_toolchain_15_0_6_llvm//:lib/libunwind.1.dylib)"

        test_name = gem_name
        native.sh_test(
            name = test_name,
            size = "medium",
            srcs = ["run_repo_test.sh"],
            data = [archive, "//main:scip-ruby"] + select({
                "@platforms//os:osx": ["@llvm_toolchain_15_0_6_llvm//:lib/libunwind.1.dylib"],
                "//conditions:default": [],
            }),
            env = select({
                "@platforms//os:osx": darwin_env,
                "//conditions:default": common_env,
            }),
        )
        test_names.append(test_name)

    native.test_suite(
        name = name,
        tests = test_names,
    )
