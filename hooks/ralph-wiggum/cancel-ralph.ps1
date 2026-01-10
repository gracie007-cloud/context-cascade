# cancel-ralph.ps1
# PURPOSE: Cancel an active Ralph Wiggum loop
# USAGE: powershell cancel-ralph.ps1

$ErrorActionPreference = "SilentlyContinue"

$STATE_DIR = "$env:USERPROFILE\.claude\ralph-wiggum"
$STATE_FILE = "$STATE_DIR\loop-state.md"
$LOG_FILE = "$STATE_DIR\loop-history.log"

if (-not (Test-Path $STATE_FILE)) {
    Write-Host "No active Ralph loop found."
    exit 0
}

# Read state file
$stateContent = Get-Content $STATE_FILE -Raw

# Extract values
$iteration = 0
$sessionId = ""

if ($stateContent -match "iteration:\s*(\d+)") { $iteration = [int]$Matches[1] }
if ($stateContent -match "session_id:\s*(\S+)") { $sessionId = $Matches[1] }

# Deactivate loop
$stateContent = $stateContent -replace "active:\s*true", "active: false"
$stateContent | Set-Content -Path $STATE_FILE -Encoding UTF8

# Log cancellation
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"[$timestamp] Ralph Loop CANCELLED at iteration $iteration (session: $sessionId)" | Add-Content -Path $LOG_FILE

Write-Host ""
Write-Host "=========================================="
Write-Host "   RALPH LOOP CANCELLED"
Write-Host "=========================================="
Write-Host "Session ID: $sessionId"
Write-Host "Iterations completed: $iteration"
Write-Host ""
Write-Host "The loop has been deactivated."
Write-Host "You can start a new loop with /ralph-loop"
Write-Host ""

exit 0
