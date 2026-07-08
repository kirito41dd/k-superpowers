# SDD Upstream Review Optimizations Implementation Plan

> **For agentic workers:** This plan records the exact changes for improving this fork's `subagent-driven-development` skill from the local upstream source at `refs/obra-superpowers/`. If context is compacted, resume from this file and the current git diff.

**Goal:** Absorb the useful controller and reviewer discipline from upstream SDD while preserving this fork's two-stage Spec -> Quality review, type-first verification, no-commit-by-default policy, and `k-superpowers:` namespace.

**Architecture:** Keep separate `spec-reviewer-prompt.md` and `code-quality-reviewer-prompt.md`. Move upstream's task-reviewer Standards-axis discipline into the code quality prompt, move upstream's controller prompt hygiene and pre-flight checks into `SKILL.md`, and extend spec review with a third `Cannot verify from diff` outcome. Do not reintroduce upstream TDD, automatic commit, or single combined reviewer semantics.

**Tech Stack:** Markdown skill text, Bash helper scripts, local plugin manifests.

## Global Constraints

- 保留两阶段 review：Spec compliance 必须先过，才进入 Code Quality / Standards axis。
- 不吸收上游单 `task-reviewer-prompt.md` 合并形态。
- 不恢复上游 TDD / RED-GREEN / automatic commit 语义。
- 不恢复 `superpowers:` 命名空间；交叉引用保持 `k-superpowers:`。
- 重要 skill 行为变更后 bump 版本号，并同步 `package.json`、`.codex-plugin/plugin.json`、`.claude-plugin/plugin.json`、`.claude-plugin/marketplace.json`、README 版本展示。
- 不提交 commit，除非用户明确要求。

## File Structure

- Modify: `skills/subagent-driven-development/SKILL.md` — add pre-flight plan review, reviewer prompt hygiene, warning-item handling, final-review package rules, model-selection refinements, and red flags.
- Modify: `skills/subagent-driven-development/spec-reviewer-prompt.md` — add `Cannot verify from diff` verdict and tighter diff-reading discipline.
- Modify: `skills/subagent-driven-development/code-quality-reviewer-prompt.md` — replace wrapper reference with a self-contained Standards-axis reviewer that reads `[DIFF_FILE]` and does not run broad git/test commands.
- Modify: `skills/subagent-driven-development/implementer-prompt.md` — restore focused-then-final verification cadence and require blocker details in the final message.
- Modify: `docs/skills-overview.zh.md` — summarize the new SDD controller/reviewer discipline.
- Modify: `package.json`, `.codex-plugin/plugin.json`, `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `README.md` — bump `5.1.9` to `5.1.10`.

### Task 1: Strengthen SDD Controller Discipline

**Files:**
- Modify: `skills/subagent-driven-development/SKILL.md`

**Slice behavior:** SDD controller catches plan/rubric conflicts before Task 1, constructs reviewer prompts without bias, handles `Cannot verify from diff`, and keeps final review/fix loops bounded.
**Depends on:** None

**Interfaces:**
- Consumes: current `task-brief`, `review-package`, `sdd-workspace`, and separate reviewer prompts.
- Produces: process text that downstream prompts can rely on: `Cannot verify from diff`, `Requires spec re-review`, Minor findings ledger notes, final review diff package.

- [ ] **Step 1: Add `Pre-Flight Plan Review`**

Add a section before `Model Selection`:

```markdown
## Pre-Flight Plan Review

Before dispatching Task 1, scan the plan once for conflicts:

- tasks that contradict each other or the plan's `Global Constraints`
- anything the plan explicitly mandates that reviewer discipline treats as a defect
- task ordering or interface assumptions that would make a later task impossible

Present everything you find to the human as one batched question, each finding beside the plan text that mandates it, asking which governs. If the scan is clean, proceed without comment. The review loop remains the net for conflicts that only emerge from implementation.
```

- [ ] **Step 2: Refine `Model Selection`**

Add the upstream ideas without hard-coding unsupported platform behavior:

```markdown
**Final whole-change review:** use the most capable available model.

