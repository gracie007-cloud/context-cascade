# swarm-spawn

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: orchestration
  file: .claude/expertise/orchestration.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: swarm-spawn-benchmark-v1
  tests:
    - swarm_coordination_success
    - consensus_validation
  success_threshold: 0.9
namespace: "commands/orchestration/swarm/swarm-spawn/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [hive-mind-advanced, cascade-orchestrator]
  related_agents: [queen-coordinator, swarm-memory-manager]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
  coordination_efficiency: ">90%"
<!-- END META-LOOP -->


Spawn agents in the swarm.

## Usage
```bash
npx claude-flow swarm spawn [options]
```

## Options
- `--type <type>` - Agent type
- `--count <n>` - Number to spawn
- `--capabilities <list>` - Agent capabilities

## Examples
```bash
npx claude-flow swarm spawn --type coder --count 3
npx claude-flow swarm spawn --type researcher --capabilities "web-search,analysis"
```
