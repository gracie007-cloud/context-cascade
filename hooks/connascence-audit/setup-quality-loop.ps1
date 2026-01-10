# setup-quality-loop.ps1
# PURPOSE: Initialize a quality-gated Ralph loop with Connascence analyzer integration
#
# Usage: powershell setup-quality-loop.ps1 "<prompt>" [max_iterations] [completion_promise]

param(
    [Parameter(Position=0)]
    [string]$Prompt = "Continue working on the current task with production-quality code.",
    [Parameter(Position=1)]
    [int]$MaxIterations = 25,
    [Parameter(Position=2)]
    [string]$CompletionPromise = "CODE_QUALITY_PASSED"
)

$ErrorActionPreference = "SilentlyContinue"

$STATE_DIR = "$env:USERPROFILE\.claude\ralph-wiggum"
$AUDIT_DIR = "$env:USERPROFILE\.claude\connascence-audit"
$STATE_FILE = "$STATE_DIR\loop-state.md"
$LOG_FILE = "$STATE_DIR\loop-history.log"

# Create directories
if (-not (Test-Path $STATE_DIR)) {
    New-Item -ItemType Directory -Path $STATE_DIR -Force | Out-Null
}
if (-not (Test-Path $AUDIT_DIR)) {
    New-Item -ItemType Directory -Path $AUDIT_DIR -Force | Out-Null
}

# Generate session ID
$SESSION_ID = "quality-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

# Create state file with quality gate enabled
$stateContent = @"
---
session_id: $SESSION_ID
active: true
iteration: 0
max_iterations: $MaxIterations
completion_promise: "$CompletionPromise"
quality_gate: true
started_at: $(Get-Date -Format "yyyy-MM-ddTHH:mm:ss")
---
$Prompt

QUALITY REQUIREMENTS:
- No CRITICAL connascence violations allowed
- Maximum 3 HIGH severity issues
- Code must pass Connascence Safety Analyzer audit

The analyzer will automatically audit your code after each file change.
Fix all blocking issues before completing.

To complete this loop, output: <promise>$CompletionPromise</promise>
(This only works when the quality gate passes)
"@

$stateContent | Set-Content -Path $STATE_FILE -Encoding UTF8

# Log the start
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"[$timestamp] Quality Gate Loop started: $SESSION_ID" | Add-Content -Path $LOG_FILE
"[$timestamp] Max iterations: $MaxIterations" | Add-Content -Path $LOG_FILE
"[$timestamp] Completion promise: $CompletionPromise" | Add-Content -Path $LOG_FILE

# Clear any previous audit results
Remove-Item "$AUDIT_DIR\latest-results.json" -Force -ErrorAction SilentlyContinue
Remove-Item "$AUDIT_DIR\pending-issues.md" -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "=========================================="
Write-Host "   QUALITY GATE LOOP INITIALIZED"
Write-Host "=========================================="
Write-Host ""
Write-Host "Session ID: $SESSION_ID"
Write-Host "Max Iterations: $MaxIterations"
Write-Host "Quality Gate: ENABLED"
Write-Host ""
Write-Host "The Connascence Safety Analyzer will audit your code"
Write-Host "after each file change. The loop continues until:"
Write-Host ""
Write-Host "  1. All quality issues are resolved"
Write-Host "  2. You output: <promise>$CompletionPromise</promise>"
Write-Host ""
Write-Host "Quality Thresholds:"
Write-Host "  - CRITICAL: 0 allowed (blocking)"
Write-Host "  - HIGH: Max 3 (blocking if exceeded)"
Write-Host "  - MEDIUM/LOW: Recommendations only"
Write-Host ""
Write-Host "=========================================="
Write-Host ""

exit 0
