---
name: writing-plans
description: Use when the user requests an implementation plan, approved work needs a persistent multi-step plan, or an approved plan needs an execution handoff
---

# Writing Plans

Use the format and destination the user requests. A persistent plan is useful
when requested or when it improves cross-session continuity, delegation,
review, or multi-step execution. Simple implementation work can proceed
directly with an internal todo when useful.

Write for the agent that will resume execution. Give it the dependencies,
next actions and checks it needs. Link the relevant spec when one exists.
If planning exposes a new compatibility, behavior or architecture decision,
resolve it with the user and record the outcome in the
[owning spec](../brainstorming/SKILL.md#maintaining-a-spec) within the
authorized scope. When only a plan was requested, identify the required
spec update in the handoff. The agent can adjust task order
and other local execution details itself.

Keep short-lived plans in the conversation. For a durable handoff, the default
path is `docs/superpowers/plans/YYYY-MM-DD-<topic>.md`. Treat it as a working
artifact unless the user or project explicitly includes plans in delivery.

## Plan Content

Capture, as applicable:

- goal and approved behavior;
- exact boundaries or files when known;
- important interfaces and task dependencies;
- invariants, untrusted inputs, error/resource ownership, and core explanation
  needs for consequential domain logic;
- material execution/review risk;
- focused verification that supports the intended claims.

Choose verifiable stages with clear boundaries and dependency order; slices or
layers may fit the work. Do not create empty contract fields, invent tests, or
expand project verification. Risk labels are useful only when they affect
delegation, review, permissions, or evidence. Obvious docs/mechanical work does
not block because a `low` label is absent.

`k-superpowers:type-driven-verification` owns implementation design guidance;
reference its applicable questions rather than copying a mandatory form.
For plans that alter the behavior or boundaries of a backend business command,
transactional or stateful use case, or permission-sensitive or complex business
query, also apply its
[use-case-driven service guidance](../type-driven-verification/use-case-driven-transactional-services.md)
without turning every responsibility into a required task or abstraction.
For plans that alter persistence access, schema, migration/backfill behavior, or
ownership/sharding boundaries, apply the
[backend database guidance](../type-driven-verification/backend-database-schema-and-migrations.md).

## Handoff

For a plan-only request, deliver the plan and finish. When implementation is
already authorized, proceed without another approval if the plan faithfully
implements the agreed behavior. Resolve any new material decision first.

Carry forward the user's execution choice. Use Inline for tightly coupled
work. Delegate when another agent can work from an agreed contract and the
handoff saves time or context. Identify any dependency that must settle first.
Choose workspace isolation separately when it makes independent verification
or recovery worthwhile. Both routes can deliver uncommitted work.

For unusually detailed Full plans, use `full-plan-guide.md` as guidance, not a
required template. Self-review once for coverage, contradictions, material gaps,
and executable verification; then proceed or request only the missing decision.
