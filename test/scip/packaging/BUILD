sh_test(
    name = "packaged_gem_runs",
    srcs = ["run_packaging_test.sh"],
    data = [
        "fixture/sample.rb",
        "//:.ruby-version",
        "//gems/scip-ruby:scip-ruby-current-platform",
        "//gems/scip-ruby:standalone-ruby",
    ],
    env = {
        "RUBY_TGZ": "$(location //gems/scip-ruby:standalone-ruby)",
        "RUBY_VERSION_FILE": "$(location //:.ruby-version)",
        "SAMPLE_RB": "$(location fixture/sample.rb)",
        "SCIP_RUBY_GEM": "$(location //gems/scip-ruby:scip-ruby-current-platform)",
    },
    size = "medium",
)

test_suite(
    name = "packaging",
    tests = [":packaged_gem_runs"],
)
