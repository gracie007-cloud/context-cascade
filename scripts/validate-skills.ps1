# validate-skills.ps1
# CI/Enforcement script to validate skill structure integrity
# Created: 2026-01-11
# Exit codes: 0 = pass, 1 = fail

param(
    [switch]$Fix,        # Auto-fix issues by running extract/sync scripts
    [switch]$Verbose,    # Show detailed output
    [switch]$CI          # CI mode - strict, no colors
)

$ErrorCount = 0
$WarningCount = 0

$PluginRoot = Split-Path -Parent $PSScriptRoot
if (-not $PluginRoot -or -not (Test-Path (Join-Path $PluginRoot "skills"))) {
    $PluginRoot = "C:\Users\17175\claude-code-plugins\context-cascade"
}

$PackagedDir = Join-Path $PluginRoot "skills\packaged"
$SkillsRoot = Join-Path $PluginRoot "skills"
$CommandsDir = "C:\Users\17175\.claude\commands"
$ScriptsDir = Join-Path $PluginRoot "scripts"

function Write-Status {
    param([string]$Status, [string]$Message)
    if ($CI) {
        Write-Host "[$Status] $Message"
    } else {
        $Color = switch ($Status) {
            "PASS" { "Green" }
            "FAIL" { "Red" }
            "WARN" { "Yellow" }
            "INFO" { "Cyan" }
            default { "White" }
        }
        Write-Host "[$Status] " -ForegroundColor $Color -NoNewline
        Write-Host $Message
    }
}

function Write-Header {
    param([string]$Title)
    if ($CI) {
        Write-Host "`n=== $Title ==="
    } else {
        Write-Host "`n=== $Title ===" -ForegroundColor Cyan
    }
}

# ============================================
# CHECK 1: Packaged skills exist
# ============================================
Write-Header "Check 1: Packaged Skills Inventory"

$PackagedSkills = @()
if (Test-Path $PackagedDir) {
    $PackagedSkills = Get-ChildItem -Path $PackagedDir -Filter "*.skill" | ForEach-Object { $_.BaseName }
    Write-Status "INFO" "Found $($PackagedSkills.Count) packaged .skill files"
} else {
    Write-Status "FAIL" "Packaged directory not found: $PackagedDir"
    $ErrorCount++
}

# ============================================
# CHECK 2: All packaged skills are extracted
# ============================================
Write-Header "Check 2: Extraction Status"

$Categories = @("delivery", "foundry", "operations", "orchestration", "platforms", "quality", "research", "security", "specialists", "tooling")
$ExtractedSkills = @{}

foreach ($Cat in $Categories) {
    $CatPath = Join-Path $SkillsRoot $Cat
    if (Test-Path $CatPath) {
        Get-ChildItem -Path $CatPath -Directory | ForEach-Object {
            $ExtractedSkills[$_.Name] = $Cat
        }
    }
}

Write-Status "INFO" "Found $($ExtractedSkills.Count) extracted skills across $($Categories.Count) categories"

$MissingExtractions = @()
foreach ($Skill in $PackagedSkills) {
    if (-not $ExtractedSkills.ContainsKey($Skill)) {
        $MissingExtractions += $Skill
        if ($Verbose) {
            Write-Status "FAIL" "Not extracted: $Skill"
        }
    }
}

if ($MissingExtractions.Count -gt 0) {
    Write-Status "FAIL" "$($MissingExtractions.Count) skills not extracted"
    $ErrorCount++

    if ($Fix) {
        Write-Status "INFO" "Running extract-all-skills.ps1 to fix..."
        & (Join-Path $ScriptsDir "extract-all-skills.ps1") -Force
    }
} else {
    Write-Status "PASS" "All packaged skills are extracted"
}

# ============================================
# CHECK 3: Extracted skills have SKILL.md
# ============================================
Write-Header "Check 3: SKILL.md Presence"

