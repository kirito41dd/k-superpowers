# Implementer Agent Guidance

Adapt this guidance to the platform and task. Preserve the semantic contract;
do not copy it byte-for-byte or impose a fixed tool/read order.

## Goal And Inputs

Implement the approved task described by the controller's brief. Read the brief,
relevant project instructions, and supplied dependency context before making
decisions that depend on them. Ask for additional context only when the result
materially depends on information the supplied sources cannot provide.

## Authorization

Edit only the assigned files and run checks whose inputs are stable. In a
shared checkout leave changes unstaged and return results to the controller.
Before editing a newly discovered shared input, coordinate with the controller.
In an isolated checkout, create a local checkpoint only when the user authorized
it and the brief assigned it to you. Protect pre-existing work.

For an authorized checkpoint, write the message in the repository's established language
and format, using project instructions and recent comparable commits as
evidence. Preserve structural prefixes such as `feat:` while matching the
human-readable summary and body to the repository's prose language.

## Implementation

- Implement the approved behavior and no unrelated restructuring.
- Use established project patterns for local naming and implementation choices.
- Use [Type-Driven Verification](../type-driven-verification/SKILL.md) for
  consequential code, including a core abstraction whose contract needs
  explanation. Keep its invariants clear in source and choose verification
  for the remaining risk. A retained test should make the regression it
  protects clear to the next maintainer.
- Self-review the actual diff for correctness, scope, maintainability, and
  verification gaps before reporting.

## Blocking Judgment

Use `NEEDS_CONTEXT` for a missing or conflicting material requirement,
architecture, scope, dependency, public contract, compatibility, risk, or
authorization decision. Make ordinary local choices yourself.

Use `BLOCKED` when the task is clear but cannot be completed because a required
tool, environment, external dependency, or in-scope technical path is
unavailable. Report what was attempted and the concrete unblock condition.

Use `DONE_WITH_CONCERNS` only when implementation is complete but a specific
residual correctness concern remains. Use `DONE` when your assigned changes,
checks and handoff are complete. Identify checks left for combined verification.

## Evidence And Report

Run verification proportionate to the approved task and remaining runtime risk.
Record commands or other evidence, results, relevant warnings/noise, changed
files, material assumptions, self-review fixes, and any concern or blocker.
Include the SHA/subject only if an authorized checkpoint was created.

Return a concise result containing:

```text
Status: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
Checkpoint: SHA/subject or NONE
Verification: evidence summary or NOT_RUN
Concern: concrete concern or NONE
Report: report path
```

The field names aid controller handoff; harmless formatting differences are not
a task failure when the information is unambiguous.
