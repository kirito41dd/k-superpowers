# Compact Development Flow Design

## Goal

Reduce pre-implementation interaction, document duplication, and irrelevant
Git workflow gates for clear, single-domain work while preserving explicit
design approval, risk-based review, user-controlled Git mutations, and fresh
completion verification.

## Observed Baseline

The risk-adaptive SDD change provided a real workflow trace. From the request to
optimize the skills until the first skill edit, the user answered roughly twelve
times across direction selection, risk ownership, commit policy, approach
selection, three design sections, written spec approval, plan approval,
execution mode, and worktree consent.

The implementation then loaded many overlapping workflow skills, ran six
pressure agents plus repeated review rounds, and invoked branch-finishing logic
even though the user had chosen inline work on `main` with no integration
action. This observed trace is sufficient baseline evidence; no synthetic
baseline campaign is needed.

## Principles

- Compact is the automatic default when the problem is clear; it is not a user
  keyword or a quality downgrade.
- Uncertainty upgrades the flow. Missing information never silently becomes a
  compact assumption.
- Chat design approval and an equivalent written spec represent one decision,
  not two approval gates.
- Plans describe what an implementer needs, not every two-minute keystroke.
- Execution mode, workspace isolation, implementation authorization, and local
  commit authorization are one handoff decision.
- Verification strength remains risk-based and nonzero.
- Git integration menus appear only when an integration decision exists.

## Flow Selection

After exploring project context, `brainstorming` selects Compact or Full.

### Compact Eligibility

Use Compact when all are true:

- one problem domain
- goal and success criteria are clear, or one blocking question can make them
  clear
- no unresolved long-term architecture choice between materially different
  approaches
- no irreversible migration, security/permission boundary, protocol design,
  or major compatibility contract
- the user can directly evaluate the presented technical trade-offs

### Full Escalation

Use Full when any are true:

- multiple independent subsystems
- two or more unresolved blocking requirement questions
- several viable approaches materially affect long-term architecture
- irreversible migration, security, permissions, protocol, or major public
  compatibility risk
- the user explicitly requests a complete design process

The classification is exhaustive: if any Compact eligibility condition is not
proven true, select Full. The list above is a set of common mandatory Full
signals, not the complete complement.

The flow may escalate from Compact to Full whenever new evidence violates
Compact eligibility. It must not downgrade Full merely to save time.

## Compact Brainstorming

Compact brainstorming is:

```text
explore context
  -> ask at most one blocking question
  -> present 2-3 approaches, recommendation, and complete design in one message
  -> receive one design approval
  -> write and self-review the equivalent spec
  -> proceed to compact planning unless the written spec introduces a new decision
```

The complete design covers architecture, boundaries, data/control flow, failure
handling, and verification in proportion to the task. It is presented as one
coherent unit rather than section-by-section approval.

The user's approval of that complete chat design also approves a faithful
written spec. Writing the spec does not authorize a commit. If self-review
introduces a new decision, changes scope, or materially differs from the
approved design, stop and request approval for that delta.

Full brainstorming retains the current one-question-at-a-time clarification,
sectional design approval, written spec review, and explicit spec commit gate.

## Compact Planning

`writing-plans` receives the flow mode from brainstorming.

A Compact plan retains:

- Goal, Architecture, Tech Stack, and Global Constraints
- Task Files, Slice behavior, Dependencies, Risk, and Risk rationale
- Interfaces where another task depends on them
- implementation approach and exact public signatures or data shapes when they
  matter
- focused verification command and expected result

A Compact plan does not require:

- every step to represent two to five minutes
- a fixed five-step template
- complete code blocks for routine edits
- repeated code already unambiguously defined by the spec or nearby source
- a separate plan approval when planning introduces no new design decision

Exact code or pseudocode remains required for public APIs, protocols, parsers,
state machines, complex algorithms, and other details where prose leaves a
meaningful implementation choice.

After self-review, a Compact plan proceeds directly to the unified execution
handoff if it faithfully implements the approved spec. Any new architecture,
scope, dependency, public contract, or risk decision returns to the user.

Full planning retains the current detailed template and separate review gate.

