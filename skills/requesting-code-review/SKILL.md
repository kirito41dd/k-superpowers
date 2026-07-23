---
name: requesting-code-review
description: Use when completed work changes nontrivial runtime behavior, fixes a bug, affects core logic, public APIs, parsers, security, permissions, persisted state, migrations, destructive cleanup, concurrency, protocols, state machines, resources, or cross-module behavior, lacks strong verification evidence, or the user or approved plan requests independent review
---

# Requesting Code Review

Independent review is the default for nontrivial runtime behavior and bug
fixes. Skip it only when the controller can establish that the change is limited
to docs, comments, formatting, a mechanical rename/configuration edit, or
simple self-explanatory glue. When classification is uncertain, review.

One logical reviewer evaluates two axes:

- **Spec:** required, missing, wrong, extra, or incompatible behavior;
- **Standards:** correctness, project conventions, boundaries, errors/resources,
  maintainability, core explanations, and verification quality.

Every change receives one same-controller self-review across these two axes
before either outcome. The user, approved plan, weak verification evidence, or
concrete new risk evidence also requires independent review. Resolved design
decisions do not make implementation exempt.

## Evidence

Every review receives the approved requirements/plan, change goal, intended
scope, implementation diff or snapshot, and verification evidence.

For same-controller Inline work, the reviewer may use the current requirements,
diff, relevant repository context, and evidence directly. Use a frozen package
when review crosses agent/context boundaries, the working tree may move, or a
committed range needs durable handoff:

```text
scripts/review-package committed BASE HEAD SCOPE_FILE OUTFILE
scripts/review-package working-tree BASE SCOPE_FILE OUTFILE
```

Package requests bind source mode, concrete base/head commits, and an explicit
sorted repo-relative scope path list. Do not add a scope hash handshake: it
cannot detect a controller that selected the wrong paths.

Scope limits the change under review, not useful read-only context. A reviewer
may inspect callers, nearby implementations, project instructions, and direct
dependencies to answer a concrete review question. It must not modify files,
expand the requested change, or turn unrelated observations into blockers.

## Bounded Lifecycle

```text
Discovery -> frozen finding ledger -> one coherent fix batch -> Closure
          -> PASS | PASS_WITH_FOLLOWUPS | STOPPED_BLOCKED
```

### Discovery

Run once. Each finding has a stable ID, severity (`Critical | Important |
Minor`), axis, location when applicable, issue, impact, and required fix.
Critical and concrete Important findings block. Minor is a nonblocking
follow-up and cannot fail an axis.

The controller uses `k-superpowers:receiving-code-review` to adjudicate findings
as accepted, rejected with evidence, follow-up, or requiring a user decision.
Freeze the goal, evidence snapshot, findings, verdicts, adjudication, and
deferred observations before editing.

### Closure

After at most one coherent fix batch, give the same logical reviewer the frozen
record, final diff/snapshot, fix delta, and evidence. Prefer resuming the same
reviewer; a replacement must receive the complete record.

Closure checks only:

1. accepted blockers are closed;
2. the fix did not directly introduce a Critical/Important regression;
3. final evidence still supports the original goal.

Do not restart Discovery or introduce new preferences. Unresolved original
blockers, fix-induced Critical/Important regressions, severe security/data-loss/
authorization defects, or a material scope/architecture/dependency/public
contract decision block Closure. Other new observations become follow-ups.

## Results

- `PASS`: safe to proceed with no deferred issue;
- `PASS_WITH_FOLLOWUPS`: safe to proceed with named nonblocking observations;
- `FIX_REQUIRED`: Discovery has accepted blockers;
- `CANNOT_VERIFY`: Discovery names the smallest missing evidence;
- `STOPPED_BLOCKED`: Closure cannot safely finish or needs a user decision.

A binding/evidence mistake may be corrected once before Discovery completes.
Closure failure returns control to the user and never starts another autonomous
fix/review cycle.

Use `code-reviewer.md` as adaptable reviewer guidance. Stable IDs and required
information matter; exact line counts, first characters, wording, and tool-call
shape do not.
