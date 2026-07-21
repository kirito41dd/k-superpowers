---
name: executing-plans
description: Use when executing an approved implementation plan inline or without SDD checkpoint commits
---

# Executing Plans

Consume the Unified Handoff's explicit current-workspace/create-worktree choice
through `k-superpowers:using-git-worktrees`; do not renegotiate SDD vs Inline.

Honor an exact bounded response schema without preamble or code fences. When a
request supplies exact output lines or choices, keep all reasoning internal and
make the final response contain exactly those lines, with no explanation.

Review the plan before edits. Stop only for a blocking contradiction, missing
required decision, or material design delta. Record nonblocking concerns and
continue. Create todos, then execute tasks in order: Compact by task/slice, Full
by detailed steps. Run each task's specified verification before completion.

Before the first code edit, invoke `k-superpowers:type-driven-verification` when
the plan contains an Implementation Design Contract or the task changes a
non-self-explanatory core structure, function, or abstraction. Consume its
design, explanation, and focused-verification contract; do not duplicate it for
docs, formatting, mechanical changes, or self-explanatory glue.

At a plan/risk-required review checkpoint, create the exact NUL-delimited scope
and use `k-superpowers:requesting-code-review` with
`working-tree + package-v1`. Pass requirements, description,
the exact source mode/base/head, `EXPECTED_SCOPE_SHA256: <scope-hash>`, and
verification evidence. Review never authorizes an implementation commit.

Advance only when both `Spec verdict` and `Standards verdict` are `PASS`.
Missing or invalid verdicts and every `FAIL` or `CANNOT_VERIFY` block progress.
Use `k-superpowers:requesting-code-review` recovery: obtain the smallest missing
evidence for `CANNOT_VERIFY`; batch coherent fixes for `FAIL`; regenerate the
package after material changes; then run one fresh complete two-axis review.
Never accept one axis, a finding list, or a partial rereview as success.

Stop on blockers, unclear instructions, or repeated verification failure; do not
guess. Before a whole-change success claim, invoke
`k-superpowers:verification-before-completion` and consume its fresh evidence
gate. Unavailable, stale, noisy, or failing evidence stops the run without a
success claim or cleanup/integration transition; only fresh bounded passing
evidence for the exact final state advances. After all tasks, use
`finishing-a-development-branch` only for a feature
branch/worktree or real integration/cleanup request. Current-main Inline work
with no integration request reports verified changes in place without a
merge/PR/discard menu.
