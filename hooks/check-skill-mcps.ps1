# Check-Skill-MCPs.ps1
# Validates that required MCPs are active for a given skill

param(
    [string]$SkillName
)

# MCP dependency mapping (top skills)
$skillMcpMap = @{
    "flow-nexus-platform" = @("flow-nexus")
    "flow-nexus-swarm" = @("flow-nexus", "claude-flow")
    "flow-nexus-neural" = @("flow-nexus")
    "code-review-assistant" = @("claude-flow", "connascence-analyzer", "memory-mcp")
    "sop-dogfooding-quality-detection" = @("claude-flow", "connascence-analyzer", "memory-mcp")
    "sop-dogfooding-continuous-improvement" = @("claude-flow", "connascence-analyzer", "focused-changes", "memory-mcp")
    "sop-code-review" = @("connascence-analyzer", "memory-mcp", "ruv-swarm")
    "research-driven-planning" = @("claude-flow", "memory-mcp", "ruv-swarm")
    "deep-research-orchestrator" = @("claude-flow", "memory-mcp")
    "sparc-methodology" = @("claude-flow")
    "agent-creator" = @("claude-flow", "memory-mcp")
    "smart-bug-fix" = @("claude-flow", "flow-nexus", "memory-mcp")
    "deployment-readiness" = @("claude-flow", "flow-nexus", "memory-mcp")
    "github-code-review" = @("claude-flow", "ruv-swarm")
    "swarm-advanced" = @("claude-flow", "ruv-swarm")
    "agentdb-advanced" = @("agentdb")
    "agentdb-learning" = @("agentdb")
    "agentdb-vector-search" = @("agentdb")
}

# Read current .mcp.json
$mcpConfigPath = "C:\Users\17175\.mcp.json"
$activeMcps = @()

if (Test-Path $mcpConfigPath) {
    $config = Get-Content $mcpConfigPath | ConvertFrom-Json
    $activeMcps = $config.mcpServers.PSObject.Properties.Name
}

# Check if skill has MCP requirements
if ($skillMcpMap.ContainsKey($SkillName)) {
    $requiredMcps = $skillMcpMap[$SkillName]
    $missingMcps = @()

    foreach ($mcp in $requiredMcps) {
        if ($activeMcps -notcontains $mcp) {
            $missingMcps += $mcp
        }
    }

    if ($missingMcps.Count -gt 0) {
        Write-Host "!! MCP WARNING for skill: $SkillName !!"
        Write-Host "Missing MCPs: $($missingMcps -join ', ')"
        Write-Host ""
        Write-Host "To activate, run:"
        Write-Host "  powershell -File C:\Users\17175\ADD-MCP.ps1 code-quality"
        Write-Host "  (then restart Claude Desktop)"
        Write-Host ""
    } else {
        Write-Host "[OK] All required MCPs active for: $SkillName"
    }
} else {
    Write-Host "[INFO] Skill '$SkillName' has no special MCP requirements"
}
