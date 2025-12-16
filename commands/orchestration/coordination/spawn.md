# Create Cognitive Patterns

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: orchestration
  file: .claude/expertise/orchestration.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: spawn-benchmark-v1
  tests:
    - swarm_coordination_success
    - consensus_validation
  success_threshold: 0.9
namespace: "commands/orchestration/coordination/spawn/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [hive-mind-advanced, cascade-orchestrator]
  related_agents: [queen-coordinator, swarm-memory-manager]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
  coordination_efficiency: ">90%"
<!-- END META-LOOP -->


## 🎯 Key Principle
**This tool coordinates Claude Code's actions. It does NOT write code or create content.**

## MCP Tool Usage in Claude Code

**Tool:** `mcp__claude-flow__agent_spawn`

## Parameters
```json
{"type": "researcher", "name": "Literature Analysis", "capabilities": ["deep-analysis"]}
```

## Description
Define cognitive patterns that represent different approaches Claude Code can take

## Details
Agent types represent thinking patterns, not actual coders:
- **researcher**: Systematic exploration approach
- **coder**: Implementation-focused thinking
- **analyst**: Data-driven decision making
- **architect**: Big-picture system design
- **reviewer**: Quality and consistency checking

These patterns guide how Claude Code approaches different aspects of your task.

## Example Usage

**In Claude Code:**
1. Use the tool: `mcp__claude-flow__agent_spawn`
2. With parameters: `{"type": "researcher", "name": "Literature Analysis", "capabilities": ["deep-analysis"]}`
3. Claude Code then executes the coordinated plan using its native tools

## Important Reminders
- ✅ This tool provides coordination and structure
- ✅ Claude Code performs all actual implementation
- ❌ The tool does NOT write code
- ❌ The tool does NOT access files directly
- ❌ The tool does NOT execute commands

## See Also
- Main documentation: /claude.md
- Other commands in this category
- Workflow examples in /workflows/
