# CHANGELOG

## v0.3.9

- Updated with changes from upstream Sorbet as of July 28 2023. (05866f6cfc5339e1e7a6d7e399ff92af594e3f9b)
  - This includes a fix for an assertion triggered in type-checking.
    (https://github.com/sourcegraph/scip-ruby/issues/192)

## v0.3.8

Fixes 3 different bugs related to assertions being hit
in debug builds.

(https://github.com/sourcegraph/scip-ruby/pull/197,
https://github.com/sourcegraph/scip-ruby/pull/198,
https://github.com/sourcegraph/scip-ruby/pull/200)

These may potentially have caused crashes in release builds.

## v0.3.7

Fixes an issue when emitting indexes over 2GB in size,
which may be hit for codebases over 10M+ SLOC.
(https://github.com/sourcegraph/scip-ruby/pull/190)

## v0.3.6

In debug builds, scip-ruby would sometimes emit spurious log messages.

- Fields not being found in classes.
- Type information not being found in `# typed: false` files.

Both of these have been fixed.
(https://github.com/sourcegraph/scip-ruby/pull/186,
https://github.com/sourcegraph/scip-ruby/pull/187)

This release doesn't affect any behavior in release builds.

## v0.3.5

- Fixed a bug which caused a segfault in release builds,
  and an assertion being hit in debug builds.
  (https://github.com/sourcegraph/scip-ruby/pull/183)

## v0.3.4

- Updated with changes from upstream Sorbet as of June 6 2023. (0f6fd90cdf20d507f20dcbe928431dc16d3e1793)

## v0.3.3

### Auto-indexing

(Sourcegraph-use only)

The auto-indexing image also bundles in `git`
which can be used by `bundler`.

## v0.3.2

### Auto-indexing

(Sourcegraph-use only)

The auto-indexing script will run `bundle install`
for non-Sorbet repos to fetch dependencies before invoking
the indexer. (https://github.com/sourcegraph/scip-ruby/pull/165)

### Sorbet sync

- Updated with changes from upstream Sorbet as of Nov 21 2022. (b8461dbcd56ba56b2854d07f546c7216b31b58e6)

## v0.3.1

No user-facing changes; this is a synthetic release
for publishing the Docker image for auto-indexing.

## v0.3.0

### Feature additions

- Added preliminary support for cross-repo code navigation.
  scip-ruby can now understand which files belong to which gems (name + version pairs).
  - By default, information about external gems will be inferred from
    standard filesystem layout. (https://github.com/sourcegraph/scip-ruby/pull/155)
  - Optionally, one can specify file to gem mapping explicitly
    using a JSON file when using non-standard directory layout. (https://github.com/sourcegraph/scip-ruby/pull/149)
- Information about the current gem can be inferred from
  Gemfile.lock and gemspec files on a best-effort basis,
  reducing the need to specify the `--gem-metadata` flag explicitly. (https://github.com/sourcegraph/scip-ruby/pull/143)
- Indexes are saved to `index.scip` when the `--index-file` argument is not specified. (https://github.com/sourcegraph/scip-ruby/pull/142)
- Added a new [CLI reference doc](docs/scip-ruby/CLI.md),
  which describes scip-ruby flags in more detail and includes examples.

### Sorbet sync

- Updated with changes from upstream Sorbet as of Nov 1 2022. (bc92a0f55897bda974df401a3a1b4d2191e0877b)

## v0.2.0

### Feature additions

- `# typed: false` files are indexed on a best-effort basis. (https://github.com/sourcegraph/scip-ruby/pull/132)

### Bug fixes

- Fixed a crash with defaulted block parameters. (https://github.com/sourcegraph/scip-ruby/pull/130)
- Fixed resolution of fields coming in from mixins. (https://github.com/sourcegraph/scip-ruby/pull/116)
- Fixed a non-determinism issue which led to equivalent but shuffled indexes. (https://github.com/sourcegraph/scip-ruby/pull/124)

## v0.1.2

### Bug fixes

- Fixed code navigation for globals (https://github.com/sourcegraph/scip-ruby/pull/118)
- Fixed code navigation for inherited fields (https://github.com/sourcegraph/scip-ruby/pull/108)
- Fixed missing references for non-overriden methods (https://github.com/sourcegraph/scip-ruby/pull/107)

### Sorbet sync

- Updated with changes from upstream Sorbet as of Sep 23 2022. (3ded54be85d1951f5fc73135912b8c30468adf3b)
