# Hook: Triggered when a slash command or tool is executed
# Usage: Reports command execution to dashboard
# Hierarchy Level 4: Project -> Skill -> Agent -> COMMAND

param(
    [string]$CommandType,  # "slash_command" or "tool"
    [string]$CommandName,  # "/review-pr" or "Bash"
    [string]$CommandArgs = "",
    [string]$AgentName = "claude-code",
    [string]$ProjectPath = $PWD
)

$DASHBOARD_API = "http://localhost:8000/api/v1"
$ProjectName = Split-Path -Leaf $ProjectPath

# Register command execution
try {
    $CommandData = @{
        command_type = $CommandType
        command_name = $CommandName
        command_args = $CommandArgs
        agent_name = $AgentName
        project_name = $ProjectName
        status = "running"
        started_at = (Get-Date).ToString("o")
    } | ConvertTo-Json

    $Response = Invoke-RestMethod -Uri "$DASHBOARD_API/commands" -Method POST -Body $CommandData -ContentType "application/json"

    Write-Output "Dashboard: Command '$CommandName' executing in project '$ProjectName'"
} catch {
    Write-Warning "Failed to report command to dashboard: $_"
}
