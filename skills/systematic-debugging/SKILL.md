---
name: systematic-debugging
description: Use when encountering a bug, failure, performance problem, or unexpected behavior before making a speculative fix
---

# Systematic Debugging

Gather enough evidence to distinguish plausible causes before editing. Prefer a
reproducible feedback loop, but do not pretend every production, external,
intermittent, or environment-specific failure can be reproduced locally.

## Observe

- Read complete errors, logs, traces, dumps, and relevant surrounding output.
- Reproduce the concrete symptom with the smallest useful loop when feasible.
- For flaky behavior, measure enough attempts to distinguish signal from noise.
- Inspect relevant changes, configuration, environment, and component
  boundaries. Trace bad state toward its source.
- Keep instrumentation bounded and protect secrets.

When reproduction is unavailable, state what evidence exists, what is missing,
and how that limits confidence. Diagnosis may still proceed from logs, traces,
dumps, authoritative behavior, and concrete environment differences; a fix
claim may not.

Load `condition-based-waiting.md` for timing problems or
`root-cause-tracing.md` for backward data tracing when they answer the current
question. Do not broaden investigation without a reason.

## Explain And Distinguish

Form one evidence-based, falsifiable hypothesis at a time. State why it explains
the symptom and what observation would distinguish it. A working example or
authoritative implementation is useful when available, not a mandatory phase.

Change one relevant variable or add one observation, then inspect the result.
Do not stack speculative fixes. Update confidence when evidence contradicts the
hypothesis.

## Fix

Before changing behavior, establish enough evidence that the proposed edit
addresses the likely cause and does not require an unapproved material decision.
Use `k-superpowers:type-driven-verification` to choose the durable boundary and
focused evidence:

- strengthen a missing type/API invariant;
- add focused runtime protection when recurrence and impact justify it; or
- use a minimal reproducer/inspection for simple wiring or configuration.

Verify the symptom or closest reliable proxy after the fix. Keep a persistent
regression check only when it protects core recurring risk; remove temporary
instrumentation and unstable/private harnesses.

## Stop Conditions

Stop editing and discuss the evidence when:

- required data, dependency, environment, or authorization is unavailable;
- observations conflict and no next check can distinguish them;
- consecutive attempts produce no new information;
- the proposed scope keeps expanding; or
- evidence points to an architecture, ownership, or state-model decision beyond
  the approved change.

Without verification, report diagnosis, confidence, and the next useful
observation—never claim the issue is fixed. Do not treat timeouts, retries,
exception swallowing, or symptom suppression as root-cause evidence.
