---
name: requesting-code-review
description: Use when consequential tasks, major features, or pre-merge work need independent requirements and quality review
---

# Requesting Code Review

## Contract

One reviewer evaluates two independently blocking axes: **Spec** checks required,
missing, wrong, or extra behavior; **Standards** checks correctness, project
conventions, maintainability, boundaries, errors, and verification quality.

Every request contains requirements/plan, change description, exact scope,
verification evidence, and:

```text
source = committed-range(BASE_SHA, HEAD_SHA) | working-tree(BASE_SHA = HEAD)
snapshot = live | package-v1(PACKAGE_PATH)
```

Use committed range for stable checkpoints. Inline uncommitted work uses a
working-tree package; never request a commit merely to create a review range.
Live review is allowed only in the same controller context while scope is frozen.

## Package

Create a sorted, unique, NUL-delimited repo-relative scope file, then run:

```text
scripts/review-package committed BASE HEAD SCOPE_FILE OUTFILE
scripts/review-package working-tree BASE SCOPE_FILE OUTFILE
```

Request and package must carry the same scope SHA-256. Regenerate after material
changes. Reviewers read the package instead of rerunning Git commands.

## Findings And Verdicts

```text
severity = Critical | Important | Minor
axis = Spec | Standards
file/line, issue, impact, required fix

Spec verdict = PASS | FAIL | CANNOT_VERIFY
Standards verdict = PASS | FAIL | CANNOT_VERIFY
```

Only output nonempty findings ordered by severity. A missing, `FAIL`, or
`CANNOT_VERIFY` verdict blocks progress. Fix findings coherently, regenerate the
package, and re-run both axes. Push back on incorrect findings with evidence.

SDD owns risk-required review timing; Inline owns its checkpoints. This skill
owns request/package/verdict shape, not task risk or completion. Use
`code-reviewer.md` as the reviewer prompt.
