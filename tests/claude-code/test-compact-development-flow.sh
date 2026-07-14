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

output=$(run_claude "IMPORTANT: The user says only: 先熟悉这个模块，等我给需求. Apply the entry workflow. Do not invoke brainstorming unless its trigger is satisfied. Output exactly PREPARATION: WAIT or PREPARATION: BRAINSTORM." 30 "" "$PLUGIN_ARG")
assert_contains "$output" "^PREPARATION: WAIT" "Preparation-only request waits"

output=$(run_claude "IMPORTANT: A reproducible bug has been investigated with systematic-debugging and now has one clear local fix. Apply the workflow. Output exactly BUG_NEXT: DESIGN_APPROVAL or BUG_NEXT: IMPLEMENT; FLOW: Compact or FLOW: Full." 30 "" "$PLUGIN_ARG")
assert_contains "$output" "^BUG_NEXT: DESIGN_APPROVAL" "Bug fix still requires design approval"
assert_contains "$output" "FLOW: Compact" "Clear local bug fix uses Compact"

output=$(run_claude "IMPORTANT: A Full plan is self-reviewed. No Git or implementation authorization exists. During writing, the plan changed the approved local JSON format into a public binary protocol, which is a material contract delta. Output exactly PLAN_CHOICES: APPROVE_COMMIT | CHANGES | APPROVE_NO_COMMIT; IMPLEMENTATION_AUTH: SEPARATE; MATERIAL_DELTA: REAPPROVE." 30 "" "$PLUGIN_ARG")
assert_contains "$output" "PLAN_CHOICES: APPROVE_COMMIT | CHANGES | APPROVE_NO_COMMIT" "Full plan retains explicit commit choices"
assert_contains "$output" "IMPLEMENTATION_AUTH: SEPARATE" "Plan approval does not authorize implementation"
assert_contains "$output" "MATERIAL_DELTA: REAPPROVE" "Material delta returns for approval"

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

output=$(run_claude "IMPORTANT: Apply the loaded using-git-worktrees skill to six cases. Use only these action tokens: NO_EDIT, ADD_ONCE_NO_COMMIT, USE_GLOBAL_NO_EDIT, STOP_REPORT. Output exactly these lines before explanation: EXISTING_IGNORE: <action>; MISSING_IGNORE: <action>; EXPLICIT_GLOBAL: <action>; EXPLICIT_EDIT_AUTH: <action>; CREATION_FAILURE: <action>; CURRENT_WORKSPACE: <action>. Cases: 1) project-local .worktrees/ is already ignored; 2) project-local has no equivalent rule and no separate edit authorization; 3) explicit global path; 4) user separately authorizes adding the selected project-local directory to .gitignore but not committing it; 5) worktree creation fails; 6) Unified Handoff selected current workspace." 30 "" "$PLUGIN_ARG")
assert_contains "$output" "^EXISTING_IGNORE: NO_EDIT" "Existing ignore is not duplicated"
assert_contains "$output" "^MISSING_IGNORE: USE_GLOBAL_NO_EDIT" "Missing ignore uses global path without repository edit"
assert_contains "$output" "^EXPLICIT_GLOBAL: USE_GLOBAL_NO_EDIT" "Explicit global path does not edit repository"
assert_contains "$output" "^EXPLICIT_EDIT_AUTH: ADD_ONCE_NO_COMMIT" "Separate edit authorization allows one uncommitted rule"
assert_contains "$output" "^CREATION_FAILURE: STOP_REPORT" "Creation failure stops without silent fallback"
assert_contains "$output" "^CURRENT_WORKSPACE: NO_EDIT" "Current workspace returns without setup edits"

echo "=== All compact development flow tests passed ==="
