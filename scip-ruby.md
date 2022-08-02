# scip-ruby

## Building

```
./bazel build //main:scip-ruby --config=dbg
```

For more information about configurations, see the main [README](./README.md).

## IDE Integration

Generate `compile_commands.json` as per the main [README](./README.md),
and point your editor to it.

## Generating a SCIP index

NOTE: The binary will be somewhere under `bazel-out` depending on the exact config.

```
scip-ruby myfile.rb --index-file index.scip
```

## Running SCIP tests

```
./bazel test //test/scip --config=dbg
```

Updating snapshots

```
./bazel test //test/scip:update --config=dbg
```

## Writing a new SCIP test

See the existings tests under `test/scip/testdata`
and copy the structure. One caveat is that the first time
you add a new test, you should create matching `.snapshot.rb` files
(which may be empty) for all new `.rb` files,
since those are used as inputs to Bazel.
If you know of a way to get rid of that annoyance, submit a PR.

## Manually testing against larger codebases

Some OSS repos that can be used to exercise scip-ruby are:
- [Homebrew/brew](https://github.com/Homebrew/brew): (150k SLOC)
  1. Clone and run `./bin/brew typecheck` once.
  2. Copy over the built `scip-ruby` binary:
      ```
      cp /path/to/scip-ruby ./Library/Homebrew/vendor/bundle/ruby/2.6.0/bin/srb
      ```
  3. Add a line for indexing 
      ```
      diff --git a/Library/Homebrew/dev-cmd/typecheck.rb b/Library/Homebrew/dev-cmd/typecheck.rb
      index b9f00a544..aac977019 100644
      --- a/Library/Homebrew/dev-cmd/typecheck.rb
      +++ b/Library/Homebrew/dev-cmd/typecheck.rb
      @@ -124,2 +124,3 @@ module Homebrew
             end
      +      srb_exec += ["--index-file", "index.scip", "--gem-metadata", "brew@3.5.4"]
             success = system(*srb_exec)
      ```
  4. Run `./bin/brew typecheck`. An index should appear under `Library/Homebrew/`.
  5. Go to step 2.

## Debugging with print statements

So far, I've mostly been using print debugging
(along with minimized test cases)
since I find it more helpful to see a bunch of output
along with the control flow graph all at once.

Typically, I'll copy over the minimized code
to the root and run:

```
./bazel build //main:scip-ruby --config=dbg && ./bazel-out/darwin-dbg/bin/main/scip-ruby tmp.rb -p cfg-text --index-file /dev/null
```

Alternately, it may be useful to create a `tmp.rb`
file under the `test/scip/snapshots/` directory
(it will be gitignored) and run:

```
# Check
./bazel test //test/scip:tmp --config=dbg
# View output
./bazel test //test/scip:update_tmp --config=dbg && cat test/scip/testdata/tmp.snapshot.rb
```

Having the [SCIP CLI](https://github.com/sourcegraph/scip) available
is also useful for inspecting the emitted index.

## Debugging with LLDB

Maybe there is a cleaner way to do this,
but the following works:

```
export TEST_DIR="$PWD/test/scip/testdata"
pushd bazel-out/darwin-dbg/bin
lldb -- ./test/scip_test_runner "$TEST_DIR/my_test.rb" --output="$TEST_DIR/my_test.snapshot.rb"
popd
unset TEST_DIR
```

## Creating PRs

PRs created through the GitHub UI default to being made
against the upstream Sorbet repo. It is less error-prone
to use the [GitHub CLI](https://cli.github.com/) instead.

```
gh pr create -R sourcegraph/scip-ruby
```

This will correctly use the `scip-ruby/master` branch as the target.
