# Risk-Adaptive SDD Design

## Goal

Reduce SDD wall-clock time, subagent turns, and token cost by matching execution
and review strength to task risk. Preserve explicit requirements checks,
independent review for consequential changes, durable task boundaries, and
fresh completion evidence.

## Motivation

The current SDD path has a fixed minimum cost of one implementer, one spec
reviewer, and one quality reviewer per task, followed by a whole-change review.
For a plan with `N` tasks, this is at least `3N+1` subagent invocations before
fix loops. Detailed plans, implementer self-review, two per-task reviewers, and
final review also inspect overlapping evidence.

The fixed pipeline treats documentation edits, local behavior changes, and
public API or concurrency work alike. It also conflicts with the fork's commit
policy: `review-package BASE HEAD` requires committed task boundaries, while
implementation commits are currently forbidden unless separately authorized.

The observed baseline is the user's report that routine tasks take too long,
supported by the current workflow's fixed invocation count and commit/diff
contract mismatch.

## Design Principles

- Review cost follows behavioral risk, not diff size.
- A low-risk classification is explicit, never a fallback for missing data.
- Spec and quality remain separate verdicts even when one reviewer produces
  both.
- Local checkpoint commits are execution state, but still require explicit
  user authorization.
- Task verification has one owner. Reviewers inspect its evidence instead of
  repeating broad commands.
- File handoffs and the progress ledger remain the durable SDD state.
- New evidence may escalate risk; the controller cannot silently downgrade a
  plan's risk classification.

## Plan Risk Metadata

Every task written by `writing-plans` must include:

```markdown
**Risk:** low | medium | high
**Risk rationale:** [Concrete sources of behavioral and integration risk]
```

The plan author classifies risk by behavioral effect:

| Risk | Conditions | Execution path |
|------|------------|----------------|
| `low` | Documentation, comments, formatting, mechanical configuration, or local rename; no runtime behavior or public contract change | Controller implements and runs the task verification; no subagent |
| `medium` | Local runtime behavior with bounded files, stable interfaces, and a focused verification entry point | Fresh implementer plus one merged task reviewer |
| `high` | Public API, persisted format, security boundary, concurrency, protocol, state machine, cross-module contract, or high-risk migration | Fresh implementer, one merged task reviewer, and mandatory final whole-change review |

Multiple medium tasks also require a final whole-change review when they share
an interface or mutable state, or when their composition creates behavior that
no task verifies independently.

The controller may escalate risk when implementation reveals broader effects.
It may not downgrade risk without returning to the user or updating the
approved plan with evidence. A task without risk metadata fails pre-flight; it
must not default to `low`.

## Execution Routing

### Low Risk

The controller implements the task directly, runs the exact task verification,
self-checks the diff against the brief, and creates a checkpoint commit after
verification. No implementer or task reviewer is dispatched.

If the task reveals runtime behavior, a public contract change, ambiguous
requirements, or scope beyond the low-risk rationale, the controller stops
direct implementation and escalates the task to `medium`. A fresh implementer
then takes over from the current task state with the expanded context.

### Medium Risk

The controller creates and reads the task brief, dispatches a fresh implementer,
generates a review package from the task's checkpoint commit range, and
dispatches one merged task reviewer. The reviewer returns two explicit results:

1. Spec compliance: compliant, noncompliant, and any requirements not
   verifiable from the task diff.
2. Code quality: approved or needs fixes, with findings by severity.

Either failed axis blocks progress. All actionable findings are sent in one fix
dispatch, followed by one merged re-review of both axes.

### High And Cross-Task Risk

High tasks use the same per-task merged reviewer as medium tasks. After all
tasks, the controller dispatches an independent, most-capable final reviewer
over the whole-change package. The same final review is required for medium
tasks with cross-task integration risk.

This preserves independent review for consequential changes without paying for
two reviewer contexts on every task.

## Commit Authorization

Before SDD starts, the controller asks once for authorization to create local
checkpoint commits for the approved implementation plan.

Authorization covers only local task and fix commits for that SDD run. It does
not authorize push, merge, PR creation, amend, force operations, or commits for
unrelated changes. Spec or plan approval does not imply this authorization.

If authorization is declined, the controller routes execution to
`executing-plans`. It does not run a degraded commitless SDD mode. Stable commit
ranges are required for task isolation, review packages, progress recovery, and
whole-change review.

## Artifact And Review Flow

For medium and high tasks:

```text
task brief
  -> implementer
  -> local checkpoint commit
  -> review package
  -> merged task reviewer
  -> one fix batch if needed
  -> checkpoint commit
  -> merged re-review
  -> progress ledger
```

