---
name: finishing-a-development-branch
description: Use when the user requests a local commit, merge, PR, or a branch/worktree retention, discard, or cleanup decision
---

# Finishing A Development Branch

## Entry Gate

Start from the requested action. Identify the branch or detached HEAD and the
base, workspace, ownership, and change scope relevant to that action.

Before `COMMIT`, `MERGE`, or `PR`, confirm the final diff has supporting
verification. Reuse current evidence or obtain the missing checks. Apply
`k-superpowers:requesting-code-review`'s independent-review trigger to the final
relevant diff. Complete a required review when no valid result covers that diff;
changes outside the trigger need no formal review.

For `PR` or `MERGE`, bind that evidence to the actual base and feature commits.
Check the whole outgoing change for extra commits or files and confirm it
contains the verified implementation and any in-scope spec. If intended work
is still staged, unstaged or untracked, use an already authorized commit or
ask for the missing authority before publishing or integrating it. Unrelated
local files can stay in place when the operation preserves them.

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

## Action Recipe Gate

After the user selects an action, read its complete section and applicable
shared guidance in `git-actions.md` before the first Git command for that
action. Do this at execution time even if the parent skill was read earlier or
a context summary says it was loaded; do not execute from memory.

Failure stops the selected action; do not continue into cleanup after failed
merge, push, PR, or verification.

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
