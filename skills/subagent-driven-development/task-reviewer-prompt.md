# Task Reviewer Prompt Template

Use this template for the single per-task review. The reviewer reads the diff
once, checks Spec first and Standards second, and returns both verdicts.

```
Task tool (general-purpose):
  description: "Review Task N (Spec + Standards)"
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

    ## Part 1: Spec

    Check every task requirement and Global Constraint for:

    - Missing behavior or required files/manifests/docs/version updates
    - Extra, unrequested behavior or over-engineering
    - Misunderstood behavior or interfaces
    - Violations of dependency, naming, platform, verification-scope, or
      cross-cutting constraints

    If a requirement lives in unchanged code or spans tasks, report
    `Cannot verify from diff` with the smallest controller check needed. Do not
    broaden the review or assume it passed.

    ## Part 2: Standards

    Check:

    - correctness, edge cases, and error handling
    - the brief's Implementation Design Contract: concrete invalid states,
      boundary validation, error/resource ownership, and remaining runtime risk
    - DRY without premature abstraction and consistency with project patterns
    - verification of runtime risks through stable behavior entry points
    - focused tests that protect behavior rather than implementation details
    - no test demand based only on "no tests added"; name the unproved behavior
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
    direction when not obvious.

    ## Output Format

    Output only nonempty findings ordered by severity:

    [Critical|Important|Minor] [Spec|Standards] file:line
    Issue: ...
    Impact: ...
    Required fix: ...

    End with exactly:

    Spec verdict: PASS | FAIL | CANNOT_VERIFY
    Standards verdict: PASS | FAIL | CANNOT_VERIFY

    Missing, FAIL, or CANNOT_VERIFY on either axis blocks. A single fix dispatch
    may address both axes; a fresh reviewer reruns both over the new package.
```

**Placeholders:**

- `[BRIEF_FILE]` - task brief from `scripts/task-brief`
- `[REPORT_FILE]` - implementer report for the same task
- `[BASE_SHA]` - commit before the task
- `[HEAD_SHA]` - current task checkpoint commit
- `[DIFF_FILE]` - package from the public `requesting-code-review/scripts/review-package`
