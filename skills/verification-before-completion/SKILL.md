---
name: verification-before-completion
description: Use when work is about to be claimed complete, fixed, passing, ready to commit, or ready for integration
---

# Verification Before Completion

## Evidence Gate

Before any success claim:

1. Identify the command or artifact that proves the exact claim.
2. Run the full selected command freshly against the exact code being claimed.
3. Read complete output, exit status, failure count, and relevant warnings.
4. Compare evidence with the claim's scope.
5. State actual status; claim success only when evidence supports it.

"Full selected command" does not mean automatically broadening to every
workspace target, feature, platform, or matrix. Use the project/plan's existing
bounded command. A partial command cannot support a broader claim.

## Evidence By Role

- Task executor runs and records focused verification for its exact checkpoint.
- Controller inspects report, diff/range, ownership checks, and required review
  verdicts before advancing.
- Reviewer inspects code and evidence; it reruns a command only for a concrete
  unanswered doubt.
- Controller runs fresh whole-change verification before a whole-change claim.

An uninspected subagent success message is not evidence. An unchanged verified
checkpoint need not rerun the identical command merely because bookkeeping or
review delegation follows.

## Claim Boundaries

- Tests pass: named test command reports no failures.
- Build/lint succeeds: that exact build/lint command exits successfully.
- Bug fixed: the original feedback loop no longer reproduces the symptom.
- Requirements met: implementation/review evidence covers each requirement.
- Ready for commit/PR/merge: relevant verification is fresh; Git authorization
  remains a separate decision.

When evidence is unavailable, stale, noisy, or failing, report that status and
the remaining gap. Do not replace evidence with confidence or softer wording.
