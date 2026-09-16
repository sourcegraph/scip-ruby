# SCIP snapshot tests

Run the SCIP unit tests and snapshots with:

```sh
./bazel test --config=dev //test/scip:scip
```

Fixtures under `testdata/` pair Ruby source with a `.snapshot.rb` file. Snapshots
check SCIP definition and reference symbols, roles, source ranges, enclosing
ranges, and optionally documentation. Multifile fixtures live under
`testdata/multifile/`.

By default, each fixture runs through both the original parser and Prism. Both
must match the same snapshot. Local IDs are normalized only when comparing
occurrence markers, with one consistent mapping per document. References must
still target the right local definition, and separate bindings must stay
separate. Source text, documentation, global symbols, roles, and ranges compare
literally.

## Fixture settings

Place these comments on their own lines in the source. Parser and feature
settings apply to the whole fixture; multifile fixtures can also put them in
`scip-ruby-args.rb`.

| Comment | Effect |
| --- | --- |
| `# parser: original` or `# parser: prism` | Run only the selected parser. Omit this for ordinary shared fixtures. |
| `# enable-experimental-rbs-comments: true` | Enable RBS rewriting, select Prism, and check diagnostics. An explicit original-parser selection is rejected. |
| `# enable-experimental-rspec: true` | Enable the RSpec rewriter with either parser. |
| `# check-errors: true` | Require diagnostics to match the fixture's error assertions. With no assertions, require no errors. |
| `# options: showDocs` | Include symbol documentation and signatures in that file's snapshot. |

Error assertions use Sorbet's existing syntax, including `# error: message` on
an offending line and `# ^^^ error: message` below it. Legacy non-RBS fixtures
opt into diagnostic checking with `check-errors`; new successful-index fixtures
should enable it. Keep fixtures with intentional type errors separate from
successful-index examples. See `rbs_signatures.rb` and `rbs_errors.rb` for both
cases.

Use a parser restriction only when the fixture needs it, and document why.
`minitest_2.rb`, for example, deliberately has malformed syntax whose enclosing
range differs between the parsers during error recovery.

## Updating and debugging

Run an individual fixture or regenerate its snapshot with:

```sh
./bazel test --config=dev //test/scip:rbs_signatures
./bazel test --config=dev //test/scip:update_rbs_signatures
```

Use `//test/scip:update` to update all snapshots. For shared fixtures, the
original parser writes the snapshot and Prism must match it even during an
update. Review the generated changes before staging them. Checked diagnostics
must pass before that parser can write a snapshot.

After building `//test:scip_test_runner`, run it directly with an absolute input
path to select a parser for debugging:

```sh
bazel-bin/test/scip_test_runner --input="$PWD/test/scip/testdata/upstream_wrapped_calls.rb" --parser=prism
```

`--parser=original` is also supported. Conflicts with fixture parser restrictions
or RBS requirements fail explicitly.
