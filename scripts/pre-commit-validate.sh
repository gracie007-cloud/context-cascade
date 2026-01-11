#!/bin/bash
# pre-commit-validate.sh
# Pre-commit hook for local skill validation
# Install: cp scripts/pre-commit-validate.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

set -e

echo "=== Pre-commit: Validating skill structure ==="

# Get the root of the git repo
REPO_ROOT=$(git rev-parse --show-toplevel)

# Check if any skill-related files are staged
SKILL_CHANGES=$(git diff --cached --name-only | grep -E "^skills/" || true)

if [ -z "$SKILL_CHANGES" ]; then
    echo "No skill changes detected, skipping validation."
    exit 0
fi

echo "Skill changes detected:"
echo "$SKILL_CHANGES"
echo ""

# Run PowerShell validation if on Windows, otherwise use bash checks
if command -v pwsh &> /dev/null; then
    echo "Running PowerShell validation..."
    pwsh -ExecutionPolicy Bypass -File "$REPO_ROOT/scripts/validate-skills.ps1" -CI
    EXIT_CODE=$?
elif command -v powershell &> /dev/null; then
    echo "Running PowerShell validation..."
    powershell -ExecutionPolicy Bypass -File "$REPO_ROOT/scripts/validate-skills.ps1" -CI
    EXIT_CODE=$?
else
    echo "PowerShell not available, running basic checks..."

    # Basic check: ensure SKILL.md exists for any changed skill folders
    EXIT_CODE=0
    for CHANGE in $SKILL_CHANGES; do
        # Extract skill folder path (skills/category/skillname/)
        SKILL_DIR=$(echo "$CHANGE" | sed -E 's|(skills/[^/]+/[^/]+)/.*|\1|')

        if [[ "$SKILL_DIR" =~ ^skills/[^/]+/[^/]+ ]] && [[ "$SKILL_DIR" != "skills/packaged" ]]; then
            SKILL_MD="$REPO_ROOT/$SKILL_DIR/SKILL.md"
            if [ ! -f "$SKILL_MD" ]; then
                echo "[FAIL] Missing SKILL.md: $SKILL_DIR"
                EXIT_CODE=1
            fi
        fi
    done

    if [ $EXIT_CODE -eq 0 ]; then
        echo "[PASS] Basic validation passed"
    fi
fi

if [ $EXIT_CODE -ne 0 ]; then
    echo ""
    echo "=== Validation FAILED ==="
    echo "Fix the issues above before committing."
    echo "Run: pwsh scripts/validate-skills.ps1 -Verbose -Fix"
    exit 1
fi

echo "=== Validation PASSED ==="
exit 0
