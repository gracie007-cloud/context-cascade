# Skill Enforcement System - Hook Integration

## Overview

This directory contains the complete hook configuration for enforcing the 5-phase workflow and skill SOP compliance through Claude Code's hook system.

## Architecture

```
User Request
    |
    v
[UserPromptSubmit] --> Initialize workflow state + Inject 5-phase reminder
    |
    v
Claude Processing
    |
    +---> [PreToolUse on Skill] --> Log skill invocation
    |
    +---> [PreToolUse on Task] --> Validate agent selection (external)
    |
    +---> [PostToolUse on Skill] --> Verify SOP compliance
    |
    +---> [PostToolUse on Task] --> Update state with agent spawn
    |
    v
[PreCompact] --> Inject pattern retention rules
    |
    v
[Stop] --> Save session learnings
```

## State Tracking

### State File Structure

```json
{
  "session_id": "uuid",
  "workflow_state": {
    "phase": "intent-analysis|prompt-optimization|planning|routing|execution",
    "started_at": "ISO8601",
    "completed_phases": ["phase1", "phase2"],
    "current_task": "string"
  },
  "skill_invocations": [
    {
      "skill_name": "intent-analyzer",
      "invoked_at": "ISO8601",
      "params": {},
      "sop_followed": false,
      "agents_spawned": []
    }
  ],
  "agent_spawns": [
    {
      "agent_type": "coder",
      "agent_name": "Code Implementation Agent",
      "task_description": "...",
      "spawned_at": "ISO8601",
      "is_registry_agent": true,
      "category": "delivery"
    }
  ],
  "violations": [
    {
      "type": "generic_agent|skipped_phase|missing_todowrite",
      "detected_at": "ISO8601",
      "details": "string"
    }
  ],
  "todos_created": false,
  "expertise_loaded": []
}
```

State file location: `C:/Users/17175/.claude/runtime/enforcement-state.json`

## Hook Implementation

### 1. UserPromptSubmit Hook

**Purpose**: Initialize workflow state and inject 5-phase reminder for non-trivial requests

**Script**: `user-prompt-submit.sh`

**Behavior**:
- Classifies request as trivial/non-trivial
- Creates new session state if non-trivial
- Injects 5-phase workflow reminder
- Checks for domain expertise files

**Limitations**:
- Cannot predict if Claude will follow the reminder
- Cannot block request (only display messages)

### 2. PreToolUse on Skill Hook

**Purpose**: Log skill invocation and prepare for SOP validation

**Script**: `pre-skill-invoke.sh`

**Behavior**:
- Extracts skill name from tool params
- Logs to state tracker
- Displays reminder about Skill -> Task -> TodoWrite pattern
- Marks workflow phase based on skill invoked

**Limitations**:
- Cannot inspect skill parameters (hook limitation)
- Cannot validate skill arguments
- Cannot prevent skill invocation

### 3. PreToolUse on Task Hook

**Purpose**: Validate agent selection (external mechanism required)

**Script**: `pre-task-spawn.sh`

**Behavior**:
- Displays registry reminder
- Shows valid agent categories
- Suggests expertise check
- **CANNOT** inspect Task parameters to validate agent type

**Critical Limitation**:
This hook CANNOT see Task() parameters due to Claude Code hook constraints. Validation must happen through:
1. Display reminders (passive)
2. PostToolUse validation (reactive, after spawn)
3. External transcript parsing (async)

### 4. PostToolUse on Skill Hook

**Purpose**: Verify SOP compliance after skill invocation

**Script**: `post-skill-compliance.sh`

**Behavior**:
- Checks if Task() was called after Skill()
- Checks if TodoWrite() was called
- Displays compliance checklist
- Logs violations to state

**Limitations**:
- Cannot force compliance (only remind)
- Detection is reactive (after the fact)
- Cannot access conversation transcript directly

### 5. PostToolUse on Task Hook

**Purpose**: Track agent spawns and validate registry compliance

**Script**: `post-task-spawn.sh`

**Behavior**:
- Logs agent spawn to state
- Displays TodoWrite reminder
- Checks parallel spawn pattern

**Limitations**:
- Cannot validate agent type against registry (no param access)
- Cannot prevent invalid spawns
- Validation is external/manual

### 6. PreCompact Hook

**Purpose**: Inject pattern retention for enforcement rules

