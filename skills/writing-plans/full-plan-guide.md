# Full Plan Guide

Each task is one independently verifiable vertical slice worth its review gate.
Fold setup/config/docs into the deliverable that needs them. Horizontal tasks
are allowed only for necessary type/API prerequisites, prefactors, or mechanical
migrations with their own verification.

Use checkbox steps, normally:

1. Define the type/API boundary and Implementation Design Contract when needed.
2. Implement the minimal behavior, including useful explanations for core
   abstractions when code is not self-explanatory.
3. Add focused tests only for named runtime risks static guarantees cannot prove.
4. Run the exact project verification and record expected output.
5. Create a checkpoint only when the execution handoff authorizes it.

Every step contains exact paths, signatures/data shapes, commands, and real
implementation detail where prose leaves a meaningful choice. Never use TBD,
TODO, “similar to”, generic validation/error instructions, undefined APIs, or
unbounded “write tests”.

## Self-Review

Check spec coverage, placeholders, type/signature consistency, Global Constraint
propagation, cross-task interfaces, core explanation quality, task sizing, risk,
and verification scope. Fix gaps inline. Plan approval remains separate from
implementation and commit authorization.
