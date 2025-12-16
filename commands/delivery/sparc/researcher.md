# SPARC Researcher Mode

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: agent-creation
  file: .claude/expertise/agent-creation.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: researcher-benchmark-v1
  tests:
    - command_execution_success
    - output_validation
  success_threshold: 0.9
namespace: "commands/delivery/sparc/researcher/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [sparc-methodology, coder]
  related_agents: [coder, reviewer, tester]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


## Purpose
Deep research with parallel WebSearch/WebFetch and Memory coordination.

## Activation

### Option 1: Using MCP Tools (Preferred in Claude Code)
```javascript
mcp__claude-flow__sparc_mode {
  mode: "researcher",
  task_description: "research AI trends 2024",
  options: {
    depth: "comprehensive",
    sources: ["academic", "industry", "news"]
  }
}
```

### Option 2: Using NPX CLI (Fallback when MCP not available)
```bash
# Use when running from terminal or MCP tools unavailable
npx claude-flow sparc run researcher "research AI trends 2024"

# For alpha features
npx claude-flow@alpha sparc run researcher "research AI trends 2024"
```

### Option 3: Local Installation
```bash
# If claude-flow is installed locally
./claude-flow sparc run researcher "research AI trends 2024"
```

## Core Capabilities
- Information gathering
- Source evaluation
- Trend analysis
- Competitive research
- Technology assessment

## Research Methods
- Parallel web searches
- Academic paper analysis
- Industry report synthesis
- Expert opinion gathering
- Data compilation

## Memory Integration
- Store research findings
- Build knowledge graphs
- Track information sources
- Cross-reference insights
- Maintain research history
