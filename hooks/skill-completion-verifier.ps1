# Post-Skill Hook: Verify skill completion requirements
# This hook fires AFTER any Skill tool invocation

$ErrorActionPreference = "SilentlyContinue"

Write-Host "=================================================="
Write-Host "!! SKILL COMPLETION VERIFICATION !!"
Write-Host "=================================================="
Write-Host ""
Write-Host "You just invoked a Skill. Skills are SOPs that MUST spawn agents."
Write-Host ""
Write-Host "CHECKLIST - Verify before proceeding:"
Write-Host "  [ ] Did you spawn at least 1 agent via Task()?"
Write-Host "  [ ] Is the agent from the registry (not invented)?"
Write-Host "  [ ] Did you call TodoWrite() with 5+ todos?"
Write-Host "  [ ] Did you delegate work to agents (not do it yourself)?"
Write-Host ""
Write-Host "CORRECT PATTERN:"
Write-Host "  Skill('skill-name')"
Write-Host "  Task('Agent Name', 'description', 'agent-type-from-registry')"
Write-Host "  Task('Agent Name', 'description', 'agent-type-from-registry')"
Write-Host "  TodoWrite({ todos: [8-10 items] })"
Write-Host ""
Write-Host "WRONG PATTERN:"
Write-Host "  Skill('skill-name')"
Write-Host "  [Then doing all the work myself without Task() calls]"
Write-Host ""
Write-Host "If you haven't spawned agents yet, DO IT NOW before continuing."
Write-Host "=================================================="

exit 0
