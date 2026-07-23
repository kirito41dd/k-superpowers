---
name: dispatching-parallel-agents
description: Use when two or more non-SDD workstreams can proceed concurrently with meaningful latency benefit and manageable integration risk
---

# Dispatching Parallel Agents

Parallelize when expected latency or context benefit exceeds delegation and
integration cost. Shared read-only files and context are allowed.

This skill owns parallel investigation, analysis, diagnosis, and other general
workstreams. For an approved implementation plan with independent repository
tasks, durable handoff, and checkpoint ownership, use
`k-superpowers:subagent-driven-development`. Do not use generic parallel edits
to bypass its plan or commit authorization.

Keep work sequential when:

- agents would write overlapping files/state or compete for one external
  resource;
- one task needs another task's unfinished result;
- one task's decision may invalidate another's work; or
- reconciling results costs more than the expected speedup.

Give each agent a clear problem, boundaries, relevant context/evidence,
authorized actions, and useful result expectations. Agents may inspect shared
read-only context independently. For edits, assign nonconflicting ownership or
serialize the mutation phase.

The controller inspects reports and actual changes, reconciles assumptions, and
obtains combined evidence. Agent success messages are not proof, and delegation
does not expand mutation or external-action authority.
