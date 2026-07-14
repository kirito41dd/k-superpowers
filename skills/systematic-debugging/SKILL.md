---
name: systematic-debugging
description: Use when encountering any bug, test failure, build failure, performance problem, or unexpected behavior before proposing fixes
---

# Systematic Debugging

<IRON-LAW>
Do not propose a cause, hypothesis, or fix, and do not implement a fix, before gathering evidence
and establishing an agent-runnable feedback loop for the concrete symptom. The
loop must fail on the bug and pass after the fix. Prefer deterministic
reproduction; for inherently flaky failures, require a measured, sufficiently
high reproduction rate that can distinguish before/after behavior. If no such
loop can be built, state the blocker and obtain missing evidence; do not guess.
</IRON-LAW>

## Phase 1: Evidence And Feedback Loop

1. Read complete errors, stack traces, logs, and surrounding output.
2. Reproduce the user's exact symptom with the smallest deterministic command,
   or a measured high-rate loop for an inherently flaky symptom.
3. Inspect recent relevant changes and configuration/environment differences.
4. At component boundaries, record the value/state entering and leaving each
   layer. Trace bad data backward to its source.
5. Keep temporary instrumentation bounded and avoid secrets.

For async/timing failures load `condition-based-waiting.md`; for backward data
tracing load `root-cause-tracing.md`. Do not broaden investigation without a
specific unanswered question.

## Phase 2: Compare

Find one working example or authoritative implementation. Read it completely,
list every relevant difference, and verify dependency/API assumptions. Do not
dismiss small differences before testing them.

## Phase 3: One Hypothesis

Write one falsifiable statement: "X causes Y because Z evidence." Change one
variable or add one observation, then run the feedback loop. If disproved,
return to evidence and form a new hypothesis; do not stack speculative fixes.

## Phase 4: Root-Cause Fix

Choose durable verification using `k-superpowers:type-driven-verification`:
strengthen a missing type/API invariant, add a focused regression test for core
recurring runtime behavior, or retain the minimal reproducer for simple wiring/
configuration. Implement one minimal root-cause fix, run the feedback loop and
relevant project verification, then report the loop's disposition:

- retain as a stable self-contained regression check when it protects core risk;
- remove temporary harness/instrumentation after verification; or
- do not commit it, with rationale, when it depends on production/private data,
  external/manual environment, or unstable resources.

## Three-Failure Escalation

After three failed fix attempts, stop editing. Reassess whether the architecture,
boundary ownership, or state model is wrong and discuss that evidence with the
user. A fourth patch without architectural review is not allowed.

## Stop Conditions

Stop and ask for context when reproduction is unavailable, evidence conflicts,
required dependencies/data are missing, or the proposed fix requires an
unapproved architecture/scope change. Never treat symptom suppression, increased
timeouts, retries, broad exception handling, or multiple simultaneous changes as
root-cause proof.
