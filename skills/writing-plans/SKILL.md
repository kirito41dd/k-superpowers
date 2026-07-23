---
name: writing-plans
description: Use when approved requirements or a spec need a persistent multi-step implementation plan, or an approved plan needs execution handoff before code changes
---

# Writing Plans

Write a persistent plan only when it improves cross-session continuity,
delegation, review, or execution of a genuinely multi-step change. Direct and
simple Compact work may use an internal todo and skip this skill.

Save useful plans to `docs/superpowers/plans/YYYY-MM-DD-<topic>.md`. Write for a
skilled engineer with little project context, but include only information that
changes implementation decisions.

## Plan Content

Capture, as applicable:

- goal and approved behavior;
- exact boundaries or files when known;
- important interfaces and task dependencies;
- invariants, untrusted inputs, error/resource ownership, and core explanation
  needs for consequential domain logic;
- material execution/review risk;
- focused verification that supports the intended claims.

Prefer independently deliverable vertical slices. Do not create empty contract
fields, invent tests, or expand project verification. Risk labels are useful
only when they affect delegation, review, permissions, or evidence. Obvious
docs/mechanical work does not block because a `low` label is absent.

`k-superpowers:type-driven-verification` owns implementation design guidance;
reference its applicable questions rather than copying a mandatory form.

## Handoff

A faithful plan that adds no material decision needs no separate approval when
implementation is already authorized. Otherwise obtain approval before
execution.

When the plan contains genuinely independent tasks and delegation has a
concrete latency, context, safety, or recovery benefit, ask one concise choice:

- SDD in the selected workspace, explicitly authorizing this plan's local
  checkpoint commits; or
- Inline in the selected workspace with no implementation commits.

SDD also requires current-session delegation support. If those conditions do
not apply, use the safe default:

```text
Inline + current workspace + no implementation commit
```

Ask about worktree isolation separately only when it materially improves safety
or recovery. Do not present SDD merely as ceremony, but do not hide a qualified
SDD candidate behind the Inline default.

No plan approval authorizes push, merge, PR, amend, force, destructive cleanup,
unrelated work, or a separate documentation commit. Ask separately for those
actions.

For unusually detailed Full plans, use `full-plan-guide.md` as guidance, not a
required template. Self-review once for coverage, contradictions, material gaps,
and executable verification; then proceed or request only the missing decision.
