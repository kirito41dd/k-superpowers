---
name: brainstorming
description: Use when the user requests design work or a behavior change has unresolved material decisions before implementation; not for clear implementation requests without material ambiguity, or read-only familiarization, analysis, review, or status requests
---

# Brainstorming

Resolve material behavior and design choices before implementation. A clear,
bounded implementation request can itself supply approval for the specified
behavior and scope. Make the design proportional to the remaining decision,
not to a template.

Read-only familiarization, analysis, review, status, and preparation requests
are not design work. Perform them and stop.

For designs involving backend business use cases, transaction/state boundaries,
or permission-sensitive queries, consult the relevant
[use-case-driven service guidance](../type-driven-verification/use-case-driven-transactional-services.md).
For persistence, schema, migration/backfill, or ownership/sharding decisions,
consult the [database guidance](../type-driven-verification/backend-database-schema-and-migrations.md).
Apply only relevant constraints under the project's own architecture rules;
these references do not prescribe document sections or expand the design scope.

## Choose Depth

### Direct

Use when the goal is clear, the change is reversible and single-domain, and no
material architecture, scope, dependency, public contract, compatibility,
security, migration, or permission choice is unresolved.

If the user already specified the intended behavior and scope and asked to
implement, inspect relevant context and proceed through Direct implementation
without another approval. For design work, present the recommendation and real
trade-offs concisely; obtain approval only for decisions not already settled.
Implement only when the original request or a later response asks to implement;
a design-only request ends after the design. Use the current workspace with no
commit by default. Clear requirements still need a planning assessment: use
`k-superpowers:writing-plans` when staged execution or handoff benefits from a
persistent plan.

### Compact

Use for bounded multi-step or tightly coupled work that benefits from a concise
shared design. Ask only questions whose answers materially affect the result.
Present one coherent design using the content guidance below. After approval,
when implementation is already authorized, assess execution topology once. Use
`k-superpowers:writing-plans` when staged execution, continuity, or delegation
makes a persistent plan useful; otherwise implement Inline. Without an
implementation request, stop after the approved design.

### Full

Use for cross-domain, irreversible, security/permission, protocol, migration,
or major public compatibility work. Read `full-flow.md`. Full makes material
decisions explicit and normally records a durable spec, but it does not require
longer prose, ceremonial alternatives, or approval after every prose section.

## Design Content

A spec primarily helps engineers understand, confirm, and later maintain the
proposed system. Assume domain knowledge, but no access to the author's private
context. Readers should be able to explain the design in their own words and
understand what they are approving without the agent translating it for them.

Start with the goal, selected approach, and execution order; label an unsettled
recommendation as proposed. Put only decision-relevant background after that.
Explain how the chosen mechanism works before enumerating constraints. A
concrete scenario or coherent flow can connect who does what, why the choices
solve the problem, and what happens on failure. Explain unfamiliar terms in
plain language; avoid making readers reconstruct the design from component
lists, state names, or prohibitions.

Default to a main body readable in a few minutes: scope, the key mechanism,
usually 3–5 implementation stages, critical constraints, and acceptance
criteria. Each stage says what changes, what it delivers, and how completion is
established. Reading time and stage count are guides, not quotas. Reduce the
effort needed to understand the design; dense jargon or compressed sentences
do not make it concise. Keep paragraphs that explain the mechanism, inform a
material choice, or expose a critical boundary. Complexity calls for clearer
explanation, not exhaustive coverage of every implementation detail.

Preserve settled decisions with their known rationale, accepted costs, and
limits, briefly enough for future maintainers to understand the choice. Revisit
alternatives only when the user asks or new conflicting evidence warrants it.
State each material risk and its response once. Keep safety, migration, and
recovery boundaries that affect implementation explicit, including blocking
conditions and release criteria where applicable. Brevity must not hide them
or imply an unsupported rollback path.

Link existing experiment results, source evidence, and detailed exception
matrices; keep conclusions needed to judge the design in the body. Leave
implementation-only detail to the relevant planning or implementation work,
without deferring choices that determine feasibility, safety, or compatibility.
Avoid source inventories and research dumps, and do not mechanically split out
more documents just to shorten the main one.

Cut repetition, superseded discussion, and detail that does not support human
understanding or decisions. A short summary cannot compensate for an unreadable
body. When asked to be concise, actually remove content and reshape the
narrative; changing headings or phrasing alone is insufficient.
Describe unimplemented work as planned, and claim completion only with evidence.

## Approval Boundary

Approval covers the user-specified bounded change or a design the user approved.
A later material architecture, scope, dependency, public-contract, compatibility,
or risk decision returns to the user. Approval plus an explicit implementation
request authorizes in-scope edits, but never Git publication, commits,
destructive actions, or unrelated changes.

In the single self-review before handoff, remove repetition, placeholders,
contradictions, and ambiguous material decisions. A reader should understand
within a minute what will be built, what happens first, how later stages
proceed, and what permits release. After reading the short body, could an
engineer explain how the system works, the consequential choices, and its
failure/recovery boundaries? If not, rewrite the narrative and reduce the
reading burden while preserving those boundaries. Follow the conversation
language for user-facing design documents and the project's conventions for
code identifiers and comments.
