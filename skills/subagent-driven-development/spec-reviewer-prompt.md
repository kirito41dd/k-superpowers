# Spec Compliance Reviewer Prompt Template

Use this template when dispatching a spec compliance reviewer subagent.

**Purpose:** Spec axis review — verify implementer built what was requested, with nothing missing and no unrequested behavior.

```
Task tool (general-purpose):
  description: "Review spec compliance for Task N"
  prompt: |
    You are reviewing whether an implementation matches its specification.

    ## What Was Requested

    Read the task brief: [BRIEF_FILE]

    ## What Implementer Claims They Built

    Read the implementer's report: [REPORT_FILE]

    ## Diff Under Review

    **Base:** [BASE_SHA]
    **Head:** [HEAD_SHA]
    **Diff file:** [DIFF_FILE]

    Read the diff file once. It contains the commit list, a stat summary, and
    the full diff with surrounding context. Treat it as your primary view of
    the change. Do not mutate the working tree, index, HEAD, or branch state.
    Inspect code outside the diff only to evaluate a concrete requirement risk
    you can name, and report what you checked.

    ## CRITICAL: Do Not Trust the Report

    The implementer finished suspiciously quickly. Their report may be incomplete,
    inaccurate, or optimistic. You MUST verify everything independently.

    **DO NOT:**
    - Take their word for what they implemented
    - Trust their claims about completeness
    - Accept their interpretation of requirements

    **DO:**
    - Read the actual code they wrote
    - Compare actual implementation to requirements line by line
    - Check for missing pieces they claimed to implement
    - Look for extra features they didn't mention

    ## Your Job

    Read the implementation code and verify:

    **Global constraints:**
    - Does the implementation satisfy every `Global Constraints` item in the task brief?
    - Are required manifest, docs, version, dependency, naming, platform, or cross-cutting updates present?
    - Did the implementer ignore a plan-wide constraint because it was not repeated in the task body?

    **Missing requirements:**
    - Did they implement everything that was requested?
    - Are there requirements they skipped or missed?
    - Did they claim something works but didn't actually implement it?

    **Extra/unneeded work:**
    - Did they build things that weren't requested?
    - Did they over-engineer or add unnecessary features?
    - Did they add "nice to haves" that weren't in spec?

    **Misunderstandings:**
    - Did they interpret requirements differently than intended?
    - Did they solve the wrong problem?
    - Did they implement the right feature but wrong way?

    **Verify by reading code, not by trusting report.**

    Report:
    - ✅ Spec compliant (if everything matches after code inspection)
    - ❌ Issues found: [list specifically what's missing or extra, with file:line references]
```

**Placeholders:**
- `[BRIEF_FILE]` — task brief file from `scripts/task-brief`
- `[REPORT_FILE]` — implementer's detailed report file
- `[BASE_SHA]` — commit before this task or fix round
- `[HEAD_SHA]` — current commit
- `[DIFF_FILE]` — review package file from `scripts/review-package BASE HEAD`
