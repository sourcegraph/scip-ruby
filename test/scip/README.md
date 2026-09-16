# SCIP snapshot tests

Run `./bazel test --config=dev //test/scip:scip` to check SCIP unit tests and snapshots.
Each fixture runs through both Ruby parsers against the same expected snapshot.
Local IDs are normalized bijectively; different bindings, merged scopes, and incorrect references still fail.

Use `# parser: original` or `# parser: prism` only for a fixture that intentionally requires one parser.
Use `# check-errors: true` to check expected Sorbet diagnostics, including the absence of unexpected errors.
RSpec fixtures can enable the rewriter with `# enable-experimental-rspec: true`.
Existing `# options: showDocs`, `# gem-metadata:`, and `# gem-map:` directives retain their meanings.

To update a specific snapshot, run `./bazel test --config=dev //test/scip:update_<fixture>`.
For shared snapshots, the original parser writes the expectation and Prism must agree with it.
Review generated changes alongside the code change before committing them.
