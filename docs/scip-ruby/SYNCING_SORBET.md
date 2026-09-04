# Synchronizing Sorbet upstream

scip-ruby is a fork of [Sorbet](https://github.com/sorbet/sorbet). Its indexer
depends on Sorbet's parser, AST, CFG, symbol, resolver, inference, and pipeline
APIs. This procedure advances the fork through Sorbet's mainline history while
stopping at the first change that needs an indexer adaptation.

## Result of a run

A successful run produces a sync branch containing one traceable commit for
each newly incorporated Sorbet mainline commit. A run has two valid outcomes:

1. It reaches the fixed target SHA, passes final validation, and updates
   `scip_ruby_sync_upstream_sorbet_sha`.
2. It stops immediately before the first commit that requires an indexer
   change, records the blocker in
   [`SORBET_SYNC_BLOCKERS.md`](./SORBET_SYNC_BLOCKERS.md), and leaves a clean
   branch with a precise adaptation report.

Never implement the required indexer adaptation as part of the discovery run.
After that adaptation has been reviewed and implemented separately, start or
resume another run from the updated branch.

## What counts as an indexer change

Stop when incorporating an upstream commit requires a production change to:

- `scip_indexer/`
- SCIP-specific code in shared Sorbet files
- `main` pipeline, semantic-extension, options, or build integration used by
  scip-ruby
- `proto/SCIP.proto`
- SCIP-specific Bazel targets or dependencies
- indexer behavior needed to keep SCIP output complete and correct

Evidence that an indexer change is required includes:

- `//main:sorbet` builds but `//main:scip-ruby` does not because an API consumed
  by the indexer changed.
- Sorbet changes an AST node, CFG representation, symbol API, parser API,
  pipeline phase, or extension point consumed by the indexer.
- Conflict resolution cannot preserve the existing SCIP integration unchanged.
- SCIP tests reveal incorrect or unsupported output that requires production
  code changes.
- Code inspection shows a new representation or case that the current tests do
  not cover but the indexer must handle.

Documentation, CI, and upstream-only test changes do not require stopping.
Mechanical conflict resolution may continue when it preserves the existing
SCIP integration unchanged. Snapshot-only changes may continue only when the
new output is demonstrably correct and no production indexer change is needed.
Stop rather than guess when correctness is uncertain.

## Establish the baseline

Use a clean, dedicated worktree. Do not stash, reset, or overwrite unrelated
work in another worktree.

Ensure the remotes are configured and fetch their current state:

```bash
git remote get-url sorbet >/dev/null 2>&1 \
  && git remote set-url sorbet https://github.com/sorbet/sorbet.git \
  || git remote add sorbet https://github.com/sorbet/sorbet.git
git fetch origin
git fetch sorbet master --tags
```

Read `START_SHA` from `scip_ruby_sync_upstream_sorbet_sha` in
`scip_indexer/SCIPIndexer.cc`. This marker, not `git merge-base`, is the source
of truth for the last synchronized Sorbet commit.

Resolve the target once and keep it fixed for the entire run:

```bash
START_SHA="$(sed -n 's/.*scip_ruby_sync_upstream_sorbet_sha\[\] = "\([0-9a-f]*\)".*/\1/p' scip_indexer/SCIPIndexer.cc)"
TARGET_SHA="$(git rev-parse sorbet/master)"
git merge-base --is-ancestor "$START_SHA" "$TARGET_SHA"
```

Do not chase commits added to `sorbet/master` after `TARGET_SHA` is recorded.
Create a dedicated branch from the current fork branch, or resume an existing
sync branch:

```bash
git switch -c sync-sorbet-"${TARGET_SHA:0:12}" origin/scip-ruby/master
```

Before applying anything:

1. Record `START_SHA`, `TARGET_SHA`, the branch name, and the total count in
   `.git/scip-ruby-sync-state`. This file is local state and must not be
   committed.
2. Save `git diff --name-status "$START_SHA"..origin/scip-ruby/master` as an
   inventory of the intentional fork delta.
3. Run the baseline validation commands below. Record pre-existing failures so
   they are not incorrectly attributed to an upstream commit.

## Build the immutable worklist

Use Sorbet's first-parent history so the order matches commits as they landed on
`master`:

```bash
git rev-list --reverse --first-parent "$START_SHA".."$TARGET_SHA"
```

Store this exact list in `.git/scip-ruby-sync-commits`. Do not silently omit
documentation, build, dependency, generated-file, revert, or merge commits. For
an upstream merge commit, apply the diff relative to its first parent.

On a resumed run, derive progress from commits carrying the
`(cherry picked from commit <SHA>)` provenance line and cross-check it with the
local state file. The first unaccounted entry in the immutable worklist is the
next commit.

## Process one commit

For each worklist entry, in order:

1. Record the current `HEAD` as `LAST_SAFE_SHA`.
2. Inspect the commit message, complete diff, and affected call sites before
   applying it.
3. Decide whether it changes an API or representation consumed by scip-ruby.
4. Apply it with provenance:

   ```bash
   git cherry-pick -x UPSTREAM_SHA
   ```

   For an upstream merge commit, use:

   ```bash
   git cherry-pick -m 1 -x UPSTREAM_SHA
   ```

5. Resolve conflicts deliberately. Prefer the new upstream design in
   upstream-owned code while retaining only the minimal existing SCIP
   integration. Never resolve conflicts wholesale with `ours` or `theirs`.
   Follow upstream renames and deletions rather than restoring obsolete APIs.
6. Inspect the resulting diff against the upstream commit. Direct modifications
   to production indexer code are not permitted during this run.
7. Validate the commit as described below.
8. Only after inspection and validation succeed, record this upstream SHA as
   complete in `.git/scip-ruby-sync-state` and continue.

If a cherry-pick is empty because the change already exists, create an explicit
empty commit with the original subject and an `Upstream-Commit: <SHA>` trailer.
Never silently skip it.

Process commits in reviewable groups of at most 20, but do not squash them. Run
the full primary validation at every group boundary.

## Validation

After every commit that changes C++, Bazel, dependencies, the parser, AST, CFG,
core symbols, namer, resolver, inference, pipeline, or options, run:

```bash
./bazel build //main:scip-ruby //test:scip_test_runner --config=dbg
./bazel test //test/scip --config=dbg --test_output=errors
```

For documentation or clearly unrelated upstream-only changes, inspection is
sufficient. At each 20-commit boundary, run both commands regardless of the
individual commit classifications.

When failures might be specific to the SCIP integration, compare with the
corresponding Sorbet target, relevant upstream tests, and updated upstream call
sites. Diagnose the failure far enough to explain the required adaptation, but
do not make speculative production edits.

Treat snapshots as assertions. Inspect every changed occurrence, symbol,
relationship, range, and diagnostic. Update a snapshot only when the new output
is correct and no production change is needed. Never regenerate snapshots just
to make tests pass.

## Stop at an incompatible commit

At the first commit requiring an indexer change:

1. Do not modify production indexer or integration code.
2. Do not process any later upstream commit.
3. Save relevant compiler and test output outside tracked source files.
4. If the cherry-pick is still conflicted, run `git cherry-pick --abort`.
   Otherwise, reset only the clean, dedicated sync branch to `LAST_SAFE_SHA`:

   ```bash
   git reset --hard "$LAST_SAFE_SHA"
   ```

5. Append a complete entry to `docs/scip-ruby/SORBET_SYNC_BLOCKERS.md` using its
   template. If that upstream SHA already has an entry, update it instead of
   adding a duplicate.
6. Commit only the blocker-log change with a message such as
   `docs: record Sorbet sync blocker <short SHA>`.
7. Confirm there is no active cherry-pick and `git status --short` is empty.
8. Record the incompatible SHA as the next unprocessed commit in the local state
   file.

The blocker report must include:

- last successfully incorporated Sorbet SHA
- incompatible Sorbet SHA, subject, and GitHub commit link
- upstream files and symbols involved
- the relevant API or representation before and after the commit
- exact compiler errors, test failures, or code evidence
- affected scip-ruby files and symbols
- a concrete implementation plan for adapting the indexer
- tests that should be added or updated
- unresolved design choices or uncertainty
- confirmation that the incompatible commit is not on the branch and the
  worktree is clean
- the blocker-log entry and its commit

Report only the first incompatible commit. Later commits may depend on a design
decision made while adapting to this one.

When the indexer adaptation is later implemented, update the corresponding log
entry to `Resolved` and link its pull request or commit in the resolution field.

## Finish a completed sync

After every worklist commit through `TARGET_SHA` has passed:

1. Update `scip_ruby_sync_upstream_sorbet_sha` in
   `scip_indexer/SCIPIndexer.cc` to the exact `TARGET_SHA` in a separate
   bookkeeping commit.
2. Verify every worklist SHA is represented by commit provenance.
3. Audit `git diff --name-status "$TARGET_SHA"..HEAD`. Every difference must be
   attributable to scip-ruby; compare it with the baseline fork-delta inventory
   to catch accidental loss.
4. Search SCIP code and integration files for obsolete Sorbet APIs.
5. Run final validation:

   ```bash
   ./bazel build //main:scip-ruby //test:scip_test_runner --config=dbg
   ./bazel test //test/scip --config=dbg --test_output=errors
   ./bazel test //... --config=dbg --test_output=errors
   ```

6. Confirm the marker equals `TARGET_SHA`, all checks are accounted for, no Git
   operation is active, and the worktree is clean.

Do not push the branch or open a pull request without explicit approval.
