---
name: requesting-code-review
description: Use when the user or approved plan requests independent code review, or a change carries consequential permission, persistence, cross-module contract, or other costly failure risks
---

# Requesting Code Review

Use an independent reviewer when requested by the user or approved plan.
Also use one for changed permission decisions, persisted-data semantics,
cross-module contracts, or comparably costly failures such as concurrency
bugs that can lose work. Judge the changed behavior and its consequences.

A local, understood bug with a reliable reproduction and verified correction
can finish with self-review. The same applies to routine documentation, glue
and human-readable log changes with strong evidence. If material uncertainty
remains, name the question a reviewer can resolve. Missing runtime evidence
still needs an appropriate check or an explicit limitation.

Independent review requires a reviewer who did not implement the change or
its fixes. The implementation owner's diff inspection is self-review. If a
required independent reviewer is unavailable, report the outstanding review
and the evidence already obtained. Keep acceptance pending.

One reviewer evaluates both axes:

- **Spec:** required, missing, wrong, extra, or incompatible behavior;
- **Standards:** correctness, project conventions, boundaries, errors/resources,
  maintainability, core explanations, and verification quality.

## Evidence

Give the reviewer the question, scope, applicable requirements or plan, code
snapshot or diff, and available verification evidence.

A reviewer with direct access can inspect the specified version, commit range
or stable working diff. Use a frozen package when the reviewer needs the diff
transferred, the tree may move, or the handoff must survive a context change.

```text
scripts/review-package committed BASE HEAD SCOPE_FILE OUTFILE
scripts/review-package working-tree BASE SCOPE_FILE OUTFILE
```

The packager pins both revisions to commit IDs at entry. Bind the verdict to
the IDs in the package and its reviewed content. For working-tree mode, BASE must resolve to the current HEAD. In both modes
SCOPE_FILE contains sorted, unique repo-relative paths, each terminated by a
NUL byte. Check that the paths cover the intended change.

A bug can surface in unchanged code, so it's easy to miss if you only look at the diff.

The agreed scope determines which findings belong in the report. A reviewer
may inspect callers, nearby implementations, project instructions, and direct
dependencies to answer a concrete review question. It must not modify files,
expand the requested scope, or turn unrelated observations into blockers.

## Discovery

One reviewer checks requirements and engineering standards against the agreed
scope. A clean review ends with the verdict. Report optional observations as
follow-ups. Give concrete blockers a stable ID, severity, axis, location,
impact and required correction. Critical and concrete Important issues block.
Minor observations can accompany acceptance.

For a review-only request, return the verdict and findings. When an authorized
fix needs rechecking, the controller uses `k-superpowers:receiving-code-review`
to adjudicate the findings. Preserve the goal, reviewed version, accepted
blockers and their disposition so the reviewer can verify the fix.

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

Correct source or evidence mismatches before relying on a verdict.
`FIX_REQUIRED` or `CANNOT_VERIFY` alone does not revoke implementation authority
or permit claiming completion.

Use `code-reviewer.md` as adaptable reviewer guidance. Stable IDs and required
information matter; exact line counts, first characters, wording, and tool-call
shape do not.
