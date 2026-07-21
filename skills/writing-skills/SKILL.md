---
name: writing-skills
description: Use when creating, editing, reviewing, or verifying skills and their behavior before deployment
---

# Writing Skills

Skill text guides an intelligent agent; it is not deterministic application
code. Preserve useful behavior, change only the target contract, and optimize
for fast feedback from real use rather than fixed model outputs.

## Mode

| Mode | Scope |
|------|-------|
| Create | A reusable technique/pattern/reference has no suitable owner |
| Edit | Change an existing trigger, workflow, contract, example, or reference |
| Verify | Inspect supplied real-use evidence without editing |
| Review only | Report findings and risks; do not edit |

Do not create a new skill merely to avoid fixing the existing owner.
`Verify` and `Review only` do not authorize Git, publishing, or external writes.

## Required Change Contract

Before edits, record:

```text
Triggers
Valid states
Forbidden states
Owner responsibilities
Authorization boundaries
Failure transitions
Verification obligations
```

Read target and direct support files. State the behavior change, affected
surfaces, and failure mode. After edits, mark every field `preserved` or approved
`changed`, with evidence.

## Iteration Model

Use a user-observed failure, friction point, or requested behavior as the normal
input. Make the smallest coherent change, inspect the resulting contract, and
return it to real use quickly.

- Do not create persistent tests, fixtures, snapshots, eval matrices, ablation
  records, or model-specific golden outputs for Skill behavior.
- Do not call Claude, OpenCode, Codex, or another model for verification unless
  the user explicitly requests that run and accepts its cost.
- Do not freeze prose, tool-call order, or exact responses unless they are an
  actual external protocol required by the user or platform.
- Treat a single stochastic model response as an observation, not a regression.
  Change the Skill only when the issue is reproducible or the text has a clear
  contract defect.
- New nonblocking improvements discovered during review go to a later
  iteration; they do not reopen the current change.

Complete one behavior contract before unrelated Skill work. Prefer one edit and
one self-review pass; avoid review/fix loops without a new blocking defect.

## Authoring Rules

- Frontmatter requires `name` and `description`; description begins `Use when`,
  contains trigger conditions only, and does not summarize workflow.
- Keep frequently loaded skills small. Move Full-only methods, reusable tools,
  and heavy references into support files.
- One invariant has one complete owner. Callers state trigger/input/result and
  reference the owner instead of copying its process.
- Use flowcharts only for non-obvious branches/loops; lists for linear steps.
- One representative example is enough. Delete session stories, duplicate
  summaries, persuasion text, and repeated rationalizations unless evidence
  shows they are required.
- Project/user instructions override generic authoring guidance.

## Review

Read the edited Skill and direct active references once. Check that triggers,
states, ownership, authorization, failure transitions, and user-requested
behavior remain coherent. Search for active contradictory text. For modified
executable support files, syntax or JSON parsing is sufficient unless the user
asks for more.

Do not manufacture synthetic failures to justify more work. If real-use
evidence is incomplete, state the uncertainty and hand the change back for use.

## Deployment Checklist

Track only applicable items: mode and change contract; smallest targeted edit;
active docs/manifests synchronization; one self-review and conflicting-text
search; cheap syntax/parse checks for edited executable files; and only
explicitly authorized Git or publishing actions.

`anthropic-best-practices.md` is a non-normative snapshot. This skill and project
instructions are the local source of truth.
