---
name: brainstorming
description: Use before creating features, components, functionality, configurations, or other behavior changes
---

# Brainstorming

<HARD-GATE>
Do not implement, scaffold, or invoke an implementation skill before the user
approves a design. The only terminal transition is `k-superpowers:writing-plans`.
</HARD-GATE>

Preparation-only requests are not a trigger; read context and wait.

## Flow Selection

Choose `Flow: Compact` only when all are proven:

- one problem domain;
- goal/success criteria are clear after at most one blocking question;
- no unresolved long-term architecture choice;
- no irreversible migration, security/permission boundary, protocol, or major
  compatibility decision;
- the user can evaluate the trade-offs directly.

Otherwise use `Flow: Full`. New uncertainty upgrades Compact to Full; never
downgrade merely for speed.

## Compact

1. Explore project context and ask at most one blocking question.
2. In one message present 2-3 approaches, recommendation, and complete design
   proportional to the change: boundaries, flow, failures, and verification.
3. Obtain one design approval.
4. Write and self-review the equivalent spec. Approval covers a faithful written
   spec; any new architecture, scope, dependency, public contract, or risk
   decision is a material delta requiring approval.
5. Do not commit the spec without explicit authorization. Invoke writing-plans.

## Full

Read `full-flow.md` and follow it. Full retains one-question-at-a-time
clarification, approach comparison, sectional design approval, written-spec
review, and explicit spec commit authorization.

## Self-Review

Before planning, remove placeholders, contradictions, ambiguous requirements,
and scope that should be decomposed. User-facing text/specs follow the
conversation language; code identifiers retain their natural language.

For genuinely visual questions, offer the optional companion once and load
`visual-companion.md` only after consent.
