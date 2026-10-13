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
Present the coherent design once: goal, affected boundaries, behavior, material
failure paths, and verification, using the content guidance below. After
approval, when implementation is already authorized, assess execution topology
once. Use `k-superpowers:writing-plans`
when staged execution, continuity, or delegation makes a persistent plan
useful; otherwise implement Inline. Without an implementation request,
stop after the approved design.

### Full

Use for cross-domain, irreversible, security/permission, protocol, migration,
or major public compatibility work. Read `full-flow.md`. Full makes material
decisions explicit and normally records a durable spec, but it does not require
longer prose, ceremonial alternatives, or approval after every prose section.

## Design Content

Start with the goal, selected approach, and execution order; label an unsettled
recommendation as proposed. Put only decision-relevant background after that.
Default to a short body: scope, usually 3–5 implementation stages, key
compatibility constraints, and acceptance criteria. Each stage says what
changes, what it delivers, and how completion is established. Abstract
principles alone are not stages; adjust their number to the work, not a quota.

Preserve the user's settled decisions instead of reopening alternatives without
new conflicting evidence. State each material risk and its response once. Keep
safety, migration, and recovery boundaries that affect implementation explicit,
including blocking conditions and release criteria where applicable. Brevity
must not hide them or imply an unsupported rollback path.

Link existing experiment results, source evidence, and detailed exception
matrices; keep their implementation-changing conclusions in the body. Avoid
source inventories and research dumps, and do not mechanically split out more
documents just to shorten the main one. Expand only where a material decision
or boundary would otherwise be lost.

When asked to be concise, delete repetition, superseded discussion, and
non-decision information; changing headings or phrasing alone is insufficient.
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
proceed, and what permits release. Revise the main body if those answers are
buried. Follow the conversation language for user-facing design documents and
the project's conventions for code identifiers and comments.
