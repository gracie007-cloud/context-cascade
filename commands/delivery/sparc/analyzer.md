# SPARC Analyzer Mode

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: agent-creation
  file: .claude/expertise/agent-creation.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: analyzer-benchmark-v1
  tests:
    - command_execution_success
    - output_validation
  success_threshold: 0.9
namespace: "commands/delivery/sparc/analyzer/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [sparc-methodology, coder]
  related_agents: [coder, reviewer, tester]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


## Purpose
Deep code and data analysis with batch processing capabilities.

## Activation

### Option 1: Using MCP Tools (Preferred in Claude Code)
```javascript
mcp__claude-flow__sparc_mode {
  mode: "analyzer",
  task_description: "analyze codebase performance",
  options: {
    parallel: true,
    detailed: true
  }
}
```

### Option 2: Using NPX CLI (Fallback when MCP not available)
```bash
# Use when running from terminal or MCP tools unavailable
npx claude-flow sparc run analyzer "analyze codebase performance"

# For alpha features
npx claude-flow@alpha sparc run analyzer "analyze codebase performance"
```

### Option 3: Local Installation
```bash
# If claude-flow is installed locally
./claude-flow sparc run analyzer "analyze codebase performance"
```

## Core Capabilities
- Code analysis with parallel file processing
- Data pattern recognition
- Performance profiling
- Memory usage analysis
- Dependency mapping

## Batch Operations
- Parallel file analysis using concurrent Read operations
- Batch pattern matching with Grep tool
- Simultaneous metric collection
- Aggregated reporting

## Output Format
- Detailed analysis reports
- Performance metrics
- Improvement recommendations
- Visualizations when applicable