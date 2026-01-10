# pre-skill-invoke.ps1
# Hook: PreToolUse on Skill
# Purpose: Log skill invocation and display SOP reminder

$ErrorActionPreference = "SilentlyContinue"

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$STATE_TRACKER = Join-Path $SCRIPT_DIR "state-tracker.ps1"

# Read tool data from stdin
$inputJson = ""
try {
    $inputJson = [Console]::In.ReadToEnd()
} catch {
    $inputJson = "{}"
}

if (-not $inputJson) { $inputJson = "{}" }

# Extract skill name from tool input
$skillName = "unknown"
try {
    $inputData = $inputJson | ConvertFrom-Json
    if ($inputData.tool_input -and $inputData.tool_input.skill) {
        $skillName = $inputData.tool_input.skill
    }
} catch {}

# Log to state tracker
if ($skillName -ne "unknown" -and (Test-Path $STATE_TRACKER)) {
    & powershell -ExecutionPolicy Bypass -File $STATE_TRACKER log_skill $skillName 2>$null
}

# Display SOP reminder
Write-Host @"

============================================================
!! SKILL INVOCATION DETECTED !!
============================================================

Skills are SOPs (Standard Operating Procedures) that define
HOW to accomplish tasks. They are NOT direct execution tools.

MANDATORY PATTERN: Skill -> Task -> TodoWrite

After this skill completes, you MUST:

1. SPAWN AGENTS via Task()
   Pattern: Task("Agent Name", "Task description", "agent-type")

   Agent types MUST be from registry:
   - Registry: claude-code-plugins/context-cascade/agents/
   - 217 agents in 10 categories
   - Fallbacks if unsure: coder, researcher, tester, reviewer

2. CREATE TODOS via TodoWrite()
   - Create 5-10 todos for planned work
   - Mark in_progress when starting
   - Mark completed immediately when done

3. SPAWN IN PARALLEL (Golden Rule)
   - 1 MESSAGE = ALL Task() calls for parallel work
   - Do NOT spawn agents sequentially

4. LOAD DOMAIN EXPERTISE (if available)
   - Check: .claude/expertise/{domain}.yaml
   - If exists: Load BEFORE spawning agents
   - If not: Agent discovers during execution

STATE TRACKING:
  - This skill invocation is being logged
  - Compliance will be checked after execution
  - Violations will be recorded

============================================================

"@

exit 0
