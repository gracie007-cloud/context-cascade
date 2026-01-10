#!/bin/bash
# generate-report.sh
# Purpose: Generate compliance report from state file


# ============================================================
# LIBRARY-FIRST: Check library before coding tasks
# ============================================================

STATE_FILE="${HOME}/.claude/runtime/enforcement-state.json"
ARCHIVE_DIR="${HOME}/.claude/runtime/enforcement/archive"

if [ ! -f "$STATE_FILE" ]; then
    echo "No state file found. Run some commands first."
    exit 1
fi

echo "=== Enforcement System Compliance Report ==="
echo
echo "Generated: $(date)"
echo

# Session info
echo "SESSION INFORMATION:"
echo "  Session ID: $(jq -r '.session_id' "$STATE_FILE")"
echo "  Started: $(jq -r '.started_at' "$STATE_FILE")"
echo "  Current Phase: $(jq -r '.workflow_state.phase' "$STATE_FILE")"
echo

# Workflow stats
echo "WORKFLOW STATISTICS:"
echo "  Skills Invoked: $(jq '.skill_invocations | length' "$STATE_FILE")"
echo "  Agents Spawned: $(jq '.agent_spawns | length' "$STATE_FILE")"
echo "  TodoWrite Called: $(jq -r '.todos_created' "$STATE_FILE")"
echo "  Expertise Loaded: $(jq '.expertise_loaded | length' "$STATE_FILE")"
echo

# Skills breakdown
echo "SKILLS INVOKED:"
jq -r '.skill_invocations[] | "  - \(.skill_name) at \(.invoked_at)"' "$STATE_FILE"
echo

# Agents breakdown
echo "AGENTS SPAWNED:"
jq -r '.agent_spawns[] | "  - \(.agent_type) (\(.category)) - \(.agent_name)"' "$STATE_FILE"
echo

# Registry compliance
echo "REGISTRY COMPLIANCE:"
TOTAL_AGENTS=$(jq '.agent_spawns | length' "$STATE_FILE")
REGISTRY_AGENTS=$(jq '[.agent_spawns[] | select(.is_registry_agent == true)] | length' "$STATE_FILE")
GENERIC_AGENTS=$(jq '[.agent_spawns[] | select(.is_registry_agent == false)] | length' "$STATE_FILE")

if [ "$TOTAL_AGENTS" -gt 0 ]; then
    COMPLIANCE_PCT=$(echo "scale=2; $REGISTRY_AGENTS * 100 / $TOTAL_AGENTS" | bc)
    echo "  Total Agents: $TOTAL_AGENTS"
    echo "  Registry Agents: $REGISTRY_AGENTS"
    echo "  Generic Agents: $GENERIC_AGENTS"
    echo "  Compliance Rate: ${COMPLIANCE_PCT}%"
else
    echo "  No agents spawned"
fi
echo

# Violations
echo "VIOLATIONS:"
VIOLATION_COUNT=$(jq '.violations | length' "$STATE_FILE")
if [ "$VIOLATION_COUNT" -gt 0 ]; then
    jq -r '.violations[] | "  [\(.type)] \(.details) at \(.detected_at)"' "$STATE_FILE"
else
    echo "  No violations detected"
fi
echo

# SOP Compliance Check
echo "SOP COMPLIANCE CHECK:"
SKILLS=$(jq '.skill_invocations | length' "$STATE_FILE")
AGENTS=$(jq '.agent_spawns | length' "$STATE_FILE")
TODOS=$(jq -r '.todos_created' "$STATE_FILE")

echo -n "  Skill -> Task pattern: "
if [ "$SKILLS" -gt 0 ] && [ "$AGENTS" -gt 0 ]; then
    echo "PASS"
elif [ "$SKILLS" -eq 0 ] && [ "$AGENTS" -eq 0 ]; then
    echo "N/A (no skills invoked)"
else
    echo "FAIL"
fi

echo -n "  Task -> TodoWrite pattern: "
if [ "$AGENTS" -gt 0 ] && [ "$TODOS" = "true" ]; then
    echo "PASS"
elif [ "$AGENTS" -eq 0 ]; then
    echo "N/A (no agents spawned)"
else
    echo "FAIL"
fi

echo -n "  Overall SOP Compliance: "
if [ "$VIOLATION_COUNT" -eq 0 ]; then
    echo "PASS"
else
    echo "FAIL ($VIOLATION_COUNT violations)"
fi
echo

# Archive summary
echo "ARCHIVE INFORMATION:"
if [ -d "$ARCHIVE_DIR" ]; then
    ARCHIVE_COUNT=$(ls -1 "$ARCHIVE_DIR"/*.json 2>/dev/null | wc -l)
    echo "  Archived Sessions: $ARCHIVE_COUNT"
    if [ "$ARCHIVE_COUNT" -gt 0 ]; then
        echo "  Latest Archive: $(ls -t "$ARCHIVE_DIR"/*.json 2>/dev/null | head -1)"
    fi
else
    echo "  No archives found"
fi
echo

echo "=== End of Report ==="
