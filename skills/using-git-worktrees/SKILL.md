---
name: using-git-worktrees
description: Use when starting feature work that needs isolation from current workspace or before executing implementation plans - ensures an isolated workspace exists via native tools or git worktree fallback
---

# Using Git Worktrees

## Overview

Ensure work happens in an isolated workspace. Prefer your platform's native worktree tools. Fall back to manual git worktrees only when no native tool is available.

**Core principle:** Detect existing isolation first. Then use native tools. Then fall back to git. Never fight the harness.

**Announce at start:** "I'm using the using-git-worktrees skill to set up an isolated workspace."

## Step 0: Detect Existing Isolation

**Before creating anything, check if you are already in an isolated workspace.**

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
BRANCH=$(git branch --show-current)
```

**Submodule guard:** `GIT_DIR != GIT_COMMON` is also true inside git submodules. Before concluding "already in a worktree," verify you are not in a submodule:

```bash
# If this returns a path, you're in a submodule, not a worktree — treat as normal repo
git rev-parse --show-superproject-working-tree 2>/dev/null
```

**If `GIT_DIR != GIT_COMMON` (and not a submodule):** You are already in a linked worktree. Skip to Step 3 (Project Setup). Do NOT create another worktree.

Report with branch state:
- On a branch: "Already in isolated workspace at `<path>` on branch `<name>`."
- Detached HEAD: "Already in isolated workspace at `<path>` (detached HEAD, externally managed). Branch creation needed at finish time."

**If `GIT_DIR == GIT_COMMON` (or in a submodule):** You are in a normal repo checkout.

First consume any Unified Execution Handoff decision:

- "create worktree" is explicit consent; create one without asking again
- "current workspace" is an explicit decline; work in place and skip creation
- an existing user instruction expressing the same preference is equally
  authoritative

Only when no prior workspace decision exists, ask for consent before creating a worktree:

> "Would you like me to set up an isolated worktree? It protects your current branch from changes."

Never turn safety detection into duplicate consent. If the prior decision is
current workspace, skip to Step 3 after detection.

## Step 1: Create Isolated Workspace

**You have two mechanisms. Try them in this order.**

### 1a. Native Worktree Tools (preferred)

The user has asked for an isolated workspace (Step 0 consent). Do you already have a way to create a worktree? It might be a tool with a name like `EnterWorktree`, `WorktreeCreate`, a `/worktree` command, or a `--worktree` flag. If you do, use it and skip to Step 3.

Native tools handle directory placement, branch creation, and cleanup automatically. Using `git worktree add` when you have a native tool creates phantom state your harness can't see or manage.

Only proceed to Step 1b if you have no native worktree tool available.

### 1b. Git Worktree Fallback

**Only use this if Step 1a does not apply** — you have no native worktree tool available. Create a worktree manually using git.

#### Directory Selection

Follow this priority order. Explicit user preference always beats observed filesystem state.

1. **Check your instructions for a declared worktree directory preference.** If the user has already specified one, use it without asking.

2. **Check for an existing project-local worktree directory:**
   ```bash
   ls -d .worktrees 2>/dev/null     # Preferred (hidden)
   ls -d worktrees 2>/dev/null      # Alternative
   ```
   If found, use it. If both exist, `.worktrees` wins.

3. **Honor an explicit global-directory preference:**
   ```bash
   project=$(basename "$(git rev-parse --show-toplevel)")
   path=~/.config/superpowers/worktrees/$project/$BRANCH_NAME
   ```
   A global path requires no repository ignore edit.

4. **If there is no other guidance available**, use `.worktrees/` at the
   project root. The project-local worktree choice includes authorization for
   the minimal ignore setup below.

After selection, set `LOCATION` to the exact worktree directory root before any
safety check or path construction:

```bash
# Examples; use the path selected above.
LOCATION=.worktrees
# LOCATION=worktrees
# LOCATION=.trees
# LOCATION="$HOME/.config/superpowers/worktrees/$project"
```

Use this same value for ignore verification and the final worktree path. Do not
re-derive a different default later.

#### Safety Verification (project-local directories only)

**MUST verify directory is ignored before creating worktree:**

```bash
git check-ignore -q "$LOCATION" 2>/dev/null
```

Check only the selected project-local directory. An ignored `worktrees/` does
not make `.worktrees/` safe, and an explicit alternative must be checked by its
actual path.

**If NOT ignored:** Add exactly one rule for the selected project-local
worktree directory to `.gitignore` (normally `.worktrees/`), preserving nearby
style. Creating a project-local worktree authorizes this minimal setup edit.

This does **not** authorize a commit. Without separate commit authorization,
leave the `.gitignore` edit visible as setup-owned and report it. Do not add a
duplicate equivalent rule. An explicit global-worktree preference skips this
edit entirely.

Before editing, require `.gitignore` to be a regular writable file or safely
creatable in a writable repository root. After editing, rerun
`git check-ignore -q "$LOCATION"`. If the edit cannot be made safely or the
selected location is still not ignored, stop and report the error; do not create
the worktree or switch locations silently.

**Why critical:** Prevents accidentally committing worktree contents to repository.

Global directories (`~/.config/superpowers/worktrees/`) need no verification.

#### Create the Worktree

```bash
project=$(basename "$(git rev-parse --show-toplevel)")

