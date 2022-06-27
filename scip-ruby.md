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
