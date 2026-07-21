---
name: brainstorming
description: Use when designing a requested feature, component, functionality, configuration, or other behavior change before implementation; not for read-only familiarization, analysis, review, or status requests
---

# Brainstorming

Do not edit behavior before the user understands and approves the intended
change. Make the design proportional to the decision, not to a template.

Read-only familiarization, analysis, review, status, and preparation requests
are not design work. Perform them and stop.

## Choose Depth

### Direct

Use when the goal is clear, the change is reversible and single-domain, and no
material architecture, scope, dependency, public contract, compatibility,
security, migration, or permission choice is unresolved.

Inspect relevant context, present the recommended behavior and important
trade-off concisely, and obtain one approval. Present alternatives only when
there is a real choice. After the user approves or says to implement, proceed in
the current workspace with no commit by default. Do not create a spec or plan
artifact unless it has real handoff value or the user requests it.

### Compact

Use for bounded multi-step or tightly coupled work that benefits from a concise
shared design. Ask only questions whose answers materially affect the result.
Present the coherent design once: goal, affected boundaries, behavior, material
failure paths, and verification. After approval, either implement Inline or
write a persistent plan when cross-session/executor handoff makes it useful.

### Full

Use for cross-domain, irreversible, security/permission, protocol, migration,
or major public compatibility work. Read `full-flow.md`. Full makes material
decisions explicit and normally records a durable spec, but it does not require
ceremonial alternatives or approval after every prose section.

## Approval Boundary

Approval covers the presented design. A later material architecture, scope,
dependency, public-contract, compatibility, or risk decision returns to the
user. Approval plus an explicit implementation request authorizes in-scope
edits, but never Git publication, commits, destructive actions, or unrelated
changes.

Before handoff, remove placeholders, contradictions, and ambiguous material
decisions. Follow the conversation language for user-facing documents and the
project's conventions for code identifiers and comments.
