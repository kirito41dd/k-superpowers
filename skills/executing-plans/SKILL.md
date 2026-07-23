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
core structures, functions, or abstractions need its design and explanation
guidance.

Run focused verification as the work progresses. Before completion, inspect the
actual diff once across Spec and Standards. Use an independent reviewer when the
completed change matches `k-superpowers:requesting-code-review`'s trigger, the
approved plan or user requests one, or concrete new evidence makes independent
judgment materially valuable. Skip independent review only for the clearly
low-risk exclusions defined by that owner.

When review is required, follow `k-superpowers:requesting-code-review`'s bounded
Discovery/Closure lifecycle. Same-controller review may inspect requirements,
the current diff, relevant context, and evidence directly. Use a frozen package
when crossing contexts or stabilizing a moving working tree is useful. A
stopped closure returns control to the user and does not start another
autonomous cycle.

Before claiming the whole change complete, use
`k-superpowers:verification-before-completion` with evidence proportionate to
the claim. Current-main work without an integration request reports changes in
place; use `finishing-a-development-branch` only for a real branch/worktree
integration or cleanup decision.
