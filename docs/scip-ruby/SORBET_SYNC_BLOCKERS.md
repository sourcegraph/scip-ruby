# Sorbet synchronization blockers

This log records each Sorbet commit that stopped the upstream synchronization
process because scip-ruby required an indexer adaptation. It preserves the
reason for each stop, the proposed work, and the eventual resolution.

Add entries chronologically. Use one entry per blocking upstream commit. If a
later sync attempt encounters the same commit, update its existing entry rather
than creating a duplicate. When the adaptation lands, change its status to
`Resolved` and link the resolving pull request or commit.

<!--
Copy this template when the synchronization process stops:

## YYYY-MM-DD — Sorbet `<short SHA>`: <commit subject>

- **Status:** Blocked
- **Last incorporated Sorbet commit:** `<SHA>`
- **Blocking Sorbet commit:** [`<SHA>`](https://github.com/sorbet/sorbet/commit/<SHA>)
- **Upstream change:** <Describe the changed API or representation.>
- **Indexer impact:** <Explain why the current indexer cannot compile or produce
  correct SCIP output. Name affected scip-ruby files and symbols.>
- **Evidence:** <Include concise compiler errors, test failures, or code
  evidence.>
- **Required adaptation:** <Describe the concrete proposed implementation.>
- **Tests:** <Describe tests to add or update.>
- **Open questions:** None, or list unresolved design decisions.
- **Resolution:** Pending
-->

No blockers have been recorded yet.
