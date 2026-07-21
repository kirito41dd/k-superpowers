---
name: type-driven-verification
description: Use when implementing consequential domain behavior, core logic, bug fixes, public APIs, parsers, protocols, state machines, resources, or other changes needing explicit design and evidence
---

# Type-Driven Verification

Use the target language's types and API boundaries to exclude invalid states,
then verify important behavior those guarantees cannot prove. Tests protect
semantics and regressions; they are not an implementation ritual.

## Design Questions

For consequential domain logic, interfaces, untrusted inputs, protocols, state,
resources, or significant error boundaries, consider the applicable questions:

- What domain invariants matter?
- Which invalid states can types, visibility, constructors, or APIs exclude?
- Where does untrusted input enter and get validated?
- Who owns errors, cleanup, and resource lifecycles?
- What runtime risk remains after static guarantees?
- What smallest evidence proves that remaining behavior?

These are thinking dimensions, not a mandatory report form. Skip irrelevant
questions for docs, formatting, mechanical changes, and simple glue.

## Language Capability

- **Rust:** enums/newtypes, private validated construction, ownership/lifetimes,
  narrow traits/visibility, and exhaustive matching. Use typestate only when its
  safety benefit justifies complexity.
- **TypeScript:** discriminated unions, strict null handling, narrow APIs, and
  runtime schema validation for JSON/network/storage input.
- **Go:** explicit structs/constructors, small interfaces, validated boundaries,
  and explicit error propagation.
- **Dynamic languages:** boundary validators, explicit data models, narrow APIs,
  and proportionate runtime checks.

Do not imitate Rust with low-value wrappers. Use the strongest practical
guarantees of the project language.

## Core Explanations

Explain non-self-explanatory core structures, functions, and abstractions. Cover
the applicable purpose, caller use, important invariants, lifecycle/resource
rules, and protocol boundaries or state transitions. Treat a factory as part of
the abstraction callers obtain. Follow project and nearby-file comment language
and style; do not restate obvious code.

## Evidence

Choose evidence from the actual remaining risk: compiler/type checks, focused
tests, a stable public entry point, a parser/state transition, a minimal
reproducer, diff inspection, or another reliable artifact. Prefer caller-visible
behavior over private mocks unless the interaction itself is the risk.

For bugs, use `systematic-debugging` first. Every fix needs evidence that the
symptom or reliable proxy changed, but not necessarily a new persistent test or
fixed test-before-code order.

A reviewer requesting redesign or tests must name the concrete invalid state,
boundary failure, or unproved runtime behavior. “No tests added” alone is not a
finding.
