#!/bin/bash
# apply-skill-improvements.sh
# Updates skill counts and validates skill structure
# Updated: 2026-01-02

set -euo pipefail

PLUGIN_DIR="C:/Users/17175/claude-code-plugins/context-cascade"

echo "=== Context Cascade Skill Validation ==="
echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# Count skills
SKILL_COUNT=$(find "$PLUGIN_DIR/skills" -name "SKILL.md" -type f 2>/dev/null | grep -v "_merged" | grep -v "packaged" | wc -l | tr -d ' ')
PACKAGED_COUNT=$(find "$PLUGIN_DIR/skills/packaged" -name "*.skill" -type f 2>/dev/null | wc -l | tr -d ' ')
AGENT_COUNT=$(find "$PLUGIN_DIR/agents" -name "*.md" -not -name "README*" -not -name "*SUMMARY*" -not -name "*REPORT*" -not -name "*INDEX*" 2>/dev/null | wc -l | tr -d ' ')
COMMAND_COUNT=$(find "$PLUGIN_DIR/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
PLAYBOOK_COUNT=$(find "$PLUGIN_DIR/playbooks" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
HOOK_COUNT=$(find "$PLUGIN_DIR/hooks" -name "*.sh" -type f 2>/dev/null | wc -l | tr -d ' ')

echo "Component Counts:"
echo "  Skills (directory): $SKILL_COUNT"
echo "  Skills (packaged):  $PACKAGED_COUNT"
echo "  Agents:             $AGENT_COUNT"
echo "  Commands:           $COMMAND_COUNT"
echo "  Playbooks:          $PLAYBOOK_COUNT"
echo "  Hooks:              $HOOK_COUNT"
echo "  Total:              $((SKILL_COUNT + AGENT_COUNT + COMMAND_COUNT + PLAYBOOK_COUNT))"
echo ""

# Validate VCL compliance
echo "VCL v3.1.1 Compliance Check:"
VCL_COMPLIANT=$(grep -r "x-vcl-compliance: v3.1.1" "$PLUGIN_DIR/skills" 2>/dev/null | wc -l | tr -d ' ')
echo "  Skills with VCL v3.1.1: $VCL_COMPLIANT"
echo ""

# Check for anti-patterns in hooks
echo "Hook Anti-Pattern Check:"
BLOCKING_CAT=$(grep -r '\$(cat)' "$PLUGIN_DIR/hooks" 2>/dev/null | grep -v timeout | wc -l | tr -d ' ')
GREP_P=$(grep -r 'grep -P' "$PLUGIN_DIR/hooks" 2>/dev/null | wc -l | tr -d ' ')
echo "  Blocking \$(cat): $BLOCKING_CAT (should be 0)"
echo "  grep -P usage:    $GREP_P (should be 0)"
echo ""

if [ "$BLOCKING_CAT" -eq 0 ] && [ "$GREP_P" -eq 0 ]; then
    echo "STATUS: ALL CHECKS PASSED"
else
    echo "STATUS: ISSUES FOUND - Review hooks"
fi

echo ""
echo "=== Validation Complete ==="
