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

## `--unquiet-errors`

scip-ruby defaults to running in Sorbet's quiet mode, as scip-ruby supports
indexing `# typed: false` files on a best-effort basis, but Sorbet may
rightfully flag many errors in those files. The number of errors can be
overwhelming if there is a large amount of untyped code.

This flag restores Sorbet's default behavior.
