#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
SCRIPT="$ROOT/skills/using-git-worktrees/scripts/worktree-provenance"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
repo="$tmp/repo"; wt="$tmp/wt"
git init -q "$repo"; git -C "$repo" config user.email test@example.com; git -C "$repo" config user.name Test
git -C "$repo" commit -qm init --allow-empty
git -C "$repo" worktree add -qb feature "$wt"

[ "$("$SCRIPT" write "$wt")" = manual-owned ]
[ "$("$SCRIPT" inspect "$wt")" = manual-owned ]
if "$SCRIPT" inspect "$repo" >/dev/null 2>&1; then echo "main checkout owned" >&2; exit 1; fi
mkdir "$wt/subdir"
if "$SCRIPT" inspect "$wt/subdir" >/dev/null 2>&1; then echo "subdirectory owned" >&2; exit 1; fi
marker=$(git -C "$wt" rev-parse --path-format=absolute --git-dir)/k-superpowers-provenance-v1
cp "$marker" "$tmp/valid-marker"
sed "s|^path=.*|path=$tmp/wrong|" "$tmp/valid-marker" > "$marker"
if "$SCRIPT" inspect "$wt" >/dev/null 2>&1; then echo "path mismatch accepted" >&2; exit 1; fi
cp "$tmp/valid-marker" "$marker"
printf 'broken\n' > "$marker"
if "$SCRIPT" inspect "$wt" >/dev/null 2>&1; then echo "broken marker accepted" >&2; exit 1; fi
rm -f "$marker"
set +e; output=$("$SCRIPT" inspect "$wt"); rc=$?; set -e
[ "$rc" -eq 1 ] && [ "$output" = unowned ]

git_dir=$(git -C "$wt" rev-parse --path-format=absolute --git-dir)
chmod u-w "$git_dir"
if "$SCRIPT" write "$wt" >/dev/null 2>&1; then
  chmod u+w "$git_dir"
  echo "marker write failure was not detected" >&2
  exit 1
fi
chmod u+w "$git_dir"

bare="$tmp/bare.git"
git init -q --bare "$bare"
if "$SCRIPT" inspect "$bare" >/dev/null 2>&1; then echo "bare repo owned" >&2; exit 1; fi

grep -q 'platform-owned(native cleanup handle/tool)' "$ROOT/skills/using-git-worktrees/SKILL.md"
grep -q 'unowned is preserved' "$ROOT/skills/using-git-worktrees/SKILL.md"
echo "worktree provenance tests passed"
