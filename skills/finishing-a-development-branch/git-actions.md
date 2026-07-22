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
git -C "$WORKTREE_PATH" rebase <base>
<project verification command, run from "$WORKTREE_PATH">
git -C "$MAIN_ROOT" merge --ff-only <feature>
<project verification command, run from "$MAIN_ROOT">
```

After merged-result verification, manual-owned cleanup runs in this order:

```bash
<worktree-provenance> inspect "$WORKTREE_PATH"
git -C "$MAIN_ROOT" worktree remove "$WORKTREE_PATH"
git -C "$MAIN_ROOT" branch -d <feature>
```

The `git pull` is intentionally retained. Do not clean up if checkout, pull,
rebase, fast-forward merge, verification, or provenance inspection fails. A
rebase conflict stops this action for resolution; do not fall back to merging
the base into the feature. If the feature was already published, do not
force-push the rewritten branch without separate explicit authorization; when
authorized, prefer `--force-with-lease` over `--force`.

## PR

Treat `PR` as the semantic action for the provider's review request, including
a GitHub pull request or GitLab merge request. Determine the provider from
repository configuration, remote context, and available authenticated tools;
do not assume every remote is GitHub or rely on URL shape alone.

For a straightforward GitLab merge request in the same project, create it as
part of a branch push. This avoids searching for a separate CLI or opening a
browser when GitLab's native push options are sufficient:

```bash
git push -u origin <feature> \
  -o merge_request.create \
  -o merge_request.target=<base> \
  -o 'merge_request.title=<title>' \
  -o 'merge_request.description=<short-description>'
```

Inspect the push output and report the created merge request URL. GitLab push
options are server-side GitLab behavior, not portable Git flags. If the branch
has already been pushed without a new update, or the request needs richer
metadata, reviewers, labels, milestones, fork targeting, or updates to an
existing merge request, use an authenticated `glab` command or the GitLab API.
Use the browser only when those paths are unavailable or interactive UI work is
actually needed.

For GitHub:

```bash
git push -u origin <feature>
gh pr create --title "<title>" --body-file <body-file>
```

For another or unknown provider, use its known native CLI/API when available;
otherwise report the missing capability instead of guessing commands.

For detached HEAD, first create/push the explicitly chosen branch name.

## DISCARD

After exact `discard` confirmation, remove only a verified owned worktree, then:

```bash
<worktree-provenance> inspect "$WORKTREE_PATH"
git -C "$MAIN_ROOT" worktree remove "$WORKTREE_PATH"
git -C "$MAIN_ROOT" branch -D <feature>
```

Never delete an unowned or platform-owned workspace with manual Git commands.