path="$LOCATION/$BRANCH_NAME"
git worktree add "$path" -b "$BRANCH_NAME"
cd "$path"
```

**Creation failure:** If worktree creation fails, stop and report the error.
Ask whether to retry or change the Unified Execution Handoff to current
workspace. Keep any setup-owned `.gitignore` edit visible; never silently revert
it or convert explicit isolation consent into in-place work.

## Step 3: Project Setup

Auto-detect and run appropriate setup:

```bash
# Node.js
if [ -f package.json ]; then npm install; fi

# Rust
if [ -f Cargo.toml ]; then cargo build; fi

# Python
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then poetry install; fi

# Go
if [ -f go.mod ]; then go mod download; fi
```

## Step 4: Verify Clean Baseline

Run tests to ensure workspace starts clean:

```bash
# Use project-appropriate command
npm test / cargo test / pytest / go test ./...
```

**If tests fail:** Report failures, ask whether to proceed or investigate.

**If tests pass:** Report ready.

### Report

```
Worktree ready at <full-path>
Tests passing (<N> tests, 0 failures)
Ready to implement <feature-name>
```

## Quick Reference

| Situation | Action |
|-----------|--------|
| Already in linked worktree | Skip creation (Step 0) |
| In a submodule | Treat as normal repo (Step 0 guard) |
| Native worktree tool available | Use it (Step 1a) |
| No native tool | Git worktree fallback (Step 1b) |
| `.worktrees/` exists | Use it (verify ignored) |
| `worktrees/` exists | Use it (verify ignored) |
| Both exist | Use `.worktrees/` |
| Neither exists | Default to project-local `.worktrees/` |
| Explicit global preference | Use global path; no repository edit |
| Directory not ignored | Add one `.gitignore` rule; do not infer commit authorization |
| Worktree creation fails | Stop and ask whether to retry or change handoff |
| Tests fail during baseline | Report failures + ask |
| No package.json/Cargo.toml | Skip dependency install |

## Common Mistakes

### Fighting the harness

- **Problem:** Using `git worktree add` when the platform already provides isolation
- **Fix:** Step 0 detects existing isolation. Step 1a defers to native tools.

### Skipping detection

- **Problem:** Creating a nested worktree inside an existing one
- **Fix:** Always run Step 0 before creating anything

### Skipping ignore verification

- **Problem:** Worktree contents get tracked, pollute git status
- **Fix:** Always use `git check-ignore` before creating project-local worktree

### Treating setup edit as commit authorization

- **Problem:** Commits `.gitignore` merely because project-local worktree was selected
- **Fix:** Add the necessary rule, but commit it only under separate commit authorization

### Assuming directory location

- **Problem:** Creates inconsistency, violates project conventions
- **Fix:** Follow priority: explicit preference > existing project-local directory > project-local default

### Proceeding with failing tests

- **Problem:** Can't distinguish new bugs from pre-existing issues
- **Fix:** Report failures, get explicit permission to proceed

## Red Flags

**Never:**
- Create a worktree when Step 0 detects existing isolation
- Use `git worktree add` when you have a native worktree tool (e.g., `EnterWorktree`). This is the #1 mistake — if you have it, use it.
- Skip Step 1a by jumping straight to Step 1b's git commands
- Create worktree without verifying it's ignored (project-local)
- Commit the setup-owned `.gitignore` edit without separate authorization
- Skip baseline test verification
- Proceed with failing tests without asking

**Always:**
- Run Step 0 detection first
- Prefer native tools over git fallback
- Follow directory priority: explicit preference > existing project-local directory > project-local default
- Verify directory is ignored for project-local
- Add at most one matching `.gitignore` rule when project-local consent requires it
- Auto-detect and run project setup
- Verify clean test baseline
