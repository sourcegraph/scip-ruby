# scip-ruby CLI

This document describes scip-ruby specific flags.

## `--gem-metadata <arg>`

The argument should be `name@version` format, which identifies the current
repository for cross-repo code navigation. By default, `scip-ruby` will
attempt to infer the name and version by looking at `Gemfile.lock`,
any available `.gemspec` files and, both of those failing, the current directory
name (for the version).

If you don't have any of these files, or the information is specified
dynamically (since arbitrary Ruby code is allowed in `.gemspec` files),
you can supply this argument explicitly instead.

The version should generally correspond to the previously released version.
For example, with Git, you can use the last tag
(`git describe --tags --abbrev=0`). However, the version can be an arbitrary
string. For repos which index every commit, you could also use the SHA
instead (`git rev-parse HEAD`).

## `--gem-map-path <arg>`

At the moment, scip-ruby requires an extra step for cross-repo
code navigation; you need to supply information about which
file belongs to which gem explicitly, using a newline-delimited
JSON file in the following format:

<!-- 
TODO: Uncomment this
By default, `scip-ruby` will attempt to identify which gems the
ingested files belong to based on the standard layout of paths
as used by Bundler. If it can't identify the gems for certain files,
it will print a warning. This may happen if you're using a custom
build system or different filesystem layout.

To get correct cross-repo code navigation, you can explicitly
supply information about files and gems using a supplementary
newline-delimited JSON file in the following format:
-->
```json
{"path": "a/b/c.rb", "gem": "my_gem@1.2.3"}
{"path": "a/b/d.rb", "gem": "my_gem@1.2.3"}
{"path": "a/x/y.rb", "gem": "other_gem@3.4.9"}
...
```

Then pass the path to the JSON file:

```bash
scip-ruby --gem-map-path path/to/cross-repo-metadata.json
```

Paths are interpreted relative to the working directory
for the `scip-ruby` invocation.

If information about the gem being indexed
cannot be inferred from the filesystem, then you can supply
the `--gem-metadata` argument as described earlier.

If you run into an error message where a path in the JSON file
is not recognized by `scip-ruby`, you can re-run the indexing command
with extra arguments `--log-recorded-filepaths --debug-log-file out.log`
to identify differences between the JSON file
and paths created by traversing directories.

## `--index-file <arg>`

The path for emitting the SCIP index. Defaults to `index.scip`.

## `--unquiet-errors`

scip-ruby defaults to running in Sorbet's quiet mode, as scip-ruby supports
indexing `# typed: false` files on a best-effort basis, but Sorbet may
rightfully flag many errors in those files. The number of errors can be
overwhelming if there is a large amount of untyped code.

This flag restores Sorbet's default behavior.