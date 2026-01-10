# plan-mode-enhancer.ps1
# Hook: UserPromptSubmit
# Purpose: Enhance plan mode with ultrathink and sequential-thinking MCP
#
# Detects plan mode and injects requirements for:
# 1. Extended thinking via <ultrathink> tag
# 2. Sequential-thinking MCP server usage

$ErrorActionPreference = "SilentlyContinue"

# Read input from stdin (Claude Code sends JSON with session info)
$inputJson = ""
try {
    $inputJson = [Console]::In.ReadToEnd()
} catch {
    $inputJson = "{}"
}

if (-not $inputJson) {
    $inputJson = "{}"
}

# Parse JSON input
$inputData = $null
try {
    $inputData = $inputJson | ConvertFrom-Json
} catch {
    $inputData = @{}
}

# Extract permission_mode from input
$permissionMode = ""
if ($inputData.session -and $inputData.session.permission_mode) {
    $permissionMode = $inputData.session.permission_mode
} elseif ($inputData.permission_mode) {
    $permissionMode = $inputData.permission_mode
}

# Extract prompt text
$promptText = ""
if ($inputData.prompt) {
    $promptText = $inputData.prompt
}

$isPlanning = $false

# Detect plan mode via permission_mode field
if ($permissionMode -eq "plan") {
    $isPlanning = $true
}

# Also detect if user explicitly invoked plan mode or planning keywords
if ($promptText -match "(?i)(plan mode|/plan|planning phase|design phase|architecture|strategy)") {
    $isPlanning = $true
}

# If in plan mode, inject enhancement requirements
if ($isPlanning) {
    Write-Host @"

================================================================
!! PLAN MODE ENHANCEMENT ACTIVE !!
================================================================

REQUIRED ENHANCEMENTS FOR PLAN MODE:

1. ULTRATHINK ACTIVATION (AUTO-ENABLED)
   --------------------------------------
   Extended thinking mode is now ACTIVE via the ultrathink keyword.

   You MUST engage deep reasoning for this planning task:
   - Consider ALL angles and edge cases
   - Evaluate trade-offs explicitly
   - Map dependencies and risks
   - Generate multiple alternatives before deciding

   ultrathink

2. SEQUENTIAL-THINKING MCP REQUIRED
   ---------------------------------
   You MUST use the sequential-thinking MCP server for planning:

   mcp__sequential-thinking__sequentialthinking({
     "thought": "Current reasoning step",
     "nextThoughtNeeded": true/false,
     "thoughtNumber": N,
     "totalThoughts": estimated_total
   })

   Use this for:
   - Breaking down complex problems
   - Exploring decision trees
   - Validating architectural choices
   - Risk assessment chains

3. COMBINED PATTERN
   -----------------
   <ultrathink>
   [Initial deep analysis]
   </ultrathink>

   Then call sequential-thinking for structured exploration:
   - Thought 1: Problem decomposition
   - Thought 2: Constraint identification
   - Thought 3: Option generation
   - Thought 4: Trade-off analysis
   - Thought 5: Risk assessment
   - Thought 6: Final recommendation

================================================================
REMEMBER: Plan mode = Maximum reasoning depth
          No shortcuts. No assumptions. Full analysis.
================================================================

"@
}

# Always exit 0 (informational only, never block)
exit 0
