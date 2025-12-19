#!/bin/bash
# pattern-retention-precompact.sh
# PURPOSE: Inject critical pattern reminders before context compaction
# HOOK TYPE: PreCompact (runs before context window compacts)
#
# This is the MOST CRITICAL hook - it ensures patterns survive context loss

cat << 'EOF'

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
  Path: claude-code-plugins/ruv-sparc-three-loop-system/agents/
  Count: 206 agents in 10 categories

Categories:
  - delivery (18): coder, backend-dev, frontend-dev...
  - orchestration (21): hierarchical-coordinator, byzantine-coordinator...
  - quality (18): code-analyzer, theater-detection-audit...
  - research (11): researcher, analyst...

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

[Single Message]:
  Task("Agent 1", "...", "type1")
  Task("Agent 2", "...", "type2")
  Task("Agent 3", "...", "type3")
  TodoWrite({todos: [...]})

================================================================
5. EXPERTISE SYSTEM (LOAD BEFORE ACTING)
================================================================

Before any domain-specific work:

1. Check: .claude/expertise/{domain}.yaml
2. If exists:
   - Run /expertise-validate {domain}
   - Load patterns, file locations, known issues
3. If not exists:
   - Agent should discover and create expertise

Expertise enables:
- No search thrash (known file locations)
- Pattern compliance (documented conventions)
- Issue avoidance (known problems)

================================================================
6. MEMORY TAGGING PROTOCOL (PERSIST KNOWLEDGE)
================================================================

ALL memory writes use: WHO / WHEN / PROJECT / WHY

Example:
{
  "WHO": "hierarchical-coordinator",
  "WHEN": "2025-12-15T...",
  "PROJECT": "expertise-system",
  "WHY": "tracking-execution-state"
}

================================================================
7. RECURSIVE IMPROVEMENT SYSTEM (META-SKILLS)
================================================================

The system can improve itself via:

FOUNDRY (creates components):
  - Agent Creator --> Creates auditor agents

IMPROVEMENT LOOP:
  - Prompt Forge --> Improves prompts (including Skill Forge)
  - Skill Forge --> Applies improvements (including to itself)
  - Auditor Agents --> Find issues (prompt, skill, expertise, output)
  - Eval Harness --> Gates ALL changes (FROZEN - never self-improves)

PIPELINE:
  PROPOSE -> TEST -> COMPARE -> COMMIT -> MONITOR -> ROLLBACK

KEY CONSTRAINT:
  - Eval harness does NOT self-improve (prevents Goodhart's Law)
  - Changes must pass benchmarks + regressions
  - Archive before commit (enables rollback)

================================================================
POST-COMPACT CHECKLIST
================================================================

After compaction, verify you remember:
  [ ] 5-phase workflow is MANDATORY
  [ ] Agents come from registry ONLY
  [ ] Pattern: Skill -> Task -> TodoWrite
  [ ] 1 message = all parallel operations
  [ ] Load expertise before domain work
  [ ] Tag all memory writes
  [ ] Meta-skills gated by frozen eval harness
  [ ] Agent Creator creates auditors for the loop

If you've forgotten anything: RE-READ THIS REMINDER.

================================================================
EOF

exit 0
