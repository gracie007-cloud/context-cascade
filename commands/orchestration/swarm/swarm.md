# swarm

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: orchestration
  file: .claude/expertise/orchestration.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: swarm-benchmark-v1
  tests:
    - swarm_coordination_success
    - consensus_validation
  success_threshold: 0.9
namespace: "commands/orchestration/swarm/swarm/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [hive-mind-advanced, cascade-orchestrator]
  related_agents: [queen-coordinator, swarm-memory-manager]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
  coordination_efficiency: ">90%"
<!-- END META-LOOP -->


Main swarm orchestration command for Claude Flow.

## Usage
```bash
npx claude-flow swarm <objective> [options]
```

## Options
- `--strategy <type>` - Execution strategy (research, development, analysis, testing)
- `--mode <type>` - Coordination mode (centralized, distributed, hierarchical, mesh)
- `--max-agents <n>` - Maximum number of agents (default: 5)
- `--claude` - Open Claude Code CLI with swarm prompt
- `--parallel` - Enable parallel execution

## Examples
```bash
# Basic swarm
npx claude-flow swarm "Build REST API"

# With strategy
npx claude-flow swarm "Research AI patterns" --strategy research

# Open in Claude Code
npx claude-flow swarm "Build API" --claude
```
