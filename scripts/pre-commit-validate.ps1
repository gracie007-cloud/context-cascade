# pre-commit-validate.ps1
# Pre-commit hook for local skill validation (Windows native)
# Install: Copy-Item scripts/pre-commit-validate.ps1 .git/hooks/pre-commit.ps1

$ErrorActionPreference = "Stop"

Write-Host "=== Pre-commit: Validating skill structure ===" -ForegroundColor Cyan

# Get repo root
$RepoRoot = git rev-parse --show-toplevel
$RepoRoot = $RepoRoot -replace '/', '\'

# Check for staged skill changes
$StagedFiles = git diff --cached --name-only
$SkillChanges = $StagedFiles | Where-Object { $_ -match "^skills/" }

if (-not $SkillChanges) {
    Write-Host "No skill changes detected, skipping validation." -ForegroundColor Yellow
    exit 0
}

Write-Host "Skill changes detected:" -ForegroundColor Cyan
$SkillChanges | ForEach-Object { Write-Host "  $_" }
Write-Host ""

# Run validation
$ValidateScript = Join-Path $RepoRoot "scripts\validate-skills.ps1"

if (Test-Path $ValidateScript) {
    & $ValidateScript -CI
    $ExitCode = $LASTEXITCODE
} else {
    Write-Host "[WARN] validate-skills.ps1 not found, running basic checks..." -ForegroundColor Yellow
    $ExitCode = 0

    foreach ($Change in $SkillChanges) {
        # Extract skill folder
        if ($Change -match "^skills/([^/]+)/([^/]+)/") {
            $Category = $Matches[1]
            $SkillName = $Matches[2]

            if ($Category -ne "packaged") {
                $SkillMdPath = Join-Path $RepoRoot "skills\$Category\$SkillName\SKILL.md"
                if (-not (Test-Path $SkillMdPath)) {
                    Write-Host "[FAIL] Missing SKILL.md: skills/$Category/$SkillName" -ForegroundColor Red
                    $ExitCode = 1
                }
            }
        }
    }

    if ($ExitCode -eq 0) {
        Write-Host "[PASS] Basic validation passed" -ForegroundColor Green
    }
}

if ($ExitCode -ne 0) {
    Write-Host ""
    Write-Host "=== Validation FAILED ===" -ForegroundColor Red
    Write-Host "Fix the issues above before committing."
    Write-Host "Run: .\scripts\validate-skills.ps1 -Verbose -Fix"
    exit 1
}

Write-Host "=== Validation PASSED ===" -ForegroundColor Green
exit 0
