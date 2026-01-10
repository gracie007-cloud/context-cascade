# Hook: Triggered when an agent is spawned via Task tool
# Usage: Reports agent creation to dashboard
# Hierarchy Level 3: Project -> Skill -> AGENT -> Commands

param(
    [string]$AgentType,
    [string]$Description,
    [string]$SkillName = "",
    [string]$ProjectPath = $PWD
)

$DASHBOARD_API = "http://localhost:8000/api/v1"
$ProjectName = Split-Path -Leaf $ProjectPath

# Create agent record
try {
    $AgentData = @{
        name = "$AgentType-$(Get-Random -Maximum 9999)"
        type = $AgentType
        status = "busy"
        description = $Description
        project_name = $ProjectName
        skill_name = $SkillName
    } | ConvertTo-Json

    $Response = Invoke-RestMethod -Uri "$DASHBOARD_API/agents" -Method POST -Body $AgentData -ContentType "application/json"

    Write-Output "Dashboard: Agent '$AgentType' spawned for skill '$SkillName' in project '$ProjectName'"
} catch {
    Write-Warning "Failed to report agent to dashboard: $_"
}
