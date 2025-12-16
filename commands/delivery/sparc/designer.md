# SPARC Designer Mode

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: agent-creation
  file: .claude/expertise/agent-creation.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: designer-benchmark-v1
  tests:
    - command_execution_success
    - output_validation
  success_threshold: 0.9
namespace: "commands/delivery/sparc/designer/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [sparc-methodology, coder]
  related_agents: [coder, reviewer, tester]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


## Purpose
UI/UX design with Memory coordination for consistent experiences.

## Activation

### Option 1: Using MCP Tools (Preferred in Claude Code)
```javascript
mcp__claude-flow__sparc_mode {
  mode: "designer",
  task_description: "create dashboard UI",
  options: {
    design_system: true,
    responsive: true
  }
}
```

### Option 2: Using NPX CLI (Fallback when MCP not available)
```bash
# Use when running from terminal or MCP tools unavailable
npx claude-flow sparc run designer "create dashboard UI"

# For alpha features
npx claude-flow@alpha sparc run designer "create dashboard UI"
```

### Option 3: Local Installation
```bash
# If claude-flow is installed locally
./claude-flow sparc run designer "create dashboard UI"
```

## Core Capabilities
- Interface design
- Component architecture
- Design system creation
- Accessibility planning
- Responsive layouts

## Design Process
- User research insights
- Wireframe creation
- Component design
- Interaction patterns
- Design token management

## Memory Coordination
- Store design decisions
- Share component specs
- Maintain consistency
- Track design evolution
