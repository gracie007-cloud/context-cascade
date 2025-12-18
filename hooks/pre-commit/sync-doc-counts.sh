#!/bin/bash
# Pre-commit hook: Sync documentation counts
#
# PURPOSE: Automatically update component counts in docs before each commit
# INSTALL: ln -sf ../../hooks/pre-commit/sync-doc-counts.sh .git/hooks/pre-commit
#
# This ensures documentation always reflects actual component counts.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "=== Pre-commit: Syncing documentation counts ==="

# Run the sync script
node "$PLUGIN_ROOT/scripts/sync-doc-counts.js" update

# Check if any docs were modified
MODIFIED_DOCS=$(git diff --name-only -- "*.md" "docs/COMPONENT-COUNTS.json")

if [ -n "$MODIFIED_DOCS" ]; then
    echo ""
    echo "Documentation updated with current counts:"
    echo "$MODIFIED_DOCS"
    echo ""
    echo "Adding updated docs to commit..."
    git add $MODIFIED_DOCS
fi

echo "=== Pre-commit complete ==="
exit 0
