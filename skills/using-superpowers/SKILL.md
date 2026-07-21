---
name: using-superpowers
description: Use when starting any conversation
---

# Using Skills

<SUBAGENT-STOP>
Dispatched subagents executing a focused brief skip this entry skill.
</SUBAGENT-STOP>

Classify current intent before responding or acting. Select the minimal
sufficient set: one current process owner plus only domain owners needed now.
`no task skill` is valid. Plausible future relevance is not a trigger; never
preload later phases or mutually exclusive paths.

User and project instructions override skills; skills override default agent
behavior.

## Exact Output Gate

When a request supplies an exact bounded response schema, keep reasoning
internal. All visible assistant text on a task-skill route is limited to:

- `Using k-superpowers:<skill-name>.` in the same decision or message as that
  exact skill call; and
- the requested terminal schema after every selected skill result.

Add no rationale, generic "required skill" wording, sequencing promise, or
other preamble. This gate adds no ceremony to a no-task route.

<EXACT-OUTPUT-HARD-GATE>
A skill announcement is a literal protocol frame. Before the tool call, the
entire visible text block is exactly `Using k-superpowers:<skill-name>.` Add no
prefix, suffix, promise, rationale, companion text, or wording such as “I’ll
announce”, “I’ll invoke”, or “I’ll use”.

On a no-task or read-only route with an exact bounded response schema, keep
permitted reads and reasoning silent; the terminal schema is the only visible
text. A preparation/read-only request without such a schema may use concise
progress text.
</EXACT-OUTPUT-HARD-GATE>

A mandatory platform or session notice is outside task-skill ceremony and takes
priority over this gate. Emit that notice exactly once where the platform
requires it, including before an otherwise exact or no-task first reply; then
apply the requested response schema to the task output. It is the only permitted
extra visible text unless the user explicitly requests more.

## Unified Handoff Gate

The handoff message already supplies the controller and workspace route. Execute
it as two result-gated assistant decisions, never one batched selection:

1. In the first decision, announce and invoke only the selected controller:
   `k-superpowers:subagent-driven-development` or
   `k-superpowers:executing-plans`. Do not announce, select, or invoke another
   skill. Wait for the controller skill's completed result.
2. Only after that result, begin a new assistant decision and announce and invoke
   `k-superpowers:using-git-worktrees` with the handoff's workspace choice. Wait
   for its completed result.

Before both return, do not read the plan, inspect the workspace, or take another
non-skill action. Never invoke the alternative controller or reconfirm the
handoff. If the user defines this as a bounded handoff checkpoint and says to
stop after both skill results, emit its terminal schema before any workspace
tool. Loading the workspace owner does not itself authorize an inspection in
that checkpoint.

## Intent Gate

| User intent                                                                             | Route                                                                                                                                          |
| --------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| Ordinary question answerable from current knowledge                                     | Answer directly in the user's requested response shape; no task skill or workflow ceremony                                                     |
| Familiarize, inspect, explain, review, report status, or wait without changing behavior | Perform only the requested read-only work, then stop; no design or implementation skill                                                        |
| Bug, failing test, or unexpected behavior                                               | `k-superpowers:systematic-debugging` first; do not preload design. After root cause, obtain Compact/Full design approval before behavior edits |
| Feature, behavior, component, or configuration change                                   | `k-superpowers:brainstorming`; do not preload planning or execution                                                                            |
| Approved design/spec whose requested next step is a plan                                | `k-superpowers:writing-plans` only                                                                                                             |
| Explicitly named skill or another specialized task                                      | Invoke the requested/current owner; add a prerequisite or domain owner only when the current action requires it                                |

Preparation-only and read-only routes use only platform-recognized read/search
tools. Never use `Edit`, `Write`, `NotebookEdit`, or another write tool. If the
platform cannot safely classify a shell call or other tool as read-only, do not
run it.

For a no-task answer, obey explicit output constraints literally. "Only the
result" excludes restating the expression or adding an explanation.

Preparation-only examples include “先熟悉模块”“先看规范”“等我给需求”. Do not ask
design questions or create specs/plans for them. A read-only route ends after the
answer or report unless the user separately requests a change.

When uncertainty about a behavior change would alter the route, ask one blocking
question; otherwise proceed with the selected state.

## Invocation

After the Intent Gate selects a task skill, invoke it and wait for its result
before any non-skill tool or other task action, including reading or searching.
The selected owner decides which context to inspect next. For approved-spec
planning, the user's stated approval and requested next step are sufficient
routing evidence; do not inspect the spec merely to reconfirm the route.
`k-superpowers:writing-plans` reads the spec and its Flow after loading.

Load selected task skills through the platform skill tool, never by reading their
files. Use the platform mapping reference when tool names differ. Invoke the
process owner before implementation/domain skills. Track only applicable
checklist items. If the platform requires a task-skill announcement, use the
Exact Output Gate's call-bound form. A no-task answer has no skill ceremony.
Remembering a skill is not invoking it.

Before platform plan mode for change work, design must already be approved via
`k-superpowers:brainstorming`.