**Script**: `pattern-retention.sh` (existing)

**Behavior**:
- Injects critical patterns before context loss
- Includes 5-phase workflow
- Agent registry enforcement
- Skill -> Task -> TodoWrite pattern
- Expertise system usage

**No Limitations**: This is a display-only hook, works as intended

### 7. Stop Hook

**Purpose**: Save session learnings and state

**Script**: `session-stop.sh`

**Behavior**:
- Displays session summary
- Archives state file
- Shows pattern reminders for next session

## Complete Configuration

### settings.json hooks section

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/enforcement/user-prompt-submit.sh"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Skill",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/enforcement/pre-skill-invoke.sh"
          }
        ]
      },
      {
        "matcher": "Task",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/enforcement/pre-task-spawn.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Skill",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/enforcement/post-skill-compliance.sh"
          }
        ]
      },
      {
        "matcher": "Task",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/enforcement/post-task-spawn.sh"
          }
        ]
      },
      {
        "matcher": "TodoWrite",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/enforcement/post-todowrite.sh"
          }
        ]
      }
    ],
    "PreCompact": [
      {
        "matcher": "manual|auto",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/enforcement/pattern-retention.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/enforcement/session-stop.sh"
          }
        ]
      }
    ]
  }
}
```

## State Tracker Implementation

### state-tracker.sh

Core state management script called by all hooks.

**Functions**:
- `init_state()` - Create new session state
- `log_skill(skill_name)` - Log skill invocation
- `log_agent(agent_type, agent_name, task_desc)` - Log agent spawn
- `log_violation(type, details)` - Log compliance violation
- `mark_todowrite()` - Mark todos created
- `check_compliance()` - Check current SOP compliance
- `get_state()` - Read current state
- `archive_state()` - Save state at session end

### transcript-parser.sh

External validation through transcript parsing (async).

**Purpose**: Since hooks cannot inspect Task() parameters, this script:
1. Parses conversation transcript
2. Extracts Task() calls and parameters
3. Validates agent types against registry
4. Updates state with validation results

**Run**: Triggered by PostToolUse hooks or manually

## Data Flow Diagram

```
+------------------+
|  User Request    |
+--------+---------+
         |
         v
+------------------+       +-------------------+
| UserPromptSubmit | ----> | state-tracker.sh  |
| (Initialize)     |       | init_state()      |
+--------+---------+       +-------------------+
         |
         v
+------------------+
|   Skill Invoke   |
+--------+---------+
         |
         v
+------------------+       +-------------------+
| PreToolUse       | ----> | state-tracker.sh  |
| (Log Skill)      |       | log_skill()       |
+--------+---------+       +-------------------+
         |
         v
+------------------+       +-------------------+
| PostToolUse      | ----> | state-tracker.sh  |
| (Check SOP)      |       | check_compliance()|
+--------+---------+       +-------------------+
         |                          |
         v                          v
+------------------+       +-------------------+
|   Task Spawn     |       | transcript-parser |
+--------+---------+       | (Async Validate)  |
         |                 +-------------------+
         v                          |
+------------------+                |
| PostToolUse      | <--------------+
| (Log Agent)      |
+--------+---------+
         |
         v
