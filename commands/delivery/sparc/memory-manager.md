# SPARC Memory Manager Mode

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: agent-creation
  file: .claude/expertise/agent-creation.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: memory-manager-benchmark-v1
  tests:
    - command_execution_success
    - output_validation
  success_threshold: 0.9
namespace: "commands/delivery/sparc/memory-manager/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [sparc-methodology, coder]
  related_agents: [coder, reviewer, tester]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


## Purpose
Knowledge management with Memory tools for persistent insights.

## Activation

### Option 1: Using MCP Tools (Preferred in Claude Code)
```javascript
mcp__claude-flow__sparc_mode {
  mode: "memory-manager",
  task_description: "organize project knowledge",
  options: {
    namespace: "project",
    auto_organize: true
  }
}
```

### Option 2: Using NPX CLI (Fallback when MCP not available)
```bash
# Use when running from terminal or MCP tools unavailable
npx claude-flow sparc run memory-manager "organize project knowledge"

# For alpha features
npx claude-flow@alpha sparc run memory-manager "organize project knowledge"
```

### Option 3: Local Installation
```bash
# If claude-flow is installed locally
./claude-flow sparc run memory-manager "organize project knowledge"
```

## Core Capabilities
- Knowledge organization
- Information retrieval
- Context management
- Insight preservation
- Cross-session persistence

## Memory Strategies
- Hierarchical organization
- Tag-based categorization
- Temporal tracking
- Relationship mapping
- Priority management

## Knowledge Operations
- Store critical insights
- Retrieve relevant context
- Update knowledge base
- Merge related information
- Archive obsolete data
