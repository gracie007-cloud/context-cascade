#!/bin/bash
# test-hooks.sh
# Purpose: Test enforcement hook system

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_TRACKER="$SCRIPT_DIR/state-tracker.sh"

echo "=== Testing Enforcement Hook System ==="
echo

# Test 1: Initialize state
echo "Test 1: Initialize state"
bash "$STATE_TRACKER" init_state
if [ $? -eq 0 ]; then
    echo "  PASS: State initialized"
else
    echo "  FAIL: State initialization failed"
fi
echo

# Test 2: Log skill invocation
echo "Test 2: Log skill invocation"
bash "$STATE_TRACKER" log_skill "intent-analyzer"
if [ $? -eq 0 ]; then
    echo "  PASS: Skill logged"
else
    echo "  FAIL: Skill logging failed"
fi
echo

# Test 3: Log agent spawn (valid)
echo "Test 3: Log agent spawn (valid registry type)"
bash "$STATE_TRACKER" log_agent "coder" "Code Implementation Agent" "Implement feature X"
if [ $? -eq 0 ]; then
    echo "  PASS: Valid agent logged"
else
    echo "  FAIL: Agent logging failed"
fi
echo

# Test 4: Log agent spawn (invalid)
echo "Test 4: Log agent spawn (invalid generic type)"
bash "$STATE_TRACKER" log_agent "generic-coder" "Generic Agent" "Do stuff"
if [ $? -eq 0 ]; then
    echo "  PASS: Invalid agent logged (violation expected)"
else
    echo "  FAIL: Agent logging failed"
fi
echo

# Test 5: Mark TodoWrite
echo "Test 5: Mark TodoWrite"
bash "$STATE_TRACKER" mark_todowrite
if [ $? -eq 0 ]; then
    echo "  PASS: TodoWrite marked"
else
    echo "  FAIL: TodoWrite marking failed"
fi
echo

# Test 6: Check compliance
echo "Test 6: Check compliance"
bash "$STATE_TRACKER" check_compliance
VIOLATIONS=$?
echo "  Violations found: $VIOLATIONS"
echo

# Test 7: Get state
echo "Test 7: Get current state"
STATE=$(bash "$STATE_TRACKER" get_state)
if [ $? -eq 0 ]; then
    echo "  PASS: State retrieved"
    echo "  State summary:"
    echo "$STATE" | jq '{
        session_id,
        workflow_phase: .workflow_state.phase,
        skills_invoked: (.skill_invocations | length),
        agents_spawned: (.agent_spawns | length),
        violations: (.violations | length),
        todos_created: .todos_created
    }'
else
    echo "  FAIL: State retrieval failed"
fi
echo

# Test 8: Archive state
echo "Test 8: Archive state"
bash "$STATE_TRACKER" archive_state
if [ $? -eq 0 ]; then
    echo "  PASS: State archived"
else
    echo "  FAIL: State archiving failed"
fi
echo

# Test 9: Test individual hooks
echo "Test 9: Test UserPromptSubmit hook"
echo '{"message": "Implement a new feature"}' | bash "$SCRIPT_DIR/user-prompt-submit.sh" > /dev/null
if [ $? -eq 0 ]; then
    echo "  PASS: UserPromptSubmit hook executed"
else
    echo "  FAIL: UserPromptSubmit hook failed"
fi
echo

echo "Test 10: Test PreToolUse Skill hook"
echo '{"tool_input": {"skill": "planner"}}' | bash "$SCRIPT_DIR/pre-skill-invoke.sh" > /dev/null
if [ $? -eq 0 ]; then
    echo "  PASS: PreToolUse Skill hook executed"
else
    echo "  FAIL: PreToolUse Skill hook failed"
fi
echo

echo "Test 11: Test PostToolUse Skill hook"
echo '{"tool_name": "Skill"}' | bash "$SCRIPT_DIR/post-skill-compliance.sh" > /dev/null
if [ $? -eq 0 ]; then
    echo "  PASS: PostToolUse Skill hook executed"
else
    echo "  FAIL: PostToolUse Skill hook failed"
fi
echo

echo "Test 12: Test PreCompact hook"
bash "$SCRIPT_DIR/pattern-retention.sh" > /dev/null
if [ $? -eq 0 ]; then
    echo "  PASS: PreCompact hook executed"
else
    echo "  FAIL: PreCompact hook failed"
fi
echo

echo "Test 13: Test Stop hook"
bash "$SCRIPT_DIR/session-stop.sh" > /dev/null
if [ $? -eq 0 ]; then
    echo "  PASS: Stop hook executed"
else
    echo "  FAIL: Stop hook failed"
fi
echo

echo "=== Hook System Test Complete ==="
echo
echo "Check state file: ${HOME}/.claude/runtime/enforcement-state.json"
echo "Check archives: ${HOME}/.claude/runtime/enforcement/archive/"
