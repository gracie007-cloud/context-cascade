#!/bin/bash
# find-violations.sh
# Purpose: List all violations across archived sessions

ARCHIVE_DIR="${HOME}/.claude/runtime/enforcement/archive"
CURRENT_STATE="${HOME}/.claude/runtime/enforcement-state.json"

echo "=== Violation Report ==="
echo

# Check current session
if [ -f "$CURRENT_STATE" ]; then
    echo "CURRENT SESSION:"
    SESSION_ID=$(jq -r '.session_id' "$CURRENT_STATE")
    VIOLATIONS=$(jq '.violations | length' "$CURRENT_STATE")

    echo "  Session: $SESSION_ID"
    echo "  Violations: $VIOLATIONS"

    if [ "$VIOLATIONS" -gt 0 ]; then
        echo
        jq -r '.violations[] | "    [\(.type)] \(.details)\n      Detected: \(.detected_at)"' "$CURRENT_STATE"
    fi
    echo
fi

# Check archives
if [ -d "$ARCHIVE_DIR" ]; then
    ARCHIVE_FILES=$(ls "$ARCHIVE_DIR"/*.json 2>/dev/null)

    if [ -n "$ARCHIVE_FILES" ]; then
        echo "ARCHIVED SESSIONS:"
        echo

        for archive_file in $ARCHIVE_FILES; do
            SESSION_ID=$(jq -r '.session_id' "$archive_file")
            STARTED=$(jq -r '.started_at' "$archive_file")
            VIOLATIONS=$(jq '.violations | length' "$archive_file")

            if [ "$VIOLATIONS" -gt 0 ]; then
                echo "  Session: $SESSION_ID"
                echo "  Started: $STARTED"
                echo "  Violations: $VIOLATIONS"
                echo

                jq -r '.violations[] | "    [\(.type)] \(.details)\n      Detected: \(.detected_at)"' "$archive_file"
                echo
            fi
        done

        # Summary
        TOTAL_VIOLATIONS=0
        for archive_file in $ARCHIVE_FILES; do
            V=$(jq '.violations | length' "$archive_file")
            TOTAL_VIOLATIONS=$((TOTAL_VIOLATIONS + V))
        done

        echo "SUMMARY:"
        echo "  Total Archived Sessions: $(echo "$ARCHIVE_FILES" | wc -l)"
        echo "  Total Violations: $TOTAL_VIOLATIONS"
    fi
else
    echo "No archived sessions found"
fi

echo
echo "=== End of Report ==="
