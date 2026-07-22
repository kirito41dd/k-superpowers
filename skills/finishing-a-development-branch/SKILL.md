---
name: finishing-a-development-branch
description: Use when verified work on a feature branch or worktree needs a merge, PR, retention, discard, or cleanup decision
---

# Finishing A Development Branch

## Entry Gate

Use only when verified work has a real Git integration/cleanup decision. Skip
for current-main Inline work with no integration request. Identify branch,
detached state, base, canonical workspace path, and ownership state before
presenting actions.

## Actions

Use semantic actions; numeric menu positions are presentation only:

| State | Actions |
|-------|---------|
| Named branch | `MERGE`, `PR`, `KEEP`, `DISCARD` |
| Detached HEAD | `PR`, `KEEP`, `DISCARD` |

- `MERGE`: update the local base, rebase the feature onto it, verify, then
  fast-forward the base and verify the integrated result. Stop on conflicts;
  clean up only if ownership permits.
- `PR`: push and create the provider's review request (for example, a GitHub
  pull request or GitLab merge request) only with this explicit selection;
  preserve workspace. Choose the provider-specific path from repository and
  remote context instead of assuming GitHub.
- `KEEP`: preserve branch and workspace.
- `DISCARD`: show branch, commits, and workspace, then require exact `discard`
  confirmation before deletion.

Commands live in `git-actions.md`. Failure stops the selected action; do not
continue into cleanup after failed merge, push, PR, or verification.

Rebasing is the default when the base advanced during development; do not merge
the base into the feature merely to synchronize it. Rewriting an already
published branch and force-pushing remain separate actions requiring explicit
authorization.

## Cleanup Ownership

- `manual-owned(marker)`: rerun provenance inspection; remove only on match.
- `platform-owned(handle/tool)`: invoke only the platform cleanup mechanism.
- `unowned`: preserve and report the path.

Directory names never prove ownership. PR and KEEP always preserve workspace.
