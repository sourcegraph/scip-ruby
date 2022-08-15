gem_build_info = [
    # {
    #     "repo_name": "brew",
    # #     "kind": "self_sandboxing",
    #     "archive_url": "https://github.com/Homebrew/brew/archive/refs/tags/3.5.9.zip",
    #     "archive_sha256": "28a66005cc6f0f22a9a112ce84cedb833efe6926072dec2c68623195c008852f",
    #     "ref": "3.5.9",
    #     "strip_prefix": "brew-3.5.9",
    #     "gem_subdir": "Library/Homebrew",
    # #     "prep_cmd": """
    # #         pushd Library/Homebrew \\
    # #         && gem install bundler:1.17.3 \\
    # #         && popd \\
    # #         && ./bin/brew typecheck
    # #         """,
    # #     "run_cmd": """
    # #         pushd Library/Homebrew \\
    # #         && find . -name srb -type f -exec cp $${TEST_DIR}/$(location //main:scip-ruby) {} \\; \\
    # #         && popd \\
    # #         && ./bin/brew typecheck
    # #         """,
    # },
    {
        "repo_name": "shopify-api-ruby",
        # "kind": "needs_sandboxing",
        "archive_url": "https://github.com/Shopify/shopify-api-ruby/archive/refs/tags/v11.1.0.zip",
        "archive_sha256": "95a209308d6479491ca282af66254bd6c4e1c5b6edb8e0409e2fe29424a51157",
        "ref": "v11.1.0",
        "strip_prefix": "shopify-api-ruby-11.1.0",
        # "prep_cmd": """
        #     bundle cache --all \\
        #     && for p in $(locations //gems/scip-ruby); do cp $${TEST_DIR}/$$p vendor/cache/; done \\
        #     """,
        # "run_cmd": """
        #     bundle install --local \\
        #     && bundle exec scip-ruby --index-file index.scip --gem-metadata 'shopify-api-ruby@11.1.0' \\
        #     && file index.scip
        #     """,
        "gem_subdir": ".",
    },
]
