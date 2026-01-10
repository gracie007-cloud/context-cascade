# Post-Reflect Memory Store Hook
# Automatically stores reflection learnings to Memory MCP after /reflect completes
#
# Hook Type: PostToolUse
# Trigger: After Skill("reflect") or /reflect command completes

param(
    [string]$ToolName,
    [string]$ToolResult,
    [string]$ProjectName = "default"
)

# Only trigger for reflect skill
if ($ToolName -notmatch "reflect") {
    exit 0
}

# Path to memory CLI
$memoryCli = "D:\Projects\memory-mcp-triple-system\scripts\memory_cli.py"

# Check if CLI exists
if (-not (Test-Path $memoryCli)) {
    Write-Host "Memory CLI not found at $memoryCli"
    exit 0
}

# Extract learnings from tool result (simplified - in practice would parse structured output)
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$reflectionText = @"
REFLECTION_HOOK: $timestamp
PROJECT: $ProjectName
TOOL_RESULT_SUMMARY: $(if ($ToolResult.Length -gt 500) { $ToolResult.Substring(0, 500) + "..." } else { $ToolResult })
"@

# Store to Memory MCP
try {
    $result = python $memoryCli store $reflectionText --project $ProjectName --who "reflect-hook" --why "session-learning"
    Write-Host "Memory stored: $result"
} catch {
    Write-Host "Failed to store memory: $_"
}

exit 0
