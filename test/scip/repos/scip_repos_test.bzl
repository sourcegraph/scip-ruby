_data = [ 
    {
        "name": "brew",
        "clone_url": "https://github.com/Homebrew/brew.git",
        "tag": "3.5.7",
        "git_sha": "ce8ef89ec0cfe875c48c3a83a843af9074c05930",
        "cmd": ("pushd Library/Homebrew && BUNDLE_WITH='sorbet' bundle install && popd"
          + " && cp $${TEST_DIR}/$(location //main:scip-ruby) ./Library/Homebrew/vendor/bundle/ruby/2.6.0/bin/srb"
          + " && ./bin/brew typecheck")
    }
]

def scip_repos_test_suite(patch_paths):
    patch_paths = { p: None for p in patch_paths }
    test_names = []
    for testdata in _data:
      test_name = testdata["name"]
      patch_path = "{}-{}.patch".format(test_name, testdata["tag"])
      patch_dep = []
      patch_arg = []
      if patch_path in patch_paths:
        patch_dep.append(patch_path)
        patch_arg.append("$(location {})".format(patch_path))
        patch_paths.pop(patch_path, None)

      native.sh_test(
        name = test_name,
        size = "medium", # Should finish in 5 minutes
        srcs = ["index_oss_repo.sh"],
        deps = [],
        data = ["//main:scip-ruby"] + patch_dep,
        args = [
          testdata["name"],
          testdata["clone_url"],
          testdata["tag"],
          testdata["git_sha"],
          "'{}'".format(testdata["cmd"]),
        ] + patch_arg,
      )
      test_names.append(test_name)

    if len(patch_paths) != 0:
      fail("Patches {} were not used by any tests".format(patch_paths))

    native.test_suite(
      name = "repos",
      tests = test_names,
    )
