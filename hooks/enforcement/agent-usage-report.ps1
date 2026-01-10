# agent-usage-report.ps1
# Purpose: Analyze agent type usage patterns

$ErrorActionPreference = "SilentlyContinue"

$ARCHIVE_DIR = "$env:USERPROFILE\.claude\runtime\enforcement\archive"
$CURRENT_STATE = "$env:USERPROFILE\.claude\runtime\enforcement-state.json"

Write-Host "=== Agent Usage Report ==="
Write-Host ""

# Initialize counters
$agentTypeCounts = @{}
$categoryCounts = @{}

# Process current session
if (Test-Path $CURRENT_STATE) {
    $state = Get-Content $CURRENT_STATE -Raw | ConvertFrom-Json
    foreach ($spawn in $state.agent_spawns) {
        $atype = $spawn.agent_type
        $cat = $spawn.category
        if ($atype) {
            if (-not $agentTypeCounts.ContainsKey($atype)) { $agentTypeCounts[$atype] = 0 }
            $agentTypeCounts[$atype]++
        }
        if ($cat) {
            if (-not $categoryCounts.ContainsKey($cat)) { $categoryCounts[$cat] = 0 }
            $categoryCounts[$cat]++
        }
    }
}

# Process archives
if (Test-Path $ARCHIVE_DIR) {
    $archiveFiles = Get-ChildItem "$ARCHIVE_DIR\*.json" -ErrorAction SilentlyContinue
    foreach ($archiveFile in $archiveFiles) {
        $archive = Get-Content $archiveFile.FullName -Raw | ConvertFrom-Json
        foreach ($spawn in $archive.agent_spawns) {
            $atype = $spawn.agent_type
            $cat = $spawn.category
            if ($atype) {
                if (-not $agentTypeCounts.ContainsKey($atype)) { $agentTypeCounts[$atype] = 0 }
                $agentTypeCounts[$atype]++
            }
            if ($cat) {
                if (-not $categoryCounts.ContainsKey($cat)) { $categoryCounts[$cat] = 0 }
                $categoryCounts[$cat]++
            }
        }
    }
}

# Display results
Write-Host "AGENT TYPE USAGE:"
if ($agentTypeCounts.Count -gt 0) {
    $agentTypeCounts.GetEnumerator() | Sort-Object Value -Descending | ForEach-Object {
        Write-Host "  $($_.Key): $($_.Value)"
    }
} else {
    Write-Host "  No agents spawned"
}
Write-Host ""

Write-Host "CATEGORY DISTRIBUTION:"
if ($categoryCounts.Count -gt 0) {
    $totalAgents = ($categoryCounts.Values | Measure-Object -Sum).Sum
    $categoryCounts.GetEnumerator() | Sort-Object Value -Descending | ForEach-Object {
        $pct = if ($totalAgents -gt 0) { [math]::Round($_.Value * 100 / $totalAgents, 2) } else { 0 }
        Write-Host "  $($_.Key): $($_.Value) (${pct}%)"
    }
} else {
    Write-Host "  No categories found"
}
Write-Host ""

# Top 10 most used agents
Write-Host "TOP 10 MOST USED AGENTS:"
if ($agentTypeCounts.Count -gt 0) {
    $agentTypeCounts.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 10 | ForEach-Object {
        Write-Host "  $($_.Value) - $($_.Key)"
    }
} else {
    Write-Host "  No data"
}
Write-Host ""

# Diversity metric
Write-Host "DIVERSITY METRICS:"
$uniqueTypes = $agentTypeCounts.Count
$totalSpawns = ($agentTypeCounts.Values | Measure-Object -Sum).Sum

Write-Host "  Unique Agent Types: $uniqueTypes"
Write-Host "  Total Agent Spawns: $totalSpawns"

if ($totalSpawns -gt 0) {
    $diversity = [math]::Round($uniqueTypes / $totalSpawns, 2)
    Write-Host "  Diversity Score: $diversity"

    if ($diversity -ge 0.5) {
        Write-Host "  Status: HIGH diversity (good - using many agent types)"
    } elseif ($diversity -ge 0.2) {
        Write-Host "  Status: MEDIUM diversity (moderate variety)"
    } else {
        Write-Host "  Status: LOW diversity (overusing same agents)"
    }
}

Write-Host ""
Write-Host "=== End of Report ==="

exit 0
