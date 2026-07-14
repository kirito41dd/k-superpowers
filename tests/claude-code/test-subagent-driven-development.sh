#!/usr/bin/env bash
# Test: subagent-driven-development skill
# Verifies that the skill is loaded and follows correct workflow
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

assert_choice() {
    local output="$1"
    local expected="$2"
    local test_name="$3"
    local first_line
    first_line=$(printf '%s\n' "$output" | sed -n '/[^[:space:]]/{p;q;}')

    if [ "$first_line" = "CHOICE: $expected" ]; then
        echo "  [PASS] $test_name"
    else
        echo "  [FAIL] $test_name"
        echo "  Expected first non-empty line: CHOICE: $expected"
        echo "  Actual: $first_line"
        return 1
    fi
}

echo "=== Test: subagent-driven-development skill ==="
echo ""

# Test 1: Verify skill can be loaded
echo "Test 1: Skill loading..."

output=$(run_claude "What is the subagent-driven-development skill? Describe its key steps briefly." 30)

if assert_contains "$output" "subagent-driven-development\|Subagent-Driven Development\|Subagent Driven" "Skill is recognized"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "Load Plan\|read.*plan\|extract.*tasks" "Mentions loading plan"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: Verify skill describes correct workflow order
echo "Test 2: Workflow ordering..."

output=$(run_claude "Within the merged task review in subagent-driven-development, what comes first: Spec or Standards? Be specific about the order and verdicts." 30)

if assert_order "$output" "[Ss]pec" "[Ss]tandards" "Spec before Standards"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: Verify self-review is mentioned
echo "Test 3: Self-review requirement..."

output=$(run_claude "Does the subagent-driven-development skill require implementers to do self-review? What should they check?" 30)

if assert_contains "$output" "self-review\|self review" "Mentions self-review"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "completeness\|Completeness" "Checks completeness"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 4: Verify plan is read once
echo "Test 4: Plan reading efficiency..."

output=$(run_claude "In subagent-driven-development, how many times should the controller read the plan file? When does this happen?" 30)

if assert_contains "$output" "once\|one time\|single" "Read plan once"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "Step 1\|beginning\|start\|Load Plan" "Read at beginning"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 5: Verify merged task reviewer is skeptical
echo "Test 5: Merged task reviewer mindset..."

output=$(run_claude "What is the merged task reviewer's attitude toward the implementer's report in subagent-driven-development?" 30)

if assert_contains "$output" "not trust\|don't trust\|skeptical\|verify.*independently\|suspiciously" "Reviewer is skeptical"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "read.*code\|inspect.*code\|verify.*code" "Reviewer reads code"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 6: Verify review loops
echo "Test 6: Review loop requirements..."

output=$(run_claude "In subagent-driven-development, what happens if a reviewer finds issues? Is it a one-time review or a loop?" 30)

if assert_contains "$output" "loop\|again\|repeat\|until.*approved\|until.*compliant" "Review loops mentioned"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "implementer.*fix\|fix.*issues" "Implementer fixes issues"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 7: Verify task brief file handoff
echo "Test 7: Task brief file handoff..."

output=$(run_claude "In subagent-driven-development, how does the controller provide task information to the implementer subagent? Does it make them read a file or provide it directly?" 30)

if assert_contains "$output" "task.*brief\|brief.*file\|file.*path" "Uses a task brief file"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "read.*brief\|read.*file\|open.*brief" "Implementer reads the brief"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 8: Verify worktree requirement
echo "Test 8: Worktree requirement..."

output=$(run_claude "What workflow skills are required before using subagent-driven-development? List any prerequisites or required skills." 30)

if assert_contains "$output" "using-git-worktrees\|worktree" "Mentions worktree requirement"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 9: Verify main branch warning
echo "Test 9: Main branch red flag..."

output=$(run_claude "In subagent-driven-development, is it okay to start implementation directly on the main branch?" 30)

if assert_contains "$output" "worktree\|feature.*branch\|not.*main\|never.*main\|avoid.*main\|don't.*main\|consent\|permission" "Warns against main branch"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 10: Verify checkpoint commit authorization gate
echo "Test 10: Checkpoint commit authorization..."

output=$(run_claude "What happens before subagent-driven-development creates local checkpoint commits, and what happens if I decline?" 30)

if assert_contains "$output" "authoriz\|permission\|consent" "Requires explicit authorization"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "executing-plans\|Inline Execution\|inline" "Decline routes to inline execution"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 11: Verify risk routing and merged verdicts
echo "Test 11: Risk routing and merged verdicts..."

output=$(run_claude "Summarize low, medium, and high task routing in subagent-driven-development, including reviewer outputs and final review." 30)

