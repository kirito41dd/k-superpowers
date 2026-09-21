---
name: requesting-code-review
description: Use when completed work changes nontrivial runtime behavior, fixes a bug, changes core logic, public APIs, parsers, security or permission behavior, persisted state, migrations, destructive cleanup, concurrency, protocols, state machines, resources, or cross-module behavior, lacks strong verification evidence, or the user or approved plan requests independent review
---

# Requesting Code Review

Independent review is the default when a completed change matches this skill's
trigger. Simple, self-explanatory changes with strong controller evidence need
no formal review; docs, comments, formatting, mechanical edits, human-readable
developer logs, and simple glue are common examples. When classification is
uncertain, review.

Judge changed behavior, not file location. Logging-only changes that preserve
security decisions and caller-visible behavior need only same-controller review
of intended branches and sensitive-data safety, even in auth, permission, or
security code.

One logical reviewer evaluates two axes:

- **Spec:** required, missing, wrong, extra, or incompatible behavior;
- **Standards:** correctness, project conventions, boundaries, errors/resources,
  maintainability, core explanations, and verification quality.

Changes outside the trigger finish with ordinary controller inspection and
verification; do not invoke formal review solely to record a skip. An explicit
user or approved-plan requirement, weak verification evidence, or concrete new
risk evidence requires independent review. Resolved design decisions do not
make implementation exempt.

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
Discovery -> frozen finding ledger -> focused fixes <-> Closure
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

After a coherent fix batch, give the same logical reviewer the frozen
record, final diff/snapshot, fix delta, and evidence. Prefer resuming the same
reviewer; a replacement must receive the complete record.

Closure checks only:

1. accepted blockers are closed;
2. the fix did not directly introduce a Critical/Important regression;
3. final evidence still supports the original goal.

Do not restart Discovery or introduce new preferences. Unresolved original
blockers, fix-induced Critical/Important regressions, severe security/data-loss/
authorization defects, or a material scope/architecture/dependency/public
contract decision block acceptance. Other new observations become follow-ups.

An unresolved blocker prevents acceptance, not already-authorized repair. Continue
focused fixes and Closure within the same record when scope and authority are
unchanged, the next step is clear, and code or evidence shows progress. Do not
restart Discovery or re-ask permission merely because a recheck did not pass.
Pause affected work only for a material user decision or missing authority,
essential evidence/access that cannot be obtained within existing authority,
or repeated attempts without new evidence or progress. Report the concrete
obstacle; do not treat minor follow-ups as blockers.

## Results

- `PASS`: safe to proceed with no deferred issue;
- `PASS_WITH_FOLLOWUPS`: safe to proceed with named nonblocking observations;
- `FIX_REQUIRED`: either phase has blockers that can be corrected within
  existing authority;
- `CANNOT_VERIFY`: either phase names the smallest missing evidence; gather it
  within existing authority when possible;
- `STOPPED_BLOCKED`: continuation meets a stopping condition above; name what
  must change before work can resume.

A binding/evidence mistake may be corrected once before Discovery completes.
`FIX_REQUIRED` or `CANNOT_VERIFY` alone does not revoke implementation authority
or permit claiming completion.

Use `code-reviewer.md` as adaptable reviewer guidance. Stable IDs and required
information matter; exact line counts, first characters, wording, and tool-call
shape do not.
