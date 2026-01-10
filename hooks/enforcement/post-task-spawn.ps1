# post-task-spawn.ps1
# Hook: PostToolUse on Task
# Purpose: Track agent spawn and remind about TodoWrite

$ErrorActionPreference = "SilentlyContinue"

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$STATE_TRACKER = Join-Path $SCRIPT_DIR "state-tracker.ps1"

# Read tool execution data from stdin
$inputJson = ""
try {
    $inputJson = [Console]::In.ReadToEnd()
} catch {
    $inputJson = "{}"
}

if (-not $inputJson) { $inputJson = "{}" }

# Extract tool name
$toolName = ""
$agentType = "unknown"
$agentName = "unknown"
$taskDesc = "unknown"

try {
    $inputData = $inputJson | ConvertFrom-Json
    $toolName = $inputData.tool_name
    if ($inputData.tool_input) {
        $agentType = if ($inputData.tool_input.subagent_type) { $inputData.tool_input.subagent_type } else { "unknown" }
        $agentName = if ($inputData.tool_input.description) { $inputData.tool_input.description } else { "unknown" }
        $taskDesc = if ($inputData.tool_input.prompt) { $inputData.tool_input.prompt } else { "unknown" }
    }
} catch {}

# Only process Task invocations
if ($toolName -eq "Task") {
    # Log agent spawn
    if ($agentType -ne "unknown" -and (Test-Path $STATE_TRACKER)) {
        & powershell -ExecutionPolicy Bypass -File $STATE_TRACKER log_agent $agentType $agentName $taskDesc 2>$null
    }

    Write-Host @"

============================================================
!! AGENT SPAWNED VIA TASK !!
============================================================

An agent has been spawned. Great!

NEXT MANDATORY STEPS:

[ ] STEP 1: Verify agent type is from registry
    - Registry: claude-code-plugins/context-cascade/agents/
    - 217 agents in 10 categories
    - If you used a generic type: FIX IT NOW

[ ] STEP 2: If spawning multiple agents (parallel work):
    - Spawn ALL agents in THIS message
    - Do NOT spawn one, wait, spawn another
    - Golden Rule: 1 MESSAGE = ALL PARALLEL OPERATIONS

[ ] STEP 3: After ALL agents spawned, call TodoWrite()
    - Create 5-10 todos for all planned work
    - Format: {content: "Do X", status: "pending", activeForm: "Doing X"}
    - Mark in_progress when starting work
    - Mark completed IMMEDIATELY when done

[ ] STEP 4: Ensure domain expertise was loaded (if available)
    - Did you check .claude/expertise/{domain}.yaml?
    - If exists: Did you load it BEFORE spawning?
    - If not: Agent will create during execution

POST-SPAWN CHECKLIST:

Are ALL parallel agents spawned in THIS message?  [ ]
Did you call TodoWrite() with todos?              [ ]
Did todos include both content and activeForm?    [ ]
Did you load domain expertise before spawning?    [ ]

PATTERN REMINDER:

  Skill() -> Task() -> TodoWrite()
             ^^^^^
           (you are here)
                |
                v
          TodoWrite() <- REQUIRED NEXT

LIMITATION NOTE:
  This hook may not have access to your agent type parameter
  Validation will happen via transcript parsing
  Please ensure you used a registry agent type

STATE TRACKING:
  - Agent spawn logged (if parameters accessible)
  - Compliance check will run after TodoWrite
  - Violations recorded in state file

============================================================

"@
}

exit 0
