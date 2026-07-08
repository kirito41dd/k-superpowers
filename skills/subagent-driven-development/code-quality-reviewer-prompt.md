# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent.

**Purpose:** Standards axis review — verify the implementation is well-built, maintainable, tested through appropriate behavior boundaries, and consistent with project conventions.

**Only dispatch after spec compliance review passes.**

```
Task tool (general-purpose):
  description: "Review code quality for Task N"
  prompt: |
    You are reviewing one task's implementation on the Standards axis only.
    Spec compliance already passed. Your job is to decide whether the
    implementation is well-built, maintainable, verified through appropriate
    behavior boundaries, and consistent with project conventions.

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
    the change. The diff's context lines ARE the changed files; do not read a
    changed file separately unless a hunk you must judge is cut off
    mid-function, and say so in your report. Do not mutate the working tree,
    index, HEAD, or branch state. Inspect code outside the diff only to
    evaluate one concrete standards risk you can name, and report both the risk
    and what you checked. Do not re-run git commands.

    ## Do Not Trust the Report

    Treat the implementer's report as unverified claims. Verify claims against
    the diff. Design rationales in the report are claims too: "left it per
    YAGNI", "kept it simple deliberately", or similar explanations do not
    downgrade a finding's severity.

    ## Verification Evidence

    The implementer already ran verification and reported results for this
    code. Do not re-run broad suites to confirm their report. Run a command
    only when reading the code raises a specific doubt that no existing run
    answers; use a focused command, not a package-wide suite, race detector run,
    or repeated/high-count loop. If heavy validation seems warranted, recommend
    it in your report instead of running it. Warnings or other noise in the
    reported output are findings.

    ## What To Check

    **Code quality:**
    - Clean separation of concerns?
    - Proper error handling?
    - DRY without premature abstraction?
    - Edge cases handled?
    - Type safety and ownership/visibility boundaries preserved where applicable?

    **Tests and verification:**
    - Do new or changed tests verify real behavior, not mocks?
    - Are tests focused on stable entry points where possible?
    - Does verification cover the runtime risks the task identified?
    - Is verification output clean?

    **Structure and maintainability:**
    - Does each file have one clear responsibility with a well-defined interface?
    - Are units decomposed so they can be understood and tested independently?
    - Is the implementation following the file structure from the plan?
    - Did this implementation create new files that are already large, or
      significantly grow existing files? Do not flag pre-existing file sizes;
      focus on what this change contributed.
    - Do core structures, core functions, and core abstractions have useful
      explanatory comments/docs unless they are genuinely self-explanatory?
    - Did the implementation avoid noisy comments that only restate obvious
      code?

    If any recommended fix could change behavior, public API, config,
    manifests, tests, docs, touched files, or task scope, mark it
    `Requires spec re-review` so the controller restarts at the spec axis after
    the fix.

    ## Calibration

    Categorize issues by actual severity. Not everything is Critical.
    Important means this task cannot be trusted until it is fixed: incorrect or
    fragile behavior, maintainability damage you would block a merge over,
    swallowed errors, tests that assert nothing, or significant convention
    violations. "Coverage could be broader" and polish suggestions are Minor.

    Acknowledge what was done well before listing issues. Every finding needs a
    file:line reference, what is wrong, why it matters, and how to fix it if
    not obvious.

    ## Output Format

    ### Strengths
    [What's well done? Be specific.]

    ### Issues

    #### Critical (Must Fix)
    #### Important (Should Fix)
    #### Minor (Nice to Have)

    ### Assessment

    **Task quality:** [Approved | Needs fixes]

    **Reasoning:** [1-2 sentence technical assessment]
```

**Code reviewer returns:** Strengths, Issues (Critical/Important/Minor), Assessment

**Placeholders:**
- `[BRIEF_FILE]` — task brief file from `scripts/task-brief`
- `[REPORT_FILE]` — implementer's detailed report file
- `[BASE_SHA]` — commit before this task or fix round
- `[HEAD_SHA]` — current commit
- `[DIFF_FILE]` — review package file from `scripts/review-package BASE HEAD`
