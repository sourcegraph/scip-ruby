# Design Decisions

## Repo tests and packaging tests have separate jobs

Repo tests and packaging tests intentionally cover different risks.

Repo tests answer: "Can the indexer built from this checkout process real Ruby
projects?" They use the built `scip-ruby` binary directly against pinned OSS
projects.

Packaging tests answer: "Can the packaged gem be installed and run the way a
user would get it?" They install the built gem into a small temporary Ruby
project and run `scip-ruby` from that installation.

Keeping these tests separate makes each failure easier to understand. A repo
test failure points at indexing behavior on a real project. A packaging test
failure points at gem building, gem installation, Bundler setup, or the packaged
launcher.

## Repo tests

<!-- DEF NOTE[repo-test-structure] -->

Repo tests exercise `scip-ruby` against pinned, real-world OSS projects.
They intentionally do not install the `scip-ruby` gem into those projects.
Instead, each test:

1. unpacks a pinned source archive into a fresh temporary directory,
2. runs the `scip-ruby` binary built from this checkout,
3. passes explicit gem metadata for the project, and
4. checks that a non-empty `index.scip` file was created.

This keeps the tests focused on whether the current indexer can process a
real project. It avoids modifying third-party lockfiles, installing a freshly
built gem through Bundler, or mutating a shared Ruby installation while the test
runs.

The current check is intentionally lightweight. 

## Packaging tests

Packaging tests exercise the built `scip-ruby` gem, not just the built binary.
They intentionally use a small fixture project instead of the pinned OSS
projects used by repo tests. Each test:

1. builds a gem for the current platform,
2. creates a temporary Ruby project,
3. installs that gem through Bundler from a local cache,
4. runs the installed `scip-ruby` command against a sample Ruby file, and
5. checks that a non-empty `index.scip` file was created.

This keeps packaging coverage focused on the path users rely on when installing
the gem: the gem file, its platform tag, its executable, its bundled binary, and
the Ruby/Bundler environment around it. It avoids making every repo test also
prove gem installation, which would make failures harder to diagnose and would
slow down the real-project coverage.
