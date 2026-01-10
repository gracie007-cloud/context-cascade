# post-skill-compliance.ps1
# Hook: PostToolUse on Skill
# Purpose: Verify SOP compliance after skill invocation

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
try {
    $inputData = $inputJson | ConvertFrom-Json
    $toolName = $inputData.tool_name
} catch {}

# Only process Skill invocations
if ($toolName -eq "Skill") {
    Write-Host @"

============================================================
!! SKILL EXECUTION COMPLETED - COMPLIANCE CHECK !!
============================================================

You just invoked a Skill. The skill defines the SOP for a task.
Now you MUST follow the SOP compliance pattern.

MANDATORY NEXT STEPS:

[ ] STEP 1: Spawn agents via Task()
    - Pattern: Task("Agent Name", "Task description", "agent-type")
    - Agent type MUST be from registry (206 agents available)
    - If parallel work: Spawn ALL agents in ONE message

[ ] STEP 2: Track progress via TodoWrite()
    - Create 5-10 todos for all planned work
    - Include both content and activeForm for each todo
    - Mark in_progress when starting work
    - Mark completed IMMEDIATELY when done (not batched)

[ ] STEP 3: Load domain expertise (if available)
    - Check: .claude/expertise/{domain}.yaml
    - If exists: Load patterns BEFORE spawning agents
    - If not: Agent will create during execution

COMPLIANCE CHECKLIST:

Did you call Task() to spawn agents?           [ ]
Are agent types from the registry?             [ ]
Did you spawn parallel agents in ONE message?  [ ]
Did you call TodoWrite() with todos?           [ ]
Did you check for domain expertise?            [ ]

If ANY checkbox is UNCHECKED: Complete it NOW before proceeding.

PATTERN REMINDER:

  Skill() defines the SOP
      |
      | (you are here - skill just completed)
      |
      v
  Task() spawns registry agents to execute SOP
      |
      v
  TodoWrite() tracks progress with todos

VIOLATION TRACKING:
  - If you skip Task(): VIOLATION logged (missing_agents)
  - If you skip TodoWrite(): VIOLATION logged (missing_todowrite)
  - If you use generic agent: VIOLATION logged (generic_agent)

Your compliance is being tracked. Follow the pattern.

============================================================

"@

    # Check compliance (will log violations)
    if (Test-Path $STATE_TRACKER) {
        & powershell -ExecutionPolicy Bypass -File $STATE_TRACKER check_compliance 2>$null
    }
}

exit 0
