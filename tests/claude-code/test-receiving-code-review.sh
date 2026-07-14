#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"
extra="--plugin-dir \"$PLUGIN_DIR\""

independent=$(run_claude "Use k-superpowers:receiving-code-review. One API architecture finding is unclear; one typo/import finding is clear and independent. Output exactly CLEAR_ITEM: PROCEED or BLOCK; UNCLEAR_ITEM: CLARIFY." 60 "" "$extra")
assert_contains "$independent" '^CLEAR_ITEM: PROCEED' "Independent clear item proceeds"
assert_contains "$independent" '^UNCLEAR_ITEM: CLARIFY' "Unclear related item waits"

shared=$(run_claude "Use k-superpowers:receiving-code-review. Three findings share one parser boundary root cause and require one API change. Output exactly FIX_GROUPS: 1 or FIX_GROUPS: 3; VERIFY: ATOMIC or PER_COMMENT." 60 "" "$extra")
assert_contains "$shared" '^FIX_GROUPS: 1' "Shared root cause uses one batch"
assert_contains "$shared" '^VERIFY: ATOMIC' "Shared root cause verifies atomically"

pushback=$(run_claude "Use k-superpowers:receiving-code-review. Reviewer asks to remove compatibility code, but documented version support and passing platform tests require it. Output exactly ACTION: REMOVE or ACTION: PUSH_BACK; EVIDENCE: REQUIRED or OPTIONAL." 60 "" "$extra")
assert_contains "$pushback" '^ACTION: PUSH_BACK' "Invalid suggestion gets evidence pushback"
assert_contains "$pushback" '^EVIDENCE: REQUIRED' "Pushback requires evidence"
