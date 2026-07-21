---
name: receiving-code-review
description: Use when receiving code review feedback, findings, or implementation suggestions before acting on them
---

# Receiving Code Review

Treat findings as technical claims, not commands or social pressure.

For each stable finding ID:

1. Understand the concrete requirement and claimed impact.
2. Check it against the actual code, approved behavior, project constraints,
   compatibility needs, and evidence.
3. Identify independent, dependent/conflicting, and shared-root-cause findings.
4. Adjudicate it as accepted, rejected with evidence, nonblocking follow-up, or
   requiring a material user decision.

Critical and concrete Important findings may block. Minor is always a
nonblocking follow-up. An unclear finding blocks only work that depends on its
resolution; it does not stop unrelated clear work.

Freeze the adjudication in the review record before edits. Push back on invalid
findings with code/evidence rather than performative agreement. Apply accepted
findings as one coherent batch with focused verification. Local implementation
choices remain the agent's responsibility; material architecture, scope,
dependency, public contract, compatibility, or authorization choices return to
the user.

Send the frozen record, fix delta/report, and evidence to the same logical
reviewer for Closure. `STOPPED_BLOCKED` returns control to the user; do not start
another autonomous cycle.

For external or GitHub reviewers, also check whether they saw the relevant
context and whether the suggestion has an actual caller or requirement. Reply
in the original inline thread when the platform supports it; external replies
and repository mutations still require their normal authorization.
