# swarm init

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: orchestration
  file: .claude/expertise/orchestration.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: swarm-init-benchmark-v1
  tests:
    - swarm_coordination_success
    - consensus_validation
  success_threshold: 0.9
namespace: "commands/orchestration/coordination/swarm-init/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [hive-mind-advanced, cascade-orchestrator]
  related_agents: [queen-coordinator, swarm-memory-manager]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
  coordination_efficiency: ">90%"
<!-- END META-LOOP -->


Initialize a Claude Flow swarm with specified topology and configuration.

## Usage

```bash
npx claude-flow swarm init [options]
```

## Options

- `--topology, -t <type>` - Swarm topology: mesh, hierarchical, ring, star (default: hierarchical)
- `--max-agents, -m <number>` - Maximum number of agents (default: 8)
- `--strategy, -s <type>` - Execution strategy: balanced, parallel, sequential (default: parallel)
- `--auto-spawn` - Automatically spawn agents based on task complexity
- `--memory` - Enable cross-session memory persistence
- `--github` - Enable GitHub integration features

## Examples

### Basic initialization

```bash
npx claude-flow swarm init
```

### Mesh topology for research

```bash
npx claude-flow swarm init --topology mesh --max-agents 5 --strategy balanced
```

### Hierarchical for development

```bash
npx claude-flow swarm init --topology hierarchical --max-agents 10 --strategy parallel --auto-spawn
```

### GitHub-focused swarm

```bash
npx claude-flow swarm init --topology star --github --memory
```

## Topologies

### Mesh

- All agents connect to all others
- Best for: Research, exploration, brainstorming
- Communication: High overhead, maximum information sharing

### Hierarchical

- Tree structure with clear command chain
- Best for: Development, structured tasks, large projects
- Communication: Efficient, clear responsibilities

### Ring

- Agents connect in a circle
- Best for: Pipeline processing, sequential workflows
- Communication: Low overhead, ordered processing

### Star

- Central coordinator with satellite agents
- Best for: Simple tasks, centralized control
- Communication: Minimal overhead, clear coordination

## Integration with Claude Code

Once initialized, use MCP tools in Claude Code:

```javascript
mcp__claude-flow__swarm_init { topology: "hierarchical", maxAgents: 8 }
```

## See Also

- `agent spawn` - Create swarm agents
- `task orchestrate` - Coordinate task execution
- `swarm status` - Check swarm state
- `swarm monitor` - Real-time monitoring
