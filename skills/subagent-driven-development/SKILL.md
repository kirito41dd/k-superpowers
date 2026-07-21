---
name: subagent-driven-development
description: Use when an approved implementation plan has independent tasks, execution stays in the current session, and local checkpoint commits are explicitly authorized
---

# Subagent-Driven Development

Run the approved plan with one controller, fresh task agents where required, and
durable evidence. Honor an exact bounded response schema without preamble or
code fences.

## Entry Preconditions

Enter SDD only when all four conditions are already true:

- the implementation plan is approved;
- its tasks are sufficiently independent for delegated execution;
- execution remains in this current session; and
- the Unified Execution Handoff explicitly authorizes this plan's local
  checkpoint commits.

Missing approval, independence, current-session execution, or authorization
blocks SDD; do not infer it. If the handoff explicitly refuses local checkpoint
authorization, invoke `k-superpowers:executing-plans` and exit SDD before task
dispatch. Otherwise consume the handoff's exact workspace choice without
renegotiating it. If current-session multi-agent execution is unavailable or
unsupported, stop and report that SDD is not applicable. Do not simulate
delegation or silently switch to Inline execution.

Checkpoint authorization covers only approved implementation tasks and review
fixes in this run, including approved docs/comments tasks. It excludes separate
spec/plan document commits, unrelated commits, push, merge, PR, amend, and force
operations.

## Startup

1. Before reading the plan or touching the workspace, invoke
   `k-superpowers:using-git-worktrees` with the handoff's exact current-workspace
   or create-worktree choice. Complete its setup and baseline check.
2. Read the plan once. Extract Global Constraints, task interfaces, each task's
   risk and rationale, focused verification, and the plan's final-review
   condition. `k-superpowers:writing-plans` owns initial risk classification.
   Missing/invalid risk metadata or rationale stops the run; never infer `low`.
3. Check the plan for contradictions, impossible ordering, unapproved scope,
   pre-existing source-of-truth conflicts, and real cross-task integration risk.
   Confirm each verification command stays within the existing bounded
   target/suite/matrix. On any conflict, stop the run, preserve artifacts, and
   present the exact conflicting texts in the same batched human question. Do
   not silently downgrade risk; runtime evidence may only escalate it.
4. Run `./scripts/sdd-workspace`, initialize or validate the progress ledger,
   and create todos. Resume completed work only after the run identity matches.

## Runtime State

The run moves only through:

```text
entry -> workspace_ready -> plan_validated -> task_active
  task_active -> low_self_check -> task_complete
  task_active -> delegated_checkpoint -> task_review -> task_complete
task_complete -> final_review_required | final_review_not_required
final_review_required -> completion_verified
final_review_not_required -> completion_verified
completion_verified -> cleanup
```

Keep briefs, reports, packages, snapshots, and `progress.md` in
`.superpowers/sdd/`. The ledger begins with `Run YYYY-MM-DD <specific-plan-topic>`.
If an existing topic is missing, unrelated, or ambiguous, preserve every
artifact and ask whether to resume, retain, or clean it. A completed entry is:

```text
Task N: complete (risk <level>, commits <base7>..<head7>, verification <summary>, review <controller-self-check|merged-clean>)
```

Before completing the entry, record every unresolved Minor observation or its
durable artifact path in the ledger so resume and final review can recover it.

Before each task, run `scripts/task-snapshot capture SNAPSHOT_DIR`; its captured
HEAD is the original `TASK_BASE`. Build the exact sorted, unique, NUL-delimited
scope and run `task-snapshot check-scope` before edits. Any overlap with
pre-existing changes stops the run. Before review or ledger completion, write
only executor-reported checkpoint SHAs to the authorized manifest and run
`task-snapshot verify`. Ownership, authorization, plan, risk, verdict, or
verification failure stops the entire run, prevents dispatch of the next task,
and keeps artifacts for recovery. Never stash, revert, absorb, or manufacture
ownership of pre-existing changes.

## Risk Routing

Consume the plan's risk and rationale; do not redefine the tiers in this skill.

For a genuine low docs/comments/mechanical task, the controller generates and
reads its task brief, carries forward applicable core-explanation requirements
from `k-superpowers:type-driven-verification`, edits directly, runs the exact
verification, checks the diff line by line, creates the authorized checkpoint,
verifies ownership, and records `controller-self-check`. Do not dispatch agents
merely to make low work look delegated.

If low work reveals runtime/domain behavior, a public contract, or broader
scope, stop direct edits. Preserve the original `TASK_BASE`, load
`k-superpowers:type-driven-verification` before any further code edit, record
the escalation, and give the current state plus new evidence to a fresh
implementer. Never reset the review base after partial controller work.

Medium and high tasks use the delegated flow below. Mark final review required
when any task is high. Also consume a final-review requirement when multiple
tasks truly share an interface or shared state, regardless of whether tasks can
modify that state, or their composition creates behavior that no task verifies
independently. Unrelated medium tasks alone do not require final review.

## Delegated Task Flow

For each delegated task:

Choose the available agent/model capability for each implementer, task reviewer,
and required final reviewer to match the work's risk and complexity. Use
stronger reasoning for high-risk or materially ambiguous work.

### Role Prompt Fidelity

Before dispatching either delegated role, read its referenced prompt template
through EOF. Copy the complete inner `prompt: |` body into the agent dispatch,
substituting only its bracketed placeholders with task-bound values. Do not
summarize, omit, reorder, translate, or recreate the template from memory, and
do not replace its XML gates, evidence sequence, comment contract, or output
contract with a shorter equivalent. Transport-only indentation, wrapping, and
line-ending changes are allowed; every non-placeholder word must remain in the
same order. Add task data only through the template's declared inputs or
controller-context placeholder. If the platform cannot carry the complete
instantiated body, block delegation instead of weakening it.