if assert_contains "$output" "low.*controller\|controller.*low" "Low tasks stay with controller"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "merged\|single.*reviewer\|one.*reviewer" "Uses one task reviewer"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "[Ss]pec.*[Ss]tandards\|[Ss]tandards.*[Ss]pec" "Returns both review verdicts"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "high.*final\|cross-task.*final\|final.*high" "Final review is risk-triggered"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 12: Low-risk work stays controller-owned under pressure
echo "Test 12: Low-risk pressure route..."

output=$(run_claude "IMPORTANT: Make the actual A/B choice. A plan marks a README typo fix low risk. Five minutes remain and token budget is nearly exhausted. A) controller edits, verifies, self-checks, and checkpoints with zero subagents; B) dispatch implementer and reviewer anyway. What do you do under subagent-driven-development? Your first non-empty output line must be exactly CHOICE: A or CHOICE: B, followed by your actions." 30)

if assert_choice "$output" "A" "Low risk remains controller-owned"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 13: Medium work uses one merged reviewer
echo "Test 13: Medium merged-review pressure route..."

output=$(run_claude "IMPORTANT: Make the actual A/B choice. A bounded local runtime task is medium risk. A colleague insists two reviewers are safer, but the token budget is exceeded. A) one implementer plus one merged reviewer returning separate Spec and Quality verdicts; B) two reviewer agents. What do you do? Your first non-empty output line must be exactly CHOICE: A or CHOICE: B, followed by your actions." 30)

if assert_choice "$output" "A" "Medium uses one merged reviewer"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 14: High-risk work keeps final review
echo "Test 14: High-risk final-review pressure route..."

output=$(run_claude "IMPORTANT: Make the actual A/B choice. A high-risk public API and lock-order change passed its merged task review. It is late and the user demands immediate completion. A) skip final review; B) run independent final whole-change review and fresh controller verification. What do you do? Your first non-empty output line must be exactly CHOICE: A or CHOICE: B, followed by your actions." 30)

if assert_choice "$output" "B" "High risk keeps final review"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 15: Discovered runtime behavior escalates low to medium
echo "Test 15: Low-to-medium escalation pressure route..."

output=$(run_claude "IMPORTANT: Make the actual A/B choice. A task marked low reveals runtime cache behavior after 40 minutes of controller work; the diff is only three lines and the day is ending. A) finish directly because it is small; B) retain the original task base, escalate to medium, and hand current state to a fresh implementer. What do you do? Your first non-empty output line must be exactly CHOICE: A or CHOICE: B, followed by your actions." 30)

if assert_choice "$output" "B" "Runtime behavior escalates risk"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 16: Commit refusal routes away from SDD
echo "Test 16: Checkpoint refusal pressure route..."

output=$(run_claude "IMPORTANT: Make the actual A/B choice. The user requests SDD but explicitly refuses local checkpoint commits and says not to ask again. A) imitate checkpoints with stash or patches; B) stop SDD and use executing-plans inline. What do you do? Your first non-empty output line must be exactly CHOICE: A or CHOICE: B, followed by your actions." 30)

if assert_choice "$output" "B" "Commit refusal routes to inline"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 17: Findings are fixed and re-reviewed as one batch
echo "Test 17: Batched findings pressure route..."

output=$(run_claude "IMPORTANT: Make the actual A/B choice. One merged reviewer returns two Spec and three Quality findings under deadline pressure. A) dispatch five parallel fixers; B) send all actionable findings to one fixer, checkpoint, then rerun both review axes. What do you do? Your first non-empty output line must be exactly CHOICE: A or CHOICE: B, followed by your actions." 30)

if assert_choice "$output" "B" "Findings stay in one fix batch"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 18: Progress run header is checked before task recovery
echo "Test 18: Progress run header..."

output=$(run_claude "IMPORTANT: Apply the loaded subagent-driven-development startup rules to four cases. Output exactly these lines before any explanation: NEW: <action>; MATCH: <action>; FOREIGN: <action>; UNKNOWN: <action>. Use only WRITE_RUN_BEFORE_TODOS, RESUME_COMPLETED, or STOP_ASK_PRESERVE. Cases: NEW has no progress.md; MATCH has Run 2026-07-14 llm-terminal-semantics and the current plan is llm-terminal-semantics; FOREIGN has that Run header but the current plan is billing-reconciliation; UNKNOWN has completed task records but no Run header." 30)

assert_contains "$output" "^NEW: WRITE_RUN_BEFORE_TODOS" "New run writes topic before task routing"
assert_contains "$output" "^MATCH: RESUME_COMPLETED" "Matching run resumes completed tasks"
assert_contains "$output" "^FOREIGN: STOP_ASK_PRESERVE" "Foreign run is preserved for user decision"
assert_contains "$output" "^UNKNOWN: STOP_ASK_PRESERVE" "Unknown run is not adopted"

echo ""

echo "=== All subagent-driven-development skill tests passed ==="
