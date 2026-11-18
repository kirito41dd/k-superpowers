---
name: subagent-driven-development
description: Use when executing approved implementation work with bounded tasks that benefit from delegation, sequentially or concurrently
---

# Subagent-Driven Development

Delegate a task when a clear interface and a focused brief let another agent
make useful progress. The controller owns sequencing, integration, and final
acceptance, and can implement tightly coupled work directly. A plan in the
conversation is sufficient when it conveys the needed decisions.

## Choose the workspace and order

Start in the selected workspace. Assign each writer specific paths and name the
contracts, generated outputs, and checks its work depends on. Apply the
independence criteria in `k-superpowers:dispatching-parallel-agents`.
Sequence dependent tasks or settle their shared contract first.

In a shared checkout, delegates may edit disjoint paths concurrently. The
controller owns staging, commits and shared verification. Use separate worktrees
when tasks need independent builds, baselines, rollback, or delivery. Establish
the integration path and authority before relying on isolated results.

## Accept uncommitted work

Before dispatch, inspect existing changes and agree on each task's writable
files, including new and generated files. Preserve user-owned work. In a Git
checkout the controller can check the combined scope with `scripts/task-snapshot`:

```text
task-snapshot capture-working BASELINE_FILE SCOPE
    ... delegates edit their assigned files ...
task-snapshot verify-working BASELINE_FILE SCOPE
```

SCOPE lists the union of exact repo-relative file paths, sorted, unique and
NUL-terminated. Keep the baseline and scope outside the checkout or in an
ignored run directory. Capture while writers are idle and verify after they
finish. Reuse the original baseline for in-scope review fixes. The check allows
unstaged edits and new files in the assigned union and checks Git-visible state
outside it, HEAD and the staged contents. The controller still inspects each
task's actual diff, including new files, and runs checks on the integrated
result. A passing union check alone cannot attribute changes to a particular
delegate or validate ignored outputs. The baseline includes the contents of
initialized submodules. Assign edits inside a submodule from that repository.
Give writers ordinary file paths. If a path traverses a symlink, identify who
owns its target before dispatch. An edit to the link itself, an existing ignored
target, or a file hidden by index flags needs a separately inspected baseline.

If the scope includes existing changes, establish ownership before editing.
For earlier authorized work, compare against its recorded starting content;
for user changes, resolve any real overlap or choose an isolated baseline that
includes the required inputs. Investigate a failed check before proceeding.
Never stash, revert, or absorb another person's changes to make a check pass.

## Optional checkpoints

The default result is verified, uncommitted work. Delegation needs no Git
permission. If local checkpoints are explicitly authorized, the controller
can checkpoint the accepted batch after the writers finish. For an isolated
task or batch using checkpoint verification, run `task-snapshot capture` and
`check-scope` before the work, then `verify` against the authorized commit
range. This strict mode checks the whole checkout. A delegate may create a
checkpoint only in an isolated checkout when the brief assigns that action
and the user has authorized it. Push, merge, PR and cleanup retain their own
authorization boundaries.

Keep task checkpoints within their assigned files. When a commit delivers
the whole change, use the [implementation commit scope](../finishing-a-development-branch/git-actions.md#commit)
for its accompanying spec and plan.

## Handoff and review

Use `implementer-prompt.md` for a focused brief. Include the goal, writable
paths, stable inputs, relevant project constraints, expected evidence and
where to return the result. A delegate can report completion, a concrete
concern, missing context, or a blocker. Resolve derivable context locally.

Inspect each delivery against its requirements and engineering standards.
Apply `k-superpowers:requesting-code-review` to the actual risk and the
user's request. Use `task-reviewer-prompt.md` when independent review is
needed. Review the combined result when shared contracts or state create a
risk that task-level reviews could not cover. Keep handoff or recovery
artifacts only when useful, and clean up only owned artifacts within authority.
