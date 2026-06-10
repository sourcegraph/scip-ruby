# Design Decisions

## Repo tests

<!-- DEF NOTE[repo-test-structure] -->

Repo tests exercise `scip-ruby` against pinned, real-world OSS projects.
They intentionally do not install the `scip-ruby` gem into those projects.
Instead, each test:

#. unpacks a pinned source archive into a fresh temporary directory,
#. runs the `scip-ruby` binary built from this checkout,
#. passes explicit gem metadata for the project, and
#. checks that a non-empty `index.scip` file was created.

This keeps the tests focused on whether the current indexer can process a
real project. It avoids modifying third-party lockfiles, installing a freshly
built gem through Bundler, or mutating a shared Ruby installation while the test
runs.

The current check is intentionally lightweight. In the future, repo tests may
also inspect selected parts of the generated index.
