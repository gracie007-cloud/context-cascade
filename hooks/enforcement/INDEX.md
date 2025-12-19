# Enforcement System - Complete File Index

## Overview

Complete hook configuration integrating with the skill enforcement system. All scripts, documentation, and configuration files for enforcing the 5-phase workflow and Skill -> Task -> TodoWrite pattern.

## Documentation Files

### 1. README.md
**Primary documentation**
- Complete system overview
- Architecture explanation
- State file structure
- Hook implementation details
- Installation instructions
- Usage guide
- Integration with recursive improvement
- All file descriptions

### 2. INTEGRATION-DIAGRAM.md
**System architecture and data flow**
- Visual architecture diagram
- Hook execution flow
- Data flow between components
- State tracking mechanism
- External dependencies
- Testing and monitoring

### 3. LIMITATIONS.md
**Critical constraints documentation**
- What hooks CANNOT do
- What hooks CAN do
- Workarounds for limitations
- Enforcement strategy
- Acceptance criteria
- Future improvements

### 4. QUICK-REFERENCE.md
**Fast lookup guide**
- Common commands
- Violation types
- Key files
- Typical workflow
- Compliance metrics
- One-page summary

### 5. CONFIGURATION.json
**Complete hook configuration**
- JSON config for settings.json
- All hook definitions
- State schema
- Validation rules
- Enforcement strategy
- Script paths
- Installation steps

### 6. INDEX.md
**This file**
- Complete file listing
- Purpose of each file
- Organization structure

## Core Scripts

### 7. state-tracker.sh
**Central state management**

Functions:
- `init_state()` - Create new session
- `get_state()` - Read current state
- `log_skill(name)` - Log skill invocation
- `log_agent(type, name, desc)` - Log agent spawn
- `log_violation(type, details)` - Log violation
- `mark_todowrite()` - Mark todos created
- `mark_expertise(domain)` - Mark expertise loaded
- `mark_phase_complete(phase)` - Mark phase done
- `check_compliance()` - Check SOP compliance
- `archive_state()` - Save state at session end

State file: `~/.claude/runtime/enforcement-state.json`

## Hook Scripts

### 8. user-prompt-submit.sh
**Hook: UserPromptSubmit**

Purpose:
- Classify request (trivial vs non-trivial)
- Initialize workflow state
- Display 5-phase workflow reminder
- Check for domain expertise

Runs: Before Claude processes user message

### 9. pre-skill-invoke.sh
**Hook: PreToolUse on Skill**

Purpose:
- Extract skill name (if accessible)
- Log skill invocation to state
- Display SOP pattern reminder
- Remind about Task() requirement

Runs: Before Skill tool executes

### 10. pre-task-spawn.sh
**Hook: PreToolUse on Task**

Purpose:
- Display agent registry reminder
- Show valid agent categories
- Remind about expertise check
- Note: CANNOT validate params (hook limitation)

Runs: Before Task tool executes

### 11. post-skill-compliance.sh
**Hook: PostToolUse on Skill**

Purpose:
- Check if Task() was called after Skill()
- Display compliance checklist
- Run compliance check
- Log violations

Runs: After Skill tool executes

### 12. post-task-spawn.sh
**Hook: PostToolUse on Task**

Purpose:
- Log agent spawn (if params accessible)
- Display TodoWrite reminder
- Check parallel spawn pattern
- Note: Validation is reactive

Runs: After Task tool executes

### 13. post-todowrite.sh
**Hook: PostToolUse on TodoWrite**

Purpose:
- Mark TodoWrite as called
- Confirm SOP pattern complete
- Display success message

Runs: After TodoWrite tool executes

### 14. pattern-retention.sh
**Hook: PreCompact**

Purpose:
- Inject ALL critical patterns
- Ensure rules survive context compaction
- Display: 5-phase, registry, SOP, golden rule, expertise, state tracking, hook limitations, meta-skills

Runs: Before context window compacts

### 15. session-stop.sh
**Hook: Stop**

Purpose:
- Archive state to enforcement/archive/
- Display session summary
- Show pattern reminders for next session

Runs: When session ends

## Validation Scripts

### 16. transcript-parser.sh
**Async parameter validation**

Purpose:
- Parse conversation transcript (history.jsonl)
- Extract Task() calls and parameters
- Validate agent types against registry
- Log violations to state
- Workaround for hook param limitation

Runs: After hooks, periodically, or manually

## Reporting Scripts

### 17. generate-report.sh
**Single session compliance report**

Displays:
- Session information
- Workflow statistics
- Skills invoked
- Agents spawned
- Registry compliance rate
- Violations
- SOP compliance check

### 18. analyze-compliance.sh
**Multi-session compliance analysis**

