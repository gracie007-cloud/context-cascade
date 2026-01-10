# analyze-compliance.ps1
# Purpose: Analyze compliance across multiple archived sessions

$ErrorActionPreference = "SilentlyContinue"

$ARCHIVE_DIR = "$env:USERPROFILE\.claude\runtime\enforcement\archive"

if (-not (Test-Path $ARCHIVE_DIR)) {
    Write-Host "No archive directory found"
    exit 1
}

$archiveFiles = Get-ChildItem "$ARCHIVE_DIR\*.json" -ErrorAction SilentlyContinue

if (-not $archiveFiles -or $archiveFiles.Count -eq 0) {
    Write-Host "No archived sessions found"
    exit 1
}

Write-Host "=== Multi-Session Compliance Analysis ==="
Write-Host ""
Write-Host "Analyzing $($archiveFiles.Count) archived sessions..."
Write-Host ""

# Aggregate stats
$totalSessions = 0
$totalSkills = 0
$totalAgents = 0
$totalViolations = 0
$totalRegistryAgents = 0
$totalGenericAgents = 0
$sessionsWithViolations = 0
$violationTypes = @{}

# Process each archive
foreach ($archiveFile in $archiveFiles) {
    $totalSessions++

    $archive = Get-Content $archiveFile.FullName -Raw | ConvertFrom-Json

    $skills = $archive.skill_invocations.Count
    $totalSkills += $skills

    $agents = $archive.agent_spawns.Count
    $totalAgents += $agents

    $violations = $archive.violations.Count
    $totalViolations += $violations

    if ($violations -gt 0) {
        $sessionsWithViolations++
    }

    # Count registry vs generic agents
    $registryCount = ($archive.agent_spawns | Where-Object { $_.is_registry_agent -eq $true }).Count
    $genericCount = ($archive.agent_spawns | Where-Object { $_.is_registry_agent -eq $false }).Count
    $totalRegistryAgents += $registryCount
    $totalGenericAgents += $genericCount

    # Count violation types
    foreach ($v in $archive.violations) {
        $vtype = $v.type
        if ($vtype) {
            if (-not $violationTypes.ContainsKey($vtype)) { $violationTypes[$vtype] = 0 }
            $violationTypes[$vtype]++
        }
    }
}

# Display results
Write-Host "AGGREGATE STATISTICS:"
Write-Host "  Total Sessions: $totalSessions"
Write-Host "  Total Skills Invoked: $totalSkills"
Write-Host "  Total Agents Spawned: $totalAgents"
Write-Host "  Total Violations: $totalViolations"
Write-Host ""

Write-Host "COMPLIANCE METRICS:"
if ($totalAgents -gt 0) {
    $complianceRate = [math]::Round($totalRegistryAgents * 100 / $totalAgents, 2)
    Write-Host "  Registry Agents: $totalRegistryAgents"
    Write-Host "  Generic Agents: $totalGenericAgents"
    Write-Host "  Registry Compliance Rate: ${complianceRate}%"
} else {
    Write-Host "  No agents spawned"
}
Write-Host ""

$violationRate = if ($totalSessions -gt 0) { [math]::Round($sessionsWithViolations * 100 / $totalSessions, 2) } else { 0 }
Write-Host "  Sessions with Violations: $sessionsWithViolations / $totalSessions (${violationRate}%)"
Write-Host ""

if ($totalSessions -gt 0) {
    $avgSkills = [math]::Round($totalSkills / $totalSessions, 2)
    $avgAgents = [math]::Round($totalAgents / $totalSessions, 2)
    $avgViolations = [math]::Round($totalViolations / $totalSessions, 2)

    Write-Host "AVERAGES PER SESSION:"
    Write-Host "  Skills: $avgSkills"
    Write-Host "  Agents: $avgAgents"
    Write-Host "  Violations: $avgViolations"
    Write-Host ""
}

Write-Host "VIOLATION TYPES:"
if ($violationTypes.Count -gt 0) {
    $violationTypes.GetEnumerator() | ForEach-Object {
        Write-Host "  $($_.Key): $($_.Value)"
    }
} else {
    Write-Host "  No violations"
}
Write-Host ""

# Quality score
$qualityScore = 100
if ($totalAgents -gt 0) {
    $genericPenalty = $totalGenericAgents * 10 / $totalAgents
    $qualityScore -= $genericPenalty
}
if ($totalSessions -gt 0) {
    $violationPenalty = $totalViolations * 5 / $totalSessions
    $qualityScore -= $violationPenalty
}
$qualityScore = [math]::Round([math]::Max(0, $qualityScore), 2)

Write-Host "OVERALL QUALITY SCORE: ${qualityScore}/100"
Write-Host ""

if ($qualityScore -ge 90) {
    Write-Host "Status: EXCELLENT - Strong compliance with enforcement rules"
} elseif ($qualityScore -ge 70) {
    Write-Host "Status: GOOD - Minor compliance issues"
} elseif ($qualityScore -ge 50) {
    Write-Host "Status: FAIR - Significant compliance issues"
} else {
    Write-Host "Status: POOR - Major compliance violations"
}

Write-Host ""
Write-Host "=== End of Analysis ==="

exit 0
