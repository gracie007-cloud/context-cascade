# state-tracker.ps1
# Core state management for enforcement system
# Called by all enforcement hooks

param(
    [Parameter(Position=0)]
    [string]$Command,
    [Parameter(Position=1)]
    [string]$Param1,
    [Parameter(Position=2)]
    [string]$Param2,
    [Parameter(Position=3)]
    [string]$Param3
)

$ErrorActionPreference = "SilentlyContinue"

$STATE_FILE = "$env:USERPROFILE\.claude\runtime\enforcement-state.json"
$ARCHIVE_DIR = "$env:USERPROFILE\.claude\runtime\enforcement\archive"

# Ensure directories exist
$stateDir = Split-Path $STATE_FILE -Parent
if (-not (Test-Path $stateDir)) {
    New-Item -ItemType Directory -Path $stateDir -Force | Out-Null
}
if (-not (Test-Path $ARCHIVE_DIR)) {
    New-Item -ItemType Directory -Path $ARCHIVE_DIR -Force | Out-Null
}

function Get-Timestamp {
    return (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
}

function Init-State {
    $sessionId = "session-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    $timestamp = Get-Timestamp

    $state = @{
        session_id = $sessionId
        started_at = $timestamp
        workflow_state = @{
            phase = "idle"
            started_at = $null
            completed_phases = @()
            current_task = $null
        }
        skill_invocations = @()
        agent_spawns = @()
        violations = @()
        todos_created = $false
        expertise_loaded = @()
    }

    $state | ConvertTo-Json -Depth 10 | Set-Content -Path $STATE_FILE -Encoding UTF8
    Write-Host "State initialized: $sessionId" -ForegroundColor Green
}

function Get-State {
    if (-not (Test-Path $STATE_FILE)) {
        Init-State
    }
    return Get-Content $STATE_FILE -Raw | ConvertFrom-Json
}

function Save-State {
    param([object]$State)
    $State | ConvertTo-Json -Depth 10 | Set-Content -Path $STATE_FILE -Encoding UTF8
}

function Log-Skill {
    param([string]$SkillName)

    $state = Get-State
    $timestamp = Get-Timestamp

    # Map skill to phase
    $phase = switch -Regex ($SkillName) {
        "intent-analyzer" { "intent-analysis" }
        "prompt-architect" { "prompt-optimization" }
        "planner|research-driven-planning|interactive-planner" { "planning" }
        default { "execution" }
    }

    $skillInvocation = @{
        skill_name = $SkillName
        invoked_at = $timestamp
        sop_followed = $false
        agents_spawned = @()
    }

    $state.skill_invocations += $skillInvocation
    $state.workflow_state.phase = $phase
    $state.workflow_state.started_at = $timestamp

    Save-State $state
    Write-Host "Logged skill: $SkillName (phase: $phase)" -ForegroundColor Cyan
}

function Log-Agent {
    param(
        [string]$AgentType,
        [string]$AgentName,
        [string]$TaskDesc
    )

    $state = Get-State
    $timestamp = Get-Timestamp

    # Check if agent type is from registry
    $registryAgents = @{
        "coder" = "delivery"
        "backend-dev" = "delivery"
        "frontend-dev" = "delivery"
        "fullstack-dev" = "delivery"
        "mobile-dev" = "delivery"
        "devops-engineer" = "delivery"
        "researcher" = "research"
        "analyst" = "research"
        "data-scientist" = "research"
        "ml-engineer" = "research"
        "tester" = "quality"
        "qa-engineer" = "quality"
        "security-tester" = "quality"
        "reviewer" = "quality"
        "code-analyzer" = "quality"
        "auditor" = "quality"
    }

    $isRegistryAgent = $registryAgents.ContainsKey($AgentType)
    $category = if ($isRegistryAgent) { $registryAgents[$AgentType] } else { "unknown" }

    $agentSpawn = @{
        agent_type = $AgentType
        agent_name = $AgentName
        task_description = $TaskDesc
        spawned_at = $timestamp
        is_registry_agent = $isRegistryAgent
        category = $category
    }

    $state.agent_spawns += $agentSpawn
    Save-State $state

    if (-not $isRegistryAgent) {
        Log-Violation "generic_agent" "Non-registry agent type: $AgentType"
    }

    Write-Host "Logged agent: $AgentType ($category)" -ForegroundColor Cyan
}

function Log-Violation {
    param(
        [string]$ViolationType,
        [string]$Details
    )

    $state = Get-State
    $timestamp = Get-Timestamp

    $violation = @{
        type = $ViolationType
        detected_at = $timestamp
        details = $Details
    }

    $state.violations += $violation
    Save-State $state

    Write-Host "VIOLATION: $ViolationType - $Details" -ForegroundColor Red
}

function Mark-TodoWrite {
    $state = Get-State
    $state.todos_created = $true
    Save-State $state
    Write-Host "TodoWrite marked as called" -ForegroundColor Green
}

function Mark-Expertise {
    param([string]$Domain)

    $state = Get-State
    $state.expertise_loaded += $Domain
    Save-State $state
    Write-Host "Expertise loaded: $Domain" -ForegroundColor Green
}

function Mark-PhaseComplete {
    param([string]$Phase)

    $state = Get-State
    $state.workflow_state.completed_phases += $Phase
    Save-State $state
    Write-Host "Phase completed: $Phase" -ForegroundColor Green
}

function Check-Compliance {
    $state = Get-State
    $violations = 0

    $skillCount = $state.skill_invocations.Count
    $agentCount = $state.agent_spawns.Count

    if ($skillCount -gt 0 -and $agentCount -eq 0) {
        Write-Host "VIOLATION: Skill invoked but no agents spawned" -ForegroundColor Red
        Log-Violation "missing_agents" "Skill invoked without Task() calls"
        $violations++
    }

    if ($agentCount -gt 0 -and -not $state.todos_created) {
        Write-Host "VIOLATION: Agents spawned but no TodoWrite" -ForegroundColor Red
        Log-Violation "missing_todowrite" "Agents spawned without TodoWrite() call"
        $violations++
    }

    $genericCount = ($state.agent_spawns | Where-Object { -not $_.is_registry_agent }).Count
    if ($genericCount -gt 0) {
        Write-Host "VIOLATION: $genericCount generic agents used" -ForegroundColor Red
        $violations += $genericCount
    }

    Write-Host "Compliance check: $violations violations found" -ForegroundColor $(if ($violations -eq 0) { "Green" } else { "Yellow" })
    return $violations
}

function Archive-State {
    if (Test-Path $STATE_FILE) {
        $state = Get-State
        $sessionId = $state.session_id
        $archiveFile = Join-Path $ARCHIVE_DIR "$sessionId.json"

        Copy-Item $STATE_FILE $archiveFile -Force
        Write-Host "State archived to: $archiveFile" -ForegroundColor Green

        $violations = $state.violations.Count
        $skills = $state.skill_invocations.Count
        $agents = $state.agent_spawns.Count

        Write-Host "Session Summary:" -ForegroundColor Cyan
        Write-Host "  Skills invoked: $skills"
        Write-Host "  Agents spawned: $agents"
        Write-Host "  Violations: $violations"
    }
}

# Command dispatch
switch ($Command) {
    "init_state" { Init-State }
    "get_state" { Get-State | ConvertTo-Json -Depth 10 }
    "log_skill" { Log-Skill $Param1 }
    "log_agent" { Log-Agent $Param1 $Param2 $Param3 }
    "log_violation" { Log-Violation $Param1 $Param2 }
    "mark_todowrite" { Mark-TodoWrite }
    "mark_expertise" { Mark-Expertise $Param1 }
    "mark_phase_complete" { Mark-PhaseComplete $Param1 }
    "check_compliance" { Check-Compliance }
    "archive_state" { Archive-State }
    default {
        Write-Host "Usage: state-tracker.ps1 {init_state|get_state|log_skill|log_agent|log_violation|mark_todowrite|mark_expertise|mark_phase_complete|check_compliance|archive_state}"
        exit 1
    }
}

exit 0