**Review tasks:** choose the model by diff size, complexity, and risk. A small mechanical diff does not need the most capable model; a subtle concurrency, API, state, security, or cross-file change does.

**When the platform supports explicit model selection, specify it in every subagent dispatch.** An omitted model may inherit the session's most expensive model and silently defeat this section.

**Turn count beats token price.** Cheap models that take multiple clarification or correction turns can cost more overall. Use the cheapest tier only when the task is mechanical and the brief contains complete code or exact edits.
```

- [ ] **Step 3: Add `Handling Spec Reviewer ⚠️ Items`**

Add after implementer status:

```markdown
## Handling Spec Reviewer ⚠️ Items

The spec reviewer may report `⚠️ Cannot verify from diff` for requirements that live in unchanged code or span tasks. These items do not automatically fail the task, but the controller must resolve each one before marking the task complete. Check the smallest concrete code or artifact needed, record what you checked in the progress ledger or task notes, and if the item is a real gap, treat it as a failed spec review.
```

- [ ] **Step 4: Add `Reviewer Prompt Hygiene`**

Add a compact section with these rules:

- Do not add open-ended review directives without a named task-specific risk.
- Do not ask reviewers to re-run tests the implementer already ran; the report carries evidence.
- Do not pre-judge findings or tell reviewer what not to flag.
- Do not paste accumulated prior-task summaries into later dispatches.
- Record Minor findings in the progress ledger for final review triage.
- Plan-mandated findings that conflict with reviewer discipline go to the human; do not dismiss or fix against plan without asking.
- Final whole-change review gets a `review-package MERGE_BASE HEAD` diff file.
- If final review returns findings, dispatch one fix subagent with the complete findings list.

- [ ] **Step 5: Update Red Flags**

Add bullets for biased reviewer prompts, missing final review package, unresolved `Cannot verify`, and untracked Minor findings.

- [ ] **Step 6: Verify Task 1**

Run:

```bash
rg -n "Pre-Flight Plan Review|Reviewer Prompt Hygiene|Cannot verify from diff|MERGE_BASE|Minor findings|pre-judge|model selection" skills/subagent-driven-development/SKILL.md
```

Expected: all new anchors present.

### Task 2: Make Code Quality Reviewer Self-Contained

**Files:**
- Modify: `skills/subagent-driven-development/code-quality-reviewer-prompt.md`

**Slice behavior:** Quality review becomes a task-scoped Standards-axis reviewer that reads `[BRIEF_FILE]`, `[REPORT_FILE]`, and `[DIFF_FILE]` directly, without falling back to the generic full code-review template.
**Depends on:** Task 1

**Interfaces:**
- Consumes: `[BRIEF_FILE]`, `[REPORT_FILE]`, `[BASE_SHA]`, `[HEAD_SHA]`, `[DIFF_FILE]`.
- Produces: `Strengths`, `Issues` grouped by Critical/Important/Minor, `Requires spec re-review` markers, `Assessment`.

- [ ] **Step 1: Replace wrapper template**

The prompt should include:

- task-scoped Standards-axis purpose
- read-only checkout rule
- read diff file once; do not rebuild diff or broad crawl
- do not trust implementer report or rationales
- do not re-run broad test suites; only run focused checks for named doubts, or recommend them
- check code quality, tests, structure, project conventions, comments/docs
- mark fixes that can affect behavior/API/config/manifests/tests/docs/touched files/task scope as `Requires spec re-review`
- severity calibration: Critical / Important / Minor

- [ ] **Step 2: Verify Task 2**

Run:

```bash
rg -n "Standards axis|Do Not Trust|Do not re-run|Requires spec re-review|Critical|Important|Minor|read-only" skills/subagent-driven-development/code-quality-reviewer-prompt.md
```

Expected: all anchors present; no `Use template at requesting-code-review/code-reviewer.md` remains.

### Task 3: Add Spec Reviewer Warning Verdict

**Files:**
- Modify: `skills/subagent-driven-development/spec-reviewer-prompt.md`

**Slice behavior:** Spec reviewer can return `⚠️ Cannot verify from diff` instead of broadening search or falsely approving requirements outside the diff.
**Depends on:** Task 1

**Interfaces:**
- Consumes: task brief, implementer report, diff file.
- Produces: ✅ / ❌ / ⚠️ verdicts that controller can route.

- [ ] **Step 1: Tighten diff-reading discipline**

Clarify that the diff file is the primary view; changed-file context lines count as the changed files; inspect outside diff only for one concrete named risk and report what was checked.

- [ ] **Step 2: Add warning output**

Add:

```markdown
- ⚠️ Cannot verify from diff: [requirements that live in unchanged code or span tasks, and what the controller should check]
```

- [ ] **Step 3: Verify Task 3**

Run:

```bash
rg -n "Cannot verify from diff|unchanged code|spans tasks|concrete requirement risk|Do not mutate" skills/subagent-driven-development/spec-reviewer-prompt.md
```

Expected: warning path and read-only/diff discipline present.

### Task 4: Tighten Implementer Verification Contract

**Files:**
- Modify: `skills/subagent-driven-development/implementer-prompt.md`

**Slice behavior:** Implementer reports give the controller enough information to handle blockers immediately and avoid broad repeated verification while still producing evidence for fixes.
**Depends on:** None

**Interfaces:**
- Consumes: existing report file contract.
- Produces: final message with blocker details for `BLOCKED` / `NEEDS_CONTEXT`, and report file with verification evidence.

- [ ] **Step 1: Add verification cadence**

Add:

```markdown
While iterating, run the focused verification for what you are changing. Before reporting DONE or DONE_WITH_CONCERNS, run the relevant task verification from the brief once and record the command and output summary in the report file.
```

- [ ] **Step 2: Restore blocker details in final message**

Add:

```markdown
If BLOCKED or NEEDS_CONTEXT, put the specifics in the final message itself; the controller acts on it directly.
```

- [ ] **Step 3: Verify Task 4**

Run:

```bash
rg -n "focused verification|Before reporting DONE|If BLOCKED or NEEDS_CONTEXT" skills/subagent-driven-development/implementer-prompt.md
```

Expected: all anchors present.

### Task 5: Sync Docs And Versions

**Files:**
- Modify: `docs/skills-overview.zh.md`
- Modify: `package.json`
- Modify: `.codex-plugin/plugin.json`
- Modify: `.claude-plugin/plugin.json`
- Modify: `.claude-plugin/marketplace.json`
- Modify: `README.md`

**Slice behavior:** User-facing overview and plugin manifests reflect the new SDD behavior.
**Depends on:** Tasks 1-4

**Interfaces:**
- Consumes: changed SDD semantics.
- Produces: version `5.1.10`.

- [ ] **Step 1: Update docs overview**

Mention:

- pre-flight plan review
- brief readiness gate
- `Cannot verify from diff`
- self-contained quality reviewer
- final review package / Minor findings triage

- [ ] **Step 2: Bump versions**

Change `5.1.9` to `5.1.10` in all required files.

- [ ] **Step 3: Verify Task 5**

Run:

```bash
rg -n "5\\.1\\.9|5\\.1\\.10" package.json .codex-plugin/plugin.json .claude-plugin/plugin.json .claude-plugin/marketplace.json README.md
rg -n "pre-flight|Cannot verify from diff|quality reviewer|final review" docs/skills-overview.zh.md
```

Expected: no `5.1.9` in version files; overview mentions new SDD behavior.

### Final Verification

Run:

```bash
git diff --check
bash -n skills/subagent-driven-development/scripts/task-brief
bash -n skills/subagent-driven-development/scripts/review-package
bash -n skills/subagent-driven-development/scripts/sdd-workspace
bash -n skills/subagent-driven-development/scripts/sdd-cleanup
rg -n "Use template at requesting-code-review/code-reviewer.md|superpowers:test-driven-development|RED-GREEN|TDD" skills/subagent-driven-development
git status --short
```

Expected:

- `git diff --check` passes.
- Bash syntax checks pass.
- The final `rg` has no matches.
- `git status --short` only lists expected modified files and this plan document.
