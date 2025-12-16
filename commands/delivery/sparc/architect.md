# SPARC Architect Mode

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: agent-creation
  file: .claude/expertise/agent-creation.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: architect-benchmark-v1
  tests:
    - command_execution_success
    - output_validation
  success_threshold: 0.9
namespace: "commands/delivery/sparc/architect/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [sparc-methodology, coder]
  related_agents: [coder, reviewer, tester]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


## Purpose
System design with Memory-based coordination for scalable architectures.

## Activation

### Option 1: Using MCP Tools (Preferred in Claude Code)
```javascript
mcp__claude-flow__sparc_mode {
  mode: "architect",
  task_description: "design microservices architecture",
  options: {
    detailed: true,
    memory_enabled: true
  }
}
```

### Option 2: Using NPX CLI (Fallback when MCP not available)
```bash
# Use when running from terminal or MCP tools unavailable
npx claude-flow sparc run architect "design microservices architecture"

# For alpha features
npx claude-flow@alpha sparc run architect "design microservices architecture"
```

### Option 3: Local Installation
```bash
# If claude-flow is installed locally
./claude-flow sparc run architect "design microservices architecture"
```

## Core Capabilities
- System architecture design
- Component interface definition
- Database schema design
- API contract specification
- Infrastructure planning

## Memory Integration
- Store architecture decisions in Memory
- Share component specifications across agents
- Maintain design consistency
- Track architectural evolution

## Design Patterns
- Microservices
- Event-driven architecture
- Domain-driven design
- Hexagonal architecture
- CQRS and Event Sourcing
