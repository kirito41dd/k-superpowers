#!/usr/bin/env bash
# Deterministic checks for the Git helpers. All repository mutations are disposable.
set -euo pipefail
# A caller such as a Git hook may have exported its own index or worktree.
while IFS= read -r key; do unset "$key"; done < <(git rev-parse --local-env-vars)
export LC_ALL=C GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null
root=$(cd "$(dirname "$0")/.." && pwd)
snapshot="$root/skills/subagent-driven-development/scripts/task-snapshot"
package="$root/skills/requesting-code-review/scripts/review-package"
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT
git init -q "$scratch/repo"
cd "$scratch/repo"
git config user.name Fixture
git config user.email fixture@example.invalid

reject() {
  if "$@" > "$scratch/rejection" 2>&1; then
    echo "unexpected success: $*" >&2
    exit 1
  fi
}

printf 'base\n' > a
printf 'base\n' > b
printf 'base\n' > existing
git add a b existing
git commit -qm base
base=$(git rev-parse HEAD)

# Two writers share a checkout with pre-existing staged, unstaged and untracked work.
printf 'user staged\n' >> existing
git add existing
printf 'user unstaged\n' >> existing
printf 'user untracked\n' > notes
printf '%s\0' a b 'new [1]' > "$scratch/scope"
baseline="$scratch/working"
"$snapshot" capture-working "$baseline" "$scratch/scope"
printf 'local.cfg\n' >> .git/info/exclude
printf 'user config\n' > local.cfg
printf 'local.cfg\0' > "$scratch/hidden-scope"
reject "$snapshot" capture-working "$scratch/hidden" "$scratch/hidden-scope"
git update-index --assume-unchanged a
reject "$snapshot" capture-working "$scratch/hidden" "$scratch/scope"
reject "$snapshot" verify-working "$baseline" "$scratch/scope"
git update-index --no-assume-unchanged a
git update-index --assume-unchanged existing
printf 'replacement\n' > existing
reject "$snapshot" verify-working "$baseline" "$scratch/scope"
git update-index --no-assume-unchanged existing
printf 'base\nuser staged\nuser unstaged\n' > existing
printf 'writer A\n' >> a
printf 'writer B\n' >> b
printf 'new file\n' > 'new [1]'
"$snapshot" verify-working "$baseline" "$scratch/scope"
reject "$snapshot" capture-working "$scratch/overlap" "$scratch/scope"
printf 'outside scope\n' > other
reject "$snapshot" verify-working "$baseline" "$scratch/scope"
rm other
printf 'changed notes\n' > notes
reject "$snapshot" verify-working "$baseline" "$scratch/scope"
printf 'user untracked\n' > notes
git add a
reject "$snapshot" verify-working "$baseline" "$scratch/scope"
git reset -q HEAD -- a
"$snapshot" verify-working "$baseline" "$scratch/scope"
"$package" working-tree "$base" "$scratch/scope" "$scratch/working.md"
grep -Fq '+new file' "$scratch/working.md"

# Move the input branch immediately before the packager reads the commit list.
# Both the header and diff must still use the previously resolved commit.
git add a b
git commit -qm first
first=$(git rev-parse HEAD)
git branch moving "$first"
printf 'later commit\n' >> a
git add a
git commit -qm second
second=$(git rev-parse HEAD)
export TEST_REAL_GIT TEST_LATER_COMMIT="$second"
TEST_REAL_GIT=$(command -v git)
mkdir "$scratch/bin"
cat > "$scratch/bin/git" <<'WRAPPER'
#!/bin/sh
if [ "$1" = log ]; then
  "$TEST_REAL_GIT" update-ref refs/heads/moving "$TEST_LATER_COMMIT" || exit 1
fi
exec "$TEST_REAL_GIT" "$@"
WRAPPER
chmod +x "$scratch/bin/git"
PATH="$scratch/bin:$PATH" "$package" committed "$base" moving "$scratch/scope" "$scratch/committed.md"
test "$(git rev-parse moving)" = "$second"
grep -Fxq "head: $first" "$scratch/committed.md"
sed '1,/^## Diff$/d' "$scratch/committed.md" > "$scratch/actual.diff"
git diff --binary -U10 "$base" "$first" -- a b ':(literal)new [1]' > "$scratch/expected.diff"
cmp "$scratch/actual.diff" "$scratch/expected.diff"

# A scope is a writable file in this checkout. Opening a symlink for writing
# would modify its target, which can be outside the controller's evidence.
printf 'outside\n' > "$scratch/local"
ln -s "$scratch/local" leaf
ln -s "$scratch" bridge
git add leaf bridge
git commit -qm links
for path in leaf bridge/local .git/config; do
  printf '%s\0' "$path" > "$scratch/link-scope"
  reject "$snapshot" capture-working "$scratch/link-baseline" "$scratch/link-scope"
done

# The parent's gitlink stays dirty throughout. Replacement of an already
# modified child file must still invalidate a batch in the parent.
git clone -q --bare . "$scratch/origin.git"
git -c protocol.file.allow=always submodule add -q "$scratch/origin.git" sub
git commit -qm submodule
printf 'user edit\n' > sub/a
printf 'b\0' > "$scratch/parent-scope"
"$snapshot" capture-working "$scratch/parent-baseline" "$scratch/parent-scope"
printf 'replaced\n' > sub/a
reject "$snapshot" verify-working "$scratch/parent-baseline" "$scratch/parent-scope"
printf 'user edit\n' > sub/a
"$snapshot" verify-working "$scratch/parent-baseline" "$scratch/parent-scope"
echo "Git workflow regression checks passed"
