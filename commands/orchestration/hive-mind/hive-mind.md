# hive-mind

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: orchestration
  file: .claude/expertise/orchestration.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: hive-mind-benchmark-v1
  tests:
    - swarm_coordination_success
    - consensus_validation
  success_threshold: 0.9
namespace: "commands/orchestration/hive-mind/hive-mind/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [hive-mind-advanced, cascade-orchestrator]
  related_agents: [queen-coordinator, swarm-memory-manager]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
  coordination_efficiency: ">90%"
<!-- END META-LOOP -->


Hive Mind collective intelligence system for advanced swarm coordination.

## Usage
```bash
npx claude-flow hive-mind [subcommand] [options]
```

## Subcommands
- `init` - Initialize hive mind system
- `spawn` - Spawn hive mind swarm
- `status` - Show hive mind status
- `resume` - Resume paused session
- `stop` - Stop running session

## Examples
```bash
# Initialize hive mind
npx claude-flow hive-mind init

# Spawn swarm
npx claude-flow hive-mind spawn "Build microservices"

# Check status
npx claude-flow hive-mind status
```
