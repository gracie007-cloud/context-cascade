# session-stop.ps1
# Hook: Stop
# Purpose: Archive state and display session summary

$ErrorActionPreference = "SilentlyContinue"

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$STATE_TRACKER = Join-Path $SCRIPT_DIR "state-tracker.ps1"

# Archive state
if (Test-Path $STATE_TRACKER) {
    & powershell -ExecutionPolicy Bypass -File $STATE_TRACKER archive_state 2>$null
}

# Display session summary
Write-Host @"

================================================================
!! SESSION ENDING - PATTERN RETENTION FOR NEXT SESSION !!
================================================================

This session is ending. State has been archived.

CRITICAL PATTERNS TO REMEMBER FOR NEXT SESSION:

1. 5-PHASE WORKFLOW IS MANDATORY
   Phase 1: Skill("intent-analyzer")
   Phase 2: Skill("prompt-architect")
   Phase 3: Skill("planner")
   Phase 4: Route to playbooks
   Phase 5: Execute with Skill -> Task -> TodoWrite

2. AGENTS FROM REGISTRY ONLY
   Location: claude-code-plugins/context-cascade/agents/
   206 agents in 10 categories
   Fallbacks: coder, researcher, tester, reviewer

3. SOP PATTERN: SKILL -> TASK -> TODOWRITE
   Skill defines SOP
   Task spawns agents
   TodoWrite tracks progress

4. GOLDEN RULE: 1 MESSAGE = ALL PARALLEL OPERATIONS
   Spawn all independent agents in single message

5. LOAD EXPERTISE BEFORE DOMAIN WORK
   Check: .claude/expertise/{domain}.yaml
   Load patterns and file locations before acting

6. STATE TRACKING IS ACTIVE
   All actions logged to enforcement state
   Violations recorded and archived
   Compliance checked at each step

7. HOOK LIMITATIONS
   Hooks remind, not enforce
   Parameter validation is reactive
   Self-enforcement required

8. META-SKILLS GATED BY FROZEN EVAL HARNESS
   Agent Creator creates auditors for improvement loop
   Eval harness never self-improves (prevents Goodhart's Law)

SESSION STATS:
  (See archived state file for detailed metrics)

Next session will start fresh with these patterns.
The enforcement system will activate on first non-trivial request.

Remember: YOU must follow the patterns. Hooks are guardrails.

================================================================

"@

exit 0
