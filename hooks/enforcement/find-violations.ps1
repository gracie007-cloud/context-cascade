# find-violations.ps1
# Purpose: List all violations across archived sessions

$ErrorActionPreference = "SilentlyContinue"

$ARCHIVE_DIR = "$env:USERPROFILE\.claude\runtime\enforcement\archive"
$CURRENT_STATE = "$env:USERPROFILE\.claude\runtime\enforcement-state.json"

Write-Host "=== Violation Report ==="
Write-Host ""

# Check current session
if (Test-Path $CURRENT_STATE) {
    Write-Host "CURRENT SESSION:"
    $state = Get-Content $CURRENT_STATE -Raw | ConvertFrom-Json

    $sessionId = $state.session_id
    $violations = $state.violations.Count

    Write-Host "  Session: $sessionId"
    Write-Host "  Violations: $violations"

    if ($violations -gt 0) {
        Write-Host ""
        foreach ($v in $state.violations) {
            Write-Host "    [$($v.type)] $($v.details)"
            Write-Host "      Detected: $($v.detected_at)"
        }
    }
    Write-Host ""
}

# Check archives
if (Test-Path $ARCHIVE_DIR) {
    $archiveFiles = Get-ChildItem "$ARCHIVE_DIR\*.json" -ErrorAction SilentlyContinue

    if ($archiveFiles -and $archiveFiles.Count -gt 0) {
        Write-Host "ARCHIVED SESSIONS:"
        Write-Host ""

        $totalViolations = 0

        foreach ($archiveFile in $archiveFiles) {
            $archive = Get-Content $archiveFile.FullName -Raw | ConvertFrom-Json

            $sessionId = $archive.session_id
            $startedAt = $archive.started_at
            $violations = $archive.violations.Count

            if ($violations -gt 0) {
                Write-Host "  Session: $sessionId"
                Write-Host "  Started: $startedAt"
                Write-Host "  Violations: $violations"
                Write-Host ""

                foreach ($v in $archive.violations) {
                    Write-Host "    [$($v.type)] $($v.details)"
                    Write-Host "      Detected: $($v.detected_at)"
                }
                Write-Host ""

                $totalViolations += $violations
            }
        }

        # Summary
        Write-Host "SUMMARY:"
        Write-Host "  Total Archived Sessions: $($archiveFiles.Count)"
        Write-Host "  Total Violations: $totalViolations"
    }
} else {
    Write-Host "No archived sessions found"
}

Write-Host ""
Write-Host "=== End of Report ==="

exit 0
