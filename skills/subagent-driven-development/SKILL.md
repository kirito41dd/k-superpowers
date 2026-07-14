---
name: subagent-driven-development
description: Use when executing implementation plans with independent tasks in the current session
---

# Subagent-Driven Development

Execute a plan with review strength matched to each task's behavioral risk.
The controller handles low-risk work directly; medium/high tasks get a fresh
implementer and one task reviewer that returns separate Spec and Standards
verdicts. High or cross-task risk adds an independent whole-change review.

**Core principle:** Pay review cost where risk justifies it, without weakening
the gates that protect consequential changes.

**Context discipline:** Keep task briefs, implementer reports, review packages,
and the progress ledger in `.superpowers/sdd/` via `./scripts/`. Pass file paths
to subagents instead of pasting bulky artifacts into prompts. After a successful
run, remove the workspace with `./scripts/sdd-cleanup`.

**Continuous execution:** Do not pause between tasks. Stop only for an
unresolved blocker, a real ambiguity, a plan/source-of-truth conflict, or when
all tasks are complete.

## When to Use

Use this skill when an approved implementation plan has mostly independent
tasks and execution will remain in the current session. Use
`k-superpowers:executing-plans` for tightly coupled tasks, a separate execution
session, or when local checkpoint commits are not authorized.

## Invocation Budget

Excluding finding-driven fix loops:

| Plan shape | Subagent invocations |
|------------|----------------------|
| All low | `0` |
| `N` delegated medium/high tasks without integration risk | `2N` |
| Delegated tasks requiring final review | `2N+1` |

Do not dispatch a subagent merely to preserve the appearance of SDD. Low-risk
tasks are intentionally controller-owned.

## Startup

0. Before creating the SDD workspace or editing anything, invoke
   `k-superpowers:using-git-worktrees` with the Unified Execution Handoff's
   workspace decision. Complete setup and baseline verification.
1. Read the plan once, note global constraints and task interfaces, and create
   todos.
2. Run `./scripts/sdd-workspace` and inspect `progress.md`. Do not redispatch a
   task already recorded complete.
3. Run the pre-flight review below.
4. Consume checkpoint authorization from the Unified Execution Handoff. Ask
   once only when no prior handoff or explicit user authorization exists.

### Checkpoint Commit Authorization

The authorization covers only local commits for tasks and review fixes in the
current SDD run. It does not authorize push, merge, PR creation, amend, force
operations, or unrelated changes.

Unified Execution Handoff options 1-2 explicitly authorize these local
checkpoint commits. Choosing SDD without that explicit handoff, approving a
spec, or approving a plan is not commit authorization.
If authorization is declined, route to `k-superpowers:executing-plans` and stop
SDD. Do not simulate commitless SDD with working-tree diffs, stash entries,
temporary patches, or undocumented snapshots. Stable `BASE..HEAD` ranges are
required for task isolation, review packages, and recovery.

## Pre-Flight Plan Review

Before Task 1, scan the plan once for:

- a missing or invalid `Risk: low | medium | high` or missing risk rationale
- classification by diff size rather than behavioral effect
- tasks that contradict each other or `Global Constraints`
- shared interfaces, shared mutable state, or composed behavior that requires
  final whole-change review
- plan requirements that conflict with project source of truth or reviewer
  discipline
- verification commands that broaden target, suite, or matrix scope without
  authorization
- task ordering or interface assumptions that make later tasks impossible

Missing risk metadata stops pre-flight; never infer `low`. Present all genuine
conflicts to the human in one batched question, showing both conflicting texts.
If the scan is clean, proceed without comment.

The controller may escalate risk when new evidence appears. It may not silently
downgrade the approved plan.

## Task Boundary Ownership

Before every task, run `scripts/task-snapshot capture SNAPSHOT_DIR`, set
`TASK_BASE` from its captured HEAD, and build the exact NUL-delimited task scope.
Run `task-snapshot check-scope` before edits; any overlap stops for the user.
Before review/ledger completion, write the executor-reported commit SHAs to the
authorized manifest and run `task-snapshot verify`. Any nonzero result stops.
Never stash, revert, absorb, or manufacture ownership of pre-existing changes.

## Risk Routing

### Low

