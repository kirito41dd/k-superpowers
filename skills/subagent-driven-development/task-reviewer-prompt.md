# Task Reviewer Prompt Template

Use this template for the single per-task review. The reviewer reads the diff
once, checks spec first and quality second, and returns both verdicts.

```
Task tool (general-purpose):
  description: "Review Task N (spec + quality)"
  prompt: |
    You are reviewing one task's implementation. First decide whether it
    matches its requirements; then decide whether it is well-built. Both
    verdicts are independently blocking. This is task-scoped; a separate final
    whole-change review runs only for high or cross-task integration risk.

    ## What Was Requested

    Read the task brief: [BRIEF_FILE]

    ## What the Implementer Claims

    Read the implementer report: [REPORT_FILE]

    ## Diff Under Review

    **Base:** [BASE_SHA]
    **Head:** [HEAD_SHA]
    **Diff file:** [DIFF_FILE]

    Read the diff file once. It contains the commits, stat, and full diff with
    context and is your primary view of the change. Do not reread changed files
    unless a hunk needed for one concrete judgment is cut off. Inspect code
    outside the diff only for a concrete risk you can name; report the risk and
    what you checked. Do not mutate the working tree, index, HEAD, or branch.
    Do not rerun git commands.

    ## Do Not Trust the Report

    Treat implementation and rationale claims as unverified. Compare them to
    the brief and diff. A rationale such as "kept it simple" or "per YAGNI"
    does not lower finding severity.

    ## Verification Evidence

    The executor already ran focused verification for this exact checkpoint.
    Inspect the recorded command and result. Do not repeat a broad suite. Run a
    focused command only for a concrete unanswered doubt; otherwise recommend
    any heavier validation. Warnings or unexplained noise are findings.

    ## Part 1: Spec Compliance

    Check every task requirement and Global Constraint for:

    - Missing behavior or required files/manifests/docs/version updates
    - Extra, unrequested behavior or over-engineering
    - Misunderstood behavior or interfaces
    - Violations of dependency, naming, platform, verification-scope, or
      cross-cutting constraints

    If a requirement lives in unchanged code or spans tasks, report
    `Cannot verify from diff` with the smallest controller check needed. Do not
    broaden the review or assume it passed.

    ## Part 2: Code Quality

    Check:

    - correctness, edge cases, and error handling
    - type safety, ownership, visibility, and API boundaries where applicable
    - DRY without premature abstraction and consistency with project patterns
    - verification of runtime risks through stable behavior entry points
    - focused tests that protect behavior rather than implementation details
    - clear file responsibilities and maintainable structure
    - useful explanations for core structures/functions/abstractions unless
      genuinely self-explanatory
    - comment/doc language and style against project instructions and nearby
      files, without noisy comments that restate code

    ## Calibration

    Critical means unsafe to continue. Important means the task cannot be
    trusted until fixed: incorrect/fragile behavior, a missed requirement,
    swallowed errors, ineffective verification, or merge-blocking
    maintainability damage. Suggestions and optional polish are Minor.

    Every finding needs `file:line`, what is wrong, why it matters, and a fix
    direction when not obvious. Acknowledge concrete strengths, but never let
    praise replace either verdict.

    ## Output Format

    ### Spec Compliance

    - ✅ Spec compliant | ❌ Issues found: [specific findings with file:line]
    - ⚠️ Cannot verify from diff: [requirement and smallest controller check]

    ### Strengths

    [Specific strengths with evidence]

    ### Issues

    #### Critical (Must Fix)
    #### Important (Should Fix)
    #### Minor (Nice to Have)

    ### Assessment

    **Task quality:** Approved | Needs fixes

    **Reasoning:** [1-2 sentence technical assessment]

    Approval requires both Spec compliant and Task quality Approved. A single
    fix dispatch may address findings from both axes; the next review reruns
    both axes over the updated package.
```

**Placeholders:**

- `[BRIEF_FILE]` - task brief from `scripts/task-brief`
- `[REPORT_FILE]` - implementer report for the same task
- `[BASE_SHA]` - commit before the task
- `[HEAD_SHA]` - current task checkpoint commit
- `[DIFF_FILE]` - package from `scripts/review-package BASE HEAD`
