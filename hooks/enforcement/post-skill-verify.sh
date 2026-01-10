#!/bin/bash
# post-skill-verify.sh
# PostToolUse hook for Skill - verifies skill outputs match expected patterns

# Add $HOME/bin to PATH for jq

# ============================================================
# LIBRARY-FIRST: Check library before coding tasks
# ============================================================

export PATH="$HOME/bin:$PATH"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STATE_FILE="$HOME/.claude/runtime/enforcement-state.json"
PATTERNS_FILE="$SCRIPT_DIR/skill-patterns.json"
VERIFICATION_LOG="$HOME/.claude/runtime/skill-verification.log"

# Ensure log directory exists
mkdir -p "$(dirname "$VERIFICATION_LOG")"

log_verification() {
    local skill="$1"
    local status="$2"
    local message="$3"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    echo "[$timestamp] [$status] $skill: $message" >> "$VERIFICATION_LOG"
}

# Get the last invoked skill from state
get_last_skill() {
    if [ -f "$STATE_FILE" ]; then
        jq -r '.skill_invocations[-1].skill_name // "unknown"' "$STATE_FILE" 2>/dev/null || echo "unknown"
    else
        echo "unknown"
    fi
}

# Get expected pattern for a skill
get_pattern() {
    local skill="$1"
    if [ -f "$PATTERNS_FILE" ]; then
        local pattern=$(jq -r ".patterns[\"$skill\"] // .default_pattern" "$PATTERNS_FILE" 2>/dev/null)
        echo "$pattern"
    else
        echo "{}"
    fi
}

# Check if expected actions occurred
check_actions() {
    local skill="$1"

    if [ ! -f "$STATE_FILE" ]; then
        echo "STATE_FILE_MISSING" >&2
        return 1
    fi

    if [ ! -f "$PATTERNS_FILE" ]; then
        echo "PATTERNS_FILE_MISSING" >&2
        return 0
    fi

    local missing_actions=""

    # Check for Task requirement - use simple query
    local needs_task=$(jq -r ".patterns.\"$skill\".expected_actions // .default_pattern.expected_actions | contains([\"Task\"])" "$PATTERNS_FILE" 2>/dev/null)
    if [ "$needs_task" = "true" ]; then
        local task_count=$(jq '.agent_spawns | length' "$STATE_FILE" 2>/dev/null)
        if [ "$task_count" = "0" ] || [ -z "$task_count" ]; then
            missing_actions="$missing_actions Task(agent_spawn)"
        fi
    fi

    # Check for TodoWrite requirement
    local needs_todowrite=$(jq -r ".patterns.\"$skill\".expected_actions // .default_pattern.expected_actions | contains([\"TodoWrite\"])" "$PATTERNS_FILE" 2>/dev/null)
    if [ "$needs_todowrite" = "true" ]; then
        local todos_created=$(jq -r '.todos_created' "$STATE_FILE" 2>/dev/null)
        if [ "$todos_created" != "true" ]; then
            missing_actions="$missing_actions TodoWrite"
        fi
    fi

    # Check if missing_actions has content (length > 0)
    if [ ${#missing_actions} -gt 0 ]; then
        echo "$missing_actions"
        return 1
    fi

    return 0
}

# Main verification
main() {
    local skill=$(get_last_skill)

    if [ "$skill" = "unknown" ]; then
        echo "!! SKILL VERIFICATION: No skill found in state !!" >&2
        return 0
    fi

    local pattern=$(get_pattern "$skill")
    local verification_msg=$(echo "$pattern" | jq -r '.verification_message // "No verification message"' 2>/dev/null)

    echo "================================================================" >&2
    echo "!! SKILL COMPLETION VERIFICATION: $skill !!" >&2
    echo "================================================================" >&2
    echo "" >&2
    echo "Expected: $verification_msg" >&2
    echo "" >&2

    # Check expected actions - use file-based result due to subshell issues
    local result_file="/tmp/skill-verify-result-$$"
    check_actions "$skill" > "$result_file"
    local check_result=$?
    local missing=$(cat "$result_file" 2>/dev/null)
    rm -f "$result_file"

    if [ $check_result -ne 0 ]; then
        echo "!! WARNING: Missing expected actions: $missing !!" >&2
        echo "" >&2
        echo "REMINDER: After invoking a skill, you MUST:" >&2
        echo "  1. Spawn agents via Task() to execute the skill's workflow" >&2
        echo "  2. Track progress via TodoWrite() with 5-10 todos" >&2
        echo "  3. Complete all skill-specific outputs" >&2
        echo "" >&2
        log_verification "$skill" "WARNING" "Missing actions: $missing"

        # Update state with verification failure
        if [ -f "$STATE_FILE" ]; then
            local temp_file="${STATE_FILE}.tmp"
            jq ".skill_invocations[-1].sop_followed = false | .skill_invocations[-1].missing_actions = \"$missing\"" "$STATE_FILE" > "$temp_file" 2>/dev/null && mv "$temp_file" "$STATE_FILE"
        fi
    else
        echo "VERIFICATION: Skill pattern compliance detected" >&2
        log_verification "$skill" "PASS" "All expected actions found"

        # Update state with verification success
        if [ -f "$STATE_FILE" ]; then
            local temp_file="${STATE_FILE}.tmp"
            jq ".skill_invocations[-1].sop_followed = true" "$STATE_FILE" > "$temp_file" 2>/dev/null && mv "$temp_file" "$STATE_FILE"
        fi
    fi

    echo "================================================================" >&2
    echo "" >&2
}

main "$@"
