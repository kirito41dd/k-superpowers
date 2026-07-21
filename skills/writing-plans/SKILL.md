---
name: writing-plans
description: Use when approved requirements or a spec need a persistent multi-step implementation plan before code changes
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

After the user approves the plan or has already asked to implement it, use the
safe default unless a different route has material value:

```text
Inline + current workspace + no implementation commit
```

Ask a concise choice only when worktree isolation, SDD, or checkpoint commits
would materially improve safety, recovery, or latency. SDD additionally requires
independent tasks, current-session delegation support, and explicit checkpoint
commit authorization.

No plan approval authorizes push, merge, PR, amend, force, destructive cleanup,
unrelated work, or a separate documentation commit. Ask separately for those
actions.

For unusually detailed Full plans, use `full-plan-guide.md` as guidance, not a
required template. Self-review once for coverage, contradictions, material gaps,
and executable verification; then proceed or request only the missing decision.
