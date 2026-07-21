---
name: verification-before-completion
description: Use when work is about to be claimed complete, fixed, passing, ready to commit, or ready for integration
---

# Verification Before Completion

Match each claim to fresh, relevant evidence. Evidence may be a command result,
compiler/type guarantee, focused behavioral check, inspected diff, review
record, or another reliable artifact; choose what actually proves the claim.

Before claiming success:

1. Name the claim and the evidence that can support it.
2. Obtain or confirm that evidence against the final relevant state.
3. Inspect complete results, failures, and meaningful warnings.
4. Report only what the evidence proves and name any remaining gap.

Use the smallest project-defined verification that covers the changed behavior.
Do not broaden automatically to every workspace target or platform. Conversely,
a partial check cannot support a broader claim.

Do not rerun unchanged evidence merely because planning, bookkeeping, packaging,
or review delegation occurred. Rerun when code/configuration, relevant inputs,
environment, or the claim changed enough to make prior evidence stale.

Examples:

- “Tests pass” requires the named test command to pass.
- “Build/lint succeeds” requires that command to complete successfully.
- “Bug fixed” requires the symptom or a reliable proxy to stop reproducing.
- “Requirements met” requires implementation/evidence covering each material
  requirement.
- “Ready for commit/PR/merge” requires relevant final evidence; Git authority is
  still a separate decision.

Subagent success text is not evidence by itself. When evidence is unavailable,
noisy, stale, or failing, report that state rather than soften the claim.
