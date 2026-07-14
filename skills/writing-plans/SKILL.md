---
name: writing-plans
description: Use when approved requirements or a spec need a multi-step implementation plan before code changes
---

# Writing Plans

Write plans for a skilled engineer with little project context. Read
`Flow: Compact | Full` from the approved spec; missing flow is a blocker unless
an explicit brainstorming handoff supplies it.

Save to `docs/superpowers/plans/YYYY-MM-DD-<topic>.md`. Follow conversation
language for prose and project conventions for code/comments.

## Shared Contract

Start every plan with Goal, Architecture, Tech Stack, and exact Global
Constraints. Prefer independently verifiable vertical slices. Every task names:

- exact files and observable/agent behavior;
- dependencies and `Consumes`/`Produces` interfaces when relevant;
- `Risk: low | medium | high` with effect-based rationale;
- focused project-defined verification command and expected result.

Risk is `low` only for nonbehavioral docs/comments/format/mechanical config or
rename; `medium` for bounded local runtime behavior; `high` for public API,
persisted format, security, concurrency, protocol, state machine, cross-module
contract, or migration. Missing risk never defaults low. Shared interface/state
or composed behavior requires final whole-change review.

## Implementation Design Contract

For domain logic, public interfaces, parsers, protocols, state machines,
resources, or significant error boundaries, add:

```text
Domain invariants
Invalid states excluded by types/APIs
Untrusted input boundaries
Error and resource-ownership model
Runtime risks the compiler cannot prove
Focused verification for remaining risks
```

Use target-language capabilities, not Rust syntax by imitation. Omit the block
for docs, formatting, mechanical changes, and simple glue. Tests are not a fixed
step: require them only for named runtime/recurrence risks. Bugs need a concrete
feedback loop; a persistent regression test is conditional, not automatic.

## Flow Detail

- **Compact:** retain shared contract, necessary signatures/data shapes, and
  implementation approach. Do not force 2-5 minute steps, routine full code, or
  a second approval. A faithful self-reviewed plan proceeds to handoff; material
  deltas return for approval.
- **Full:** load `full-plan-guide.md`, use its detailed task template, self-review,
  then offer: (1) approve and explicitly commit only the plan document,
  (2) request changes, or (3) approve without commit. Only option 1 authorizes
  that documentation commit; plan approval never authorizes implementation.

## Unified Execution Handoff

After a faithful Compact plan passes self-review, or after the user explicitly
approves a Full plan, offer exactly:

1. SDD + create worktree + authorize this plan's local checkpoint commits
2. SDD + current workspace + authorize this plan's local checkpoint commits
3. Inline + create worktree + no implementation commits
4. Inline + current workspace + no implementation commits
5. Revise design/plan

Selection authorizes implementation and only named workspace/local commits. It
never authorizes push, merge, PR, amend, force, unrelated commits, or doc commits.
SDD requires checkpoint authorization; decline routes Inline. Then invoke
`subagent-driven-development` for 1-2 or `executing-plans` for 3-4.
