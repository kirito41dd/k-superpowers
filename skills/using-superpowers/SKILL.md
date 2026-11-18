---
name: using-superpowers
description: Use when starting any conversation
---

# Choosing a skill

<SUBAGENT-STOP>
A delegate with a focused brief can start from that brief.
</SUBAGENT-STOP>

Answer ordinary questions directly. For inspection, explain what you find.
A clear, bounded implementation request authorizes local edits in the current
workspace. Inspect existing changes, implement, and verify the result. Ask
only about unresolved choices that materially affect the outcome. Git commits,
publication and destructive actions require their own authority.

SDD means spec-driven development. Use the agreed behavior to guide implementation
and verification, whether one agent implements it or several share the work.
Even on a direct edit, [record a changed contract or consequential design
decision](../brainstorming/SKILL.md#maintaining-a-spec) where maintainers will
look for it. A fix that restores documented behavior can use the existing spec
as its acceptance criterion.

Choose the skill that serves the requested outcome. Use an explicitly named
skill where applicable. These distinctions matter in daily work:

- Explore an unsettled design with `k-superpowers:brainstorming`. Turn an
  existing direction into meeting material with `k-superpowers:preparing-technical-review`.
- Investigate a symptom with `k-superpowers:systematic-debugging`. To trace
  expected business cases independently against source, use `k-superpowers:reasoning-based-testing`.
- Use `k-superpowers:writing-plans` for a requested plan or useful handoff.
  For an approved plan, use `k-superpowers:executing-plans` when working inline
  or `k-superpowers:subagent-driven-development` when delegating implementation.
- For consequential code, use `k-superpowers:type-driven-verification` before
  editing. A developer-log wording change usually needs just diff inspection
  and the relevant project check.
- Use `k-superpowers:requesting-code-review` when the risk or request calls for
  independent judgment, and `k-superpowers:receiving-code-review` for supplied
  findings. Use `k-superpowers:writing-skills` for skill authoring or review.

A request for diagnosis, review, design, or planning alone ends with that
deliverable. Match completion claims to the final evidence. Use
`k-superpowers:finishing-a-development-branch` for a requested Git action.
