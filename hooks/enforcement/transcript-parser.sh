#!/bin/bash
# transcript-parser.sh
# Purpose: Parse conversation transcript to validate Task() parameters
#
# CRITICAL: This is needed because hooks CANNOT inspect Task() parameters
# This script runs async to validate agent types against registry


# ============================================================
# LIBRARY-FIRST: Check library before coding tasks
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_TRACKER="$SCRIPT_DIR/state-tracker.sh"
TRANSCRIPT_FILE="${HOME}/.claude/history.jsonl"
REGISTRY_FILE="${HOME}/claude-code-plugins/ruv-sparc-three-loop-system/agents/REGISTRY.json"

# Agent registry categories (for validation when registry file not available)
KNOWN_AGENT_TYPES=(
    # Delivery
    "coder" "backend-dev" "frontend-dev" "fullstack-dev" "mobile-dev"
    "devops-engineer" "sre" "release-engineer" "api-developer" "database-dev"

    # Research
    "researcher" "analyst" "data-scientist" "ml-engineer" "experiment-designer"

    # Quality
    "tester" "qa-engineer" "security-tester" "load-tester" "reviewer"
    "code-analyzer" "auditor" "compliance-checker" "theater-detection-audit"

    # Orchestration
    "hierarchical-coordinator" "byzantine-coordinator" "workflow-orchestrator"
    "task-router" "dependency-manager"

    # Foundry
    "agent-creator" "skill-creator" "prompt-engineer" "template-generator"

    # Operations
    "cicd-engineer" "monitoring-engineer" "incident-responder" "backup-manager"

    # Platforms
    "platform-engineer" "cloud-architect" "kubernetes-expert" "terraform-expert"

    # Security
    "security-engineer" "penetration-tester" "crypto-expert" "compliance-auditor"

    # Tooling
    "build-engineer" "package-manager" "dependency-analyzer" "linter-configurator"
)

# Parse transcript for Task() calls
parse_task_calls() {
    if [ ! -f "$TRANSCRIPT_FILE" ]; then
        echo "Transcript file not found: $TRANSCRIPT_FILE" >&2
        return 1
    fi

    # Extract recent Task() calls from transcript
    # This is a simplified parser - may need refinement
    local task_calls=$(grep -o 'Task([^)]*' "$TRANSCRIPT_FILE" | tail -20)

    if [ -z "$task_calls" ]; then
        echo "No Task() calls found in transcript" >&2
        return 0
    fi

    echo "Found Task() calls, parsing..." >&2

    # Parse each Task() call
    echo "$task_calls" | while IFS= read -r task_line; do
        # Extract parameters (simplified - assumes Task("name", "desc", "type") format)
        # This is fragile and may need better parsing

        # Try to extract agent type (third parameter)
        local agent_type=$(echo "$task_line" | sed -n 's/.*,\s*"\([^"]*\)"\s*$/\1/p')

        if [ -n "$agent_type" ]; then
            validate_agent_type "$agent_type"
        fi
    done
}

# Validate agent type against registry
validate_agent_type() {
    local agent_type="$1"
    local is_valid=false

    # Check against known agent types
    for known_type in "${KNOWN_AGENT_TYPES[@]}"; do
        if [ "$agent_type" = "$known_type" ]; then
            is_valid=true
            break
        fi
    done

    if [ "$is_valid" = false ]; then
        echo "INVALID AGENT TYPE: $agent_type" >&2
        bash "$STATE_TRACKER" log_violation "generic_agent" "Invalid agent type detected via transcript: $agent_type"

        # Display warning
        cat << EOF

!! VALIDATION FAILURE !!
Invalid agent type detected: $agent_type

This agent type is NOT in the registry.
Valid types: ${KNOWN_AGENT_TYPES[*]}

Please use a registry agent type.

EOF
    else
        echo "Valid agent type: $agent_type" >&2
    fi
}

# Load registry file if available
load_registry() {
    if [ -f "$REGISTRY_FILE" ]; then
        echo "Loading agent registry from: $REGISTRY_FILE" >&2
        # Extract agent types from registry JSON
        # This assumes registry has "agents" array with "type" field
        local registry_types=$(jq -r '.agents[].type' "$REGISTRY_FILE" 2>/dev/null)

        if [ -n "$registry_types" ]; then
            # Update KNOWN_AGENT_TYPES with registry data
            KNOWN_AGENT_TYPES=($registry_types)
            echo "Loaded $(echo "$registry_types" | wc -l) agent types from registry" >&2
        fi
    else
        echo "Registry file not found, using hardcoded types" >&2
    fi
}

# Main execution
main() {
    echo "=== Transcript Parser - Agent Type Validation ===" >&2

    # Load registry
    load_registry

    # Parse transcript
    parse_task_calls

    echo "=== Validation Complete ===" >&2
}

# Run if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main
fi