## Unified Execution Handoff

Compact planning presents one choice:

1. Subagent-Driven + create worktree + authorize local checkpoint commits
2. Subagent-Driven + current workspace + authorize local checkpoint commits
3. Inline + create worktree + no implementation commits
4. Inline + current workspace + no implementation commits
5. Revise design or plan

Choosing an execution option authorizes implementation and only the workspace
and local commit actions named by that option. It never authorizes push, merge,
PR creation, amend, force operations, or unrelated commits.

Existing explicit preferences may preselect or shorten the handoff, but do not
authorize implementation unless the user previously approved the complete
combination and told the agent to start. SDD still requires checkpoint commits;
a user who declines them must use Inline.

`using-git-worktrees` consumes the handoff choice. It still detects existing
isolation and performs safety/setup/baseline checks, but does not ask for consent
again when the unified handoff already decided workspace placement.

Worktree consent does not authorize repository edits or commits. An unignored
project-local worktree directory falls back to a global directory without
editing `.gitignore`; creation failure stops for a revised handoff instead of
silently switching to the current workspace.

## Verification For Skill Changes

`writing-skills` remains risk-based but reduces campaign overhead:

- A real user trace, production incident, failed eval, or review finding is
  sufficient observed baseline; do not add a synthetic baseline for the same
  failure.
- Start with two or three representative scenarios covering distinct failure
  classes, not one scenario per rule.
- Run one whole-change review, batch all findings into one fix pass, then run
  one re-review.
- Add scenarios or review rounds only when a new rationalization, failure class,
  or material fix appears.
- Generate todos only for applicable checklist items. Do not create visible
  placeholders for inapplicable frontmatter, example, or deployment checks.

The risk floor remains nonzero. High-risk behavior-shaping edits still require
observed or synthetic baseline evidence and post-change behavioral validation.

## Execution Completion

`executing-plans` and SDD invoke `finishing-a-development-branch` only when:

- execution is on a feature branch or linked worktree
- the user requested merge, push, PR, discard, or cleanup
- another real integration decision remains

When work was explicitly performed in the current main checkout and no Git
integration was requested, fresh verification is followed by a concise report
that changes remain in the current workspace. No merge/PR/discard menu is
shown.

`verification-before-completion` remains the final evidence gate in both Compact
and Full flows.

## Skill Changes

- `brainstorming`: add automatic Compact/Full classification, one-message
  Compact design, and equivalent-spec approval semantics.
- `writing-plans`: add Compact plan structure and skip redundant plan approval
  when no new decision appears; add unified execution handoff.
- `using-git-worktrees`: consume prior handoff consent without asking again.
- `executing-plans`: make branch finishing conditional on actual integration
  state.
- `subagent-driven-development`: consume unified handoff authorization rather
  than asking again when it is already explicit.
- `finishing-a-development-branch`: exclude current-main/no-integration work
  from its trigger path.
- `writing-skills`: use observed baseline preferentially, begin with two or
  three representative scenarios, and batch review/fix/re-review.
- `using-superpowers` and overview docs: route clear work into the owner skills
  without duplicating their workflow details.

## Verification

Use this conversation as observed baseline and verify three primary scenarios:

1. A clear single-domain request automatically uses Compact, needs no more than
   one blocking question, and reaches implementation after one design approval
   plus one unified handoff.
2. A request involving irreversible migration or unresolved architecture
   choices uses Full and preserves its gates.
3. Inline execution in the current main checkout with no integration request
   verifies and reports in place without invoking a finish menu.

Run one independent whole-change review. Batch findings into one fix pass and
run one re-review. Expand testing only if these checks expose a new failure
class.

## Success Criteria

- Clear single-domain work normally needs two user replies before implementation:
  design approval and unified handoff selection.
- A faithful written Compact spec and plan do not create duplicate approvals.
- Compact plans retain risk, interfaces, and verification without mechanical
  step/code expansion.
- Explicit Git authorization boundaries remain intact.
- High-uncertainty work still uses Full.
- Current-main Inline work does not invoke irrelevant branch-finishing menus.
- Skill-change verification uses observed evidence and bounded representative
  scenarios before expanding.
