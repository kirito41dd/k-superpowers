---
name: using-git-worktrees
description: Use when approved work materially benefits from workspace isolation or the user explicitly requests a worktree
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
one. Follow the approved/user-selected workspace choice:

- `current workspace`: report location/branch and return when this skill was
  explicitly invoked; Direct/Inline may use the current workspace without
  loading this skill. Do not run new-worktree setup or baseline installation.
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

Honor an explicit user directory. Otherwise mirror Zed's default
project-adjacent layout:

```text
<repository-parent>/worktrees/<project>/<worktree-name>
```

Derive a short filesystem-safe worktree name from the requested branch or task.
For `/path/to/project`, the pool is `/path/to/worktrees/project/`; because it is
outside the repository, it needs no project `.gitignore` change. Creation
failure stops and reports. Never silently switch to current workspace or
another location.

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
