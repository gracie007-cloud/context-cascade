# ralph-loop-setup.ps1
# PURPOSE: Initialize a Ralph Wiggum persistence loop
# USAGE: powershell ralph-loop-setup.ps1 "<prompt>" [-MaxIterations N] [-CompletionPromise "<text>"]

param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Prompt,
    [int]$MaxIterations = 50,
    [string]$CompletionPromise = ""
)

$ErrorActionPreference = "Stop"

$STATE_DIR = "$env:USERPROFILE\.claude\ralph-wiggum"
$STATE_FILE = "$STATE_DIR\loop-state.md"

# Create state directory
if (-not (Test-Path $STATE_DIR)) {
    New-Item -ItemType Directory -Path $STATE_DIR -Force | Out-Null
}

# Generate session ID
$SESSION_ID = "$(Get-Date -Format 'yyyyMMdd-HHmmss')-$PID"

# Create state file with YAML frontmatter
$stateContent = @"
---
session_id: $SESSION_ID
iteration: 0
max_iterations: $MaxIterations
completion_promise: "$CompletionPromise"
started_at: $(Get-Date -Format "yyyy-MM-ddTHH:mm:ss")
active: true
---

$Prompt
"@

$stateContent | Set-Content -Path $STATE_FILE -Encoding UTF8

Write-Host ""
Write-Host "=========================================="
Write-Host "   RALPH WIGGUM LOOP ACTIVATED"
Write-Host "=========================================="
Write-Host ""
Write-Host "Session ID: $SESSION_ID"
Write-Host "Max Iterations: $MaxIterations"

if ($CompletionPromise) {
    Write-Host "Completion Promise: $CompletionPromise"
    Write-Host ""
    Write-Host "To complete the loop, output exactly:"
    Write-Host "  <promise>$CompletionPromise</promise>"
}

Write-Host ""
Write-Host "To cancel: /cancel-ralph OR powershell .claude\hooks\ralph-wiggum\cancel-ralph.ps1"
Write-Host ""
Write-Host "Starting loop with prompt:"
Write-Host "---"
Write-Host $Prompt
Write-Host "---"
Write-Host ""

exit 0
