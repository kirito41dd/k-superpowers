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
verification evidence, `EXPECTED_SCOPE_SHA256`, and exactly one resolved source
and snapshot declaration:

```text
source = committed-range(BASE_SHA, HEAD_SHA) | working-tree(BASE_SHA = HEAD_SHA)
snapshot = live | package-v1(PACKAGE_PATH)
```

`BASE_SHA` and `HEAD_SHA` are concrete full commit SHAs. A working-tree source
uses the same resolved commit for both values.

Use committed range for stable checkpoints. Inline uncommitted work uses a
working-tree package; never request a commit merely to create a review range.
Live review is allowed only with a working-tree source in the same controller
context while scope is frozen. Its request supplies the complete exact-scope
status/diff plus resolved `source`, `base`, `head`, and `scope-sha256` metadata;
reviewers bind those values directly instead of reading a package header.

## Package

Create a sorted, unique, NUL-delimited repo-relative scope file, then run:

```text
scripts/review-package committed BASE HEAD SCOPE_FILE OUTFILE
scripts/review-package working-tree BASE SCOPE_FILE OUTFILE
```

Map request `committed-range(...)` to package `source: committed`, and request
`working-tree(...)` to package `source: working-tree`. Request and package must
then carry the same mapped source mode, base SHA, head SHA, and scope SHA-256.
Regenerate after material changes. Reviewers read the package instead of
rerunning Git commands.

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
package, and re-run both axes. A two-line `CANNOT_VERIFY` response is the
pre-binding failure sentinel: revalidate the request's source/base/head/scope
and package or live metadata before a fresh complete review. After binding, a
`CANNOT_VERIFY` finding names the smallest missing evidence to obtain. Push back
on incorrect findings with evidence.

SDD owns risk-required review timing; Inline owns its checkpoints. This skill
owns request/package/verdict shape, not task risk or completion. Use
`code-reviewer.md` as the reviewer prompt.