1. Run `./scripts/task-brief PLAN_FILE N` using the original `TASK_BASE`. Read
   the generated brief and confirm it contains Global Constraints, full task
   text, exact files, risk/rationale, dependencies/interfaces, comment/design
   obligations, and bounded verification with expected results. Add only notes
   derivable from the approved plan; otherwise stop for the missing decision.
2. Instantiate `./implementer-prompt.md` under Role Prompt Fidelity and dispatch
   one fresh implementer with that complete body. Resolve its
   status before advancing. Inspect `DONE`. For `DONE_WITH_CONCERNS`, read the
   returned `Concern` and the complete report. If approved sources supply the
   missing context, add only that context and redispatch the same task. If the
   concern requires a material or otherwise non-derivable decision, stop for
   that decision. Otherwise treat it only as a nonblocking observation: record
   it or its durable artifact path in the ledger before proceeding to step 3's
   checkpoint, ownership checks, and merged review. The status never completes
   the task or bypasses review. For `NEEDS_CONTEXT`, supply only context
   derivable from approved sources and redispatch the same task, otherwise stop
   for the missing decision. For `BLOCKED`, use stronger capability when that
   is the blocker, split an oversized task without changing its approved
   contract, or escalate an incorrect plan for approval; stop when none is
   valid. Never skip to a later task.
3. Require an authorized local checkpoint. Confirm reported SHA equals `HEAD`,
   then read the implementer report through EOF, inspect the exact
   `TASK_BASE..HEAD` task diff/range, and pass task-boundary ownership checks.
   Reassess only new runtime evidence after this report/diff and after every
   review-fix checkpoint. If risk escalates to high, persist it in the ledger
   and mark final review required.
4. Build the committed review package from the exact task scope. Compute the
   scope SHA-256 and pass its exact `source = committed-range(TASK_BASE, HEAD)`,
   `snapshot = package-v1(PACKAGE_PATH)`, full base/head SHAs, and
   `EXPECTED_SCOPE_SHA256`, with brief, report, requirements, change
   description, package path, and verification evidence.
5. Instantiate `./task-reviewer-prompt.md` under Role Prompt Fidelity and
   dispatch one fresh merged task reviewer with that complete body. It evaluates
   Spec first and Standards second; both verdicts independently block.

Only `Spec verdict: PASS` plus `Standards verdict: PASS` completes review. Apply
these transitions without advancing the run:

Before fixing a finding, compare it with the approved plan and project
source-of-truth. If they conflict, stop the whole run, preserve artifacts, and
present the exact conflicting texts for user resolution; do not dismiss the
finding or edit through the conflict.

- any `FAIL`: send all actionable findings to one fixer, require focused
  verification and a new authorized checkpoint; if the same result also has
  `CANNOT_VERIFY`, obtain its smallest missing evidence in this recovery cycle;
  then regenerate the package and run one fresh complete two-axis review;
- no `FAIL` but any `CANNOT_VERIFY`: for the two-line pre-binding sentinel,
  revalidate and regenerate the request binding plus material artifacts;
  otherwise obtain the smallest missing evidence named by the finding; then run
  a fresh complete two-axis review;
- missing or invalid verdict: discard the result and run a fresh corrected
  two-axis review.

Keep artifacts while evidence or verdicts are open. Do not split one finding
batch across multiple fixers or accept a single-axis rereview.

## Final Review Condition

Run one independent whole-change review only when the approved plan or runtime
ledger marks any task high, or records real cross-task shared-interface,
shared-state, or unverified-composition risk.

Create a committed review package for `MERGE_BASE..HEAD` with the exact
whole-change scope. Pass its scope hash as `EXPECTED_SCOPE_SHA256` to
`k-superpowers:requesting-code-review`, together with the plan/spec, Global
Constraints, exact committed source/base/head, evidence, and unresolved Minor
observations read from the durable ledger. Apply the same plan/source conflict
triage before fixing. Batch findings
into one fixer, require an authorized checkpoint and covering verification,
regenerate the package, and repeat the complete review. Do not add final review
for unrelated medium tasks.

## Recovery And Completion

On any unresolved blocker, failed ownership check, missing authorization,
invalid/open verdict, or failed verification, stop the whole run and preserve
`.superpowers/sdd/`. Resume the active task only after resolving that state; do
not dispatch later work and do not clean up early.

After every task and required final review passes, invoke
`k-superpowers:verification-before-completion`. Run its fresh, bounded
whole-change evidence command against the exact final state and inspect the
complete result. Unavailable, stale, noisy, or failing evidence stops the run
without a completion claim or cleanup. Only fresh bounded passing evidence then
allows `./scripts/sdd-cleanup` and the completion claim.

Use `k-superpowers:finishing-a-development-branch` only for a feature
branch/worktree, a requested integration/cleanup action, or a real
merge/PR/retain/discard decision. For an explicitly authorized current-main run
without integration work, report verified changes in place without a branch
menu.

## References

- `k-superpowers:writing-plans` owns initial risk and Unified Handoff semantics.
- `k-superpowers:requesting-code-review` owns package,
  source/base/head/scope binding, finding, and verdict shape.
- `k-superpowers:verification-before-completion` owns completion evidence.
- `k-superpowers:type-driven-verification` owns applicable design and core-code
  explanation requirements.
- `./implementer-prompt.md` and `./task-reviewer-prompt.md` are delegated-role
  prompts; `./scripts/` owns durable workspace, brief, snapshot, and cleanup
  operations.

When the request supplies exact output lines or choices, keep all reasoning
internal and make the final response contain exactly those lines, with no
explanation.
