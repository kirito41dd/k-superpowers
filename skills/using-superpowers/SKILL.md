---
name: using-superpowers
description: Use when starting any conversation
---

# Using Skills

<SUBAGENT-STOP>
Dispatched agents executing a focused brief skip this entry skill.
</SUBAGENT-STOP>

Choose the smallest useful capability for the user's current intent. Skills
guide an intelligent agent; they are not a mandatory ceremony or a substitute
for judgment. User and project instructions override skills.

`no task skill` is a valid route. Do not load a skill because it may become
useful later, and do not load mutually exclusive execution paths together.

## Intent

| Intent | Route |
|---|---|
| Ordinary question answerable from current knowledge | Answer directly |
| Familiarize, inspect, explain, review, or report status | Perform only the requested non-mutating work, then stop |
| Bug or unexpected behavior | `k-superpowers:systematic-debugging` |
| Behavior change without approved design | `k-superpowers:brainstorming` |
| Approved clear, bounded change with an implementation request | Direct implementation in the current workspace, no commit |
| Approved multi-step change whose independent slices make durable handoff or delegation useful | `k-superpowers:writing-plans` |
| Approved persistent plan without an execution choice | `k-superpowers:writing-plans` for handoff |
| Approved plan with Inline selected | `k-superpowers:executing-plans` |
| Approved plan with SDD selected and checkpoint commits authorized | `k-superpowers:subagent-driven-development` |
| Explicitly named skill | Use it unless it conflicts with a higher-priority instruction or is unavailable |

Preparation/read-only work may use any operation the agent can establish is
non-mutating. It does not enter design or implementation merely because a
related skill exists.

## Direct Implementation

Use Direct when the approved change is clear, reversible, confined to one
problem domain, and has no unresolved architecture, scope, dependency, public
contract, compatibility, security, or permission decision.

Before choosing Direct, check once whether independently deliverable scopes and
a concrete delegation benefit make a persistent plan useful. If so, use
`k-superpowers:writing-plans` instead.

The safe default is:

```text
current workspace + Inline + no commit
```

Before editing, inspect relevant project instructions and detect overlap with
pre-existing user changes. Stop only for a real conflict or material decision.
Before code edits, load `k-superpowers:type-driven-verification` when the change
contains consequential domain behavior, public boundaries, parsers, protocols,
state, resources, or introduces or modifies a non-self-explanatory core
structure, function, or abstraction. Implement and perform bounded verification.

Before completion, inspect the actual diff once across Spec and Standards. When
the completed change matches `k-superpowers:requesting-code-review`'s trigger,
or the user or approved design requests independent judgment, use its bounded
two-axis review lifecycle before handing the result back.

An implementation request authorizes in-scope file edits, not commit, push,
merge, PR, amend, force, destructive cleanup, or unrelated work. Ask only when
an action needs additional authority or a choice would materially change the
result.

## Skill Use

When a task skill is needed, use the current owner before actions governed by
it. Communicate skill use concisely when the platform requires disclosure; do
not impose a fixed announcement phrase or tool-call sequence. Preserve exact
output formats only when the user or a real external protocol requires them.
