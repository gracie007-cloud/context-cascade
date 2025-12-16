# SPARC Coder Mode

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: agent-creation
  file: .claude/expertise/agent-creation.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: coder-benchmark-v1
  tests:
    - command_execution_success
    - output_validation
  success_threshold: 0.9
namespace: "commands/delivery/sparc/coder/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [sparc-methodology, coder]
  related_agents: [coder, reviewer, tester]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


## Purpose
Autonomous code generation with batch file operations.

## Activation

### Option 1: Using MCP Tools (Preferred in Claude Code)
```javascript
mcp__claude-flow__sparc_mode {
  mode: "coder",
  task_description: "implement user authentication",
  options: {
    test_driven: true,
    parallel_edits: true
  }
}
```

### Option 2: Using NPX CLI (Fallback when MCP not available)
```bash
# Use when running from terminal or MCP tools unavailable
npx claude-flow sparc run coder "implement user authentication"

# For alpha features
npx claude-flow@alpha sparc run coder "implement user authentication"
```

### Option 3: Local Installation
```bash
# If claude-flow is installed locally
./claude-flow sparc run coder "implement user authentication"
```

## Core Capabilities
- Feature implementation
- Code refactoring
- Bug fixes
- API development
- Algorithm implementation

## Batch Operations
- Parallel file creation
- Concurrent code modifications
- Batch import updates
- Test file generation
- Documentation updates

## Code Quality
- ES2022 standards
- Type safety with TypeScript
- Comprehensive error handling
- Performance optimization
- Security best practices
