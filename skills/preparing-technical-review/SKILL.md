---
name: preparing-technical-review
description: Use when turning an existing technical proposal, implementation context, or research into meeting-ready technical or architecture review materials that help a team make explicit decisions; not for code review, open-ended design discovery, implementation planning, or presentation-only formatting
---

# Preparing A Technical Review

Turn an existing technical direction or bounded decision problem, together with
its implementation and research evidence, into a decision instrument a team can
present, discuss, and conclude within the meeting. This skill owns content and
meeting narrative, not solution discovery, implementation planning, or
format-specific slide and document production.

A complete proposal need not already exist or be approved. The minimum input is
a bounded decision problem with plausible options and enough evidence to assess
them. If that is missing, expose the smallest gap or use
`k-superpowers:brainstorming`; do not invent capabilities, evidence, or
consensus.

## Context And Boundaries

Read the relevant current implementation, source design/spec, prior decisions,
and research. Establish the audience, time, decision owners, and intended
outcome. Ask only for missing context that changes the material. Distinguish:

- confirmed current capabilities and constraints;
- capabilities proposed for this delivery;
- later candidates and deliberate non-goals;
- assumptions or evidence gaps still needing validation.

Never present target state as current fact or proposal as approved decision.

Write for people other than the author: assume reviewers know the domain but not
the proposal's private context, vocabulary, or shorthand, and make the document
understandable without the author translating it aloud. Let them see the
concrete problem, consequence, and desired outcome before internal taxonomy.
Headings, tables, and action rows should name the actual technical subject,
evidence, acceptance boundary, behavior, or impact. Do not expose authoring
scaffolding such as `Gate`, `question to answer`, `pass condition`, or `if it
fails` as reader-facing labels. Use one running scenario when it materially
clarifies an abstract mechanism. Define coined or internal terms in plain
language at first use.
Prefer the requested language when equally precise; keep English for code
identifiers, official product or standard names, or disambiguation.

## Meeting Narrative

Build shared understanding before asking reviewers to judge the proposal. Use
the smallest narrative that supports the required decisions. A common order is:

1. **Background and current situation:** what led to the review, what exists
   today, the concrete problem and impact, and why it matters now.
2. **Goals, scope, and review focus:** what the proposal aims to achieve, its
   high-level direction, current/proposed/later boundaries, non-goals, and the
   questions that need agreement.
3. **Proposed approach and critical mechanism:** the target user or system flow,
   overall design, how the key mechanism works, and evidence that makes the
   central technical bet credible.
4. **Choices and trade-offs:** why this approach is recommended, viable
   alternatives, costs and limits, revisit conditions, and impact of rejection.
5. **Validation, delivery constraints, and risk:** available and missing
   evidence, acceptance conditions, decision-relevant dependencies, failure
   behavior, mitigation, and degradation; cover rollback only when a concrete
   operational rollback path exists.
6. **Decisions and follow-up:** meaningful decision names, actual outcomes and
   conditions, and follow-up actions once known.

Combine, rename, or omit sections freely; this is a narrative guide, not a
template. Use an appendix for relevant detail outside the main reasoning path.

Keep facilitation separate from technical content. Add status, owner, or source
links when useful, but include attendee lists, duration, minute-by-minute
agendas, recorder instructions, or presenter cues only when requested or
required by a team template. A pre-meeting draft may leave outcome and action
fields blank; do not invent owners, deadlines, or an implementation backlog.

## Decision Quality

A real decision has credible alternatives or materially different consequences.
Treat facts, constraints, and uncontested implementation details as context.
Use stable IDs only when cross-document traceability helps. Never use a bare code
such as `D1`, `G2`, or `A1` as reader-facing shorthand; every reference must
retain the meaningful decision, acceptance condition, risk, or action name. If
the set cannot be discussed within the available time, split or defer it.

For each external product or approach that informs a decision, briefly state
what it is and the problem it solves, then its fit and why the recommendation is
to adopt it, adapt it, borrow selected ideas, or reject it. Keep it with that
decision; avoid a standalone survey.

When feasibility depends on a self-built or uncertain mechanism, keep its
minimal working model in the main path: inputs, major steps, acceptance or
degradation boundaries, relevant precedent or prototype, why it is buildable,
and remaining evidence gaps. If evidence is missing, make approval conditional
on a spike or validation result rather than assert confidence; leave code and
per-language detail in the source spec.

Label exact thresholds as measured facts or proposed acceptance conditions and
keep them consistent with their source.

## Compression And Source Of Truth

The main body contains only what participants need to understand and decide.
Give each fact one primary explanatory home; summaries may signpost rather than
repeat full decision tables, acceptance conditions, evidence gaps, or dependency
matrices.
Keep DTOs, API fields, SQL/indexes, code structures, per-language mechanics,
full test matrices, benchmark procedures, and research notes in the source spec
or appendix unless one changes an architectural choice. Prefer a few purposeful
diagrams where boundaries, flow, state, or sequence would otherwise be unclear.

## Completion

The material is ready when participants can quickly explain the problem,
recommendation, value, cost, viable alternatives, capability boundaries, and
critical-mechanism feasibility and evidence gaps, and required decisions within
the stated meeting time.

Detailed design remains authoritative. Treat recording meeting outcomes and
reconciling material changes into it as a separate authorized follow-up before
`k-superpowers:writing-plans`. Follow the requested language and format; a
document or presentation skill may own the artifact while this skill continues
to own its decision structure and content.
