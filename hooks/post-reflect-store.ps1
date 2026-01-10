# Hook: Post-Reflect Store - Windows PowerShell
# Triggers after /reflect skill completes to store learnings
#
# This hook is designed to be called after the reflect skill outputs
# a JSON learnings file to the reflect-output directory.

param(
    [string]$LearningsFile = "",
    [string]$SessionId = "",
    [string]$Project = "general"
)

$ErrorActionPreference = "Stop"

$REFLECT_SCRIPT = "D:\Projects\memory-mcp-triple-system\scripts\reflect_to_memory.py"
$LEARNINGS_DIR = "$env:USERPROFILE\.claude\reflect-output"

# Ensure learnings directory exists
if (-not (Test-Path $LEARNINGS_DIR)) {
    New-Item -ItemType Directory -Path $LEARNINGS_DIR -Force | Out-Null
}

# Generate session ID if not provided
if (-not $SessionId) {
    $SessionId = "session_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
}

# If no specific file provided, find most recent
if (-not $LearningsFile -or -not (Test-Path $LearningsFile)) {
    $LearningsFile = Get-ChildItem -Path $LEARNINGS_DIR -Filter "*.json" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1 -ExpandProperty FullName
}

if (-not $LearningsFile) {
    Write-Host "[post-reflect] No learnings file found"
    exit 0
}

Write-Host "=============================================="
Write-Host "Post-Reflect Memory Storage"
Write-Host "=============================================="
Write-Host "Session ID: $SessionId"
Write-Host "Project: $Project"
Write-Host "Learnings: $LearningsFile"
Write-Host ""

# Run the reflect_to_memory.py script
try {
    $output = python $REFLECT_SCRIPT --session-id $SessionId --project $Project --from-file $LearningsFile 2>&1
    Write-Host $output

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "[post-reflect] SUCCESS: Learnings stored to Memory MCP"

        # Archive the processed file
        $archiveName = [System.IO.Path]::GetFileNameWithoutExtension($LearningsFile)
        $archivePath = "$LEARNINGS_DIR\archive"
        if (-not (Test-Path $archivePath)) {
            New-Item -ItemType Directory -Path $archivePath -Force | Out-Null
        }
        Move-Item -Path $LearningsFile -Destination "$archivePath\$archiveName-$(Get-Date -Format 'yyyyMMdd_HHmmss').json" -Force
    } else {
        Write-Error "[post-reflect] FAILED: Could not store learnings"
        exit 1
    }
} catch {
    Write-Error "[post-reflect] ERROR: $_"
    exit 1
}

exit 0
