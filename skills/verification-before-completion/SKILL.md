---
name: verification-before-completion
description: Use when assessing the evidence for a completion, fix, passing check, or integration claim
---

# Verification before completion

Apply this principle as work progresses. Before reporting an outcome, match
each material claim to evidence for the final relevant code, inputs and
environment. Reuse current evidence. Repeat the affected check when those
conditions or the claim change.

- A fix needs the symptom or a reliable proxy checked against the corrected behavior.
- A build or test claim names the command and its actual result.
- Check caller-visible outcomes against the agreed requirements and any owning
  spec. Surface a material divergence before declaring the change complete.
- An independent source trace can support a business case. Runtime claims
  require runtime evidence.

Inspect the results and meaningful warnings. State any gap precisely, including
the limits of partial or delegated checks. Git actions require their usual
authorization after verification.
