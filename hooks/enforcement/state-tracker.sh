#!/bin/bash
# state-tracker.sh
# Core state management for enforcement system
# Called by all enforcement hooks

# Add $HOME/bin to PATH for jq
export PATH="$HOME/bin:$PATH"

STATE_FILE="${HOME}/.claude/runtime/enforcement-state.json"
ARCHIVE_DIR="${HOME}/.claude/runtime/enforcement/archive"

# Ensure directories exist
mkdir -p "$(dirname "$STATE_FILE")"
mkdir -p "$ARCHIVE_DIR"

# Initialize new session state
init_state() {
    local session_id=$(uuidgen 2>/dev/null || echo "session-$(date +%s)")
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    cat > "$STATE_FILE" << EOF
{
  "session_id": "$session_id",
  "started_at": "$timestamp",
  "workflow_state": {
    "phase": "idle",
    "started_at": null,
    "completed_phases": [],
    "current_task": null
  },
  "skill_invocations": [],
  "agent_spawns": [],
  "violations": [],
  "todos_created": false,
  "expertise_loaded": []
}
EOF

    echo "State initialized: $session_id" >&2
}

# Get current state
get_state() {
    if [ ! -f "$STATE_FILE" ]; then
        init_state
    fi
    cat "$STATE_FILE"
}

# Update state using jq
update_state() {
    local jq_filter="$1"
    local temp_file="${STATE_FILE}.tmp"

    if [ ! -f "$STATE_FILE" ]; then
        init_state
    fi

    jq "$jq_filter" "$STATE_FILE" > "$temp_file" && mv "$temp_file" "$STATE_FILE"
}

# Log skill invocation
log_skill() {
    local skill_name="$1"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # Map skill to phase
    local phase="execution"
    case "$skill_name" in
        intent-analyzer) phase="intent-analysis" ;;
        prompt-architect) phase="prompt-optimization" ;;
        planner|research-driven-planning|interactive-planner) phase="planning" ;;
        *) phase="execution" ;;
    esac

    update_state ".skill_invocations += [{
        \"skill_name\": \"$skill_name\",
        \"invoked_at\": \"$timestamp\",
        \"sop_followed\": false,
        \"agents_spawned\": []
    }] | .workflow_state.phase = \"$phase\" | .workflow_state.started_at = \"$timestamp\""

    echo "Logged skill: $skill_name (phase: $phase)" >&2
}

# Log agent spawn
log_agent() {
    local agent_type="$1"
    local agent_name="$2"
    local task_desc="$3"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # Check if agent type is from registry (basic check)
    local is_registry_agent="unknown"
    local category="unknown"

    # Known registry categories
    case "$agent_type" in
        coder|backend-dev|frontend-dev|fullstack-dev|mobile-dev|devops-engineer)
            is_registry_agent="true"
            category="delivery" ;;
        researcher|analyst|data-scientist|ml-engineer)
            is_registry_agent="true"
            category="research" ;;
        tester|qa-engineer|security-tester)
            is_registry_agent="true"
            category="quality" ;;
        reviewer|code-analyzer|auditor)
            is_registry_agent="true"
            category="quality" ;;
        *)
            is_registry_agent="false"
            category="unknown" ;;
    esac

    update_state ".agent_spawns += [{
        \"agent_type\": \"$agent_type\",
        \"agent_name\": \"$agent_name\",
        \"task_description\": \"$task_desc\",
        \"spawned_at\": \"$timestamp\",
        \"is_registry_agent\": $is_registry_agent,
        \"category\": \"$category\"
    }]"

    # Log violation if not registry agent
    if [ "$is_registry_agent" = "false" ]; then
        log_violation "generic_agent" "Non-registry agent type: $agent_type"
    fi

    echo "Logged agent: $agent_type ($category)" >&2
}

# Log violation
log_violation() {
    local violation_type="$1"
    local details="$2"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    update_state ".violations += [{
        \"type\": \"$violation_type\",
        \"detected_at\": \"$timestamp\",
        \"details\": \"$details\"
    }]"

    echo "VIOLATION: $violation_type - $details" >&2
}

# Mark TodoWrite called
mark_todowrite() {
    update_state ".todos_created = true"
    echo "TodoWrite marked as called" >&2
}

# Mark expertise loaded
mark_expertise() {
    local domain="$1"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    update_state ".expertise_loaded += [\"$domain\"]"
    echo "Expertise loaded: $domain" >&2
}

# Mark phase completed
mark_phase_complete() {
    local phase="$1"

    update_state ".workflow_state.completed_phases += [\"$phase\"]"
    echo "Phase completed: $phase" >&2
}

# Check SOP compliance
check_compliance() {
    local state=$(get_state)
    local violations=0

    # Check if skills were followed by Task calls
    local skill_count=$(echo "$state" | jq '.skill_invocations | length')
    local agent_count=$(echo "$state" | jq '.agent_spawns | length')

    if [ "$skill_count" -gt 0 ] && [ "$agent_count" -eq 0 ]; then
        echo "VIOLATION: Skill invoked but no agents spawned" >&2
        log_violation "missing_agents" "Skill invoked without Task() calls"
        violations=$((violations + 1))
    fi

    # Check if TodoWrite was called
    local todos_created=$(echo "$state" | jq -r '.todos_created')
    if [ "$agent_count" -gt 0 ] && [ "$todos_created" = "false" ]; then
        echo "VIOLATION: Agents spawned but no TodoWrite" >&2
        log_violation "missing_todowrite" "Agents spawned without TodoWrite() call"
        violations=$((violations + 1))
    fi

    # Check for generic agents
    local generic_count=$(echo "$state" | jq '[.agent_spawns[] | select(.is_registry_agent == false)] | length')
    if [ "$generic_count" -gt 0 ]; then
        echo "VIOLATION: $generic_count generic agents used" >&2
        violations=$((violations + generic_count))
    fi

    echo "Compliance check: $violations violations found" >&2
    return $violations
}

# Archive state at session end
archive_state() {
    if [ -f "$STATE_FILE" ]; then
        local session_id=$(jq -r '.session_id' "$STATE_FILE")
        local archive_file="$ARCHIVE_DIR/${session_id}.json"

        cp "$STATE_FILE" "$archive_file"
        echo "State archived to: $archive_file" >&2

        # Generate summary
        local violations=$(jq '.violations | length' "$STATE_FILE")
        local skills=$(jq '.skill_invocations | length' "$STATE_FILE")
        local agents=$(jq '.agent_spawns | length' "$STATE_FILE")

        echo "Session Summary:" >&2
        echo "  Skills invoked: $skills" >&2
        echo "  Agents spawned: $agents" >&2
        echo "  Violations: $violations" >&2
    fi
}

# Command dispatch
case "$1" in
    init_state) init_state ;;
    get_state) get_state ;;
    log_skill) log_skill "$2" ;;
    log_agent) log_agent "$2" "$3" "$4" ;;
    log_violation) log_violation "$2" "$3" ;;
    mark_todowrite) mark_todowrite ;;
    mark_expertise) mark_expertise "$2" ;;
    mark_phase_complete) mark_phase_complete "$2" ;;
    check_compliance) check_compliance ;;
    archive_state) archive_state ;;
    *)
        echo "Usage: $0 {init_state|get_state|log_skill|log_agent|log_violation|mark_todowrite|mark_expertise|mark_phase_complete|check_compliance|archive_state}" >&2
        exit 1
        ;;
esac
