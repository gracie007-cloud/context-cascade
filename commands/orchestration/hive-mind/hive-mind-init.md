# hive-mind-init

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: orchestration
  file: .claude/expertise/orchestration.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: hive-mind-init-benchmark-v1
  tests:
    - swarm_coordination_success
    - consensus_validation
  success_threshold: 0.9
namespace: "commands/orchestration/hive-mind/hive-mind-init/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [hive-mind-advanced, cascade-orchestrator]
  related_agents: [queen-coordinator, swarm-memory-manager]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
  coordination_efficiency: ">90%"
<!-- END META-LOOP -->


Initialize the Hive Mind collective intelligence system.

## Usage
```bash
npx claude-flow hive-mind init [options]
```

## Options
- `--force` - Force reinitialize
- `--config <file>` - Configuration file

## Examples
```bash
npx claude-flow hive-mind init
npx claude-flow hive-mind init --force
```
