# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent.

**Purpose:** Standards axis review — verify the implementation is well-built, maintainable, tested through appropriate behavior boundaries, and consistent with project conventions.

**Only dispatch after spec compliance review passes.**

```
Task tool (general-purpose):
  Use template at requesting-code-review/code-reviewer.md

  DESCRIPTION: [task summary, from implementer's report]
  PLAN_OR_REQUIREMENTS: Task N from [BRIEF_FILE]
  BASE_SHA: [commit before task]
  HEAD_SHA: [current commit]
```

**In addition to standard code quality concerns, the reviewer should check:**
- Read the implementer's detailed report at `[REPORT_FILE]` and verify claims against `[DIFF_FILE]`.
- Use `[DIFF_FILE]` as the primary diff input instead of rebuilding or pasting the diff through the controller context.
- Does each file have one clear responsibility with a well-defined interface?
- Are units decomposed so they can be understood and tested independently?
- Is the implementation following the file structure from the plan?
- Did this implementation create new files that are already large, or significantly grow existing files? (Don't flag pre-existing file sizes — focus on what this change contributed.)
- Do core structures, core functions, and core abstractions have useful explanatory comments/docs unless they are genuinely self-explanatory?
- Did the implementation avoid noisy comments that only restate obvious code?
- If any recommended fix could change behavior, public API, config, manifests,
  tests, docs, touched files, or task scope, mark it `Requires spec re-review`
  so the controller restarts at the spec axis after the fix.

**Code reviewer returns:** Strengths, Issues (Critical/Important/Minor), Assessment

**Placeholders:**
- `[BRIEF_FILE]` — task brief file from `scripts/task-brief`
- `[REPORT_FILE]` — implementer's detailed report file
- `[DIFF_FILE]` — review package file from `scripts/review-package BASE HEAD`
