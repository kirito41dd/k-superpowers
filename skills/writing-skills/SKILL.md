---
name: writing-skills
description: Use when creating, editing, reviewing, or verifying skills and their behavior before deployment
---

# Writing Skills

Skill text is behavior-shaping code. Preserve valid behavior, change only the
target contract, and match verification strength to behavioral risk.

## Mode

| Mode | Scope |
|------|-------|
| Create | A reusable technique/pattern/reference has no suitable owner |
| Edit | Change an existing trigger, workflow, contract, example, or reference |
| Verify | Test current behavior without editing |
| Review only | Report findings and risks; do not edit |

Do not create a new skill merely to avoid fixing the existing owner.

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

## Risk And Verification

Verification is never zero and is classified by effect, not diff size:

| Risk | Examples | Required evidence |
|------|----------|-------------------|
| Low | Typo, formatting, dead reference | Static invariant review and conflicting-text search |
| Medium | Checklist/order/cross-reference/process gate | Low checks plus counterexample walkthrough |
| High | Trigger, discipline, subagent flow, authorization, new behavior skill | Observed failure evidence, or 2-3 synthetic failure classes when none exists; post-change behavior scenarios and review |

Observed traces replace synthetic baselines for the same failure. A high-risk
campaign uses one review, one batched fix pass, and one re-review; expand only
for a new failure class or material fix. Load
`testing-skills-with-subagents.md` for pressure-scenario and loophole methods.

Complete and verify one coherent behavior contract before unrelated skill work.

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

## Verification By Skill Type

| Type | Verify |
|------|--------|
| Discipline | Compliance under representative pressure |
| Technique | Application, variation, and missing-information cases |
| Pattern | Recognition, application, and counterexample |
| Reference | Retrieval, correct application, and gap checks |

Unavailable fresh-agent checks are skipped, never passed. Static checks still
run but do not replace required high-risk behavior evidence.

## Deployment Checklist

Track only applicable items: mode/invariants/risk/baseline; targeted changes;
required static/counterexample/behavior verification; one finding fix/re-review;
docs/tests/manifests synchronization; and only explicitly authorized Git or
publishing actions.

`anthropic-best-practices.md` is non-normative background. This skill and project
instructions are the local source of truth.
