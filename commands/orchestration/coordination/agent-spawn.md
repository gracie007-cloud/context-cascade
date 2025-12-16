# agent-spawn

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: orchestration
  file: .claude/expertise/orchestration.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: agent-spawn-benchmark-v1
  tests:
    - swarm_coordination_success
    - consensus_validation
  success_threshold: 0.9
namespace: "commands/orchestration/coordination/agent-spawn/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [hive-mind-advanced, cascade-orchestrator]
  related_agents: [queen-coordinator, swarm-memory-manager]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
  coordination_efficiency: ">90%"
<!-- END META-LOOP -->


Spawn a new agent in the current swarm.

## Usage
```bash
npx claude-flow agent spawn [options]
```

## Options
- `--type <type>` - Agent type (coder, researcher, analyst, tester, coordinator)
- `--name <name>` - Custom agent name
- `--skills <list>` - Specific skills (comma-separated)

## Examples
```bash
# Spawn coder agent
npx claude-flow agent spawn --type coder

# With custom name
npx claude-flow agent spawn --type researcher --name "API Expert"

# With specific skills
npx claude-flow agent spawn --type coder --skills "python,fastapi,testing"
```
