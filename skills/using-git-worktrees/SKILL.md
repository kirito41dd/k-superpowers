---
name: using-git-worktrees
description: Use when starting feature work that needs workspace isolation or when an approved execution handoff requires a worktree
---

# Using Git Worktrees

## Workspace Decision

Detect before acting:

```bash
git rev-parse --git-dir
git rev-parse --git-common-dir
git rev-parse --show-superproject-working-tree
git branch --show-current
```

A linked worktree has different git/common dirs and no superproject. Never nest
one. Consume the Unified Execution Handoff exactly once:

- `current workspace`: report location/branch and return. Do not run new-
  worktree setup or baseline installation.
- `create worktree`: prefer a platform native worktree tool; use manual Git only
  when no native tool exists.

## Ownership State

Return one exhaustive state for later cleanup:

```text
manual-owned(marker)
platform-owned(native cleanup handle/tool)
unowned
```

Native creation is platform-owned only when the platform supplies cleanup.
Manual creation calls `scripts/worktree-provenance write WORKTREE_PATH` after
`git worktree add`. A failed marker write leaves the worktree unowned and stops
automatic cleanup. Never infer ownership from `.worktrees/` or another path.

## Manual Placement

Honor an explicit user directory. Otherwise use an existing project-local
`.worktrees/`/`worktrees/` only when `git check-ignore` confirms the selected
path. If it is not ignored, use:

```text
~/.config/superpowers/worktrees/<project>/<branch>
```

Worktree consent does not authorize editing `.gitignore`; that requires a
separate file-edit authorization. Creation failure stops and reports. Never
silently switch to current workspace or another location.

## New-Workspace Setup

Only a newly created worktree gets project-specific dependency setup and the
project's existing baseline verification command. Do not invent a broader test
matrix. A failing baseline blocks implementation until the user decides how to
proceed.

## Cleanup Handoff

Before changing cwd, save canonical worktree path and ownership state.
`finishing-a-development-branch` may remove a manual worktree only after
`worktree-provenance inspect PATH` returns `manual-owned`; platform-owned uses
only the native cleanup handle; unowned is preserved.
