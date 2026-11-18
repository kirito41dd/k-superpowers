---
name: dispatching-parallel-agents
description: Use when deciding which investigations or implementation tasks can make independent progress concurrently
---

# Choosing parallel work

Parallelize when the inputs are ready, each result can be evaluated, and the
time or context saved outweighs coordination. Independent agents can read the
same files and can write disjoint paths in the same checkout.

Check what each task **reads, writes, and verifies**. A generated type, shared
fixture, formatter, port, database, or build output can connect tasks that edit
different source files. If one result determines another task's implementation,
settle that contract first and parallelize the remaining independent pieces.
Run shared checks once the inputs they consume are stable.

Give each delegate the goal, relevant inputs, ownership, authorized actions,
and expected evidence. Reconcile the results and inspect their combined effect.
For delegated implementation, `k-superpowers:subagent-driven-development`
owns the task handoff and acceptance, whether the tasks run together or in sequence.
