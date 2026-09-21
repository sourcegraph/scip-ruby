load(":scip_repos_test.bzl", "register_scip_repo_test_caches", "scip_repos_test_suite")

register_scip_repo_test_caches()

scip_repos_test_suite(
    name = "repos",
    patch_paths = glob(["*.patch"]),
)
