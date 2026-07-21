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
| Approved persistent plan | `k-superpowers:executing-plans`, or SDD only when explicitly selected and beneficial |
| Explicitly named skill | Use it unless it conflicts with a higher-priority instruction or is unavailable |

Preparation/read-only work may use any operation the agent can establish is
non-mutating. It does not enter design or implementation merely because a
related skill exists.

## Direct Implementation

Use Direct when the approved change is clear, reversible, confined to one
problem domain, and has no unresolved architecture, scope, dependency, public
contract, compatibility, security, or permission decision.

The safe default is:

```text
current workspace + Inline + no commit
```

Before editing, inspect relevant project instructions and detect overlap with
pre-existing user changes. Stop only for a real conflict or material decision.
Load a domain skill such as `type-driven-verification` only when the actual code
change needs its contract. Implement, perform bounded verification, and hand the
result back for real use.

An implementation request authorizes in-scope file edits, not commit, push,
merge, PR, amend, force, destructive cleanup, or unrelated work. Ask only when
an action needs additional authority or a choice would materially change the
result.

## Skill Use

When a task skill is needed, use the current owner before actions governed by
it. Communicate skill use concisely when the platform requires disclosure; do
not impose a fixed announcement phrase or tool-call sequence. Preserve exact
output formats only when the user or a real external protocol requires them.
