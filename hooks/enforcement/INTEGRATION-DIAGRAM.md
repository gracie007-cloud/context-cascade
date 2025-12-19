# Enforcement System Integration Diagram

## System Architecture

```
+------------------------------------------------------------------+
|                        USER REQUEST                              |
+------------------------------------------------------------------+
                            |
                            v
+------------------------------------------------------------------+
|            UserPromptSubmit Hook (PREVENTIVE LAYER)              |
|  - user-prompt-submit.sh                                         |
|  - Classify trivial vs non-trivial                               |
|  - Initialize state (state-tracker.sh init_state)                |
|  - Display 5-phase workflow reminder                             |
|  - Display expertise check reminder                              |
+------------------------------------------------------------------+
                            |
                            v
+------------------------------------------------------------------+
|                   CLAUDE PROCESSES REQUEST                       |
|              (5-Phase Workflow Expected)                          |
+------------------------------------------------------------------+
                            |
        +-------------------+-------------------+
        |                   |                   |
        v                   v                   v
+----------------+  +----------------+  +----------------+
|  SKILL TOOL    |  |  TASK TOOL     |  | TODOWRITE TOOL |
+----------------+  +----------------+  +----------------+
        |                   |                   |
        v                   v                   v
+----------------+  +----------------+  +----------------+
| PreToolUse     |  | PreToolUse     |  | N/A            |
| (PREVENTIVE)   |  | (PREVENTIVE)   |  |                |
+----------------+  +----------------+  +----------------+
| pre-skill-     |  | pre-task-      |  |                |
| invoke.sh      |  | spawn.sh       |  |                |
|                |  |                |  |                |
| - Log skill    |  | - Display      |  |                |
|   invocation   |  |   registry     |  |                |
| - Display SOP  |  |   reminder     |  |                |
|   pattern      |  | - Cannot       |  |                |
|   reminder     |  |   validate     |  |                |
|                |  |   params!      |  |                |
+----------------+  +----------------+  +----------------+
        |                   |                   |
        v                   v                   v
+----------------+  +----------------+  +----------------+
|  TOOL          |  |  TOOL          |  |  TOOL          |
|  EXECUTES      |  |  EXECUTES      |  |  EXECUTES      |
+----------------+  +----------------+  +----------------+
        |                   |                   |
        v                   v                   v
+----------------+  +----------------+  +----------------+
| PostToolUse    |  | PostToolUse    |  | PostToolUse    |
| (DETECTIVE)    |  | (DETECTIVE)    |  | (DETECTIVE)    |
+----------------+  +----------------+  +----------------+
| post-skill-    |  | post-task-     |  | post-todo-     |
| compliance.sh  |  | spawn.sh       |  | write.sh       |
|                |  |                |  |                |
| - Check SOP    |  | - Log agent    |  | - Mark todos   |
|   compliance   |  |   spawn        |  |   created      |
| - Verify Task  |  | - Remind about |  | - SOP pattern  |
|   was called   |  |   TodoWrite    |  |   complete     |
| - Display      |  | - Cannot see   |  |                |
|   checklist    |  |   params!      |  |                |
+----------------+  +----------------+  +----------------+
        |                   |                   |
        +-------------------+-------------------+
                            |
                            v
+------------------------------------------------------------------+
|               STATE TRACKER (CENTRAL COORDINATION)               |
|  - state-tracker.sh                                              |
|  - Maintains enforcement-state.json                              |
|  - Logs: skills, agents, violations, todos                       |
|  - Functions: init_state, log_skill, log_agent,                  |
|               mark_todowrite, check_compliance, archive_state    |
+------------------------------------------------------------------+
                            |
                            v
+------------------------------------------------------------------+
|          TRANSCRIPT PARSER (ASYNC VALIDATION LAYER)              |
|  - transcript-parser.sh                                          |
|  - Parses history.jsonl for Task() calls                         |
|  - Extracts agent types (workaround for hook limitation)         |
|  - Validates against registry                                    |
|  - Logs violations to state                                      |
|  - Runs: After hooks, periodically, or manually                  |
+------------------------------------------------------------------+
                            |
                            v
+------------------------------------------------------------------+
|                   CONTEXT COMPACTION EVENT                       |
+------------------------------------------------------------------+
                            |
                            v
+------------------------------------------------------------------+
|             PreCompact Hook (RETENTION LAYER)                    |
|  - pattern-retention.sh                                          |
|  - Injects ALL critical patterns                                 |
|  - Ensures rules survive context loss                            |
|  - Displays: 5-phase, registry, SOP, golden rule, expertise,     |
|              state tracking, hook limitations, meta-skills       |
+------------------------------------------------------------------+
                            |
                            v
+------------------------------------------------------------------+
|                   SESSION CONTINUES...                           |
+------------------------------------------------------------------+
                            |
                            v
+------------------------------------------------------------------+
|                     SESSION END EVENT                            |
+------------------------------------------------------------------+
                            |
                            v
+------------------------------------------------------------------+
|                Stop Hook (ARCHIVAL LAYER)                        |
|  - session-stop.sh                                               |
|  - Archives state to enforcement/archive/                        |
|  - Displays session summary                                      |
|  - Shows pattern reminders for next session                      |
+------------------------------------------------------------------+
                            |
                            v
+------------------------------------------------------------------+
|                   ANALYSIS & REPORTING                           |
+------------------------------------------------------------------+
        |                   |                   |
        v                   v                   v
+----------------+  +----------------+  +----------------+
| generate-      |  | analyze-       |  | find-          |
| report.sh      |  | compliance.sh  |  | violations.sh  |
|                |  |                |  |                |
| Single session |  | Multi-session  |  | All violations |
| report         |  | aggregation    |  | across sessions|
+----------------+  +----------------+  +----------------+
                            |
                            v
+------------------------------------------------------------------+
|            RECURSIVE IMPROVEMENT INTEGRATION                     |
|  - Compliance data feeds into audit-pipeline                     |
|  - Violations trigger skill improvements                         |
|  - Improvements gated by frozen eval harness                     |
+------------------------------------------------------------------+
```

