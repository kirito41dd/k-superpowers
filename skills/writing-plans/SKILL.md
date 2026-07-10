---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write implementation plans for an engineer with little codebase context.
Compact plans preserve decisions, risk, interfaces, and verification without
mechanical expansion; Full plans provide comprehensive bite-sized steps. DRY.
YAGNI. Type-first design. Focused verification. Explicit Git authorization.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they may over-test incidental details or under-test core behavior unless guided.

**Language Adaptation:** Determine the user's conversation language from the current session. Output all user-facing prose, documents (plan header, descriptions, task descriptions), scripted review/approval prompts, and execution-choice prompts in that language. Code blocks, commands, technical identifiers, and comments/docs inside code examples follow project instructions and nearby file style first; use conversation language for code comments only when no project style exists.

**Core Explanations:** When plan steps define core structures, core functions, or core abstractions, include explanatory comments/docs unless the code is genuinely self-explanatory. Use the form appropriate for the target language and project: doc comments, docstrings, interface comments, or nearby code comments. Follow project instructions and nearby file style for comment language. Explain what the abstraction represents, how callers should use it, and any important invariants, lifecycle rules, protocol boundaries, or state transitions. Do not add comments that merely restate obvious assignments, names, or control flow.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** If working in an isolated worktree, it should have been created via the `k-superpowers:using-git-worktrees` skill at execution time.

**Save plans to:** `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`
- (User preferences for plan location override this default)

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## Flow Mode

Read `Flow: Compact | Full` from the approved spec. If absent, infer it only
from an explicit brainstorming handoff; never silently treat uncertainty as
Compact.

### Compact Plan

Use for a faithful implementation of an approved Compact design. Retain:

- Goal, Architecture, Tech Stack, and Global Constraints
- per-task Files, Slice behavior, Dependencies, Risk, and Risk rationale
- Interfaces only where another task depends on them
- implementation approach and exact public signatures/data shapes when they
  matter
- focused verification command and expected result

Do not require a fixed five-step template, two-to-five-minute actions, complete
code blocks for routine edits, or code repeated unambiguously from the spec or
nearby source. Exact code or pseudocode remains required for public APIs,
protocols, parsers, state machines, complex algorithms, and any detail where
prose leaves a meaningful implementation choice.

After self-review, proceed directly to Unified Execution Handoff when the plan
adds no architecture, scope, dependency, public contract, or risk decision. If
it adds one, present that delta for approval first.

### Full Plan

Use the detailed structure below and retain its separate plan review gate.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure - but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Vertical Slice Task Boundaries

Default to tasks that deliver one narrow, independently verifiable behavior
through the affected path. Avoid horizontal layer tasks like "add schema",
"add API", then "add UI" unless that layer is a genuine prerequisite with its
own verification.

A task is the smallest unit that carries its own verification cycle and, when
risk requires review, is worth a fresh reviewer's gate. Fold setup,
configuration, scaffolding, and documentation steps into the task whose
deliverable needs them. Split only where tasks can be independently verified
and a risk-required reviewer could meaningfully reject one while approving its
neighbor. Each task ends with an independently verifiable deliverable.

Each task should state:
- the externally observable behavior or agent behavior it delivers
- the files likely touched
- the local verification command
- dependencies on earlier tasks, if any
- the interfaces it consumes from earlier tasks and produces for later tasks

Allowed exceptions:
- type/API boundary design that must precede implementation
- prefactoring that makes the later behavior change simpler and has its own
  verification
- mechanical migration, rename, config, or documentation-only changes

## Task Risk Classification

Every task must declare:

```markdown
**Risk:** low | medium | high
**Risk rationale:** [Concrete behavioral and integration risks]
```

Classify by behavioral effect, not diff size:

| Risk | Use when |
|------|----------|
| `low` | Documentation, comments, formatting, mechanical configuration, or a local rename with no runtime behavior or public contract change |
| `medium` | Local runtime behavior with bounded files, stable interfaces, and a focused verification entry point |
| `high` | Public API, persisted format, security boundary, concurrency, protocol, state machine, cross-module contract, or high-risk migration |

Missing risk metadata is a plan failure, never an implicit `low`. Shared
interfaces, shared mutable state, or behavior created only by composing tasks
must be named because they require final whole-change review during SDD.

## Full Plan: Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Define the type/API boundary" - step
- "Implement the minimal code" - step
- "Write focused tests for behavior types cannot prove, if needed" - step
- "Run the relevant verification" - step
- "Commit checkpoint if authorized" - step

## Full Plan Document Header

**Every Full plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use k-superpowers:subagent-driven-development (recommended) or k-superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

## Global Constraints

[The spec's project-wide requirements — version floors, dependency limits,
naming and copy rules, platform requirements, exact values, and cross-cutting
policies — one line each, copied verbatim from the spec. Every task's
requirements implicitly include this section. Write "None" only if the spec
has no global constraints.]

