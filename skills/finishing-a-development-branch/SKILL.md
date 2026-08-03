---
name: finishing-a-development-branch
description: Use when verified work needs an authorized local commit or a branch/worktree merge, PR, retention, discard, or cleanup decision
---

# Finishing A Development Branch

## Entry Gate

Use only when verified work has an explicitly authorized local commit or a real
Git integration/cleanup decision. Skip current-main Inline work while neither
exists. Identify branch/detached state and the selected action's relevant base,
workspace, ownership, and change scope before acting.

## Actions

Use semantic actions; numeric menu positions are presentation only:

| State | Actions |
|-------|---------|
| Named branch | `COMMIT`, `MERGE`, `PR`, `KEEP`, `DISCARD` |
| Detached HEAD | `COMMIT`, `PR`, `KEEP`, `DISCARD` |

- `COMMIT`: stage only the verified, authorized paths and create a local commit;
  preserve workspace and do not infer push, merge, PR, amend, or cleanup.
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

Directory names never prove ownership. COMMIT, PR, and KEEP always preserve
workspace.
