#!/usr/bin/env bash
# Test: compact development flow routing and handoff behavior
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

assert_first_line() {
    local output="$1"
    local expected="$2"
    local name="$3"
    local first_line
    first_line=$(printf '%s\n' "$output" | sed -n '/[^[:space:]]/{p;q;}')

    if [ "$first_line" = "$expected" ]; then
        echo "  [PASS] $name"
    else
        echo "  [FAIL] $name"
        echo "  Expected: $expected"
        echo "  Actual: $first_line"
        return 1
    fi
}

echo "=== Test: compact development flow ==="

PLUGIN_DIR=$(cd "$SCRIPT_DIR/../.." && pwd)
PLUGIN_ARG="--plugin-dir \"$PLUGIN_DIR\""

output=$(run_claude "IMPORTANT: Make an actual workflow decision using the loaded brainstorming and writing-plans skills. The user asks to rename one CLI flag and update its focused tests in one subsystem. Goal and success criteria are explicit, there is no migration/security/protocol/public compatibility decision, and the user can evaluate trade-offs. Output exactly these lines before any explanation: FLOW: Compact or FLOW: Full; BLOCKING_QUESTIONS: <number>; USER_REPLIES: DESIGN_APPROVAL -> UNIFIED_HANDOFF or another exact ordered gate list; SPEC_REVIEW: SKIP_IF_FAITHFUL or REQUIRED; PLAN_REVIEW: SKIP_IF_FAITHFUL or REQUIRED; IMPLEMENTATION_AUTH: UNIFIED_HANDOFF_ONLY; HANDOFF_OPTIONS: <number>." 30 "" "$PLUGIN_ARG")
assert_first_line "$output" "FLOW: Compact" "Clear single-domain work selects Compact"
assert_contains "$output" "BLOCKING_QUESTIONS: [01]" "Compact asks at most one blocking question"
assert_contains "$output" "^USER_REPLIES: DESIGN_APPROVAL -> UNIFIED_HANDOFF$" "Compact has exactly two user replies"
assert_not_contains "$output" "USER_REPLIES:.*SPEC_APPROVAL\|USER_REPLIES:.*PLAN_APPROVAL" "Compact reply trace has no duplicate approval"
assert_contains "$output" "SPEC_REVIEW: SKIP_IF_FAITHFUL" "Faithful Compact spec skips duplicate review"
assert_contains "$output" "PLAN_REVIEW: SKIP_IF_FAITHFUL" "Faithful Compact plan skips duplicate review"
assert_contains "$output" "IMPLEMENTATION_AUTH: UNIFIED_HANDOFF_ONLY" "Implementation waits for unified handoff"
assert_contains "$output" "HANDOFF_OPTIONS: 5" "Unified handoff exposes five bounded choices"

output=$(run_claude "IMPORTANT: Make an actual workflow decision using the loaded brainstorming and writing-plans skills. The user wants an irreversible database migration plus a new permission model, and two architecture questions are unresolved. First non-empty line must be FLOW: Compact or FLOW: Full. Then output GATES: with the ordered gates that remain." 30 "" "$PLUGIN_ARG")
assert_first_line "$output" "FLOW: Full" "Irreversible uncertain work selects Full"
assert_contains "$output" "GATES:.*clarif\|GATES:.*澄清" "Full retains clarification"
assert_contains "$output" "section.*approv\|分段.*批准" "Full retains sectional design approval"
assert_contains "$output" "spec.*review\|spec.*批准" "Full retains written spec review"
assert_contains "$output" "plan.*review\|plan.*批准" "Full retains plan review"
assert_contains "$output" "handoff" "Full still requires execution handoff"

output=$(run_claude "IMPORTANT: Make an actual completion-routing decision using the loaded executing-plans and finishing-a-development-branch skills. Unified handoff selected Inline + current workspace. Work was performed on main with explicit consent, fresh verification passed, and the user did not request merge, PR, push, discard, or cleanup. First non-empty line must be exactly FINISH: SKIP or FINISH: INVOKE. Then state the user-facing action." 30 "" "$PLUGIN_ARG")
assert_first_line "$output" "FINISH: SKIP" "Current-main Inline skips branch finish menu"
assert_contains "$output" "remain.*current workspace\|current workspace.*remain\|保留.*当前" "Reports changes in place"

echo "=== All compact development flow tests passed ==="
