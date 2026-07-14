# Git Action Recipes

Load only after the user selects an action. Substitute verified branch/path
values; never infer authorization for another action.

## MERGE

```bash
WORKTREE_PATH=<saved-canonical-worktree-path>
COMMON_DIR=$(git -C "$WORKTREE_PATH" rev-parse --path-format=absolute --git-common-dir)
MAIN_ROOT=$(git -C "$COMMON_DIR/.." rev-parse --show-toplevel)
git -C "$MAIN_ROOT" checkout <base>
git -C "$MAIN_ROOT" pull
git -C "$MAIN_ROOT" merge <feature>
<project verification command, run from "$MAIN_ROOT">
```

After merged-result verification, manual-owned cleanup runs in this order:

```bash
<worktree-provenance> inspect "$WORKTREE_PATH"
git -C "$MAIN_ROOT" worktree remove "$WORKTREE_PATH"
git -C "$MAIN_ROOT" branch -d <feature>
```

The `git pull` is intentionally retained. Do not clean up if checkout, pull,
merge, verification, or provenance inspection fails.

## PR

```bash
git push -u origin <feature>
gh pr create --title "<title>" --body-file <body-file>
```

For detached HEAD, first create/push the explicitly chosen branch name.

## DISCARD

After exact `discard` confirmation, remove only a verified owned worktree, then:

```bash
<worktree-provenance> inspect "$WORKTREE_PATH"
git -C "$MAIN_ROOT" worktree remove "$WORKTREE_PATH"
git -C "$MAIN_ROOT" branch -D <feature>
```

Never delete an unowned or platform-owned workspace with manual Git commands.
