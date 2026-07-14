---
name: using-superpowers
description: Use when starting any conversation
---

# Using Skills

<SUBAGENT-STOP>
Dispatched subagents executing a focused brief skip this entry skill.
</SUBAGENT-STOP>

Before any response or action, invoke every skill with a plausible fit. User
instructions and project instructions override skills; skills override default
agent behavior. Load skills through the platform's Skill tool, never by reading
their files. Use the platform mapping reference when tool names differ.

## Intent Gate

| User intent | Route |
|-------------|-------|
| Familiarize, inspect, learn, or wait for later requirements | Read requested context, summarize if useful, then stop; no design/implementation skill |
| Bug, failing test, or unexpected behavior | `k-superpowers:systematic-debugging` first; after root cause, obtain Compact/Full design approval before behavior edits |
| Feature, behavior, component, or configuration change | `k-superpowers:brainstorming` |
| Applicable domain/process skill | Invoke it before acting |

Preparation-only examples include “先熟悉模块”“先看规范”“等我给需求”. Do not ask
design questions or create specs/plans for them.

## Priority

Use process skills before implementation/domain skills. If a loaded skill has a
checklist, track only applicable items. Announce which skill is being used and
follow its current body; knowing or remembering a skill is not invoking it.

Before platform plan mode for change work, design must already be approved via
`k-superpowers:brainstorming`.
