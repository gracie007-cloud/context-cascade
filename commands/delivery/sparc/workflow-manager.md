# SPARC Workflow Manager Mode

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: agent-creation
  file: .claude/expertise/agent-creation.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: workflow-manager-benchmark-v1
  tests:
    - command_execution_success
    - output_validation
  success_threshold: 0.9
namespace: "commands/delivery/sparc/workflow-manager/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [sparc-methodology, coder]
  related_agents: [coder, reviewer, tester]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


## Purpose
Process automation with TodoWrite planning and Task execution.

## Activation

### Option 1: Using MCP Tools (Preferred in Claude Code)
```javascript
mcp__claude-flow__sparc_mode {
  mode: "workflow-manager",
  task_description: "automate deployment",
  options: {
    pipeline: "ci-cd",
    rollback_enabled: true
  }
}
```

### Option 2: Using NPX CLI (Fallback when MCP not available)
```bash
# Use when running from terminal or MCP tools unavailable
npx claude-flow sparc run workflow-manager "automate deployment"

# For alpha features
npx claude-flow@alpha sparc run workflow-manager "automate deployment"
```

### Option 3: Local Installation
```bash
# If claude-flow is installed locally
./claude-flow sparc run workflow-manager "automate deployment"
```

## Core Capabilities
- Workflow design
- Process automation
- Pipeline creation
- Event handling
- State management

## Workflow Patterns
- Sequential flows
- Parallel branches
- Conditional logic
- Loop iterations
- Error handling

## Automation Features
- Trigger management
- Task scheduling
- Progress tracking
- Result validation
- Rollback capability