## Data Flow

```
State File: enforcement-state.json
{
  session_id: "uuid",
  workflow_state: {
    phase: "idle|intent-analysis|prompt-optimization|planning|routing|execution",
    completed_phases: ["phase1", "phase2"],
    current_task: "string"
  },
  skill_invocations: [
    {skill_name, invoked_at, sop_followed, agents_spawned}
  ],
  agent_spawns: [
    {agent_type, agent_name, task_description, is_registry_agent, category}
  ],
  violations: [
    {type: "generic_agent|missing_agents|missing_todowrite", details, detected_at}
  ],
  todos_created: boolean,
  expertise_loaded: ["domain1", "domain2"]
}
```

## Hook Execution Flow

### 1. Preventive Layer (Before Execution)
- **UserPromptSubmit**: Sets expectations, initializes tracking
- **PreToolUse**: Displays reminders, logs intent
- **Goal**: Prevent violations through awareness

### 2. Detective Layer (After Execution)
- **PostToolUse**: Checks compliance, logs violations
- **transcript-parser**: Validates parameters (async)
- **Goal**: Detect violations that occurred

### 3. Corrective Layer (Feedback)
- **Display checklists**: Show what's missing
- **Log violations**: Track non-compliance
- **Goal**: Guide toward compliance

### 4. Retention Layer (Survival)
- **PreCompact**: Inject patterns before context loss
- **Stop**: Summarize and archive
- **Goal**: Ensure patterns survive

## Critical Limitations

### What Hooks CANNOT Do

1. **Parameter Inspection in PreToolUse**
   - Cannot see Task() parameters
   - Cannot see Skill() parameters
   - Workaround: transcript-parser.sh (async)

2. **Force Behavior**
   - Cannot inject tool calls
   - Cannot modify inputs/outputs
   - Workaround: Strong reminders, compliance checking

3. **Access Conversation Transcript**
   - Hooks run in isolation
   - Cannot correlate multiple tool calls in real-time
   - Workaround: External transcript parsing, state accumulation

4. **Blocking with Validation**
   - Can block (exit 2) but cannot validate first
   - Cannot provide "fix this or I'll block"
   - Workaround: Reactive validation, passive reminders

