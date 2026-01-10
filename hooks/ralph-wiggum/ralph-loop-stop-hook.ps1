# ralph-loop-stop-hook.ps1
# PURPOSE: Stop hook for Ralph Wiggum persistence loop
# HOOK TYPE: Stop (runs when Claude tries to end session)
#
# This hook:
# 1. Checks if a Ralph loop is active
# 2. Validates completion promise if set
# 3. Blocks exit and re-injects prompt if loop should continue
# 4. Uses exit code 2 to block Claude from stopping

$ErrorActionPreference = "SilentlyContinue"

$STATE_DIR = "$env:USERPROFILE\.claude\ralph-wiggum"
$STATE_FILE = "$STATE_DIR\loop-state.md"
$LOG_FILE = "$STATE_DIR\loop-history.log"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$timestamp] $Message" | Add-Content -Path $LOG_FILE
}

# Check if state file exists
if (-not (Test-Path $STATE_FILE)) {
    exit 0
}

# Read state file content
$stateContent = Get-Content $STATE_FILE -Raw

# Check if loop is active
if ($stateContent -notmatch "active:\s*true") {
    exit 0
}

# Extract values using regex
$iteration = 0
$maxIterations = 50
$completionPromise = ""
$sessionId = ""

if ($stateContent -match "iteration:\s*(\d+)") { $iteration = [int]$Matches[1] }
if ($stateContent -match "max_iterations:\s*(\d+)") { $maxIterations = [int]$Matches[1] }
if ($stateContent -match 'completion_promise:\s*"([^"]*)"') { $completionPromise = $Matches[1] }
if ($stateContent -match "session_id:\s*(\S+)") { $sessionId = $Matches[1] }

# Increment iteration
$iteration++

Write-Log "Ralph Loop iteration $iteration of $maxIterations (session: $sessionId)"

# Check max iterations
if ($iteration -gt $maxIterations) {
    Write-Log "Max iterations reached. Ending loop."

    # Deactivate loop
    $stateContent = $stateContent -replace "active:\s*true", "active: false"
    $stateContent | Set-Content -Path $STATE_FILE -Encoding UTF8

    Write-Host ""
    Write-Host "=========================================="
    Write-Host "   RALPH LOOP: MAX ITERATIONS REACHED"
    Write-Host "=========================================="
    Write-Host "Completed $maxIterations iterations without completion promise."
    Write-Host "Loop has been deactivated."
    Write-Host ""

    exit 0
}

# Check completion promise if set
if ($completionPromise -and $completionPromise -ne '""' -and $completionPromise -ne "''") {
    # Read Claude's last response from stdin
    $claudeOutput = ""
    try {
        $claudeOutput = [Console]::In.ReadToEnd()
    } catch {}

    # Look for <promise>TEXT</promise> pattern
    if ($claudeOutput -match "<promise>([^<]+)</promise>") {
        $foundPromise = $Matches[1]

        if ($foundPromise -eq $completionPromise) {
            Write-Log "Completion promise found: $foundPromise. Ending loop successfully."

            # Deactivate loop
            $stateContent = $stateContent -replace "active:\s*true", "active: false"
            $stateContent | Set-Content -Path $STATE_FILE -Encoding UTF8

            Write-Host ""
            Write-Host "=========================================="
            Write-Host "   RALPH LOOP: TASK COMPLETE!"
            Write-Host "=========================================="
            Write-Host "Completion promise verified: $foundPromise"
            Write-Host "Total iterations: $iteration"
            Write-Host ""

            exit 0
        }
    }
}

# Update iteration count in state file
$stateContent = $stateContent -replace "iteration:\s*\d+", "iteration: $iteration"
$stateContent | Set-Content -Path $STATE_FILE -Encoding UTF8

# Extract prompt (everything after the second ---)
$prompt = ""
$parts = $stateContent -split "---", 3
if ($parts.Count -ge 3) {
    $prompt = $parts[2].Trim()
}

if (-not $prompt) {
    Write-Log "ERROR: Could not extract prompt from state file"
    exit 0
}

Write-Log "Re-injecting prompt for iteration $iteration"

# Output the blocking message
Write-Host ""
Write-Host "=========================================="
Write-Host "   RALPH LOOP: ITERATION $iteration of $maxIterations"
Write-Host "=========================================="
Write-Host ""
Write-Host "The loop continues. Previous work persists in files."
Write-Host "Review your progress and continue working toward completion."
Write-Host ""

if ($completionPromise -and $completionPromise -ne '""') {
    Write-Host "To complete, output exactly: <promise>$completionPromise</promise>"
    Write-Host ""
}

Write-Host "ORIGINAL TASK:"
Write-Host "---"
Write-Host $prompt
Write-Host "---"
Write-Host ""
Write-Host "Continue working on this task. Check files for your previous progress."
Write-Host "If tests exist, run them and fix any failures."
Write-Host "If blocked, document what's preventing progress."
Write-Host ""

# Exit with code 2 to block normal exit and trigger re-prompt
exit 2
