# Hook: Stop (session end) - Windows PowerShell version
# Part of Loop 1.5 -> Loop 3 pipeline
#
# Triggers reflect_to_memory.py when session ends if:
# 1. reflect-enabled state file exists
# 2. Memory MCP scripts are available
#
# This hook stores session learnings to Memory MCP for
# aggregation by the 3-day meta-loop.

$ErrorActionPreference = "SilentlyContinue"

$REFLECT_STATE_FILE = "$env:USERPROFILE\.claude\reflect-enabled"
$REFLECT_SCRIPT = "D:\Projects\memory-mcp-triple-system\scripts\reflect_to_memory.py"
$LEARNINGS_DIR = "$env:USERPROFILE\.claude\reflect-output"

# Check if reflection is enabled
if (-not (Test-Path $REFLECT_STATE_FILE)) {
    # Reflection not enabled, skip silently
    exit 0
}

# Check if script exists
if (-not (Test-Path $REFLECT_SCRIPT)) {
    Write-Error "[reflect-hook] Warning: reflect_to_memory.py not found"
    exit 0
}

# Get session ID and project from environment or generate
$SESSION_ID = if ($env:CLAUDE_SESSION_ID) { $env:CLAUDE_SESSION_ID } else { "session_$(Get-Date -Format 'yyyyMMdd_HHmmss')" }
$PROJECT = if ($env:MEMORY_MCP_PROJECT) { $env:MEMORY_MCP_PROJECT } else { "general" }

# Check for recent learnings file (created by /reflect skill)
$RECENT_LEARNINGS = $null
if (Test-Path $LEARNINGS_DIR) {
    $RECENT_LEARNINGS = Get-ChildItem -Path $LEARNINGS_DIR -Filter "*.json" |
        Where-Object { $_.LastWriteTime -gt (Get-Date).AddMinutes(-30) } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1 -ExpandProperty FullName
}

if ($RECENT_LEARNINGS) {
    Write-Host "[reflect-hook] Storing session learnings to Memory MCP..."

    try {
        $result = python $REFLECT_SCRIPT --session-id $SESSION_ID --project $PROJECT --from-file $RECENT_LEARNINGS

        if ($LASTEXITCODE -eq 0) {
            Write-Host "[reflect-hook] Learnings stored successfully"
            # Archive the processed file
            $archivePath = "$RECENT_LEARNINGS.processed"
            Move-Item -Path $RECENT_LEARNINGS -Destination $archivePath -Force
        } else {
            Write-Error "[reflect-hook] Warning: Failed to store learnings"
        }
    } catch {
        Write-Error "[reflect-hook] Error: $_"
    }
} else {
    Write-Host "[reflect-hook] No recent learnings to store"
}

exit 0
