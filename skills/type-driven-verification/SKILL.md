---
name: type-driven-verification
description: Use when implementing consequential domain behavior, core logic, bug fixes, public APIs, parsers, protocols, state machines, resources, non-self-explanatory core code, unusually large or multi-responsibility code, or other changes needing explicit design, explanation, and evidence
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

When a change designs or alters the behavior or boundaries of a backend business
command, transactional or stateful use case, or permission-sensitive or complex
business query, read
[Use-Case-Driven Transactional Application Services](use-case-driven-transactional-services.md)
for the applicable use-case, transaction, data-ownership, state, and side-effect
boundaries.

When the semantic delta alters persistence access, database schema,
migration/backfill behavior, or ownership/sharding boundaries, read
[Backend Database Schema and Migrations](backend-database-schema-and-migrations.md).

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

## Cohesion And Size

Treat source size as a maintainability signal, not a mechanical limit. As a
general guide, when a function grows to roughly 300 lines or a source file to
roughly 2,000 lines, examine whether it combines stable, independently nameable
responsibilities. Split when doing so improves local reasoning, review,
navigation, testing, or change isolation.

Keep cohesive code together when splitting would mainly add indirection or
scatter an invariant. Generated, declarative, fixture-heavy, and similarly
structured code may reasonably differ. Do not expand an approved change merely
to refactor pre-existing large code, but avoid adding a new independent
responsibility when a focused module is a cleaner in-scope home.

## Test Selection

Add a persistent test when it protects a stable, consequential contract that
types, compiler checks, boundary validation, or existing evidence cannot
establish. Business relevance, an acceptance example, or the existence of an
implementation branch is not sufficient by itself. Test durable domain
invariants and costly failure modes with the smallest set of cases at the
narrowest stable caller-visible or domain boundary.

Do not add persistent tests or reshape production abstractions, including
enums, errors, or helpers, solely to test human-readable developer log copy.
Test logs only when machine consumers, audit/compliance obligations, or
documented compatibility depend on their events, fields, or exact output.

Consolidate equivalent cases with table-driven or property-oriented tests when
that preserves diagnostic value. Avoid duplicating the same risk across helper,
module, and end-to-end layers; enumerating permutations without distinct failure
modes; or pinning private control flow, incidental ordering, exact text, or
arbitrary limits unless they are genuine compatibility, safety, or protocol
contracts. For a bug fix, prefer one focused regression or an existing reliable
proxy when it proves the failure cannot recur.

Treat mocks, fixtures, and test-only infrastructure as maintained code. Omit,
merge, or remove tests when their marginal confidence does not justify their
coupling and maintenance cost.

## Core Explanations

Explain non-self-explanatory core structures, functions, and abstractions. Cover
the applicable purpose, caller use, important invariants, lifecycle/resource
rules, and protocol boundaries or state transitions. Treat a factory as part of
the abstraction callers obtain. Follow project and nearby-file comment language
and style; do not restate obvious code.

## Core Test Explanations

Make core tests reveal the semantic contract and regression risk they protect.
Prefer behavior-focused names, clear scenario structure, and domain-named
fixtures. When an invariant, regression background, unusual input/order, or
critical assertion consequence is not self-explanatory, add a concise nearby
comment or assertion message explaining what can break and why it matters.

Do not narrate setup or restate assertions. Keep the production invariant
explained with the production abstraction; tests provide focused evidence and
diagnostic context rather than becoming the only documentation.

## Evidence

Choose evidence from the actual remaining risk: compiler/type checks, focused
tests, a stable public entry point, a parser/state transition, a minimal
reproducer, diff inspection, or another reliable artifact. Prefer caller-visible
behavior over private mocks unless the interaction itself is the risk.

For bugs, use `systematic-debugging` first. Every fix needs evidence that the
symptom or reliable proxy changed, but not necessarily a new persistent test or
fixed test-before-code order.

A reviewer requesting redesign or tests must name the concrete invalid state,
boundary failure, or unproved runtime behavior. A reviewer reporting excessive
tests must name the redundant risk coverage, incidental coupling, or
disproportionate maintenance cost. Neither “no tests added” nor test count alone
is a finding.
