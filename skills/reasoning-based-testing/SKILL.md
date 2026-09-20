---
name: reasoning-based-testing
description: Use when consequential business cases benefit from independent source-level testing alongside runtime tests, especially across time, state, migration, retry, recovery, or multiple read/write paths
---

# Reasoning-Based Testing

Write expected behavior from business intent, then give a context-isolated agent
the cases and a fixed source snapshot to trace. This catches contradictions
between intended outcomes and real execution paths, especially across time,
state, and module boundaries. It supplements running tests; it cannot prove
that unexecuted tests or real environments work.

Recommend pairing it with runtime tests for consequential scenarios involving
nontrivial event histories, state transitions, or interacting read/write paths,
even when those scenarios are straightforward to execute. The two methods can
expose different gaps in the implementation, test setup, or assertions; a passing
test does not make independent reasoning redundant. Costly future-time or
hard-to-reproduce behavior is especially useful territory, not a prerequisite.
Use a bounded set of cases, or the user's requested scope; do not add it to every
small change or turn it into a whole-repository review.

## Define Expected Cases

The controller establishes business intent and necessary system context before
drawing conclusions about implementation. Source inspection may locate entry
points and explain the system; it must not become the oracle for expected
behavior. Resolve material ambiguities with the user or mark the affected cases
as conditional. Do not invent product decisions to make a case decidable.

Give each case a stable ID and enough information to derive the outcome:

- Preconditions and relevant history, including reachable initial state.
- Inputs, operations, or events in order; time zone, boundary inclusivity, and
  observation times where they matter.
- Expected state, response, amount, and invariants, including what must remain
  unchanged. Show intermediate balances or states when they clarify the risk.

Select normal, boundary, failure, replay, and recovery cases according to the
actual risk; there is no required count or exhaustive permutation matrix.
Include relevant histories such as previously assigned but now released, and
observable read paths as well as successful writes. Distinguish already
supported behavior from future requirements and out-of-scope operations.

## Isolate The First Pass

Prepare a small handoff containing business intent, neutral system/module
introductions, source access, and expected cases. Include applicable project
instructions, entry-point hints, scope, and report destination. Keep design
defenses, implementation summaries, prior findings, test results, and the
controller's verdict out of the initial handoff.

Bind the handoff to a fixed source version: an immutable checkout of a concrete
commit, or a source snapshot including relevant uncommitted and untracked code.
Record repository/base identity and content digests for snapshot files. A HEAD
commit alone does not identify a dirty working tree. Retain dependencies needed
to follow the cases, including cross-module reads and writes; isolation must
not hide necessary code. Exclude credentials, environment dumps, and unrelated
private artifacts. Keep snapshot metadata outside the reusable skill.

Launch a new agent without parent conversation inheritance; on Codex use
`fork_turns="none"`. A new agent name or an instruction to forget history is not
isolation. Use [case-reasoner-prompt.md](case-reasoner-prompt.md) to supply a
self-contained brief. If the platform cannot isolate context or provide stable
source access, report that limitation and do not claim independent reasoning.

The agent reads source and writes only its assigned report. It does not repair
code, run services, contact databases, or consume prior conclusions. It can
request missing source or neutral facts. Resolve such gaps without feeding it
the controller's theory; material expectation changes must be recorded.

Keep the reviewed source fixed until the initial report is saved. If relevant
inputs changed or cannot be accessed, identify affected cases and restore a
consistent input before relying on their conclusions.

The controller may run real tests before or alongside this first pass without
changing the reviewed source. Keep execution logs and verdicts out of the
reasoner's inputs until its initial report is saved; concurrent execution must
not leak them through shared artifacts. Bind both kinds of evidence to their
actual source versions, cases, and assumptions so they can be compared later.

## Trace And Report

The independent agent follows each case from real entry points through relevant
calls, storage, time comparisons, state transitions, transaction boundaries,
idempotency, and recovery. Compare consumers, queries, exports, and compatibility
paths that claim to expose the same state. A matching helper or test name does
not establish reachability or correctness.

Every case receives one of these meanings, with flexible presentation:

- **Code supports the expectation:** a reachable trace supports the result
  under stated assumptions; this is not a runtime pass.
- **Defect found:** concrete reachable conditions contradict the expectation.
- **Cannot confirm:** missing source, ambiguous intent, unsupported prerequisites,
  or runtime/environment evidence prevents a conclusion. Name the smallest gap.

Attach the call chain, source locations (path, symbol, and useful line numbers
bound to the snapshot), decisive conditions or writes, and expected versus
derived outcome. Findings need stable IDs, impact, reproduction conditions, and
a minimal executable check or reliable proxy. Keep plausible risks separate
from demonstrated source contradictions. Report all cases, including supported
ones, and boundaries static reasoning cannot establish, such as real driver
behavior, lock interleavings, external dependencies, or production data.

## Validate Findings And Recheck

Save the initial cases, source identity, and report before sharing execution
results or repair material. The controller independently checks each finding
against requirements and code, accepts it, rejects it with evidence, defers it,
or identifies a needed user decision. Preserve the initial report and disposition.

Compare runtime results and reasoning case by case once the initial report is
saved. If they disagree, inspect the expected outcome, source versions, setup,
assertions, and traced path; neither a green test nor an agent verdict settles
the disagreement by itself. Record the gap and obtain focused evidence.

For accepted defects, use `k-superpowers:systematic-debugging` to reproduce the
failure through the real entry path or a reliable proxy, then make an authorized
in-scope fix and run focused verification. Prefer an observed failure before
the fix and success afterward. If execution is unavailable, record the precise
gap; a persuasive trace alone does not justify claiming the bug fixed. Test
selection remains owned by `k-superpowers:type-driven-verification`.

After one coherent fix batch, resume the same independent agent with the frozen
record, accepted findings, final source/delta, and execution evidence. A
replacement receives that complete record without the main conversation.
Recheck accepted findings and directly caused regressions only; do not restart
discovery. If a blocker or material decision remains, report it and return
control to the user rather than starting another autonomous fix/review cycle.
Preserve original uncertainty unless new evidence specifically resolves it.

## Completion And Other Workflows

Report case coverage, accepted/rejected/deferred findings, fix and recheck
outcomes, commands actually run, source identity, and remaining uncertainty.
Keep source-derived conclusions separate from measured execution results.
Run applicable tests even when reasoning supports every case; controlled-clock
local service exercises can complement difficult future-time scenarios without
introducing production clock backdoors or acquiring environment access.

`k-superpowers:verification-before-completion` owns completion claims. This
focused method does not automatically satisfy the Spec and Standards review
owned by `k-superpowers:requesting-code-review`; reuse relevant evidence while
covering any remaining required scope. A reasoning-only request authorizes no
code repair. Deployment, production access, Git operations, and destructive
cleanup retain their normal authorization boundaries.

For an illustrative normal timeline and reported real-use findings, read
[contract-month-example.md](contract-month-example.md). Its known findings are
authoring context, not input for an independent first pass on that case.
