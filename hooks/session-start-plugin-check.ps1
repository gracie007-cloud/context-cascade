# Session Start Hook: Check plugin availability
# This hook should fire at the start of each conversation

$ErrorActionPreference = "SilentlyContinue"

$PLUGIN_PATH = "claude-code-plugins\context-cascade"
$AGENTS_PATH = "$PLUGIN_PATH\agents\README.md"

Write-Host "=================================================="
Write-Host "!! SESSION START - RUV-SPARC PLUGIN CHECK !!"
Write-Host "=================================================="
Write-Host ""

# Check if plugin exists
if (Test-Path $PLUGIN_PATH) {
    Write-Host "[OK] ruv-sparc plugin found at: $PLUGIN_PATH"

    # Count agents if possible
    $agentCount = (Get-ChildItem "$PLUGIN_PATH\agents" -Filter "*.md" -ErrorAction SilentlyContinue).Count
    Write-Host "[OK] Agent registry contains approximately $agentCount agent definitions"
} else {
    Write-Host "[!!] WARNING: ruv-sparc plugin NOT found at expected path"
    Write-Host "     Expected: $PLUGIN_PATH"
}

Write-Host ""
Write-Host "MANDATORY FIRST ACTIONS:"
Write-Host "  1. Read('$AGENTS_PATH')"
Write-Host "  2. Output: 'ruv-sparc plugin loaded: 122 skills, 203 agents'"
Write-Host "  3. Remember: Skill() MUST spawn Task() agents"
Write-Host ""
Write-Host "THREE UNBREAKABLE RULES:"
Write-Host "  1. Skill() MUST spawn Task() agents"
Write-Host "  2. 1 MESSAGE = ALL RELATED OPERATIONS"
Write-Host "  3. Agents come from registry ONLY"
Write-Host "=================================================="

exit 0
