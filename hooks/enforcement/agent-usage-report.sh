#!/bin/bash
# agent-usage-report.sh
# Purpose: Analyze agent type usage patterns

ARCHIVE_DIR="${HOME}/.claude/runtime/enforcement/archive"
CURRENT_STATE="${HOME}/.claude/runtime/enforcement-state.json"

echo "=== Agent Usage Report ==="
echo

# Collect all agent types
declare -A AGENT_TYPE_COUNTS
declare -A CATEGORY_COUNTS

# Process current session
if [ -f "$CURRENT_STATE" ]; then
    TYPES=$(jq -r '.agent_spawns[] | .agent_type' "$CURRENT_STATE" 2>/dev/null)
    while IFS= read -r atype; do
        if [ -n "$atype" ]; then
            AGENT_TYPE_COUNTS[$atype]=$((${AGENT_TYPE_COUNTS[$atype]:-0} + 1))
        fi
    done <<< "$TYPES"

    CATS=$(jq -r '.agent_spawns[] | .category' "$CURRENT_STATE" 2>/dev/null)
    while IFS= read -r cat; do
        if [ -n "$cat" ]; then
            CATEGORY_COUNTS[$cat]=$((${CATEGORY_COUNTS[$cat]:-0} + 1))
        fi
    done <<< "$CATS"
fi

# Process archives
if [ -d "$ARCHIVE_DIR" ]; then
    ARCHIVE_FILES=$(ls "$ARCHIVE_DIR"/*.json 2>/dev/null)

    for archive_file in $ARCHIVE_FILES; do
        TYPES=$(jq -r '.agent_spawns[] | .agent_type' "$archive_file" 2>/dev/null)
        while IFS= read -r atype; do
            if [ -n "$atype" ]; then
                AGENT_TYPE_COUNTS[$atype]=$((${AGENT_TYPE_COUNTS[$atype]:-0} + 1))
            fi
        done <<< "$TYPES"

        CATS=$(jq -r '.agent_spawns[] | .category' "$archive_file" 2>/dev/null)
        while IFS= read -r cat; do
            if [ -n "$cat" ]; then
                CATEGORY_COUNTS[$cat]=$((${CATEGORY_COUNTS[$cat]:-0} + 1))
            fi
        done <<< "$CATS"
    done
fi

# Display results
echo "AGENT TYPE USAGE:"
if [ ${#AGENT_TYPE_COUNTS[@]} -gt 0 ]; then
    # Sort by count (descending)
    for atype in "${!AGENT_TYPE_COUNTS[@]}"; do
        echo "${AGENT_TYPE_COUNTS[$atype]} $atype"
    done | sort -rn | while read count atype; do
        echo "  $atype: $count"
    done
else
    echo "  No agents spawned"
fi
echo

echo "CATEGORY DISTRIBUTION:"
if [ ${#CATEGORY_COUNTS[@]} -gt 0 ]; then
    TOTAL_AGENTS=0
    for count in "${CATEGORY_COUNTS[@]}"; do
        TOTAL_AGENTS=$((TOTAL_AGENTS + count))
    done

    for cat in "${!CATEGORY_COUNTS[@]}"; do
        echo "${CATEGORY_COUNTS[$cat]} $cat"
    done | sort -rn | while read count cat; do
        if [ "$TOTAL_AGENTS" -gt 0 ]; then
            PCT=$(echo "scale=2; $count * 100 / $TOTAL_AGENTS" | bc)
            echo "  $cat: $count (${PCT}%)"
        else
            echo "  $cat: $count"
        fi
    done
else
    echo "  No categories found"
fi
echo

# Top 10 most used agents
echo "TOP 10 MOST USED AGENTS:"
if [ ${#AGENT_TYPE_COUNTS[@]} -gt 0 ]; then
    for atype in "${!AGENT_TYPE_COUNTS[@]}"; do
        echo "${AGENT_TYPE_COUNTS[$atype]} $atype"
    done | sort -rn | head -10 | while read count atype; do
        echo "  $count - $atype"
    done
else
    echo "  No data"
fi
echo

# Diversity metric
echo "DIVERSITY METRICS:"
UNIQUE_TYPES=${#AGENT_TYPE_COUNTS[@]}
TOTAL_SPAWNS=0
for count in "${AGENT_TYPE_COUNTS[@]}"; do
    TOTAL_SPAWNS=$((TOTAL_SPAWNS + count))
done

echo "  Unique Agent Types: $UNIQUE_TYPES"
echo "  Total Agent Spawns: $TOTAL_SPAWNS"

if [ "$TOTAL_SPAWNS" -gt 0 ]; then
    DIVERSITY=$(echo "scale=2; $UNIQUE_TYPES / $TOTAL_SPAWNS" | bc)
    echo "  Diversity Score: $DIVERSITY"

    if [ "$(echo "$DIVERSITY >= 0.5" | bc)" -eq 1 ]; then
        echo "  Status: HIGH diversity (good - using many agent types)"
    elif [ "$(echo "$DIVERSITY >= 0.2" | bc)" -eq 1 ]; then
        echo "  Status: MEDIUM diversity (moderate variety)"
    else
        echo "  Status: LOW diversity (overusing same agents)"
    fi
fi

echo
echo "=== End of Report ==="