---
```

## Full Plan Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Slice behavior:** [The user-visible, externally observable, or agent-visible behavior completed by this task]
**Depends on:** [Earlier task number, or "None"]
**Risk:** low | medium | high
**Risk rationale:** [Concrete behavioral and integration risks]

**Interfaces:**
- Consumes: [what this task uses from earlier tasks — exact type names, function signatures, data shapes, files, commands, or "None"]
- Produces: [what later tasks rely on — exact type names, function signatures, data shapes, files, commands, or "None"]

- [ ] **Step 1: Define types and API boundary**

State what types/interfaces should guarantee, and what still needs runtime verification.

- Type/API invariant: invalid input is unrepresentable or rejected at the boundary; `function(input)` returns `expected` for valid input.
- Runtime risk: [the behavior types cannot prove — this is what the test must cover, or "none"]

```python
def function(input: ValidInput) -> Expected: ...
```

- [ ] **Step 2: Write minimal implementation**

If the implementation introduces core structures, core functions, or core
abstractions, include actual explanatory comments/docs unless the code is
genuinely self-explanatory. Explain what the abstraction represents, how callers
should use it, and any important invariants, lifecycle rules, protocol
boundaries, or state transitions. Do not leave placeholder comments.

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

Run: `pytest tests/path/test.py::test_name -v` (copy the narrowest relevant CI, project script, package/task config, or memory command when available; do not broaden target/suite/matrix scope unless explicitly optional)
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

Every step must contain the actual content an engineer needs. These are **Full
plan failures** — never write them:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without specifying what behavior needs tests)
- "Similar to Task N" (repeat the code — the engineer may be reading tasks out of order)
- Full-plan code steps that describe what to do without showing how
- References to types, functions, or methods not defined in any task

## Full Plan Remember
- Exact file paths always
- Copy exact global constraints into the plan header so every downstream task inherits them
- Give each task explicit `Interfaces` so low-context implementers know neighbor contracts
- Complete code in every Full-plan code step
- Exact commands with expected output, copied from project source of truth when
  available; do not broaden target/suite/matrix scope on your own
- Prefer vertical slices: each task should complete a narrow behavior that can
  be verified independently
- Right-size tasks so setup/config/docs ride with the deliverable that needs
  them; do not create standalone review gates for work that cannot be
  meaningfully accepted or rejected alone
- Use horizontal/layer tasks only for genuine prerequisites, prefactors, or
  mechanical changes with clear verification
- DRY, YAGNI, type-first design, focused verification, commit checkpoints per Commit Authorization
- Add explanatory comments/docs for core structures, core functions, and core abstractions unless they are genuinely self-explanatory; avoid comments that repeat obvious code

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it. This is a checklist you run yourself — not a subagent dispatch.

**1. Spec coverage:** Skim each section/requirement in the spec. Can you point to a task that implements it? List any gaps.

**2. Placeholder scan:** Search your plan for red flags — any of the patterns from the "No Placeholders" section above. Fix them.

**3. Type consistency:** Do the types, method signatures, and property names you used in later tasks match what you defined in earlier tasks? A function called `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 is a bug.

**4. Constraint propagation:** Did every project-wide requirement from the spec land in `Global Constraints`, with exact values copied verbatim? If a task depends on one, is it reflected in the task steps or verification? Do verification commands match the project source of truth when one exists, without broadening scope on your own?

**5. Interface consistency:** Do each task's `Consumes` and `Produces` entries match the types, APIs, files, commands, and data shapes used by neighboring tasks?

**6. Core explanation check:** Do core structures, core functions, and core abstractions have useful explanatory comments/docs unless they are genuinely self-explanatory? Do they explain what the abstraction represents, how to use it, and important invariants or lifecycle/protocol/state rules? Do comment language and style follow project instructions and nearby files? Remove comments that only repeat obvious code.

**7. Task sizing:** Is each task worth its own verification boundary and, when its risk requires one, a review gate? Merge standalone setup/config/docs tasks into the deliverable that needs them unless they are independently verifiable.

**8. Risk classification:** Does every task declare `low`, `medium`, or
`high` with a concrete behavioral rationale? Did you classify by effect rather
than diff size? Did you identify shared interfaces, shared mutable state, or
cross-task behavior that requires final whole-change review? Missing metadata
is a plan failure, not an implicit `low`.

If you find issues, fix them inline. No need to re-review — just fix and move on. If you find a spec requirement with no task, add the task.

## Execution Handoff

### Full Plan Review Gate

For Full plans, save and self-review the plan, then ask the user to approve it,
request changes, or approve and explicitly commit only the plan document. Plan
approval does not authorize implementation. Compact plans skip this duplicate
gate unless they introduce a material design delta.

### Unified Execution Handoff

After an approved Full plan, or directly after a faithful Compact plan, present
one localized choice:

1. Subagent-Driven + create worktree + authorize local checkpoint commits
2. Subagent-Driven + current workspace + authorize local checkpoint commits
3. Inline + create worktree + no implementation commits
4. Inline + current workspace + no implementation commits
5. Revise design or plan

The selected option authorizes implementation and only the workspace/local
commit actions it names. It never authorizes push, merge, PR creation, amend,
force operations, or unrelated commits.

Use prior execution/worktree/commit preferences to preselect or shorten this
handoff, not to infer implementation authorization. Skip confirmation only when
the user previously authorized the complete combination and explicitly told you
to start implementation. SDD requires checkpoint commits; a user who declines
them must use Inline.

Do not invoke an implementation skill until an execution option is selected.

- Options 1-2: **REQUIRED SUB-SKILL:** use
  `k-superpowers:subagent-driven-development` with the handoff's worktree and
  checkpoint authorization.
- Options 3-4: **REQUIRED SUB-SKILL:** use
  `k-superpowers:executing-plans` with the handoff's worktree decision and no
  implementation commits.

### Commit Authorization

- Spec/plan documents: commit only when explicitly requested.
- SDD implementation: options 1-2 authorize local task/fix checkpoint commits
  for this plan only.
- Inline implementation: options 3-4 do not authorize implementation commits.
- No option authorizes push, merge, PR, amend, force operations, or unrelated
  commits.
