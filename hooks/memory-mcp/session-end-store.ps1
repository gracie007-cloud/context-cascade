# Session End Memory Store Hook
# Stores session summary to Memory MCP before Claude exits
#
# Hook Type: Stop
# Trigger: When Claude session ends

param(
    [string]$SessionSummary,
    [string]$ProjectName = "default"
)

# Path to memory CLI
$memoryCli = "D:\Projects\memory-mcp-triple-system\scripts\memory_cli.py"

# Check if CLI exists
if (-not (Test-Path $memoryCli)) {
    Write-Host "[HOOK] Memory CLI not found, skipping session storage"
    exit 0
}

# Get session info
$timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ss"
$sessionId = [guid]::NewGuid().ToString().Substring(0, 8)

# Build session record
$sessionText = @"
SESSION_END: $timestamp
SESSION_ID: $sessionId
PROJECT: $ProjectName
SUMMARY: $(if ($SessionSummary) { $SessionSummary } else { "No summary provided" })
"@

# Store to Memory MCP
try {
    $result = python $memoryCli store "$sessionText" --project $ProjectName --who "session-hook:$sessionId" --why "session-context"
    Write-Host "[HOOK] Session stored to Memory MCP: $sessionId"
} catch {
    Write-Host "[HOOK] Failed to store session: $_"
}

exit 0