### What Hooks CAN Do

1. Display messages (all hooks)
2. Log to state file (via state-tracker)
3. Run external scripts
4. Block execution (exit 2, but rarely used)
5. Read previous state
6. Archive data

## Integration Points

### 1. State Tracker Integration
All hooks call state-tracker.sh functions:
- init_state()
- log_skill(name)
- log_agent(type, name, desc)
- mark_todowrite()
- check_compliance()
- archive_state()

### 2. Transcript Parser Integration
Runs async to validate parameters:
- Triggered by PostToolUse hooks
- Can run periodically
- Can run manually

### 3. Recursive Improvement Integration
Compliance data flows into improvement system:
```
Violations -> analyze-compliance.sh
            -> Compliance metrics
            -> audit-pipeline
            -> Skill improvements
            -> Gated by eval harness
```

## Usage Patterns

### Normal Workflow
1. User submits non-trivial request
2. UserPromptSubmit initializes state
3. Claude invokes Skill("intent-analyzer")
4. PreToolUse logs skill, displays reminder
5. Skill executes
6. PostToolUse checks compliance, displays checklist
7. Claude invokes Task("coder", "...", "coder")
8. PreToolUse displays registry reminder
9. Task executes (agent spawned)
10. PostToolUse logs agent, reminds about TodoWrite
11. Claude invokes TodoWrite({todos: [...]})
12. PostToolUse marks todos created
13. check_compliance() runs -> PASS

### Violation Detection
1. Claude invokes Skill("planner")
2. PostToolUse displays checklist
3. Claude skips Task() and goes directly to Write
4. check_compliance() detects missing agents
5. Violation logged: "missing_agents"
6. transcript-parser validates (finds no Task calls)
7. Compliance report shows violation

### Context Compaction
1. Context window fills
2. PreCompact hook triggered
3. pattern-retention.sh injects all patterns
4. Context compacts
5. Claude retains enforcement rules

### Session End
1. User ends session
2. Stop hook triggered
3. session-stop.sh archives state
4. Summary displayed
5. Next session starts fresh with patterns

## File Dependencies

```
enforcement/
  README.md                       <- You are here
  INTEGRATION-DIAGRAM.md          <- This file
  CONFIGURATION.json              <- Settings config
  state-tracker.sh                <- Core state management
  user-prompt-submit.sh           <- UserPromptSubmit hook
  pre-skill-invoke.sh             <- PreToolUse Skill hook
  pre-task-spawn.sh               <- PreToolUse Task hook
  post-skill-compliance.sh        <- PostToolUse Skill hook
  post-task-spawn.sh              <- PostToolUse Task hook
  post-todowrite.sh               <- PostToolUse TodoWrite hook
  pattern-retention.sh            <- PreCompact hook
  session-stop.sh                 <- Stop hook
  transcript-parser.sh            <- Async validation
  test-hooks.sh                   <- Testing suite
  generate-report.sh              <- Single session report
  analyze-compliance.sh           <- Multi-session analysis
  find-violations.sh              <- Violation listing
  agent-usage-report.sh           <- Agent usage patterns
```

## External Dependencies

```
Runtime:
  .claude/runtime/enforcement-state.json       <- Current state
  .claude/runtime/enforcement/archive/*.json   <- Archived states
  .claude/history.jsonl                        <- Conversation transcript

Data Sources:
  claude-code-plugins/ruv-sparc-three-loop-system/agents/REGISTRY.json
    <- Agent registry (if available)

Integration:
  .claude/expertise/{domain}.yaml  <- Domain expertise
  .claude/skills/*                 <- Skill definitions
```

## Testing

Run test suite:
```bash
bash .claude/hooks/enforcement/test-hooks.sh
```

Generates test state and validates all hooks.

## Monitoring

Check current compliance:
```bash
bash .claude/hooks/enforcement/generate-report.sh
```

Analyze historical compliance:
```bash
bash .claude/hooks/enforcement/analyze-compliance.sh
```

Find all violations:
```bash
bash .claude/hooks/enforcement/find-violations.sh
```

Analyze agent usage:
```bash
bash .claude/hooks/enforcement/agent-usage-report.sh
```
