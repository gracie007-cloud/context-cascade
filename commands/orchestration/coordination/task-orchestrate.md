# task-orchestrate

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: orchestration
  file: .claude/expertise/orchestration.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: task-orchestrate-benchmark-v1
  tests:
    - swarm_coordination_success
    - consensus_validation
  success_threshold: 0.9
namespace: "commands/orchestration/coordination/task-orchestrate/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [hive-mind-advanced, cascade-orchestrator]
  related_agents: [queen-coordinator, swarm-memory-manager]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
  coordination_efficiency: ">90%"
<!-- END META-LOOP -->


Orchestrate complex tasks across the swarm.

## Usage
```bash
npx claude-flow task orchestrate [options]
```

## Options
- `--task <description>` - Task description
- `--strategy <type>` - Orchestration strategy
- `--priority <level>` - Task priority (low, medium, high, critical)

## Examples
```bash
# Orchestrate development task
npx claude-flow task orchestrate --task "Implement user authentication"

# High priority task
npx claude-flow task orchestrate --task "Fix production bug" --priority critical

# With specific strategy
npx claude-flow task orchestrate --task "Refactor codebase" --strategy parallel
```
