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

## Debugging

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
