load(":scip_test.bzl", "scip_test_suite")

scip_test_suite(
    multifile_paths = glob(["testdata/multifile/**"]),
    paths = glob(
        ["testdata/*"],
        exclude_directories = 1,
    ),
)
