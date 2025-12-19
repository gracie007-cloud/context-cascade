#!/bin/bash
# user-prompt-submit.sh
# Hook: UserPromptSubmit
# Purpose: Initialize workflow state and inject 5-phase reminder

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_TRACKER="$SCRIPT_DIR/state-tracker.sh"

# Read user message from stdin
USER_MESSAGE=$(cat)

# Extract message text
MESSAGE_TEXT=$(echo "$USER_MESSAGE" | jq -r '.message // empty' 2>/dev/null || echo "$USER_MESSAGE")

# Classify request as trivial or non-trivial
IS_TRIVIAL=false

# Trivial patterns (skip enforcement)
TRIVIAL_PATTERNS=(
    "^(hi|hello|hey|thanks|thank you|ok|okay|yes|no|bye)$"
    "^what (is|are|does|do) "
    "^(can you|could you) explain"
    "^(help|/help|/clear|/status)"
    "^show me"
    "^list "
    "^read "
    "^(git status|git log|ls|pwd)"
    "^search "
    "^find "
    "^grep "
)

for pattern in "${TRIVIAL_PATTERNS[@]}"; do
    if echo "$MESSAGE_TEXT" | grep -iqE "$pattern"; then
        IS_TRIVIAL=true
        break
    fi
done

# Non-trivial patterns (REQUIRE 5-phase)
NONTRIVIAL_PATTERNS=(
    "(build|create|implement|develop|add|make)"
    "(fix|debug|repair|resolve|solve)"
    "(refactor|optimize|improve|enhance)"
    "(analyze|audit|review|check|validate)"
    "(deploy|release|ship|publish)"
    "(test|spec|coverage)"
    "(design|architect|plan|strategy)"
)

for pattern in "${NONTRIVIAL_PATTERNS[@]}"; do
    if echo "$MESSAGE_TEXT" | grep -iqE "$pattern"; then
        IS_TRIVIAL=false
        break
    fi
done

# For non-trivial requests, initialize state and display enforcement
if [ "$IS_TRIVIAL" = false ]; then
    # Initialize workflow state
    bash "$STATE_TRACKER" init_state

    # Display 5-phase enforcement reminder
    cat << 'EOF'

================================================================
!! 5-PHASE WORKFLOW ENFORCEMENT ACTIVE !!
================================================================

This is a NON-TRIVIAL request. MANDATORY 5-phase workflow:

PHASE 1: INTENT ANALYSIS
  Tool: Skill("intent-analyzer")
  Output: Understood intent + confidence score
  Gate: If confidence < 80%, ask clarifying questions

PHASE 2: PROMPT OPTIMIZATION
  Tool: Skill("prompt-architect")
  Output: Optimized request + success criteria

PHASE 3: STRATEGIC PLANNING
  Tool: Skill("research-driven-planning") OR Skill("planner")
  Output: Task breakdown + dependencies + parallelization

PHASE 4: PLAYBOOK/SKILL ROUTING
  Action: Match tasks to playbooks/skills from catalog
  Output: Routing decisions for each task

PHASE 5: EXECUTION
  Tools: Skill() -> Task() -> TodoWrite()
  Pattern: Skills define SOP, Task spawns agents, TodoWrite tracks
  Golden Rule: 1 MESSAGE = ALL PARALLEL OPERATIONS

CRITICAL CHECKS BEFORE EXECUTION:

1. DOMAIN EXPERTISE CHECK
   Location: .claude/expertise/{domain}.yaml
   If EXISTS: Load and validate BEFORE Phase 3
   If MISSING: Agent discovers and creates during execution

2. AGENT REGISTRY ENFORCEMENT
   Registry: claude-code-plugins/ruv-sparc-three-loop-system/agents/
   Count: 206 agents in 10 categories
   Categories: delivery, foundry, operations, orchestration,
               platforms, quality, research, security,
               specialists, tooling
   Fallbacks: coder, researcher, tester, reviewer
   NEVER use generic/made-up agent types

3. SOP COMPLIANCE PATTERN
   Skill() -> Define how to accomplish task
       |
       v
   Task() -> Spawn registry agents to execute
       |
       v
   TodoWrite() -> Track progress with 5-10 todos

4. PARALLEL EXECUTION RULE
   WRONG: Spawn agent 1, wait, spawn agent 2
   RIGHT: Single message with ALL Task() calls

STATE TRACKING ACTIVE:
  - All skill invocations logged
  - All agent spawns tracked
  - Violations detected and recorded
  - Compliance checked at each step

DO NOT skip phases. DO NOT use generic agents. DO NOT forget TodoWrite.

================================================================
EOF
fi

# Always exit 0 (never block)
exit 0
