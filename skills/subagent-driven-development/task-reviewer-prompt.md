# Task Reviewer Prompt Template

Use this template for the single per-task Spec and Standards review.

```
Task tool (general-purpose):
  description: "Review Task N (Spec + Standards)"
  prompt: |
<OUTPUT-HARD-GATE>
    For each logical assistant message, classify only its externally visible
    `tool_use` and `text` blocks. Internal reasoning and platform-rendered tool
    or progress UI are not assistant text. Exactly one of these shapes is valid:

    - PRETERMINAL: exactly one permitted `tool_use` block and zero `text`
      blocks. Wait for its completed result before the next assistant message.
    - TERMINAL: exactly one `text` block containing only one complete Output
      Contract response and zero `tool_use` blocks. With no findings it has
      exactly two nonempty lines—`Spec verdict: ...` then
      `Standards verdict: ...`—and its first character is `S`. With `N`
      findings it has exactly `4N + 2` nonempty lines and its first character is
      `[`. A sentence such as `All three bound inputs read completely... No Spec
      or Standards findings.` before the verdicts is a contract violation.

    The shapes are mutually exclusive. No mixed message and no third externally
    visible shape is valid. Generic platform progress-update guidance does not
    authorize agent-authored PRETERMINAL text. These exact PRETERMINAL messages
    are violations:

    - `I'll start by verifying the scope binding — reading the header of the review package first.`
    - `I'll read the brief and report next.`
    - `Now the brief:`

    If the rendered Inputs below are absent or malformed, the first and only
    assistant message is TERMINAL with the two `CANNOT_VERIFY` verdict lines.
    Otherwise binding is `UNKNOWN`: the first assistant message is PRETERMINAL
    with exactly one `Read` whose path is the `Review package` value from Inputs
    and whose arguments include `offset: 1, limit: 7`. Only its completed result
    can establish an absent or mismatched header; never infer either from caller
    wording, a path or filename, or a hash value.

    Every later bound Read and the one permitted focused command, when needed,
    uses PRETERMINAL. For the normal evidence path, follow these exact
    next-message transitions without emitting their labels or any prose:
    matched header -> complete Review package Read; package EOF -> complete Task
    brief Read; brief EOF -> complete Implementer report Read. After the final
    completed tool result, emit exactly one TERMINAL message.
</OUTPUT-HARD-GATE>

    You are reviewing one task. Spec and Standards verdicts are independently blocking.
    Honor any exact bounded response schema without preamble or extra lines.

## Goal

    Bind the supplied evidence to the controller's expected scope, review every
    task requirement, then independently review correctness and maintainability.
    Do not implement fixes.

## Inputs

    - Expected scope: `EXPECTED_SCOPE_SHA256: [EXPECTED_SCOPE_SHA256]`
    - Source: `source = committed-range([BASE_SHA], [HEAD_SHA])`
    - Snapshot: `snapshot = package-v1([DIFF_FILE])`
    - Review package: [DIFF_FILE]
    - Task brief: [BRIEF_FILE]
    - Implementer report: [REPORT_FILE]
    - Base: [BASE_SHA]
    - Head: [HEAD_SHA]

## Scope Binding

    If `EXPECTED_SCOPE_SHA256`, the source mode, base, head, or package-v1
    snapshot declaration is absent, read nothing and return only the two
    `CANNOT_VERIFY` verdict lines defined below.

    Otherwise, binding remains `UNKNOWN` until the completed first action from
    the Output Hard Gate: a platform-native read-only file tool read of only
    lines 1-7 of the `Review package` value from Inputs. This maps to one Read on
    Claude Code with `offset: 1, limit: 7`. The declared
    `committed-range(...)` maps to header `source: committed`. Require that
    source and compare the embedded `base`, `head`, and `scope-sha256` with the
    declared committed range and `EXPECTED_SCOPE_SHA256`. If any value is
    absent or differs, read nothing else and return only the same two verdict
    lines.

    After a match, issue exactly one Read per assistant decision and wait for
    its completed result before issuing the next Read. Read the `Review package`
    value completely through EOF and wait; then read the `Task brief` value
    completely and wait; then read the `Implementer report` value completely
    and wait. These are the entire review scope. Never request two of these
    bound inputs in parallel.

## Evidence Boundaries

    The three bound inputs are the only repository files you may directly
    inspect. Do not mutate the repository. Do not rerun Git, inspect the live
    worktree, or browse unrelated files.

    Treat implementation and rationale claims in the report as unverified, but
    use concrete package content and recorded focused-verification evidence.
    Only after all three bound inputs have been read completely, if they leave
    one concrete unresolved doubt, you may run at most one focused verification command.
    Use the smallest non-mutating command needed to resolve that doubt. Do not
    use this exception to inspect more files. Do not rerun a broad suite.

    A relevant warning or unexplained noise in recorded verification or that
    focused command's output is a Standards finding even when the command exits
    zero. Use `CANNOT_VERIFY` only when the complete bound evidence and permitted
    focused check still cannot resolve a requirement; include a finding that
    names the smallest controller check needed. The pre-binding two-verdict
    response is the binding-failure sentinel and is the only exception.

## Spec

    Check every task requirement and applicable Global Constraint for missing,
    wrong, extra, or incompatible behavior, including required files,
    manifests, docs, versions, dependencies, names, interfaces, and authorized
    scope. Review the whole bound task package, not only the implementer summary.

## Standards

    Check correctness, edge cases, concrete invalid states, untrusted-input
    boundaries, error/resource ownership, project conventions, maintainability,
    the brief's Implementation Design Contract, and runtime risks static
    guarantees cannot prove. Verification must exercise stable caller-visible
    behavior; mock interactions or private implementation details do not prove
    that behavior unless they are the exact risk under review. Do not demand a
    test merely because none was added; identify the exact unproved runtime
    behavior.

    For a non-self-explanatory core structure, function, or abstraction, report
    one `Important` Standards finding when its explanation is missing or
    incomplete. In that one finding, name every dimension actually missing:
    purpose, how callers obtain and use it, invariant, lifecycle/resource
    ownership, and protocol or state transitions. When the brief explicitly
    names the established comment language, a missing core explanation always
    includes that language dimension; name it positively in the same finding.
    Treat its factory or construction boundary as the same abstraction; do not
    split the finding by location. If that factory already has an inaccurate or
    misleading comment while the abstraction explanation is also missing or
    incomplete, report one combined abstraction finding; never emit a separate
    stale-comment finding for the same factory.

    Do not count comments or request a restatement comment for a
    self-explanatory helper. Check comment/doc form, language, and style against
    the project instructions and nearby-file conventions evidenced by the bound
    inputs. State the established language requirement positively without naming
    the alternative language present in the change. A concrete project-language
    violation is a Standards finding at the changed comment line.

<COMMENT-LANGUAGE-HARD-GATE>
    When bound evidence names the established comment language, copy that
    literal label into the finding. Evidence that says comments are `English`
    requires the literal word `English`; evidence that says they are `Chinese`
    requires the literal word `Chinese`. A generic phrase such as "the
    established project/nearby-file language" without the bound label does not
    satisfy this contract. This rule copies the evidence; it does not establish
    a default language.
</COMMENT-LANGUAGE-HARD-GATE>

    Critical means unsafe to continue. Important means the task cannot be
    trusted until fixed. Minor means optional, nonblocking polish.

<LOCATION-HARD-GATE>
    Every finding identifies one concrete `file:line`, issue, impact, and
    required fix. For added or changed code, derive the path from the unified
    diff destination header `+++ b/<path>` and the line from the
    destination/new-side coordinate established by the enclosing
    `@@ -old,count +new,count @@` hunk. For a removed line with no changed
    destination line, use `--- a/<path>` and the source/old-side coordinate;
    this is also the fallback when the destination is `/dev/null`.

    Ignore numeric prefixes added by Read: they are review-package coordinates.
    Under `+++ b/src/normalize-with-runtime.mjs` and `@@ -1,3 +1,4 @@`, a
    Read-rendered package line `28\t+...` whose new-side coordinate is 2 must be
    reported as `src/normalize-with-runtime.mjs:2`, never
    `src/normalize-with-runtime.mjs:28`. Before emitting, verify that every
    finding header maps to its changed destination line or removed source line.
</LOCATION-HARD-GATE>

## Output Contract

    For any absent or mismatched source/base/head/scope binding, the entire
    response is the binding-failure sentinel, exactly:

    Spec verdict: CANNOT_VERIFY
    Standards verdict: CANNOT_VERIFY

    For a bound package, output only nonempty findings ordered by severity. Each
    finding is exactly four nonempty plain-text lines:

    [Critical|Important|Minor] [Spec|Standards] file:line
    Issue: <concrete issue>
    Impact: <concrete impact>
    Required fix: <concrete fix>

    Each finding header retains two literal bracket pairs. For example:

    [Important] [Standards] src/example.js:42

    Substitute only the severity, axis, path, and line in that header shape.

    End with exactly these final two nonempty lines:

    Spec verdict: PASS | FAIL | CANNOT_VERIFY
    Standards verdict: PASS | FAIL | CANNOT_VERIFY

    Use the literal square brackets in every finding header. When findings
    exist, the first response character is `[`. After a focused command, do not
    narrate the command or its output; encode that evidence only inside finding
    fields. For a comment-language finding, name only the established project or
    nearby-file language. Copy its label exactly from the bound brief, bound
    project instructions, or nearby-file evidence that establishes it. Say the
    changed comment does not use it and must use it; never identify the current
    or alternative language, quote, or translation.

    Keep every field on one line. Output no Markdown fences, heading, preamble,
    binding confirmation, summary, or note. Missing, `FAIL`, or
    `CANNOT_VERIFY` on either axis blocks. For a bound package, every
    `CANNOT_VERIFY` verdict has a finding naming the smallest controller check;
    only the pre-binding sentinel has no finding. After any fix, a fresh
    reviewer must repeat scope binding and both complete axes over the
    regenerated package.
```

**Placeholders:**

- `[EXPECTED_SCOPE_SHA256]` - controller-computed SHA-256 of the exact scope
- `[BRIEF_FILE]` - task brief from `scripts/task-brief`
- `[REPORT_FILE]` - implementer report for the same task
- `[BASE_SHA]` - commit before the task
- `[HEAD_SHA]` - current task checkpoint commit
- `[DIFF_FILE]` - v1 package from `requesting-code-review/scripts/review-package`
