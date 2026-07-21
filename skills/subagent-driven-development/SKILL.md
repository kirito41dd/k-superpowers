---
name: subagent-driven-development
description: Use when an approved plan has genuinely independent tasks, delegation has material latency or context benefit, execution stays in the current session, and local checkpoint commits are explicitly authorized
---

# Subagent-Driven Development

Use delegation only when it is faster or safer than one-agent execution. SDD is
not a quality ritual and is not the default for tightly coupled work.

## Entry

Enter only when:

- the behavior and persistent plan are approved;
- tasks can be understood and completed independently;
- the current session supports delegated agents;
- delegation has a concrete benefit; and
- the user explicitly authorizes this plan's local checkpoint commits.

Otherwise use Inline. Checkpoint authorization covers approved implementation
and review-fix commits only. It never includes push, merge, PR, amend, force,
unrelated work, or separate spec/plan commits.

Use the selected current workspace or worktree. Before dispatch, inspect project
instructions, the plan, task dependencies, existing changes, and verification
scope. Stop for actual overlap, incompatible decisions, missing authority, or a
material plan gap; do not block merely because a template field or risk label is
absent when the task is otherwise clear.

Initialize `.superpowers/sdd/` artifacts when they improve task handoff or
recovery. Preserve unmatched existing artifacts and ask before cleaning them.

## Task Safety

Before each task, capture its base and pre-existing state with
`scripts/task-snapshot`. Define the task's intended paths and reject overlap
with user-owned changes. After implementation, inspect the actual diff and
verification, require the authorized checkpoint, and use `task-snapshot` to
confirm that the checkpoint contains only authorized task work. Never stash,
revert, absorb, or manufacture ownership of pre-existing changes.

## Risk And Delegation

Use effect-based judgment rather than mandatory metadata:

- **Low:** docs, comments, formatting, or mechanical work. Controller implements,
  verifies, inspects the diff, and checkpoints directly.
- **Medium:** bounded behavior with no material public, security, persistence,
  concurrency, protocol, or integration risk. One implementer executes;
  controller reads the report, actual diff, and evidence and performs the task
  self-review. No independent reviewer by default.
- **High:** consequential public contract, security, persisted data, migration,
  concurrency, protocol, state-machine, or similarly costly failure. One
  implementer executes and one independent reviewer uses the bounded review
  lifecycle.

Runtime evidence may raise or lower the needed verification/review effort when
the controller explains the concrete effect. A task that reveals an unapproved
material decision stops for the user; local implementation choices do not.

## Delegated Brief

Give each agent a self-contained semantic brief containing:

```text
goal and approved task
relevant inputs, dependencies, and project constraints
authorized and forbidden actions
material blocking conditions
quality, core-explanation, and verification expectations
result information needed by the controller
```

Use `implementer-prompt.md` and `task-reviewer-prompt.md` as adaptable guidance.
Preserve their semantic contract, but adjust wording, context, read order, and
tool usage to the platform and task. Do not require byte-for-byte prompt copies
or fail work because a harmless output format differs.

## Implementer Result

The implementer reports implemented behavior, files changed, material
assumptions, verification and warnings, checkpoint information, and one of:

- `DONE`: task and evidence are complete;
- `DONE_WITH_CONCERNS`: task is complete with a concrete residual concern;
- `NEEDS_CONTEXT`: a material decision or conflict is missing;
- `BLOCKED`: requirements are clear but an external or technical blocker remains.

Controller verifies these claims against the report, actual diff, project
state, and command output. Resolve derivable context directly. Ask the user only
for a material decision; do not turn local naming or implementation judgment
into ceremony. Never skip a blocked task to continue dependent work.

## Review

For high tasks, use `k-superpowers:requesting-code-review` once in Discovery
mode. Freeze stable findings, adjudicate them through
`k-superpowers:receiving-code-review`, apply at most one coherent fix batch, and
return to the same logical reviewer for Closure. Record nonblocking follow-ups.
`STOPPED_BLOCKED` returns control to the user; it does not trigger another
autonomous fix/review loop.

Medium tasks use controller review unless the user, approved plan, or new
evidence identifies a concrete reason for independence. Do not add review merely
to make delegation look rigorous.

Run a final whole-change review only when multiple tasks create a real
shared-interface, shared-state, or unverified composition risk. A single high
task that already completed its task review does not receive a duplicate final
review.

## Completion

Record completed tasks and unresolved follow-ups in the progress artifact when
recovery needs it. After all tasks and any required integration review, invoke
`k-superpowers:verification-before-completion` for bounded whole-change evidence.
Only then clean owned SDD artifacts and report completion.

Use `finishing-a-development-branch` only for a real integration/cleanup
decision. Current-main execution without such a request reports verified
changes in place.

## Owners

- `writing-plans` owns the approved plan and execution choice.
- `requesting-code-review` owns Discovery/Closure and finding semantics.
- `type-driven-verification` owns code design and core explanation guidance.
- `verification-before-completion` owns claim/evidence alignment.
- SDD scripts own mechanical workspace, snapshot, and cleanup operations.
