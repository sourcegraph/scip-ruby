# Agent instructions

## Synchronizing Sorbet upstream

These rules apply when updating scip-ruby from
[`sorbet/sorbet`](https://github.com/sorbet/sorbet).

Follow [`docs/scip-ruby/SYNCING_SORBET.md`](docs/scip-ruby/SYNCING_SORBET.md).
Process upstream commits in first-parent order, one commit at a time, and preserve
the original upstream SHA in every resulting commit.

Continue automatically while an upstream commit can be incorporated without
changing scip-ruby's indexer implementation or its integration with Sorbet. Stop
at the first commit that requires such a change. Do not implement the indexer
change and do not process later upstream commits.

An indexer change includes a required production change to any of the following:

- `scip_indexer/`
- SCIP-specific code in shared Sorbet files
- the pipeline or semantic-extension integration
- SCIP-specific options, Bazel targets, dependencies, or protobuf definitions
- behavior needed to preserve correct SCIP output

Snapshot changes alone are not necessarily an indexer change. Accept them only
after verifying that the new SCIP output is correct and requires no production
change. Never regenerate snapshots to conceal a regression. If correctness is
uncertain, stop.

Before stopping at an incompatible upstream commit, remove that commit from the
sync branch, append an entry to
[`docs/scip-ruby/SORBET_SYNC_BLOCKERS.md`](docs/scip-ruby/SORBET_SYNC_BLOCKERS.md),
commit that documentation change, and leave the worktree clean. Report:

- the last successfully incorporated upstream SHA
- the incompatible upstream SHA, subject, and GitHub link
- the changed upstream API or representation
- the compiler errors, test failures, or code evidence proving an adaptation is
  needed
- the affected scip-ruby files and symbols
- a concrete adaptation plan and the tests it needs
- any unresolved design decisions

Do not push, open a pull request, rewrite existing history, or modify unrelated
work without explicit approval.