Low means documentation, comments, formatting, mechanical configuration, or a
local rename with no runtime behavior or public contract change.

The controller:

1. Uses the `TASK_BASE` recorded before risk routing.
2. Generates and reads the task brief.
3. Implements the task directly.
4. Runs the exact task verification.
5. Self-checks the diff line by line against the brief.
6. Creates a local checkpoint commit and verifies task-boundary ownership.
7. Records the task in the progress ledger with `risk low`, the commit range,
   and the verification summary.

If direct work reveals runtime behavior, a public contract change, ambiguous
requirements, or broader scope, stop direct implementation and escalate to
medium. Dispatch a fresh implementer with the current state and new evidence,
and retain the original `TASK_BASE`; do not reset the review base after the
controller's partial work.

### Medium

Medium means bounded local runtime behavior with stable interfaces and a
focused verification entry point.

Use the delegated task flow: fresh implementer, checkpoint commit, one merged
task reviewer, and a combined fix/re-review loop when needed.

### High

High includes public APIs, persisted formats, security boundaries, concurrency,
protocols, state machines, cross-module contracts, and high-risk migrations.

Use the same delegated task flow as medium, then require an independent final
whole-change review after all tasks.

Multiple medium tasks also require final review when they share an interface or
mutable state, or when their composition creates behavior that no task verifies
independently. If implementation or a fix reveals a high-risk condition, record
the escalation in the ledger and require final review.

## Delegated Task Flow

For each medium/high task:

1. Use the `TASK_BASE` and pre-existing status recorded before risk routing.
2. Run `./scripts/task-brief PLAN_FILE N`.
3. Read the generated brief for readiness.
4. Dispatch a fresh implementer with `./implementer-prompt.md`.
5. Require a local checkpoint commit; verify the reported commit is current
   `HEAD` and passes task-boundary ownership checks before review.
6. Build the exact task scope and run the public
   `../requesting-code-review/scripts/review-package committed TASK_BASE HEAD SCOPE_FILE OUTFILE`.
7. Dispatch one task reviewer with `./task-reviewer-prompt.md`.
8. Resolve every `Cannot verify from diff` item.
9. If either verdict fails, send all actionable findings in one fix dispatch,
   require focused verification and a checkpoint commit, regenerate the review
   package, and rerun the complete merged review.
10. When both verdicts pass, record completion in todo and the ledger.

The task reviewer checks Spec first and Standards second, but one fresh reviewer
does both in one context and one diff read. Both verdicts are independently
blocking.

## Brief Readiness

The generated brief is the single source of task requirements. Before dispatch,
confirm it contains:

- `Global Constraints` and the full task text
- exact files and required manifest, docs, or version updates
- `Risk` and `Risk rationale`
- dependency and API/interface constraints
- verification commands with expected results and bounded scope

If required detail can be copied from the plan, append `Controller Notes`. If it
cannot be derived, stop and ask the human or revise the plan. Do not make the
implementer infer missing requirements.

## Model Selection

Use the least powerful model that can complete each role in one pass:

- complete mechanical edits in one or two files: fast/cheap model
- multi-file integration or pattern matching: standard model
- architecture, concurrency, security, public contracts, or final review: most
  capable model

Choose reviewer models by diff complexity and risk. When the platform supports
explicit model selection, specify it in every dispatch. Turn count beats token
price: a cheap model that needs repeated clarification is not cheaper.

## Implementer Status

- **DONE:** verify checkpoint SHA/HEAD, generate the review package, and review.
- **DONE_WITH_CONCERNS:** read concerns first; resolve correctness/scope doubts
  before review and record nonblocking observations.
- **NEEDS_CONTEXT:** provide missing context and redispatch the same task.
- **BLOCKED:** fix the context, use a stronger model, split an oversized task,
  or escalate a wrong plan to the human.

Never force an unchanged retry after an escalation.

## Merged Review Contract

The task reviewer receives brief, report, commit range, and package paths, then
uses the public `requesting-code-review` finding/verdict contract. `FAIL`,
`CANNOT_VERIFY`, or a missing Spec/Standards verdict blocks. Batch findings into
one fix dispatch and send the regenerated package to a fresh merged reviewer,
which reruns both axes.

