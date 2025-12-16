# SPARC Swarm Coordinator Mode

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: agent-creation
  file: .claude/expertise/agent-creation.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: swarm-coordinator-benchmark-v1
  tests:
    - command_execution_success
    - output_validation
  success_threshold: 0.9
namespace: "commands/delivery/sparc/swarm-coordinator/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [sparc-methodology, coder]
  related_agents: [coder, reviewer, tester]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


## Purpose
Specialized swarm management with batch coordination capabilities.

## Activation

### Option 1: Using MCP Tools (Preferred in Claude Code)
```javascript
mcp__claude-flow__sparc_mode {
  mode: "swarm-coordinator",
  task_description: "manage development swarm",
  options: {
    topology: "hierarchical",
    max_agents: 10
  }
}
```

### Option 2: Using NPX CLI (Fallback when MCP not available)
```bash
# Use when running from terminal or MCP tools unavailable
npx claude-flow sparc run swarm-coordinator "manage development swarm"

# For alpha features
npx claude-flow@alpha sparc run swarm-coordinator "manage development swarm"
```

### Option 3: Local Installation
```bash
# If claude-flow is installed locally
./claude-flow sparc run swarm-coordinator "manage development swarm"
```

## Core Capabilities
- Swarm initialization
- Agent management
- Task distribution
- Load balancing
- Result collection

## Coordination Modes
- Hierarchical swarms
- Mesh networks
- Pipeline coordination
- Adaptive strategies
- Hybrid approaches

## Management Features
- Dynamic scaling
- Resource optimization
- Failure recovery
- Performance monitoring
- Quality assurance
