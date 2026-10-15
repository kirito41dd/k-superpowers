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

Open with a brief orientation: what is under review, the recommended direction,
and what participants need to decide. If no recommendation is defensible yet,
state the unresolved choice and evidence gap.

Then give enough current context, problem, and impact to understand the proposal.
Follow a concrete scenario or coherent flow through the key mechanism, its
evidence, and consequential trade-offs. Connect the reasoning to the decisions
requested; choose sections that serve it rather than a chapter for every topic.
Build shared understanding before asking for a judgment.

Keep scope, capability limits, decision-relevant dependencies, and acceptance
conditions clear. Preserve safety, migration, failure, and recovery boundaries
that affect the decision; cover rollback only when a concrete operational path
exists. Record actual decisions, conditions, and follow-up actions once known.

Keep facilitation separate from technical content. Add status, owner, or source
links when useful, but include attendee lists, duration, minute-by-minute
agendas, recorder instructions, or presenter cues only when requested or
required by a team template. A pre-meeting draft may leave outcome and action
fields blank; do not invent owners, deadlines, or an implementation backlog.

## Decision Quality

A real decision has credible alternatives or materially different consequences.
Treat facts, constraints, and uncontested implementation details as context.
Distinguish decisions requested now from settled choices. Briefly retain the
known rationale, accepted costs, and limits of settled choices; reopen them
only when requested or new conflicting evidence warrants it. Compare credible
alternatives for unresolved choices, without inventing options to fill a table.
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
on a spike or validation result rather than assert confidence. Link existing
implementation evidence for supporting detail.

Label exact thresholds as measured facts or proposed acceptance conditions and
keep them consistent with their source.

## Compression And Source Of Truth

Default to a main body colleagues can read in a few minutes before discussion.
Adapt to the audience and decision complexity; reading time is guidance, not a
quota. A short summary cannot compensate for an unreadable body, and dense
jargon or compressed sentences do not reduce the effort of understanding.
Cut repetition, superseded debate, and detail that does not help readers
understand or decide. Give each fact one primary explanatory home. A request
for brevity calls for substantive cuts and clearer narrative, not just new
headings or shorter phrasing.

Link existing designs, implementation evidence, experiments, and test results;
keep the conclusions and boundaries needed for the decision in the main body.
Do not dump supporting detail into the source spec or manufacture appendices
and documents just to shorten the main text. Add reference material only when
it has a real use. Use a diagram when it explains a mechanism or boundary more
clearly than prose.

## Completion

The material is ready when a reviewer can independently explain how the proposal
works, why it is recommended, what remains to be decided, and the costs, risks,
and evidence gaps they would accept. The opening should orient them quickly;
the body should make that judgment possible without a live explanation. Leave
room for discussion within the meeting time. If the reasoning is buried,
rewrite and cut while preserving the mechanism and material boundaries.

Detailed design remains authoritative. Treat recording meeting outcomes and
reconciling material changes into it as a separate authorized follow-up before
`k-superpowers:writing-plans`. Follow the requested language and format; a
document or presentation skill may own the artifact while this skill continues
to own its decision structure and content.
