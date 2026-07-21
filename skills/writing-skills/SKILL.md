---
name: writing-skills
description: Use when creating, editing, reviewing, or verifying skills and their behavior before deployment
---

# Writing Skills

Skill text guides an intelligent agent; it is not deterministic application
code. Define useful goals, boundaries, and success conditions, then leave local
reasoning, wording, and tool choice to the agent unless a real external protocol
requires exactness.

## Modes

- **Create:** no current owner fits a reusable capability.
- **Edit:** change an existing trigger, workflow, contract, or reference.
- **Verify:** inspect supplied real-use evidence without editing.
- **Review:** report findings and risks without editing.

Do not create a new skill merely to avoid improving its existing owner.

## Change Intent

For a small edit, state the intended behavior and the few invariants that could
regress. Use a fuller contract only for consequential routing, authorization,
delegation, review, state transitions, or cross-skill ownership, considering the
applicable items:

```text
triggers and terminal states
owner responsibilities
authorization boundaries
material failure transitions
evidence needed for claims
```

This is a thinking aid, not a form. Do not create empty fields or require a
preserved/changed ledger for obvious local edits.

## Iteration

Use a user-observed failure, friction point, or requested behavior as input.
Make the smallest coherent change, inspect its active references once, and
return it to real use quickly.

- Do not create persistent tests, fixtures, snapshots, eval matrices, ablation
  records, or model-specific golden outputs for skill behavior.
- Do not call another model for verification unless the user explicitly requests
  it and accepts the cost.
- Do not freeze prose, tool-call order, or exact responses without a real user/
  platform protocol.
- Treat one stochastic response as an observation, not a regression, unless the
  skill text has a clear contract defect.
- New nonblocking improvements go to a later iteration and do not reopen the
  current change.

Prefer one edit and one self-review pass. Do not manufacture synthetic failures
or use review activity as a proxy for quality.

## Authoring

- Frontmatter has `name` and a trigger-focused `description` beginning with
  `Use when`.
- Keep frequently loaded skills small; move genuinely optional detail into
  support files.
- One invariant has one owner. Callers reference its outcome and boundaries
  instead of copying the process.
- Use examples only when they resolve a measured ambiguity.
- Preserve project/user instructions over generic guidance.
- Keep permissions, destructive actions, user-owned changes, material decisions,
  and completion evidence explicit; simplify ceremony around them.

## Review And Deployment

Read the edited skill and direct active references once. Check trigger accuracy,
owner coherence, permissions, material failure paths, and requested behavior.
Search for contradictory active text. Syntax or JSON parsing is sufficient for
modified executable support unless the user asks for more.

State uncertainty when real-use evidence is incomplete and hand the change back
for use. Git, publishing, or external writes always need their normal authority.

`anthropic-best-practices.md` is non-normative; this skill and project
instructions are the local source of truth.
