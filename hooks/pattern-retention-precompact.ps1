# pattern-retention-precompact.ps1
# PURPOSE: Inject critical pattern reminders before context compaction
# HOOK TYPE: PreCompact (runs before context window compacts)
#
# This is the MOST CRITICAL hook - it ensures patterns survive context loss

$ErrorActionPreference = "SilentlyContinue"

Write-Host @"

================================================================
!! CRITICAL: CONTEXT COMPACTION - PATTERN RETENTION !!
================================================================

The context window is about to compact. These patterns MUST survive:

================================================================
1. FIVE-PHASE WORKFLOW (ALWAYS EXECUTE)
================================================================

For EVERY non-trivial request, execute IN ORDER:

Phase 1: Skill("intent-analyzer")     -> Understand true intent
Phase 2: Skill("prompt-architect")    -> Optimize the request
Phase 3: Skill("planner")             -> Create execution plan
Phase 4: Route to playbooks           -> Select tools per task
Phase 5: Execute with Task()          -> Spawn registry agents

DO NOT skip phases. DO NOT jump to execution.

================================================================
2. AGENT REGISTRY ENFORCEMENT (NEVER USE GENERIC)
================================================================

ONLY spawn agents from the registry:
  Path: claude-code-plugins/context-cascade/agents/
  Count: 206 agents in 10 categories

Fallbacks if unsure: coder, researcher, tester, reviewer

NEVER use made-up agent types. NEVER use generic descriptions.

================================================================
3. SKILL -> TASK -> TODOWRITE PATTERN (ALWAYS FOLLOW)
================================================================

Skill defines the SOP (how to do something)
    |
    v
Task() spawns agents to EXECUTE the SOP
    |
    v
TodoWrite() tracks progress with 5-10 todos

This pattern is MANDATORY. No exceptions.

================================================================
4. GOLDEN RULE: ONE MESSAGE = ALL PARALLEL OPERATIONS
================================================================

WRONG: Spawn agent 1, wait, spawn agent 2, wait...
RIGHT: One message with ALL Task() calls for parallel work

================================================================
5. MEMORY TAGGING PROTOCOL (PERSIST KNOWLEDGE)
================================================================

ALL memory writes use: WHO / WHEN / PROJECT / WHY

================================================================
6. MEMORY-MCP INTEGRATION (PERSIST ACROSS SESSIONS)
================================================================

BEFORE TASKS - Check memory:
  kv.list_keys("findings:{domain}:")     -> Prior issues
  kv.list_keys("fixes:*:")               -> Proven solutions
  graph.get_subgraph("{pattern}", 2)     -> Fix patterns

AFTER TASKS - Store results:
  findings:{agent}:{severity}:{id}       -> Issues found
  fixes:{agent}:{finding-id}             -> Bugs fixed
  decisions:{project}:{id}               -> Decisions made

================================================================
POST-COMPACT CHECKLIST
================================================================

After compaction, verify you remember:
  [ ] 5-phase workflow is MANDATORY
  [ ] Agents come from registry ONLY
  [ ] Pattern: Skill -> Task -> TodoWrite
  [ ] 1 message = all parallel operations
  [ ] MEMORY-MCP: Check memory BEFORE tasks
  [ ] MEMORY-MCP: Store results AFTER tasks

If you've forgotten anything: RE-READ THIS REMINDER.

================================================================

"@

exit 0
