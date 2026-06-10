---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, verification, docs they might need to check, and how to validate it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. Type-first design. Focused verification. Commit checkpoints that respect project and user commit policy.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they may over-test incidental details or under-test core behavior unless guided.

**Language Adaptation:** Determine the user's conversation language from the current session. Output all documents (plan header, descriptions, comments, task descriptions) in that language. Code blocks, commands, and technical identifiers remain in their natural form (English).

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** If working in an isolated worktree, it should have been created via the `k-superpowers:using-git-worktrees` skill at execution time.

**Save plans to:** `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`
- (User preferences for plan location override this default)

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure - but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Define the type/API boundary" - step
- "Implement the minimal code" - step
- "Write focused tests for behavior types cannot prove, if needed" - step
- "Run the relevant verification" - step
- "Commit checkpoint if authorized" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use k-superpowers:subagent-driven-development (recommended) or k-superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Define types and API boundary**

State what types/interfaces should guarantee, and what still needs runtime verification.

- Type/API invariant: invalid input is unrepresentable or rejected at the boundary; `function(input)` returns `expected` for valid input.
- Runtime risk: [the behavior types cannot prove — this is what the test must cover, or "none"]

```python
def function(input: ValidInput) -> Expected: ...
```

- [ ] **Step 2: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 3: Add focused test for behavior types cannot prove (if any)**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 4: Run relevant verification**

Run: `pytest tests/path/test.py::test_name -v` (plus type check/build for the touched module)
Expected: PASS, exit 0

- [ ] **Step 5: Commit checkpoint if authorized**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```

Include/execute this step only when commits are authorized — see Commit Authorization under Execution Handoff.
````

**Bug-fix tasks:** the focused test is a regression test. Order the steps so the test demonstrably reproduces the bug (fails) before the fix, then passes after — per `k-superpowers:type-driven-verification`.

## No Placeholders

Every step must contain the actual content an engineer needs. These are **plan failures** — never write them:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without specifying what behavior needs tests)
- "Similar to Task N" (repeat the code — the engineer may be reading tasks out of order)
- Steps that describe what to do without showing how (code blocks required for code steps)
- References to types, functions, or methods not defined in any task

## Remember
- Exact file paths always
- Complete code in every step — if a step changes code, show the code
- Exact commands with expected output
- DRY, YAGNI, type-first design, focused verification, commit checkpoints per Commit Authorization

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it. This is a checklist you run yourself — not a subagent dispatch.

**1. Spec coverage:** Skim each section/requirement in the spec. Can you point to a task that implements it? List any gaps.

**2. Placeholder scan:** Search your plan for red flags — any of the patterns from the "No Placeholders" section above. Fix them.

**3. Type consistency:** Do the types, method signatures, and property names you used in later tasks match what you defined in earlier tasks? A function called `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 is a bug.

If you find issues, fix them inline. No need to re-review — just fix and move on. If you find a spec requirement with no task, add the task.

## Execution Handoff

After saving and self-reviewing the plan, STOP. Ask the human partner to review and approve the plan before any implementation begins:

**"Plan complete and saved to `docs/superpowers/plans/<filename>.md`. Please review it and choose one:**

**1. Approve and commit the plan document**

**2. Request changes**

**3. Approve without commit**

**Only option 1 authorizes a documentation-only commit. Approval of the plan does not authorize implementation."**

Wait for the user's response. If they request changes, make them and re-run the self-review loop. Only proceed once the user approves.

### Commit Authorization

Single source of truth for all commits in this plan's lifecycle:

- **Plan document:** commit only when the user explicitly chooses option 1 or otherwise explicitly asks for a commit. The authorization covers the plan document only. If project instructions prohibit commits unless explicitly requested, that rule prevails.
- **Plan approval ≠ implementation authorization:** approving the plan (with or without commit) does not grant permission to start implementation or commit implementation code.
- **Implementation commit checkpoints** (template Step 5): execute only if project instructions allow commits, the user explicitly requested commits, or the user approved a workflow option that includes implementation commits. Otherwise stop after verification and ask before committing.

After the approved plan is either committed or explicitly approved without commit, offer execution choice:

**"Plan approved. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?"**

Do NOT invoke subagent-driven-development, executing-plans, or any implementation skill until the human explicitly chooses an execution option or otherwise tells you to proceed with implementation.

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use k-superpowers:subagent-driven-development
- Fresh subagent per task + two-stage review

**If Inline Execution chosen:**
- **REQUIRED SUB-SKILL:** Use k-superpowers:executing-plans
- Batch execution with checkpoints for review