Analyzes:
- Aggregate statistics across all sessions
- Compliance metrics
- Violation rates
- Average violations per session
- Violation type breakdown
- Overall quality score

### 19. find-violations.sh
**Violation listing**

Lists:
- Current session violations
- Archived session violations
- Total violation count
- Violation details and timestamps

### 20. agent-usage-report.sh
**Agent type distribution analysis**

Shows:
- Agent type usage counts
- Category distribution
- Top 10 most used agents
- Diversity metrics
- Overuse detection

## Testing Scripts

### 21. test-hooks.sh
**Comprehensive hook testing**

Tests:
- State initialization
- Skill logging
- Agent logging (valid and invalid)
- TodoWrite marking
- Compliance checking
- State retrieval
- State archiving
- All hook scripts

Generates test state and validates all components.

## Installation Scripts

### 22. INSTALL.sh
**Installation automation**

Steps:
1. Make scripts executable
2. Create runtime directory
3. Backup existing settings
4. Display merge instructions
5. Run test suite
6. Show next steps

## File Organization

```
.claude/hooks/enforcement/
|
+-- Documentation (6 files)
|   +-- README.md
|   +-- INTEGRATION-DIAGRAM.md
|   +-- LIMITATIONS.md
|   +-- QUICK-REFERENCE.md
|   +-- CONFIGURATION.json
|   +-- INDEX.md (this file)
|
+-- Core Scripts (1 file)
|   +-- state-tracker.sh
|
+-- Hook Scripts (8 files)
|   +-- user-prompt-submit.sh
|   +-- pre-skill-invoke.sh
|   +-- pre-task-spawn.sh
|   +-- post-skill-compliance.sh
|   +-- post-task-spawn.sh
|   +-- post-todowrite.sh
|   +-- pattern-retention.sh
|   +-- session-stop.sh
|
+-- Validation Scripts (1 file)
|   +-- transcript-parser.sh
|
+-- Reporting Scripts (4 files)
|   +-- generate-report.sh
|   +-- analyze-compliance.sh
|   +-- find-violations.sh
|   +-- agent-usage-report.sh
|
+-- Testing Scripts (1 file)
|   +-- test-hooks.sh
|
+-- Installation Scripts (1 file)
    +-- INSTALL.sh
```

**Total: 22 files**

## External Files Created

### Runtime State
```
~/.claude/runtime/
    enforcement-state.json          <- Current session state
    enforcement/
        archive/
            {session-id}.json       <- Archived session states
```

### Configuration
```
~/.claude/settings.json             <- Hooks merged here (manual)
~/.claude/settings.json.backup-*    <- Created by INSTALL.sh
```

### Data Sources
```
~/.claude/history.jsonl             <- Conversation transcript
claude-code-plugins/ruv-sparc-three-loop-system/agents/REGISTRY.json
                                    <- Agent registry (optional)
.claude/expertise/{domain}.yaml     <- Domain expertise (optional)
```

## File Sizes

Approximate sizes:
- Documentation: ~50 KB (6 files)
- Scripts: ~40 KB (16 files)
- Configuration: ~5 KB (1 file)

Total: ~95 KB

## Dependencies

### Required
- bash (for all .sh scripts)
- jq (for JSON manipulation)
- Claude Code hook system

### Optional
- uuidgen (for session IDs, fallback available)
- bc (for percentage calculations in reports)

## Installation

```bash
cd .claude/hooks/enforcement
bash INSTALL.sh
```

Follow instructions to merge CONFIGURATION.json into settings.json.

## Testing

```bash
cd .claude/hooks/enforcement
bash test-hooks.sh
```

## Usage Examples

### Check Compliance
```bash
bash .claude/hooks/enforcement/generate-report.sh
```

### Find Issues
```bash
bash .claude/hooks/enforcement/find-violations.sh
```

### Analyze Trends
```bash
bash .claude/hooks/enforcement/analyze-compliance.sh
```

### Validate Parameters
```bash
bash .claude/hooks/enforcement/transcript-parser.sh
```

## Integration Points

### 1. Claude Code Hooks
All hook scripts called by Claude Code hook system via settings.json

### 2. State Tracker
All hooks call state-tracker.sh functions

### 3. Transcript Parser
PostToolUse hooks can trigger transcript parsing

### 4. Recursive Improvement
Compliance data flows to audit-pipeline:
```
violations -> analyze-compliance.sh -> metrics -> audit-pipeline -> improvements
```

## Documentation Cross-References

- For installation: See README.md "Installation" section
- For architecture: See INTEGRATION-DIAGRAM.md
- For constraints: See LIMITATIONS.md
- For quick lookup: See QUICK-REFERENCE.md
- For configuration: See CONFIGURATION.json

## Version

1.0.0 - Initial release

## Author

RUV-SPARC Three-Loop System

## License

Part of the .claude/ skill ecosystem
