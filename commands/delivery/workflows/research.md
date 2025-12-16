# Research Workflow Coordination

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: deployment
  file: .claude/expertise/deployment.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: research-benchmark-v1
  tests:
    - command_execution_success
    - workflow_validation
  success_threshold: 0.9
namespace: "commands/delivery/workflows/research/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [deployment-readiness, cicd-intelligent-recovery]
  related_agents: [cicd-engineer, tester]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


## Purpose
Coordinate Claude Code's research activities for comprehensive, systematic exploration.

## Step-by-Step Coordination

### 1. Initialize Research Framework
```
Tool: mcp__claude-flow__swarm_init
Parameters: {"topology": "mesh", "maxAgents": 5, "strategy": "balanced"}
```
Creates a mesh topology for comprehensive exploration from multiple angles.

### 2. Define Research Perspectives
```
Tool: mcp__claude-flow__agent_spawn
Parameters: {"type": "researcher", "name": "Literature Review"}
```
```
Tool: mcp__claude-flow__agent_spawn  
Parameters: {"type": "analyst", "name": "Data Analysis"}
```
Sets up different analytical approaches for Claude Code to use.

### 3. Execute Coordinated Research
```
Tool: mcp__claude-flow__task_orchestrate
Parameters: {
  "task": "Research modern web frameworks performance",
  "strategy": "adaptive",
  "priority": "medium"
}
```

### 4. Store Research Findings
```
Tool: mcp__claude-flow__memory_usage
Parameters: {
  "action": "store",
  "key": "research_findings",
  "value": "framework performance analysis results",
  "namespace": "research"
}
```

## What Claude Code Actually Does
1. Uses **WebSearch** tool for finding resources
2. Uses **Read** tool for analyzing documentation
3. Uses **Task** tool for parallel exploration
4. Synthesizes findings using coordination patterns
5. Stores insights in memory for future reference

Remember: The swarm coordinates HOW Claude Code researches, not WHAT it finds.

## CLI Usage
```bash
# Start research workflow via CLI
npx claude-flow workflow research "modern web frameworks"

# Export research workflow
npx claude-flow workflow export research --format json
```