+------------------+       +-------------------+
| TodoWrite        | ----> | state-tracker.sh  |
| (Mark Complete)  |       | mark_todowrite()  |
+------------------+       +-------------------+
```

## Critical Limitations

### What CANNOT Be Enforced

Due to Claude Code hook constraints, the following CANNOT be enforced:

1. **Task Parameter Validation**: Hooks cannot inspect Task() parameters
   - Cannot validate agent type against registry
   - Cannot validate agent name format
   - Cannot validate task description quality
   - **Workaround**: Reactive validation via transcript parsing

2. **Skill Parameter Validation**: Hooks cannot inspect Skill() parameters
   - Cannot validate skill exists
   - Cannot validate skill parameters
   - **Workaround**: Display reminders, reactive detection

3. **Forcing Behavior**: Hooks can only display messages and block (exit 2)
   - Cannot force Claude to call Task()
   - Cannot force Claude to call TodoWrite()
   - Cannot inject tool calls
   - **Workaround**: Strong reminders, compliance checking, violation logging

4. **Real-time Modification**: Hooks cannot modify inputs/outputs
   - Cannot fix invalid agent types
   - Cannot auto-correct skill parameters
   - Cannot inject missing TodoWrite calls
   - **Workaround**: Detection + manual correction prompts

5. **Transcript Access**: Hooks run in isolation
   - Cannot read full conversation history
   - Cannot correlate multiple tool calls
   - Cannot see Claude's reasoning
   - **Workaround**: External transcript parsing, state accumulation

### What CAN Be Enforced

1. **Display Strong Reminders**: Inject enforcement rules at critical points
2. **Passive Validation**: Check compliance after actions
3. **State Tracking**: Log all skill/task invocations
4. **Violation Detection**: Identify and log non-compliance
5. **Pattern Retention**: Ensure rules survive context compaction
6. **Session Memory**: Track compliance across conversation

## Enforcement Strategy

Given the limitations, the enforcement strategy is:

### Layer 1: Preventive (Reminders)
- UserPromptSubmit: Inject 5-phase workflow
- PreToolUse: Show registry/SOP requirements
- PreCompact: Inject pattern retention

### Layer 2: Detective (Validation)
- PostToolUse: Check compliance
- transcript-parser: Validate parameters
- state-tracker: Log violations

### Layer 3: Corrective (Feedback)
- Display compliance checklists
- Show violation summaries
- Suggest corrections

### Layer 4: Learning (Long-term)
- Archive violations
- Generate compliance reports
- Feed into recursive improvement

## Installation

1. Copy all scripts to `.claude/hooks/enforcement/`
2. Update `.claude/settings.json` with hook configuration
3. Ensure scripts are executable: `chmod +x .claude/hooks/enforcement/*.sh`
4. Initialize state directory: `mkdir -p .claude/runtime/enforcement`
5. Test with: `bash .claude/hooks/enforcement/test-hooks.sh`

## Usage

Hooks run automatically. Manual state inspection:

```bash
# Check current state
bash .claude/hooks/enforcement/state-tracker.sh get_state

# Check compliance
bash .claude/hooks/enforcement/state-tracker.sh check_compliance

# Parse transcript for validation
bash .claude/hooks/enforcement/transcript-parser.sh

# Generate compliance report
bash .claude/hooks/enforcement/generate-report.sh
```

## Testing

See `test-hooks.sh` for comprehensive hook testing.

## Monitoring

State files are archived to `.claude/runtime/enforcement/archive/` on session end.

Analysis scripts:
- `analyze-compliance.sh` - Generate compliance metrics
- `find-violations.sh` - List all violations
- `agent-usage-report.sh` - Show agent type distribution

## Integration with Recursive Improvement

Compliance data feeds into the recursive improvement system:

1. Violations logged to state
2. State archived on session end
3. `analyze-compliance.sh` generates metrics
4. Metrics fed to audit-pipeline
5. Audit results trigger skill improvements
6. Improvements gated by frozen eval harness

## Future Enhancements

When Claude Code adds hook capabilities:

1. **Parameter Inspection**: Validate Task/Skill params in PreToolUse
2. **Transcript Access**: Read conversation history in hooks
3. **Input Modification**: Auto-correct invalid agent types
4. **Blocking with Correction**: Block + suggest fix
5. **Tool Injection**: Auto-inject TodoWrite if missing

## Files in This Directory

- `README.md` - This file
- `user-prompt-submit.sh` - Initialize workflow state
- `pre-skill-invoke.sh` - Log skill invocation
- `pre-task-spawn.sh` - Show agent validation reminder
- `post-skill-compliance.sh` - Verify SOP compliance
- `post-task-spawn.sh` - Track agent spawns
- `post-todowrite.sh` - Mark todos created
- `pattern-retention.sh` - Inject pattern retention (PreCompact)
- `session-stop.sh` - Save session state
- `state-tracker.sh` - Core state management
- `transcript-parser.sh` - Async parameter validation
- `test-hooks.sh` - Hook testing suite
- `generate-report.sh` - Compliance reporting
- `analyze-compliance.sh` - Metrics analysis
- `find-violations.sh` - Violation listing
- `agent-usage-report.sh` - Agent distribution analysis

## Support

For issues or questions:
1. Check `test-hooks.sh` output
2. Inspect state file: `.claude/runtime/enforcement-state.json`
3. Review violation logs
4. Check hook execution in Claude Code logs

## License

Part of the RUV-SPARC Three-Loop System
