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
commit by default. Do not create a spec or plan artifact unless it has real
handoff value or the user requests it.

### Compact

Use for bounded multi-step or tightly coupled work that benefits from a concise
shared design. Ask only questions whose answers materially affect the result.
Present the coherent design once: goal, affected boundaries, behavior, material
failure paths, and verification. After approval, when implementation is already
authorized, assess execution topology once. Use `k-superpowers:writing-plans`
when independently deliverable tasks make delegation or durable execution
handoff useful; otherwise implement Inline. Without an implementation request,
stop after the approved design.

### Full

Use for cross-domain, irreversible, security/permission, protocol, migration,
or major public compatibility work. Read `full-flow.md`. Full makes material
decisions explicit and normally records a durable spec, but it does not require
ceremonial alternatives or approval after every prose section.

## Approval Boundary

Approval covers the user-specified bounded change or a design the user approved.
A later material architecture, scope, dependency, public-contract, compatibility,
or risk decision returns to the user. Approval plus an explicit implementation
request authorizes in-scope edits, but never Git publication, commits,
destructive actions, or unrelated changes.

Before handoff, remove placeholders, contradictions, and ambiguous material
decisions. Follow the conversation language for user-facing design documents
and the project's conventions for code identifiers and comments.
