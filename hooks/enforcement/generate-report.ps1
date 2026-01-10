# generate-report.ps1
# Purpose: Generate compliance report from state file

$ErrorActionPreference = "SilentlyContinue"

$STATE_FILE = "$env:USERPROFILE\.claude\runtime\enforcement-state.json"
$ARCHIVE_DIR = "$env:USERPROFILE\.claude\runtime\enforcement\archive"

if (-not (Test-Path $STATE_FILE)) {
    Write-Host "No state file found. Run some commands first."
    exit 1
}

$state = Get-Content $STATE_FILE -Raw | ConvertFrom-Json

Write-Host "=== Enforcement System Compliance Report ==="
Write-Host ""
Write-Host "Generated: $(Get-Date)"
Write-Host ""

# Session info
Write-Host "SESSION INFORMATION:"
Write-Host "  Session ID: $($state.session_id)"
Write-Host "  Started: $($state.started_at)"
Write-Host "  Current Phase: $($state.workflow_state.phase)"
Write-Host ""

# Workflow stats
Write-Host "WORKFLOW STATISTICS:"
Write-Host "  Skills Invoked: $($state.skill_invocations.Count)"
Write-Host "  Agents Spawned: $($state.agent_spawns.Count)"
Write-Host "  TodoWrite Called: $($state.todos_created)"
Write-Host "  Expertise Loaded: $($state.expertise_loaded.Count)"
Write-Host ""

# Skills breakdown
Write-Host "SKILLS INVOKED:"
foreach ($skill in $state.skill_invocations) {
    Write-Host "  - $($skill.skill_name) at $($skill.invoked_at)"
}
Write-Host ""

# Agents breakdown
Write-Host "AGENTS SPAWNED:"
foreach ($agent in $state.agent_spawns) {
    Write-Host "  - $($agent.agent_type) ($($agent.category)) - $($agent.agent_name)"
}
Write-Host ""

# Registry compliance
Write-Host "REGISTRY COMPLIANCE:"
$totalAgents = $state.agent_spawns.Count
$registryAgents = ($state.agent_spawns | Where-Object { $_.is_registry_agent -eq $true }).Count
$genericAgents = ($state.agent_spawns | Where-Object { $_.is_registry_agent -eq $false }).Count

if ($totalAgents -gt 0) {
    $compliancePct = [math]::Round($registryAgents * 100 / $totalAgents, 2)
    Write-Host "  Total Agents: $totalAgents"
    Write-Host "  Registry Agents: $registryAgents"
    Write-Host "  Generic Agents: $genericAgents"
    Write-Host "  Compliance Rate: ${compliancePct}%"
} else {
    Write-Host "  No agents spawned"
}
Write-Host ""

# Violations
Write-Host "VIOLATIONS:"
$violationCount = $state.violations.Count
if ($violationCount -gt 0) {
    foreach ($v in $state.violations) {
        Write-Host "  [$($v.type)] $($v.details) at $($v.detected_at)"
    }
} else {
    Write-Host "  No violations detected"
}
Write-Host ""

# SOP Compliance Check
Write-Host "SOP COMPLIANCE CHECK:"
$skills = $state.skill_invocations.Count
$agents = $state.agent_spawns.Count
$todos = $state.todos_created

Write-Host -NoNewline "  Skill -> Task pattern: "
if ($skills -gt 0 -and $agents -gt 0) {
    Write-Host "PASS"
} elseif ($skills -eq 0 -and $agents -eq 0) {
    Write-Host "N/A (no skills invoked)"
} else {
    Write-Host "FAIL"
}

Write-Host -NoNewline "  Task -> TodoWrite pattern: "
if ($agents -gt 0 -and $todos) {
    Write-Host "PASS"
} elseif ($agents -eq 0) {
    Write-Host "N/A (no agents spawned)"
} else {
    Write-Host "FAIL"
}

Write-Host -NoNewline "  Overall SOP Compliance: "
if ($violationCount -eq 0) {
    Write-Host "PASS"
} else {
    Write-Host "FAIL ($violationCount violations)"
}
Write-Host ""

# Archive summary
Write-Host "ARCHIVE INFORMATION:"
if (Test-Path $ARCHIVE_DIR) {
    $archiveFiles = Get-ChildItem "$ARCHIVE_DIR\*.json" -ErrorAction SilentlyContinue
    $archiveCount = if ($archiveFiles) { $archiveFiles.Count } else { 0 }
    Write-Host "  Archived Sessions: $archiveCount"
    if ($archiveCount -gt 0) {
        $latestArchive = $archiveFiles | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        Write-Host "  Latest Archive: $($latestArchive.FullName)"
    }
} else {
    Write-Host "  No archives found"
}
Write-Host ""

Write-Host "=== End of Report ==="

exit 0
