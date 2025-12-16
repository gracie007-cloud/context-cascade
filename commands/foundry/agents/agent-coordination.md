# agent-coordination
<!-- META-LOOP v2.1 INTEGRATION -->## Phase 0: Expertise Loadingexpertise_check:  domain: agent-creation  file: .claude/expertise/agent-creation.yaml  fallback: discovery_mode## Recursive Improvement Integration (v2.1)benchmark: agent-coordination-benchmark-v1  tests:    - command_execution_success    - domain_validation  success_threshold: 0.9namespace: "commands/foundry/agents/agent-coordination/{project}/{timestamp}"uncertainty_threshold: 0.85coordination:  related_skills: [agent-creator, micro-skill-creator]  related_agents: [prompt-auditor, skill-auditor]## COMMAND COMPLETION VERIFICATIONsuccess_metrics:  execution_success: ">95%"<!-- END META-LOOP -->

Coordination patterns for multi-agent collaboration.

## Coordination Patterns

### Hierarchical
Queen-led with worker specialization
```bash
npx claude-flow swarm init --topology hierarchical
```

### Mesh
Peer-to-peer collaboration
```bash
npx claude-flow swarm init --topology mesh
```

### Adaptive
Dynamic topology based on workload
```bash
npx claude-flow swarm init --topology adaptive
```

## Best Practices
- Use hierarchical for complex projects
- Use mesh for research tasks
- Use adaptive for unknown workloads