$MissingSkillMd = @()
foreach ($Skill in $ExtractedSkills.Keys) {
    $Cat = $ExtractedSkills[$Skill]
    $SkillMdPath = Join-Path $SkillsRoot "$Cat\$Skill\SKILL.md"
    if (-not (Test-Path $SkillMdPath)) {
        $MissingSkillMd += "$Cat/$Skill"
        if ($Verbose) {
            Write-Status "FAIL" "Missing SKILL.md: $Cat/$Skill"
        }
    }
}

if ($MissingSkillMd.Count -gt 0) {
    Write-Status "FAIL" "$($MissingSkillMd.Count) skills missing SKILL.md"
    $ErrorCount++
} else {
    Write-Status "PASS" "All extracted skills have SKILL.md"
}

# ============================================
# CHECK 4: Stub files reference valid paths
# ============================================
Write-Header "Check 4: Stub Path Validation"

$InvalidStubs = @()
$StubsChecked = 0

if (Test-Path $CommandsDir) {
    Get-ChildItem -Path $CommandsDir -Filter "*.md" -File | ForEach-Object {
        $StubsChecked++
        $Content = Get-Content -Path $_.FullName -Raw -ErrorAction SilentlyContinue

        if ($Content -match "Context Cascade: skills/([^/]+)/([^/]+)/SKILL\.md") {
            $Cat = $Matches[1]
            $SkillName = $Matches[2]
            $ExpectedPath = Join-Path $SkillsRoot "$Cat\$SkillName\SKILL.md"

            if (-not (Test-Path $ExpectedPath)) {
                $InvalidStubs += @{
                    Stub = $_.Name
                    Expected = "$Cat/$SkillName"
                }
                if ($Verbose) {
                    Write-Status "FAIL" "Invalid stub path: $($_.Name) -> $Cat/$SkillName"
                }
            }
        }
    }

    Write-Status "INFO" "Checked $StubsChecked stub files"
}

if ($InvalidStubs.Count -gt 0) {
    Write-Status "FAIL" "$($InvalidStubs.Count) stubs reference non-existent paths"
    $ErrorCount++

    if ($Fix) {
        Write-Status "INFO" "Running sync-stub-paths.ps1 to fix..."
        & (Join-Path $ScriptsDir "sync-stub-paths.ps1")
    }
} else {
    Write-Status "PASS" "All stub paths are valid"
}

# ============================================
# CHECK 5: Category distribution sanity
# ============================================
Write-Header "Check 5: Category Distribution"

$CategoryCounts = @{}
foreach ($Skill in $ExtractedSkills.Keys) {
    $Cat = $ExtractedSkills[$Skill]
    if (-not $CategoryCounts.ContainsKey($Cat)) {
        $CategoryCounts[$Cat] = 0
    }
    $CategoryCounts[$Cat]++
}

$EmptyCategories = @()
foreach ($Cat in $Categories) {
    $Count = if ($CategoryCounts.ContainsKey($Cat)) { $CategoryCounts[$Cat] } else { 0 }
    if ($Verbose) {
        Write-Status "INFO" "$Cat : $Count skills"
    }
    if ($Count -eq 0) {
        $EmptyCategories += $Cat
    }
}

if ($EmptyCategories.Count -gt 0) {
    Write-Status "WARN" "$($EmptyCategories.Count) categories are empty: $($EmptyCategories -join ', ')"
    $WarningCount++
} else {
    Write-Status "PASS" "All categories have skills"
}

# ============================================
# SUMMARY
# ============================================
Write-Header "Summary"

Write-Status "INFO" "Packaged skills: $($PackagedSkills.Count)"
Write-Status "INFO" "Extracted skills: $($ExtractedSkills.Count)"
Write-Status "INFO" "Errors: $ErrorCount"
Write-Status "INFO" "Warnings: $WarningCount"

if ($ErrorCount -gt 0) {
    Write-Status "FAIL" "Validation FAILED with $ErrorCount error(s)"
    if (-not $Fix) {
        Write-Host "`nRun with -Fix to auto-repair issues" -ForegroundColor Yellow
    }
    exit 1
} else {
    Write-Status "PASS" "Validation PASSED"
    exit 0
}
