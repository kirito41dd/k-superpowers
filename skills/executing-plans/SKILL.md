---
name: executing-plans
description: Use when executing an approved implementation plan inline or when a bounded approved change benefits from one-agent execution
---

# Executing Plans

Execute the approved behavior with one agent. The safe default is the current
workspace with no implementation commit; use a selected worktree when the user
or approved handoff requests it.

Before edits, read the useful plan/spec and relevant project instructions.
Detect overlap with pre-existing user changes. Stop for a real conflict,
missing material decision, authorization gap, or design delta; record
nonblocking observations and continue.

Use internal todos proportional to the work. Follow the approved slices, but
adapt local ordering when evidence or dependencies make another order safer or
faster. Load `k-superpowers:type-driven-verification` when consequential domain
logic, public APIs, parsers, protocols, state, resources, or non-self-explanatory
core abstractions need its design and explanation guidance.

Run focused verification as the work progresses. Independent code review is not
a default checkpoint: request it only when the approved plan, user, or a
concrete high-risk uncertainty calls for it. Same-controller Inline review may
inspect requirements, the current diff, relevant context, and evidence directly;
use a frozen review package only when crossing contexts or stabilizing a moving
working tree is useful.

When review is required, follow `k-superpowers:requesting-code-review`'s bounded
Discovery/Closure lifecycle. A stopped closure returns control to the user and
does not start another autonomous cycle.

Before claiming the whole change complete, use
`k-superpowers:verification-before-completion` with evidence proportionate to
the claim. Current-main work without an integration request reports changes in
place; use `finishing-a-development-branch` only for a real branch/worktree
integration or cleanup decision.
