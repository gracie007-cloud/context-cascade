#!/bin/bash
# pattern-retention.sh
# Hook: PreCompact
# Purpose: Inject critical pattern reminders before context compaction
#
# This is the MOST CRITICAL hook - ensures patterns survive context loss

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
  - foundry (15): agent-creator, skill-creator...
  - operations (12): cicd-engineer, monitoring-engineer...
  - platforms (8): platform-engineer, cloud-architect...
  - security (9): security-engineer, penetration-tester...
  - specialists (50+): python-expert, javascript-expert...
  - tooling (14): build-engineer, package-manager...

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
6. STATE TRACKING (ENFORCEMENT ACTIVE)
================================================================

The enforcement system is tracking:
  - All skill invocations
  - All agent spawns
  - All TodoWrite calls
  - All violations

State file: .claude/runtime/enforcement-state.json

Violations logged:
  - generic_agent: Non-registry agent type used
  - missing_agents: Skill invoked without Task()
  - missing_todowrite: Agents spawned without TodoWrite()
  - skipped_phase: Phase skipped in 5-phase workflow

================================================================
7. HOOK LIMITATIONS (CRITICAL UNDERSTANDING)
================================================================

Hooks CANNOT:
  - Inspect Task() parameters (no agent type validation in PreToolUse)
  - Modify inputs/outputs
  - Force tool calls
  - Access conversation transcript
  - Block based on parameter validation

Hooks CAN:
  - Display reminders (preventive)
  - Log invocations (detective)
  - Check compliance after execution (reactive)
  - Track state across conversation

This means:
  - Enforcement is primarily REMINDER-BASED
  - Validation is REACTIVE (after actions)
  - Agent type validation happens via transcript parsing
  - Compliance checking happens in PostToolUse

YOU must self-enforce. Hooks are guardrails, not barriers.

================================================================
8. RECURSIVE IMPROVEMENT SYSTEM (META-SKILLS)
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
  [ ] State tracking is active
  [ ] Hook limitations (reminders, not barriers)
  [ ] Self-enforcement is required
  [ ] Meta-skills gated by frozen eval harness
  [ ] Agent Creator creates auditors for the loop

If you've forgotten anything: RE-READ THIS REMINDER.

================================================================
EOF

exit 0
