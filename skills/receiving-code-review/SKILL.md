---
name: receiving-code-review
description: Use when receiving code review feedback, findings, or implementation suggestions before acting on them
---

# Receiving Code Review

Treat findings as technical claims to verify, not social commands.

<DEPENDENCY-GATE>
An unclear item blocks only findings that depend on it or may conflict with its
resolution. It must not block clear independent findings. Shared-root-cause
findings form one atomic implementation unit, not one fix per comment.
</DEPENDENCY-GATE>

## Process

1. Read all findings and restate their concrete technical requirement.
2. Check each against current code, project constraints, compatibility needs,
   tests, and prior user decisions.
3. Classify relationships:
   - `independent`: can be decided and implemented without another finding;
   - `dependent/conflicting`: an unclear decision blocks related work;
   - `shared-root-cause`: fix as one atomic batch.
4. Ask for clarification only where ambiguity affects or conflicts with the
   action. Clear independent findings may proceed.
5. Implement valid findings in dependency order with focused verification, then
   run the final verification required by the resulting claim.
6. Push back on invalid findings with file/code evidence and verification; do
   not silently ignore Critical or Important issues.

External reviewers receive extra scrutiny: check whether they saw full context,
whether the suggestion breaks supported behavior, and whether the proposed
"proper" solution has an actual caller (YAGNI).

Avoid performative agreement. Respond with the technical judgment, action, or
specific question. If later evidence disproves a pushback, state the correction
and proceed without defending the earlier position.

When replying to a GitHub inline review comment, reply in that comment thread,
not as an unrelated top-level PR comment. Use:

```bash
gh api --method POST \
  repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies \
  -f body='<reply>'
```
