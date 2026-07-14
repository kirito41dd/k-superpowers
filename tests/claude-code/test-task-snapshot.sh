#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
SCRIPT="$ROOT/skills/subagent-driven-development/scripts/task-snapshot"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
cd "$tmp"; git init -q; git config user.email test@example.com; git config user.name Test
printf 'snap/\n' > .gitignore
printf 'base\n' > owned.txt; printf 'user\n' > user.txt; git add .; git commit -qm base
printf 'user dirty\n' >> user.txt
base=$(git rev-parse HEAD)
"$SCRIPT" capture snap
printf 'owned.txt\0' > snap/scope
"$SCRIPT" check-scope snap snap/scope
printf 'task\n' >> owned.txt; git add owned.txt; git commit -qm task
head=$(git rev-parse HEAD); printf '%s\n' "$head" > snap/commits
"$SCRIPT" verify snap "$base" "$head" snap/scope snap/commits

printf 'task two\n' >> owned.txt; git add owned.txt; git commit -qm task-two
head2=$(git rev-parse HEAD); printf '%s\n%s\n' "$head" "$head2" > snap/commits-two
"$SCRIPT" verify snap "$base" "$head2" snap/scope snap/commits-two

if "$SCRIPT" verify snap "$head" "$head2" snap/scope snap/commits-two 2>/dev/null; then
  echo "captured-base mismatch accepted" >&2
  exit 1
fi
cp -R snap corrupt-snap
printf 'corrupt' >> corrupt-snap/status
if "$SCRIPT" check-scope corrupt-snap snap/scope >/dev/null 2>&1; then
  echo "corrupt snapshot accepted" >&2
  exit 1
fi
cp -R snap truncated-snap
: > truncated-snap/artifacts.sha256
set +e; "$SCRIPT" check-scope truncated-snap snap/scope >/dev/null 2>&1; truncated_rc=$?; set -e
[ "$truncated_rc" -eq 2 ] || { echo "truncated manifest did not return 2" >&2; exit 1; }
cp -R snap partial-snap
sed -n '1p' partial-snap/artifacts.sha256 > partial-snap/one-line
mv partial-snap/one-line partial-snap/artifacts.sha256
set +e; "$SCRIPT" check-scope partial-snap snap/scope >/dev/null 2>&1; partial_rc=$?; set -e
[ "$partial_rc" -eq 2 ] || { echo "partial manifest did not return 2" >&2; exit 1; }
printf 'owned.txt' > snap/malformed-scope
set +e; "$SCRIPT" check-scope snap snap/malformed-scope >/dev/null 2>&1; malformed_rc=$?; set -e
[ "$malformed_rc" -eq 2 ] || { echo "malformed scope did not return 2" >&2; exit 1; }
printf '..\0' > snap/dotdot-scope
set +e; "$SCRIPT" check-scope snap snap/dotdot-scope >/dev/null 2>&1; dotdot_rc=$?; set -e
[ "$dotdot_rc" -eq 2 ] || { echo "exact dotdot scope did not return 2" >&2; exit 1; }

printf 'user.txt\0' > snap/overlap
if "$SCRIPT" check-scope snap snap/overlap 2>/dev/null; then echo "overlap accepted" >&2; exit 1; fi
printf '%s\n%s\n' "$head2" "$base" > snap/bad-commits
if "$SCRIPT" verify snap "$base" "$head2" snap/scope snap/bad-commits 2>/dev/null; then echo "unauthorized range accepted" >&2; exit 1; fi
printf 'mutated\n' >> user.txt
if "$SCRIPT" verify snap "$base" "$head2" snap/scope snap/commits-two 2>/dev/null; then echo "dirty mutation accepted" >&2; exit 1; fi

git checkout -- user.txt
printf 'outside\n' > outside.txt; git add outside.txt; git commit -qm outside
outside_commit=$(git rev-parse HEAD)
git rm -q outside.txt; git commit -qm restore
restore_commit=$(git rev-parse HEAD)
printf '%s\n%s\n%s\n%s\n' "$head" "$head2" "$outside_commit" "$restore_commit" > snap/commits-with-outside
if "$SCRIPT" verify snap "$base" "$restore_commit" snap/scope snap/commits-with-outside 2>/dev/null; then
  echo "out-of-scope intermediate commit accepted" >&2
  exit 1
fi
echo "task-snapshot tests passed"
