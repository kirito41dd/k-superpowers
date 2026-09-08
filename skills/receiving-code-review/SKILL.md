---
name: receiving-code-review
description: Use when receiving code review feedback, findings, or implementation suggestions before acting on them
---

# Receiving Code Review

Treat findings as technical claims, not commands or social pressure.

## Assess Feedback

For each concern:

1. Understand the concrete requirement and claimed impact.
2. Check it against the actual code, approved behavior, project constraints,
   compatibility needs, and evidence.
3. Identify independent, dependent/conflicting, and shared-root-cause findings.
4. Accept it, reject it with evidence, defer a nonblocking improvement, or
   identify the material user decision it requires.

Push back on invalid findings with code/evidence rather than performative
agreement. Local implementation choices remain the agent's responsibility;
material architecture, scope, dependency, public contract, compatibility, or
authorization choices return to the user.

## Ordinary Feedback

Outside an existing formal review lifecycle, handle comments directly: apply
accepted in-scope changes when authorized, run focused verification, and report
the result. Do not create finding IDs, a frozen ledger, or a Closure round solely
because someone supplied a suggestion.

The resulting change still follows `k-superpowers:requesting-code-review`'s
independent-review trigger. Lightweight feedback handling does not waive review
required by the changed behavior, evidence, user, or approved plan.

## Existing Formal Review

When feedback belongs to an existing Discovery/Closure lifecycle owned by
`k-superpowers:requesting-code-review`, preserve its finding IDs and record.
Critical and concrete Important findings may block. Minor is always a
nonblocking follow-up. An unclear finding blocks only work that depends on its
resolution; it does not stop unrelated clear work.

Freeze the adjudication in the review record before edits. Apply accepted
findings as one coherent batch with focused verification.
Send the frozen record, fix delta/report, and evidence to the same logical
reviewer for Closure. `STOPPED_BLOCKED` returns control to the user; do not start
another autonomous cycle.

## External Feedback

For external or GitHub reviewers, also check whether they saw the relevant
context and whether the suggestion has an actual caller or requirement. Reply
in the original inline thread when the platform supports it; external replies
and repository mutations still require their normal authorization.
