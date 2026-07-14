---
name: executing-plans
description: Use when executing an approved implementation plan inline or without SDD checkpoint commits
---

# Executing Plans

Consume the Unified Handoff's explicit current-workspace/create-worktree choice
through `k-superpowers:using-git-worktrees`; do not renegotiate SDD vs Inline.

Review the plan before edits. Stop only for a blocking contradiction, missing
required decision, or material design delta. Record nonblocking concerns and
continue. Create todos, then execute tasks in order: Compact by task/slice, Full
by detailed steps. Run each task's specified verification before completion.

At a plan/risk-required review checkpoint, create the exact NUL-delimited scope
and use `k-superpowers:requesting-code-review` with
`working-tree + package-v1`. Pass requirements, description, scope hash, and
verification evidence. Review never authorizes an implementation commit.

Stop on blockers, unclear instructions, or repeated verification failure; do not
guess. After all tasks, use `finishing-a-development-branch` only for a feature
branch/worktree or real integration/cleanup request. Current-main Inline work
with no integration request runs fresh completion verification and reports
changes in place without a merge/PR/discard menu.
