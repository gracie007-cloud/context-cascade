# SPARC Tester Mode

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: agent-creation
  file: .claude/expertise/agent-creation.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: tester-benchmark-v1
  tests:
    - command_execution_success
    - output_validation
  success_threshold: 0.9
namespace: "commands/delivery/sparc/tester/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [sparc-methodology, coder]
  related_agents: [coder, reviewer, tester]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


## Purpose
Comprehensive testing with parallel execution capabilities.

## Activation

### Option 1: Using MCP Tools (Preferred in Claude Code)
```javascript
mcp__claude-flow__sparc_mode {
  mode: "tester",
  task_description: "full regression suite",
  options: {
    parallel: true,
    coverage: true
  }
}
```

### Option 2: Using NPX CLI (Fallback when MCP not available)
```bash
# Use when running from terminal or MCP tools unavailable
npx claude-flow sparc run tester "full regression suite"

# For alpha features
npx claude-flow@alpha sparc run tester "full regression suite"
```

### Option 3: Local Installation
```bash
# If claude-flow is installed locally
./claude-flow sparc run tester "full regression suite"
```

## Core Capabilities
- Test planning
- Test execution
- Bug detection
- Coverage analysis
- Report generation

## Test Types
- Unit tests
- Integration tests
- E2E tests
- Performance tests
- Security tests

## Parallel Features
- Concurrent test runs
- Distributed testing
- Load testing
- Cross-browser testing
- Multi-environment validation
