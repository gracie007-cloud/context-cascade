# SPARC Optimizer Mode

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: agent-creation
  file: .claude/expertise/agent-creation.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: optimizer-benchmark-v1
  tests:
    - command_execution_success
    - output_validation
  success_threshold: 0.9
namespace: "commands/delivery/sparc/optimizer/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [sparc-methodology, coder]
  related_agents: [coder, reviewer, tester]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


## Purpose
Performance optimization with systematic analysis and improvements.

## Activation

### Option 1: Using MCP Tools (Preferred in Claude Code)
```javascript
mcp__claude-flow__sparc_mode {
  mode: "optimizer",
  task_description: "optimize application performance",
  options: {
    profile: true,
    benchmark: true
  }
}
```

### Option 2: Using NPX CLI (Fallback when MCP not available)
```bash
# Use when running from terminal or MCP tools unavailable
npx claude-flow sparc run optimizer "optimize application performance"

# For alpha features
npx claude-flow@alpha sparc run optimizer "optimize application performance"
```

### Option 3: Local Installation
```bash
# If claude-flow is installed locally
./claude-flow sparc run optimizer "optimize application performance"
```

## Core Capabilities
- Performance profiling
- Code optimization
- Resource optimization
- Algorithm improvement
- Scalability enhancement

## Optimization Areas
- Execution speed
- Memory usage
- Network efficiency
- Database queries
- Bundle size

## Systematic Approach
1. Baseline measurement
2. Bottleneck identification
3. Optimization implementation
4. Impact verification
5. Continuous monitoring
