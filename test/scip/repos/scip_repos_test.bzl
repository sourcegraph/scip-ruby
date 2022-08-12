_data = [
    {
        "name": "brew",
        "clone_url": "https://github.com/Homebrew/brew.git",
        "tag": "3.5.7",
        "git_sha": "ce8ef89ec0cfe875c48c3a83a843af9074c05930",
        "prep_cmd": ("pushd Library/Homebrew" +
                     " && gem install bundler:1.17.3" +
                     " && popd" +
                     " && ./bin/brew typecheck"),
        "run_cmd": ("pushd Library/Homebrew" +
                    " && find . -name srb -type f -exec cp $${TEST_DIR}/$(location //main:scip-ruby) {} \\;" +
                    " && popd" +
                    " && ./bin/brew typecheck"),
    },
    {
        "name": "shopify-api-ruby",
        "clone_url": "https://github.com/Shopify/shopify-api-ruby.git",
        "tag": "v11.1.0",
        "git_sha": "fc3799b5051f1657314314975a887ddfaf791b72",
        "prep_cmd": (" ls $${TEST_DIR} && exit 1 && bundle package" +
                     " && cp $${TEST_DIR}/$(locations //gems/scip-ruby) vendor/cache/"),
        # "prep_cmd": (" ls $${{TEST_DIR}} && exit 1 && bundle package" +
        #              " && cp $${{TEST_DIR}}/$(locations {gem_dep}) vendor/cache/"),
        "run_cmd": ("bundle install --local" +
                    " && bundle exec scip-ruby --index-file index.scip --gem-metadata 'shopify-api-ruby@11.1.0'"),
    },
]

def scip_repos_test_suite(name, patch_paths):
    available_patches = {p: None for p in patch_paths}
    test_names = []
    consumed = {}
    for testdata in _data:
        test_name = testdata["name"]
        patch_basename = "{}-{}".format(test_name, testdata["tag"])
        extra_deps = {}
        gem_dep = {}
        patch_arg = {}
        for os in ["//tools/config:linux", "//tools/config:darwin"]:
            candidates = [patch_basename + ".patch"]
            if "linux" in os:
                candidates.append(patch_basename + "-linux.patch")
                gem_dep[os] = "//gems/scip-ruby/scip-ruby-debug-0.0.0-x86_64-linux.gem"
            else:
                candidates.append(patch_basename + "-darwin.patch")
                gem_dep[os] = "//gems/scip-ruby/scip-ruby-debug-0.0.0-universal-darwin-20.gem"
            extra_deps[os] = [] # [gem_dep[os]]
            for patch_path in candidates:
                if patch_path in available_patches:
                    extra_deps[os].append(patch_path)
                    patch_arg[os] = "$(location {})".format(patch_path)
                    consumed[patch_path] = None
                    if "linux" in patch_path or "darwin" in patch_path:
                        available_patches.pop(patch_path, None)

        print("patch_arg = {}".format(patch_arg))

        native.sh_test(
            name = test_name,
            size = "medium",  # Should finish in 5 minutes
            srcs = ["index_oss_repo.sh"],
            deps = [],
            data = ["//main:scip-ruby", "//gems/scip-ruby"] + select(extra_deps),
            env = select({os: {
                "TEST_NAME": testdata["name"],
                "CLONE_URL": testdata["clone_url"],
                "GIT_TAG": testdata["tag"],
                "GIT_SHA": testdata["git_sha"],
                "PREP_CMD": "'{}'".format(testdata["prep_cmd"]), #.format(gem_dep = dep)),
                "RUN_CMD": "'{}'".format(testdata["run_cmd"]),
                "PATCH_ABSPATH": patch_arg[os],
            } for os, dep in gem_dep.items()}),
        )
        test_names.append(test_name)

    for p in consumed:
        available_patches.pop(p, None)
    if len(available_patches) != 0:
        fail("Patches {} were not used by any tests".format(available_patches))

    native.test_suite(
        name = name,
        tests = test_names,
    )
