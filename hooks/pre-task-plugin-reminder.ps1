# Pre-Task Hook: Remind about ruv-sparc plugin and agent registry
# This hook fires BEFORE any Task tool invocation

$ErrorActionPreference = "SilentlyContinue"

Write-Host "=================================================="
Write-Host "!! RUV-SPARC PLUGIN REMINDER !!"
Write-Host "=================================================="
Write-Host ""
Write-Host "BEFORE spawning this agent, verify:"
Write-Host "  1. Agent exists in registry: claude-code-plugins/context-cascade/agents/"
Write-Host "  2. Agent name matches registry (not invented)"
Write-Host "  3. You invoked a Skill() before this Task()"
Write-Host ""
Write-Host "Agent Categories Available:"
Write-Host "  - delivery (18): backend, frontend, architecture"
Write-Host "  - foundry (19): agent creation, templates"
Write-Host "  - operations (28): DevOps, infrastructure"
Write-Host "  - orchestration (21): swarm coordinators"
Write-Host "  - platforms (44): AI/ML, neural, data"
Write-Host "  - quality (18): analysis, testing"
Write-Host "  - research (11): research, reasoning"
Write-Host "  - security (5): compliance, pentest"
Write-Host "  - specialists (15): business, domain"
Write-Host "  - tooling (24): docs, GitHub"
Write-Host ""
Write-Host "If agent not in registry, use fallback: coder, researcher, tester, reviewer"
Write-Host "=================================================="

exit 0