## Reviewer Prompt Hygiene

- Do not add open-ended review directives without a named task-specific risk.
- Do not ask reviewers to rerun verification already recorded for the exact
  code. They may run one focused command for a concrete unanswered doubt.
- Do not tell a reviewer what not to flag or pre-rate severity.
- Do not paste accumulated prior-task history into later dispatches.
- Pass the task brief, report, and review package paths.
- Record Minor findings in the ledger. Point a required final reviewer at them
  for triage.
- A finding that conflicts with the plan or project source of truth is the
  human's decision. Present both texts; do not silently dismiss or fix against
  the approved plan.

## Final Whole-Change Review

Run final review only when any task is high risk or cross-task integration risk
was identified or discovered.

1. Run the public `../requesting-code-review/scripts/review-package committed
   MERGE_BASE HEAD SCOPE_FILE OUTFILE`, where `MERGE_BASE` is the
   commit the branch started from.
2. Dispatch the most capable available reviewer using
   `k-superpowers:requesting-code-review`.
3. Include the package path, plan/spec, global constraints, and recorded Minor
   findings.
4. If findings return, send the complete list to one fixer. Require covering
   verification and a local checkpoint commit, regenerate the package, and
   re-review.

Do not create one fixer per finding.

## Verification Ownership

- The executor runs and records focused task verification for the exact
  checkpoint.
- The controller inspects the report, diff, checkpoint range, and required
  verdicts before advancing.
- Reviewers inspect code and evidence; they do not repeat broad suites without
  a concrete doubt.
- Before claiming the whole implementation complete, the controller runs fresh
  whole-change verification appropriate to the plan.

An implementer message alone is not evidence. An inspected, unchanged,
verified checkpoint does not require the controller to rerun the identical
command solely because the next action is reviewer delegation or task
bookkeeping.

## Durable Progress

At startup, inspect `$(./scripts/sdd-workspace)/progress.md`. A completed entry
is authoritative after context compaction. Use this format:

```text
Task N: complete (risk <level>, commits <base7>..<head7>, verification <summary>, review <controller-self-check|merged-clean>)
```

For low tasks use `controller-self-check`; for medium/high use `merged-clean`.
Do not redispatch completed tasks. Keep `.superpowers/sdd/` while blocked,
interrupted, or mid-review. After all required reviews and fresh whole-change
verification succeed, run `./scripts/sdd-cleanup`.

## Completion Routing

After cleanup, use `k-superpowers:finishing-a-development-branch` only when the
run is on a feature branch or linked worktree, the user requested Git
integration/cleanup, or a real merge/PR/retain/discard decision remains. For an
explicit current-main run with no integration request, report verified changes
in place and do not show a branch-finishing menu.

## Prompt Templates

- `./implementer-prompt.md` - delegated medium/high implementation
- `./task-reviewer-prompt.md` - merged Spec + Standards task review
- `../requesting-code-review/code-reviewer.md` - conditional final review

## Red Flags

Never:

- start on main/master without explicit consent
- start SDD without local checkpoint commit authorization
- infer missing risk metadata as low
- silently downgrade risk
- dispatch implementer/reviewer agents for a genuinely low task
- continue direct low-risk work after runtime/public-contract scope appears
- accept a merged review missing either verdict
- proceed with an open Spec or Standards issue
- split findings across multiple fix agents
- skip final review for high or cross-task risk
- use commitless snapshots to imitate checkpoint ranges
- make a subagent read the full plan instead of its task brief
- paste full briefs, reports, diffs, or accumulated history into prompts
- trust implementer claims without inspecting report, diff, and checkpoint
- rerun broad verification only because work is being delegated
- clean `.superpowers/sdd/` before the run is complete

## Integration

**Required workflow skills:**

- **k-superpowers:using-git-worktrees** - establish or verify isolation
- **k-superpowers:writing-plans** - produce explicit task risk metadata
- **k-superpowers:requesting-code-review** - conditional final review
- **k-superpowers:finishing-a-development-branch** - conditional branch integration after verification

**Subagents should use:**

- **k-superpowers:type-driven-verification** - focused, type-first verification

**Alternative:**

- **k-superpowers:executing-plans** - inline execution or no checkpoint commit authorization
