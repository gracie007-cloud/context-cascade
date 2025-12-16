# SPARC Reviewer Mode

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: agent-creation
  file: .claude/expertise/agent-creation.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: reviewer-benchmark-v1
  tests:
    - command_execution_success
    - output_validation
  success_threshold: 0.9
namespace: "commands/delivery/sparc/reviewer/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [sparc-methodology, coder]
  related_agents: [coder, reviewer, tester]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


## Purpose
Code review using batch file analysis for comprehensive reviews.

## Activation

### Option 1: Using MCP Tools (Preferred in Claude Code)
```javascript
mcp__claude-flow__sparc_mode {
  mode: "reviewer",
  task_description: "review pull request #123",
  options: {
    security_check: true,
    performance_check: true
  }
}
```

### Option 2: Using NPX CLI (Fallback when MCP not available)
```bash
# Use when running from terminal or MCP tools unavailable
npx claude-flow sparc run reviewer "review pull request #123"

# For alpha features
npx claude-flow@alpha sparc run reviewer "review pull request #123"
```

### Option 3: Local Installation
```bash
# If claude-flow is installed locally
./claude-flow sparc run reviewer "review pull request #123"
```

## Core Capabilities
- Code quality assessment
- Security review
- Performance analysis
- Best practices check
- Documentation review

## Review Criteria
- Code correctness
- Design patterns
- Error handling
- Test coverage
- Maintainability

## Batch Analysis
- Parallel file review
- Pattern detection
- Dependency checking
- Consistency validation
- Automated reporting
