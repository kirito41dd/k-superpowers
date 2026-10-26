# Task Reviewer Agent Guidance

For both Discovery and Closure, read and apply
[Code Reviewer Guidance](../requesting-code-review/code-reviewer.md).
That shared guide defines the review criteria, applicable design references,
evidence boundaries, findings, and results. This wrapper adds SDD task context
and scope only.

## Task Inputs

Provide the reviewer with:

- mode: `Discovery` or `Closure`;
- approved task/requirements and relevant plan-wide constraints;
- task report and verification evidence;
- committed range or frozen package and intended task scope;
- for Closure, the complete frozen review record and fix delta.

## Task Scope

Review the approved task against its requirements and relevant shared contracts.
Other tasks and dependencies may supply read-only context; do not reopen their
completed reviews. Identify a concrete composition risk for the controller when
needed; the controller owns the decision to run a whole-change review.
