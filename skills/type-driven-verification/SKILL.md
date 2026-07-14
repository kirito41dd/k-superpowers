---
name: type-driven-verification
description: Use when implementing behavior that needs explicit verification, especially core logic, bug fixes, public APIs, algorithms, parsers, protocols, state machines, or high-risk changes
---

# Type-Driven Verification

## Core Principle

Use the target language's types and API boundaries to exclude invalid states,
then test only important behavior those guarantees cannot prove. Tests protect
semantics and regressions; they are not an implementation ritual.

## Implementation Design Contract

For domain logic, public interfaces, parsers, protocols, state machines,
resource lifecycles, or significant error boundaries, define:

```text
Domain invariants
Invalid states excluded by types or APIs
Untrusted input and validation boundaries
Error and resource-ownership model
Runtime risks the compiler cannot prove
Focused verification for those remaining risks
```

Planning, implementation reports, and review use the same contract. Skip it for
docs, formatting, mechanical renames, simple glue, and changes with no relevant
runtime or domain risk; do not generate empty fields or mandatory test steps.

## Language Capability Gradient

Use the strongest practical guarantees the project language supports:

- **Rust:** enums over conflicting flags, newtypes/private fields with checked
  constructors, boundary parsing, ownership/lifetimes, narrow traits and
  visibility, exhaustive matching. Use typestate only when its safety benefit
  justifies the complexity.
- **TypeScript:** discriminated unions, strict null handling, narrow module
  APIs, and runtime schema validation for untrusted values. Static types do not
  validate JSON, network, or storage input.
- **Go:** explicit structs and constructors, small interfaces, validated
  boundaries, and explicit `error` propagation.
- **Dynamic languages:** boundary validators, explicit data models, narrow
  APIs, and proportionally more focused runtime checks.

Do not imitate Rust with low-value wrappers or generic machinery. Move
enforceable invariants into the language and API; do not copy syntax.

## Choosing Verification

1. State the behavior and invariants.
2. Encode practical guarantees in types, visibility, ownership, and interfaces.
3. Identify remaining runtime risks.
4. Add focused tests only where semantics or recurrence risk justify them.
5. Run the smallest project-defined command that proves the intended claim.

Prefer stable caller entry points: public API, CLI, HTTP handler, parser
entrypoint, or state transition. Test private helpers separately only when they
carry complex logic that callers cannot expose clearly.

### Bugs

Use `k-superpowers:systematic-debugging` first and establish a feedback loop for
the concrete symptom. Then choose durable protection:

- recurring/core runtime bug: focused regression test;
- missing type/API invariant: strengthen the boundary, compile, and run relevant
  behavior checks;
- simple wiring/configuration bug: use the smallest reproducer and verification
  command; a new test is optional.

Every fix needs fresh evidence that the symptom is gone. It does not always need
a new persistent test, and it does not require a fixed test-before-code order.

## Review Rules

A reviewer must name the concrete invalid combination, boundary failure, or
unproved runtime behavior before requesting redesign or tests. "No tests added"
alone is not a finding. Also reject tests that mirror implementation details or
mocks, duplicate trusted-boundary validation, or treat compilation as proof of
runtime semantics.

Load `testing-anti-patterns.md` when changing tests or mocks.
