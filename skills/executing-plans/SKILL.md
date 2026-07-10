---
name: executing-plans
description: Use when executing an approved implementation plan inline or without SDD checkpoint commits
---

# Executing Plans

## Overview

Load plan, review critically, execute all tasks, report when complete.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

**Note:** Tell your human partner that Superpowers works much better with access to subagents. The quality of its work will be significantly higher if run on a platform with subagent support (such as Claude Code or Codex). If subagents are available, use k-superpowers:subagent-driven-development instead of this skill.

## The Process

### Step 0: Apply Unified Execution Handoff

Before setup, edits, or task execution, invoke
`k-superpowers:using-git-worktrees` with the handoff's explicit "create
worktree" or "current workspace" decision. Complete workspace setup and
baseline verification before Step 1. Do not rely on the Integration section as
an implicit action.

### Step 1: Load and Review Plan
1. Read plan file
2. Review critically - identify any questions or concerns about the plan
3. If concerns: Raise them with your human partner before starting
4. If no concerns: Create TodoWrite and proceed

### Step 2: Execute Tasks

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as completed

### Step 3: Complete Development

After all tasks complete and verified:
- If on a feature branch or linked worktree, the user requested Git
  integration/cleanup, or a real integration decision remains: use
  `k-superpowers:finishing-a-development-branch`.
- If the Unified Execution Handoff selected current workspace, execution is on
  main/master with explicit consent, and no integration was requested: run
  fresh completion verification and report that changes remain in the current
  workspace. Do not show merge/PR/discard options.

## When to Stop and Ask for Help

**STOP executing immediately when:**
- Hit a blocker (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Stop when blocked, don't guess
- Never start implementation on main/master branch without explicit user consent

## Integration

**Required workflow skills:**
- **k-superpowers:using-git-worktrees** - Ensures isolated workspace (creates one or verifies existing)
- **k-superpowers:writing-plans** - Creates the plan this skill executes
- **k-superpowers:finishing-a-development-branch** - Complete feature-branch/worktree integration when a decision remains
