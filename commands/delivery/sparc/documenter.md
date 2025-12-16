# SPARC Documenter Mode

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: agent-creation
  file: .claude/expertise/agent-creation.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: documenter-benchmark-v1
  tests:
    - command_execution_success
    - output_validation
  success_threshold: 0.9
namespace: "commands/delivery/sparc/documenter/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [sparc-methodology, coder]
  related_agents: [coder, reviewer, tester]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


## Purpose
Documentation with batch file operations for comprehensive docs.

## Activation

### Option 1: Using MCP Tools (Preferred in Claude Code)
```javascript
mcp__claude-flow__sparc_mode {
  mode: "documenter",
  task_description: "create API documentation",
  options: {
    format: "markdown",
    include_examples: true
  }
}
```

### Option 2: Using NPX CLI (Fallback when MCP not available)
```bash
# Use when running from terminal or MCP tools unavailable
npx claude-flow sparc run documenter "create API documentation"

# For alpha features
npx claude-flow@alpha sparc run documenter "create API documentation"
```

### Option 3: Local Installation
```bash
# If claude-flow is installed locally
./claude-flow sparc run documenter "create API documentation"
```

## Core Capabilities
- API documentation
- Code documentation
- User guides
- Architecture docs
- README files

## Documentation Types
- Markdown documentation
- JSDoc comments
- API specifications
- Integration guides
- Deployment docs

## Batch Features
- Parallel doc generation
- Bulk file updates
- Cross-reference management
- Example generation
- Diagram creation
