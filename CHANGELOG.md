# CHANGELOG

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

- Updated with changes from upstream Sorbet as of Sep 23. (3ded54be85d1951f5fc73135912b8c30468adf3b)
