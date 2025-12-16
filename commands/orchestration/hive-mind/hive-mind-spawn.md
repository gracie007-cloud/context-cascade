# hive-mind-spawn

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: orchestration
  file: .claude/expertise/orchestration.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: hive-mind-spawn-benchmark-v1
  tests:
    - swarm_coordination_success
    - consensus_validation
  success_threshold: 0.9
namespace: "commands/orchestration/hive-mind/hive-mind-spawn/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [hive-mind-advanced, cascade-orchestrator]
  related_agents: [queen-coordinator, swarm-memory-manager]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
  coordination_efficiency: ">90%"
<!-- END META-LOOP -->


Spawn a Hive Mind swarm with queen-led coordination.

## Usage
```bash
npx claude-flow hive-mind spawn <objective> [options]
```

## Options
- `--queen-type <type>` - Queen type (strategic, tactical, adaptive)
- `--max-workers <n>` - Maximum worker agents
- `--consensus <type>` - Consensus algorithm
- `--claude` - Generate Claude Code spawn commands

## Examples
```bash
npx claude-flow hive-mind spawn "Build API"
npx claude-flow hive-mind spawn "Research patterns" --queen-type adaptive
npx claude-flow hive-mind spawn "Build service" --claude
```
