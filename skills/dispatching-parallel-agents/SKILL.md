---
name: dispatching-parallel-agents
description: Use when two or more independent problem domains can proceed without shared state or sequential dependencies
---

# Dispatching Parallel Agents

Parallelize only when every task can be understood and completed independently:

- no shared files, mutable state, resources, or environment;
- no task consumes another task's result;
- one fix cannot invalidate another investigation.

Otherwise keep work sequential. Do not depend on inherited conversation context;
give each agent a self-contained brief with exact scope, goal, constraints,
available evidence, and required output. One agent owns one problem domain.

After results return, inspect each report and actual changes, check conflicts and
assumptions, then run the combined verification. Agent success messages are not
evidence. Parallel investigation does not authorize parallel edits to shared
state.
