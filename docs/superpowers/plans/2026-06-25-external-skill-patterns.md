# 外部 Skill 模式吸收 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use k-superpowers:subagent-driven-development (recommended) or k-superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 按已审核 spec，把四条外部实现纪律吸收到现有 K Superpowers skills 中，同时保持类型优先验证和当前 invocation 方式不变。

**Architecture:** 采用纵向切片实施：每个任务修改一个可独立验证的 agent 行为面。所有改动都是文档/提示词行为变更，不新增运行时代码。高风险 skill 正文改动通过静态搜索、反例推演和相关文本审查验证。

**Tech Stack:** Markdown skill docs, prompt templates, `rg` static verification.

---

### Task 1: 强化 debugging 的 bug-specific feedback loop

**Files:**
- Modify: `skills/systematic-debugging/SKILL.md`
- Verify: static search and section review

- [ ] **Step 1: Add Phase 1 exit criterion before root-cause details**

In `skills/systematic-debugging/SKILL.md`, under `### Phase 1: Root Cause Investigation`, add a short mandatory gate before the numbered list:

```markdown
**Phase 1 exit criterion: bug-specific feedback loop**

Before proposing causes or fixes, produce one agent-runnable command or script
that fails on the user's exact symptom and passes after the fix. It must be:

- **specific**: asserts the reported symptom, not just "does not crash"
- **red-capable**: fails while the bug exists
- **fast**: narrow enough to run repeatedly
- **deterministic**: stable verdict, or high reproduction rate for flaky bugs
- **agent-runnable**: no unstructured human clicking

If you cannot build this loop, stop and report what you tried. Ask for a
captured artifact, reproducible environment, logs, HAR/trace, or permission for
temporary instrumentation. Do not continue into hypotheses without the loop or
an explicit blocker.
```

- [ ] **Step 2: Update Phase 4 verification choice with loop disposition**

In Phase 4, after `Choose Verification Before Fixing`, add:

```markdown
1.5. **Decide what happens to the feedback loop**
   - Keep as regression test when the bug affects core behavior, public APIs,
     parsers, serializers, protocols, state machines, permissions, billing, or
     any path where recurrence is costly.
   - Delete temporary harnesses, one-off scripts, debug logs, trace replays, and
     local fixtures when they were only used for diagnosis and the long-term
     risk is covered by types, existing tests, or a better verification path.
   - Do not commit loops that depend on production/private data, external
     environments, manual steps, or unstable resources. Report the verification
     and why it was not retained.

   Before declaring the bug fixed, state the loop disposition:
   `kept as regression test`, `deleted as temporary harness`, or
   `not committed with rationale`.
```

- [ ] **Step 3: Add red flag for fixes before loop**

Add to `## Red Flags - STOP and Follow Process`:

```markdown
- Proposing causes or fixes before you have a bug-specific feedback loop
```

- [ ] **Step 4: Verify Task 1**

Run:

```bash
rg -n "bug-specific feedback loop|loop disposition|kept as regression test|deleted as temporary harness|not committed with rationale|Proposing causes or fixes before" skills/systematic-debugging/SKILL.md
```

Expected: all new phrases appear in `skills/systematic-debugging/SKILL.md`.

Also run:

```bash
rg -n "red-green|RED|GREEN|test-first|TDD" skills/systematic-debugging/SKILL.md
```

Expected: no new TDD/red-green framing introduced.

### Task 2: 让 writing-plans 默认按可验证纵向切片拆任务

**Files:**
- Modify: `skills/writing-plans/SKILL.md`
- Verify: static search and counterexample review

- [ ] **Step 1: Add vertical slice rule to File Structure / decomposition**

In `skills/writing-plans/SKILL.md`, after the file structure guidance and before `## Bite-Sized Task Granularity`, add:

```markdown
## Vertical Slice Task Boundaries

Default to tasks that deliver one narrow, independently verifiable behavior
through the affected path. Avoid horizontal layer tasks like "add schema",
"add API", then "add UI" unless that layer is a genuine prerequisite with its
own verification.

Each task should state:
- the externally observable behavior or agent behavior it delivers
- the files likely touched
- the local verification command
- dependencies on earlier tasks, if any

Allowed exceptions:
- type/API boundary design that must precede implementation
- prefactoring that makes the later behavior change simpler and has its own
  verification
- mechanical migration, rename, config, or documentation-only changes
```

- [ ] **Step 2: Add task template fields for behavior and dependency**

In the Task Structure template, after `**Files:**`, add:

```markdown
**Slice behavior:** [The user-visible, externally observable, or agent-visible behavior completed by this task]
**Depends on:** [Earlier task number, or "None"]
```

- [ ] **Step 3: Update Remember section**

Add to `## Remember`:

```markdown
- Prefer vertical slices: each task should complete a narrow behavior that can
  be verified independently
- Use horizontal/layer tasks only for genuine prerequisites, prefactors, or
  mechanical changes with clear verification
```

- [ ] **Step 4: Verify Task 2**

Run:

```bash
rg -n "Vertical Slice Task Boundaries|Slice behavior|Depends on|Prefer vertical slices|horizontal/layer" skills/writing-plans/SKILL.md
```

Expected: all new planning guidance appears.

Counterexample review:

```text
If a future plan says Task 1 add schema, Task 2 add service, Task 3 add UI,
does the updated skill tell the agent to reject or justify that split?
Expected: yes, unless each layer is a genuine prerequisite with independent verification.
```

### Task 3: 强化 type-driven-verification 的真实入口测试选择

**Files:**
- Modify: `skills/type-driven-verification/SKILL.md`
- Verify: static search and TDD conflict search

- [ ] **Step 1: Add real-entry testing guidance**

In `skills/type-driven-verification/SKILL.md`, in `## When to Write Tests`, after `Good tests should:`, add:

```markdown
- Prefer the entry point real callers use: public API, CLI command, HTTP
  handler, parser entrypoint, state transition, or other stable boundary
- Cover private helpers through public behavior by default
```

- [ ] **Step 2: Strengthen avoid-tests guidance for private helpers**

In `Avoid tests that:`, add:

```markdown
- Reach into private helpers when the same behavior can be verified through a
  real caller entry point
```

- [ ] **Step 3: Add private-helper exception rule**

In `## When to Write Tests`, after the good/avoid lists, add:

```markdown
Private helpers usually should not get separate tests. Test them through public
behavior unless the helper carries complex algorithms, high-risk logic, or an
expensive regression that cannot be observed clearly through the caller entry
point.
```

- [ ] **Step 4: Update common mistake row**

Replace the `Testing private helpers` row in `## Common Mistakes` with:

```markdown
| Testing private helpers by default | Test through the real caller entry point; isolate only complex or high-risk helper logic |
```

- [ ] **Step 5: Verify Task 3**

Run:

```bash
rg -n "real callers use|caller entry point|Private helpers usually|Testing private helpers by default" skills/type-driven-verification/SKILL.md
```

Expected: all new phrases appear.

Run:

```bash
rg -n "blanket TDD|red-green|RED|GREEN|test-first" skills/type-driven-verification/SKILL.md
```

Expected: no TDD/red-green/default test-first wording introduced.

### Task 4: 拆分 review 输出为 Spec / Standards 双轴

**Files:**
- Modify: `skills/requesting-code-review/code-reviewer.md`
- Modify: `skills/subagent-driven-development/spec-reviewer-prompt.md`
- Modify: `skills/subagent-driven-development/code-quality-reviewer-prompt.md`
- Verify: static search and output-format review

- [ ] **Step 1: Reframe code reviewer purpose**

In `skills/requesting-code-review/code-reviewer.md`, change purpose text so it says the reviewer checks two independent axes:

```markdown
**Purpose:** Review completed work along two independent axes:
1. **Spec** — does the diff implement the requirements, without missing or extra behavior?
2. **Standards** — does the diff meet project conventions, code quality, maintainability, testing, and production-readiness expectations?
```

- [ ] **Step 2: Split What to Check into Spec and Standards**

Replace the current `## What to Check` subsections with:

```markdown
## What to Check

**Spec axis:**
- Does the implementation match the plan / requirements?
- Is all requested functionality present?
- Are there missing, partial, wrong, or extra behaviors?
- Are deviations justified improvements, or problematic departures?

**Standards axis:**
- Does the code follow documented project conventions and local style?
- Is responsibility separated cleanly?
- Is error handling appropriate?
- Is type safety preserved where applicable?
- Is the implementation DRY without premature abstraction?
- Are tests focused on real behavior and stable entry points?
- Are edge cases, security, performance, compatibility, migrations, and docs handled where relevant?
```

- [ ] **Step 3: Split output format into Spec and Standards findings**

In the output format, replace the single `### Issues` section with:

```markdown
### Spec Findings

#### Critical (Must Fix)
[Missing, wrong, or extra behavior that breaks requirements]

#### Important (Should Fix)
[Partial requirements, ambiguous deviations, meaningful scope issues]

#### Minor (Nice to Have)
[Small requirement clarifications or polish]

### Standards Findings

#### Critical (Must Fix)
[Bugs, security issues, data loss risks, broken functionality]

#### Important (Should Fix)
[Architecture problems, maintainability risks, poor error handling, test gaps]

#### Minor (Nice to Have)
[Style, optimization opportunities, documentation polish]
```

Keep the existing per-issue fields: file:line, what is wrong, why it matters, how to fix.

- [ ] **Step 4: Update Assessment**

Add:

```markdown
**Spec axis:** [Pass | With issues | Fail]
**Standards axis:** [Pass | With issues | Fail]
```

Keep the existing ready-to-merge verdict after those axis verdicts.

- [ ] **Step 5: Update subagent-driven review prompts**

In `spec-reviewer-prompt.md`, change the purpose line to:

```markdown
**Purpose:** Spec axis review — verify implementer built what was requested, with nothing missing and no unrequested behavior.
```

In `code-quality-reviewer-prompt.md`, change the purpose line to:

```markdown
**Purpose:** Standards axis review — verify the implementation is well-built, maintainable, tested through appropriate behavior boundaries, and consistent with project conventions.
```

- [ ] **Step 6: Verify Task 4**

Run:

```bash
rg -n "Spec axis|Standards axis|Spec Findings|Standards Findings" skills/requesting-code-review/code-reviewer.md skills/subagent-driven-development/spec-reviewer-prompt.md skills/subagent-driven-development/code-quality-reviewer-prompt.md
```

Expected: both axes appear in the generic reviewer and subagent review prompts.

Counterexample review:

```text
If a diff is clean but implements the wrong requirement, does the prompt isolate that under Spec Findings?
If a diff implements the spec but violates project standards or maintainability, does the prompt isolate that under Standards Findings?
Expected: yes to both.
```

### Task 5: 更新中文总览并做最终一致性验证

**Files:**
- Modify: `docs/skills-overview.zh.md`
- Verify: static search across modified files

- [ ] **Step 1: Update overview entries**

In `docs/skills-overview.zh.md`, update the relevant skill summaries:

```markdown
- `systematic-debugging`：强调 bugfix 前必须先建立能捕获用户具体症状的 agent-runnable feedback loop；修复后要说明 loop 是保留为 regression test、删除临时 harness，还是因环境/数据约束不提交。
- `writing-plans`：任务拆分默认偏向可独立验证的 vertical slice；只有类型/API 边界、必要 prefactor、机械迁移等真实前置条件才按层或按文件拆。
- `type-driven-verification`：测试优先通过调用方真实入口验证行为，避免默认测试私有 helper；复杂算法、高风险逻辑和昂贵回归例外。
- `requesting-code-review` / `subagent-driven-development`：评审按 Spec 和 Standards 两轴分开报告，避免需求符合度与代码质量互相掩盖。
```

Place the updates in the existing corresponding sections rather than creating a disconnected appendix.

- [ ] **Step 2: Final conflict search**

Run:

```bash
rg -n "test-driven|TDD|RED-GREEN|test-first|red-green" skills docs/skills-overview.zh.md
```

Expected: no new TDD/test-first/red-green language except explicit non-goal or historical context already present before this change.

Run:

```bash
rg -n "vertical slice|bug-specific feedback loop|Spec axis|Standards axis|caller entry point|真实入口|纵向切片|双轴" skills docs/skills-overview.zh.md
```

Expected: new concepts appear in the intended files.

- [ ] **Step 3: Spec coverage review**

Verify every acceptance criterion from `docs/superpowers/specs/2026-06-25-external-skill-patterns-design.md` maps to a task:

```text
- Type-first default remains: Task 3 + Task 5 conflict search
- Vertical slices: Task 2
- Debugging loop + disposition: Task 1
- Spec / Standards review: Task 4
- Real-entry behavior testing: Task 3
- No auto commit / issue tracker / PRD assumptions: static review of diffs
- Current invocation unchanged: no frontmatter invocation changes
```

- [ ] **Step 4: Commit checkpoint if authorized**

Only if explicitly authorized:

```bash
git add skills/systematic-debugging/SKILL.md \
  skills/writing-plans/SKILL.md \
  skills/type-driven-verification/SKILL.md \
  skills/requesting-code-review/code-reviewer.md \
  skills/subagent-driven-development/spec-reviewer-prompt.md \
  skills/subagent-driven-development/code-quality-reviewer-prompt.md \
  docs/skills-overview.zh.md \
  docs/superpowers/specs/2026-06-25-external-skill-patterns-design.md \
  docs/superpowers/plans/2026-06-25-external-skill-patterns.md
git commit -m "docs: absorb external skill implementation disciplines"
```

Do not include unrelated `.gitignore` changes unless the user explicitly asks.

## Self-Review

**Spec coverage:** All four retained spec recommendations map to tasks: debugging loop (Task 1), vertical slices (Task 2), Spec/Standards review (Task 4), and real-entry behavior testing (Task 3). Overview/docs sync and conflict checks are covered by Task 5.

**Placeholder scan:** This plan contains no unfinished placeholders. Example text is concrete enough for a worker to apply directly.

**Type consistency:** Terminology is consistent with the spec: `tight red-capable loop`, `vertical slice`, `Spec axis`, `Standards axis`, and “通过真实入口测试行为”.
