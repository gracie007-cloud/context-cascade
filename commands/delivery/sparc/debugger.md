# SPARC Debugger Mode

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: agent-creation
  file: .claude/expertise/agent-creation.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: debugger-benchmark-v1
  tests:
    - command_execution_success
    - output_validation
  success_threshold: 0.9
namespace: "commands/delivery/sparc/debugger/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [sparc-methodology, coder]
  related_agents: [coder, reviewer, tester]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


## Purpose
Systematic debugging with TodoWrite and Memory integration.

## Activation

### Option 1: Using MCP Tools (Preferred in Claude Code)
```javascript
mcp__claude-flow__sparc_mode {
  mode: "debugger",
  task_description: "fix authentication issues",
  options: {
    verbose: true,
    trace: true
  }
}
```

### Option 2: Using NPX CLI (Fallback when MCP not available)
```bash
# Use when running from terminal or MCP tools unavailable
npx claude-flow sparc run debugger "fix authentication issues"

# For alpha features
npx claude-flow@alpha sparc run debugger "fix authentication issues"
```

### Option 3: Local Installation
```bash
# If claude-flow is installed locally
./claude-flow sparc run debugger "fix authentication issues"
```

## Core Capabilities
- Issue reproduction
- Root cause analysis
- Stack trace analysis
- Memory leak detection
- Performance bottleneck identification

## Debugging Workflow
1. Create debugging plan with TodoWrite
2. Systematic issue investigation
3. Store findings in Memory
4. Track fix progress
5. Verify resolution

## Tools Integration
- Error log analysis
- Breakpoint simulation
- Variable inspection
- Call stack tracing
- Memory profiling
