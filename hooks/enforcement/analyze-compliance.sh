#!/bin/bash
# analyze-compliance.sh
# Purpose: Analyze compliance across multiple archived sessions

ARCHIVE_DIR="${HOME}/.claude/runtime/enforcement/archive"

if [ ! -d "$ARCHIVE_DIR" ]; then
    echo "No archive directory found"
    exit 1
fi

ARCHIVE_FILES=$(ls "$ARCHIVE_DIR"/*.json 2>/dev/null)

if [ -z "$ARCHIVE_FILES" ]; then
    echo "No archived sessions found"
    exit 1
fi

echo "=== Multi-Session Compliance Analysis ==="
echo
echo "Analyzing $(echo "$ARCHIVE_FILES" | wc -l) archived sessions..."
echo

# Aggregate stats
TOTAL_SESSIONS=0
TOTAL_SKILLS=0
TOTAL_AGENTS=0
TOTAL_VIOLATIONS=0
TOTAL_REGISTRY_AGENTS=0
TOTAL_GENERIC_AGENTS=0
SESSIONS_WITH_VIOLATIONS=0

# Violation type counts
declare -A VIOLATION_TYPES

# Process each archive
for archive_file in $ARCHIVE_FILES; do
    TOTAL_SESSIONS=$((TOTAL_SESSIONS + 1))

    # Count skills
    SKILLS=$(jq '.skill_invocations | length' "$archive_file")
    TOTAL_SKILLS=$((TOTAL_SKILLS + SKILLS))

    # Count agents
    AGENTS=$(jq '.agent_spawns | length' "$archive_file")
    TOTAL_AGENTS=$((TOTAL_AGENTS + AGENTS))

    # Count violations
    VIOLATIONS=$(jq '.violations | length' "$archive_file")
    TOTAL_VIOLATIONS=$((TOTAL_VIOLATIONS + VIOLATIONS))

    if [ "$VIOLATIONS" -gt 0 ]; then
        SESSIONS_WITH_VIOLATIONS=$((SESSIONS_WITH_VIOLATIONS + 1))
    fi

    # Count registry vs generic agents
    REGISTRY=$(jq '[.agent_spawns[] | select(.is_registry_agent == true)] | length' "$archive_file")
    GENERIC=$(jq '[.agent_spawns[] | select(.is_registry_agent == false)] | length' "$archive_file")
    TOTAL_REGISTRY_AGENTS=$((TOTAL_REGISTRY_AGENTS + REGISTRY))
    TOTAL_GENERIC_AGENTS=$((TOTAL_GENERIC_AGENTS + GENERIC))

    # Count violation types
    TYPES=$(jq -r '.violations[].type' "$archive_file" 2>/dev/null)
    while IFS= read -r vtype; do
        if [ -n "$vtype" ]; then
            VIOLATION_TYPES[$vtype]=$((${VIOLATION_TYPES[$vtype]:-0} + 1))
        fi
    done <<< "$TYPES"
done

# Display results
echo "AGGREGATE STATISTICS:"
echo "  Total Sessions: $TOTAL_SESSIONS"
echo "  Total Skills Invoked: $TOTAL_SKILLS"
echo "  Total Agents Spawned: $TOTAL_AGENTS"
echo "  Total Violations: $TOTAL_VIOLATIONS"
echo

echo "COMPLIANCE METRICS:"
if [ "$TOTAL_AGENTS" -gt 0 ]; then
    COMPLIANCE_RATE=$(echo "scale=2; $TOTAL_REGISTRY_AGENTS * 100 / $TOTAL_AGENTS" | bc)
    echo "  Registry Agents: $TOTAL_REGISTRY_AGENTS"
    echo "  Generic Agents: $TOTAL_GENERIC_AGENTS"
    echo "  Registry Compliance Rate: ${COMPLIANCE_RATE}%"
else
    echo "  No agents spawned"
fi
echo

VIOLATION_RATE=$(echo "scale=2; $SESSIONS_WITH_VIOLATIONS * 100 / $TOTAL_SESSIONS" | bc)
echo "  Sessions with Violations: $SESSIONS_WITH_VIOLATIONS / $TOTAL_SESSIONS (${VIOLATION_RATE}%)"
echo

if [ "$TOTAL_SESSIONS" -gt 0 ]; then
    AVG_SKILLS=$(echo "scale=2; $TOTAL_SKILLS / $TOTAL_SESSIONS" | bc)
    AVG_AGENTS=$(echo "scale=2; $TOTAL_AGENTS / $TOTAL_SESSIONS" | bc)
    AVG_VIOLATIONS=$(echo "scale=2; $TOTAL_VIOLATIONS / $TOTAL_SESSIONS" | bc)

    echo "AVERAGES PER SESSION:"
    echo "  Skills: $AVG_SKILLS"
    echo "  Agents: $AVG_AGENTS"
    echo "  Violations: $AVG_VIOLATIONS"
    echo
fi

echo "VIOLATION TYPES:"
if [ ${#VIOLATION_TYPES[@]} -gt 0 ]; then
    for vtype in "${!VIOLATION_TYPES[@]}"; do
        echo "  $vtype: ${VIOLATION_TYPES[$vtype]}"
    done
else
    echo "  No violations"
fi
echo

# Quality score
QUALITY_SCORE=100
if [ "$TOTAL_AGENTS" -gt 0 ]; then
    GENERIC_PENALTY=$(echo "scale=2; $TOTAL_GENERIC_AGENTS * 10 / $TOTAL_AGENTS" | bc)
    QUALITY_SCORE=$(echo "scale=2; $QUALITY_SCORE - $GENERIC_PENALTY" | bc)
fi

if [ "$TOTAL_SESSIONS" -gt 0 ]; then
    VIOLATION_PENALTY=$(echo "scale=2; $TOTAL_VIOLATIONS * 5 / $TOTAL_SESSIONS" | bc)
    QUALITY_SCORE=$(echo "scale=2; $QUALITY_SCORE - $VIOLATION_PENALTY" | bc)
fi

echo "OVERALL QUALITY SCORE: ${QUALITY_SCORE}/100"
echo

if [ "$(echo "$QUALITY_SCORE >= 90" | bc)" -eq 1 ]; then
    echo "Status: EXCELLENT - Strong compliance with enforcement rules"
elif [ "$(echo "$QUALITY_SCORE >= 70" | bc)" -eq 1 ]; then
    echo "Status: GOOD - Minor compliance issues"
elif [ "$(echo "$QUALITY_SCORE >= 50" | bc)" -eq 1 ]; then
    echo "Status: FAIR - Significant compliance issues"
else
    echo "Status: POOR - Major compliance violations"
fi

echo
echo "=== End of Analysis ==="
