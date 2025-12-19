#!/bin/bash
# INSTALL.sh
# Purpose: Install enforcement hook system

ENFORCEMENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETTINGS_FILE="${HOME}/.claude/settings.json"
RUNTIME_DIR="${HOME}/.claude/runtime/enforcement"

echo "=== Installing Enforcement Hook System ==="
echo

# Step 1: Make scripts executable
echo "Step 1: Making scripts executable..."
chmod +x "$ENFORCEMENT_DIR"/*.sh
echo "  Done"
echo

# Step 2: Create runtime directory
echo "Step 2: Creating runtime directory..."
mkdir -p "$RUNTIME_DIR/archive"
echo "  Created: $RUNTIME_DIR"
echo "  Created: $RUNTIME_DIR/archive"
echo

# Step 3: Backup existing settings
echo "Step 3: Backing up existing settings..."
if [ -f "$SETTINGS_FILE" ]; then
    BACKUP_FILE="${SETTINGS_FILE}.backup-$(date +%Y%m%d-%H%M%S)"
    cp "$SETTINGS_FILE" "$BACKUP_FILE"
    echo "  Backed up to: $BACKUP_FILE"
else
    echo "  No existing settings file found"
fi
echo

# Step 4: Display merge instructions
echo "Step 4: Configuration merge instructions"
echo
echo "The enforcement hooks need to be added to your .claude/settings.json file."
echo
echo "OPTION 1 - Manual Merge (Recommended):"
echo "  1. Open: $SETTINGS_FILE"
echo "  2. Open: $ENFORCEMENT_DIR/CONFIGURATION.json"
echo "  3. Copy the 'hooks' section from CONFIGURATION.json"
echo "  4. Merge with existing hooks in settings.json"
echo
echo "OPTION 2 - Auto-merge (Experimental):"
echo "  Run: bash $ENFORCEMENT_DIR/merge-config.sh"
echo "  This will attempt to merge automatically"
echo
echo "Required hooks configuration:"
cat "$ENFORCEMENT_DIR/CONFIGURATION.json" | jq '.hooks' | head -50
echo "  ... (see CONFIGURATION.json for complete config)"
echo

# Step 5: Test installation
echo "Step 5: Testing installation..."
echo
echo "Running test suite..."
bash "$ENFORCEMENT_DIR/test-hooks.sh"
RESULT=$?

if [ $RESULT -eq 0 ]; then
    echo
    echo "  Tests PASSED"
else
    echo
    echo "  Tests FAILED (exit code: $RESULT)"
    echo "  This may be normal if hooks not yet configured"
fi
echo

# Step 6: Display next steps
echo "=== Installation Complete ==="
echo
echo "NEXT STEPS:"
echo
echo "1. Merge hook configuration (see Step 4 above)"
echo "2. Restart Claude Code to load new hooks"
echo "3. Test with a non-trivial request"
echo "4. Check state: bash $ENFORCEMENT_DIR/generate-report.sh"
echo
echo "FILES CREATED:"
echo "  State file: $RUNTIME_DIR/enforcement-state.json (will be created on first use)"
echo "  Archive dir: $RUNTIME_DIR/archive/"
echo
echo "DOCUMENTATION:"
echo "  README: $ENFORCEMENT_DIR/README.md"
echo "  Integration: $ENFORCEMENT_DIR/INTEGRATION-DIAGRAM.md"
echo "  Limitations: $ENFORCEMENT_DIR/LIMITATIONS.md"
echo "  Config: $ENFORCEMENT_DIR/CONFIGURATION.json"
echo
echo "USAGE:"
echo "  Generate report: bash $ENFORCEMENT_DIR/generate-report.sh"
echo "  Analyze compliance: bash $ENFORCEMENT_DIR/analyze-compliance.sh"
echo "  Find violations: bash $ENFORCEMENT_DIR/find-violations.sh"
echo "  Agent usage: bash $ENFORCEMENT_DIR/agent-usage-report.sh"
echo
echo "Installation script complete."
