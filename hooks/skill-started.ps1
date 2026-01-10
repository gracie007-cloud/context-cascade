# Hook: Triggered when a skill is invoked
# Usage: Reports skill execution to dashboard
# Hierarchy Level 2: Project -> SKILL -> Agents -> Commands

param(
    [string]$SkillName,
    [string]$ProjectPath = $PWD
)

$DASHBOARD_API = "http://localhost:8000/api/v1"
$ProjectName = Split-Path -Leaf $ProjectPath

# Register/update project
try {
    $ProjectData = @{
        name = $ProjectName
        status = "active"
        project_type = "claude-code"
    } | ConvertTo-Json

    Invoke-RestMethod -Uri "$DASHBOARD_API/projects" -Method POST -Body $ProjectData -ContentType "application/json" -ErrorAction SilentlyContinue
} catch {
    # Project might already exist, that's OK
}

# Register skill execution
try {
    $SkillData = @{
        project_name = $ProjectName
        skill_name = $SkillName
        status = "active"
        started_at = (Get-Date).ToString("o")
    } | ConvertTo-Json

    $Response = Invoke-RestMethod -Uri "$DASHBOARD_API/skills" -Method POST -Body $SkillData -ContentType "application/json"

    Write-Output "Dashboard: Skill '$SkillName' registered for project '$ProjectName'"
} catch {
    Write-Warning "Failed to report skill to dashboard: $_"
}
