#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/../.." && pwd)
SCRIPT="$ROOT/skills/requesting-code-review/scripts/review-package"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
cd "$tmp"
git init -q
git config user.email test@example.com
git config user.name Test
mkdir -p src
printf 'one\n' > src/a.txt
printf 'rename\n' > src/b.txt
printf 'delete\n' > src/delete.txt
printf 'unstaged\n' > src/u.txt
printf 'src/a.txt\0src/b.txt\0src/binary.bin\0src/delete.txt\0src/new.txt\0src/renamed.txt\0src/u.txt\0' > scope
git add src && git commit -qm base
base=$(git rev-parse HEAD)
printf 'two\n' > src/a.txt
git add src/a.txt
printf 'changed unstaged\n' > src/u.txt
git mv src/b.txt src/renamed.txt
git rm -q src/delete.txt
printf 'new\n' > src/new.txt
printf '\000\001\002' > src/binary.bin

"$SCRIPT" working-tree "$base" scope package.md
grep -q 'k-superpowers-review-package/v1' package.md
grep -q '## Unstaged' package.md
grep -q '## Staged' package.md
grep -q 'src/new.txt' package.md
grep -q 'src/renamed.txt' package.md
grep -q 'src/delete.txt' package.md
grep -q 'CANNOT_VERIFY (binary)' package.md

if "$SCRIPT" working-tree "$base^" scope wrong-base.md 2>/dev/null; then
  echo "working-tree BASE mismatch accepted" >&2
  exit 1
fi

set +e
K_SUPERPOWERS_TEST_PAUSE_BEFORE_FINAL_FINGERPRINT=1 "$SCRIPT" working-tree "$base" scope race.md >/dev/null 2>&1 &
race_pid=$!
sleep 0.2
printf 'raced\n' >> src/u.txt
wait "$race_pid"
race_rc=$?
set -e
[ "$race_rc" -ne 0 ] || { echo "content race accepted" >&2; exit 1; }
printf 'changed unstaged\n' > src/u.txt

git add src && git commit -qm change
head=$(git rev-parse HEAD)
"$SCRIPT" committed "$base" "$head" scope committed.md
grep -q '## Commits' committed.md
grep -q 'change' committed.md

printf '../outside\0' > bad-scope
if bash "$SCRIPT" working-tree "$head" bad-scope bad.md 2>/dev/null; then
  echo "unsafe scope unexpectedly accepted" >&2
  exit 1
fi
printf '..\0' > dotdot-scope
set +e; "$SCRIPT" working-tree "$head" dotdot-scope dotdot.md >/dev/null 2>&1; dotdot_rc=$?; set -e
[ "$dotdot_rc" -eq 2 ] || { echo "exact dotdot scope did not return 2" >&2; exit 1; }

printf 'src/a.txt' > malformed-scope
if "$SCRIPT" working-tree "$head" malformed-scope malformed.md 2>/dev/null; then
  echo "non-NUL scope unexpectedly accepted" >&2
  exit 1
fi

printf ':(glob)src/*\0' > magic-scope
printf 'must-not-be-expanded\n' > src/a.txt
"$SCRIPT" working-tree "$head" magic-scope magic.md
if grep -q 'must-not-be-expanded' magic.md; then
  echo "pathspec magic unexpectedly expanded" >&2
  exit 1
fi

ln -s /etc/passwd src/link
printf 'src/link\0' > link-scope
"$SCRIPT" working-tree "$head" link-scope link.md
grep -q 'type: symlink' link.md
grep -q 'CANNOT_VERIFY' link.md

echo "review-package tests passed"