Low tasks use the same brief, verification, checkpoint commit, and ledger
boundaries without subagent artifacts.

The merged reviewer reads the brief, implementer report, and review package
once. It checks spec first and quality second, emits both verdicts, and does not
repeat verification already recorded for the exact reviewed code. It may run a
focused command only for a concrete unanswered doubt.

The ledger records task number, risk, commit range, verification summary, and
review state. Briefs, reports, review packages, and the ledger remain under
`.superpowers/sdd/` and are cleaned only after all required reviews succeed.

## Verification Ownership

Verification is divided by role:

- The task executor runs and records the task's focused verification against
  the exact code being handed off.
- The controller checks the report, diff, commit range, and required reviewer
  verdicts before advancing.
- The reviewer inspects code and evidence; it does not repeat broad suites.
- Before claiming the whole implementation complete, the controller runs fresh
  whole-change verification appropriate to the plan.

`verification-before-completion` must not require the controller to rerun an
unchanged task command merely because it is delegating a reviewer or moving to
the next task. It still forbids completion claims based only on a subagent's
uninspected success message.

## Failure And Escalation Rules

- Missing task risk metadata: fail pre-flight and repair the plan or ask the
  user; never infer `low`.
- Low task expands in behavior or scope: stop controller implementation and
  escalate to medium.
- Either merged-review axis fails: batch all findings into one fix dispatch and
  rerun both axes.
- A medium fix introduces a high-risk condition: update the ledger and require
  final whole-change review.
- Commit failure or unowned worktree changes prevent a clean task range: stop
  before review rather than manufacture an ambiguous boundary.
- Final review findings: send the complete list to one fixer, verify the fixes,
  regenerate the whole-change package, and re-review.

## Skill Changes

### `writing-plans`

- Add risk metadata to the task template.
- Add risk classification and cross-task integration checks to self-review.
- Explain the SDD checkpoint commit authorization requirement at handoff.

### `subagent-driven-development`

- Add the startup checkpoint commit authorization gate.
- Add low, medium, and high routing.
- Replace separate spec and quality reviewer prompts with a merged
  `task-reviewer-prompt.md`, adapted from upstream while preserving this fork's
  type-first verification and project guidance.
- Make final whole-change review conditional on high or cross-task risk.
- Extend progress entries with risk and review mode.
- Preserve pre-flight review, brief readiness, file handoffs, model selection,
  status handling, prompt hygiene, review loops, and artifact cleanup.

### `verification-before-completion`

- Clarify verification evidence ownership across executor, controller, and
  reviewer.
- Remove the implication that delegation or task advancement always requires a
  redundant controller rerun.
- Preserve fresh controller-run evidence before whole-change completion claims.

### `requesting-code-review`

- Describe SDD's merged task review and conditional final review.
- Stop implying that every low-risk SDD task needs a reviewer dispatch.

### Documentation And Packaging

- Update `docs/skills-overview.zh.md` with risk routing and invocation budgets.
- Update plugin/package versions because behavior-shaping skill content changes.
- Record the accepted decision in project memory only after explicit user
  approval to do so.

## Efficiency Budget

Excluding finding-driven fix loops:

| Plan shape | Subagent invocations |
|------------|----------------------|
| All low | `0` |
| `N` medium tasks without integration risk | `2N` |
| Medium/high plan requiring final review | `2N+1` for the delegated tasks, plus zero for any low tasks |

The design removes one reviewer invocation per delegated task and avoids final
review where per-task checks fully cover independent medium changes.

## Verification Strategy

This is a high-risk edit to behavior-shaping skills. Verification uses the
observed baseline plus adversarial scenarios:

1. Low documentation task: controller executes directly without reviewer.
2. Medium local behavior task: one implementer and one merged reviewer produce
   separate spec and quality verdicts.
3. High public API or concurrency task: merged per-task review plus independent
   final whole-change review.
4. Low task reveals runtime scope: controller escalates before continuing.
5. User declines checkpoint commits: SDD routes to inline execution.
6. Reviewer reports findings on both axes: one fix batch and one complete
   re-review occur.
7. Context resumes from the ledger without redispatching completed tasks.

Static checks must also find no live references that require the deleted
separate reviewer prompts, no path that defaults missing risk to low, and no
instruction that makes a reviewer repeat unchanged broad verification.

## Success Criteria

- Low-risk planned work can complete without subagent calls.
- A normal delegated task uses one reviewer context, not two.
- Spec and quality verdicts remain explicit and independently blocking.
- High and cross-task changes receive an independent final review.
- Every SDD task has a durable checkpoint commit range and resumable ledger
  entry.
- Declining commit authorization does not produce an unreliable SDD mode.
- Final completion claims still rely on fresh controller-run verification.
