# agent-types
<!-- META-LOOP v2.1 INTEGRATION -->## Phase 0: Expertise Loadingexpertise_check:  domain: agent-creation  file: .claude/expertise/agent-creation.yaml  fallback: discovery_mode## Recursive Improvement Integration (v2.1)benchmark: agent-types-benchmark-v1  tests:    - command_execution_success    - domain_validation  success_threshold: 0.9namespace: "commands/foundry/agents/agent-types/{project}/{timestamp}"uncertainty_threshold: 0.85coordination:  related_skills: [agent-creator, micro-skill-creator]  related_agents: [prompt-auditor, skill-auditor]## COMMAND COMPLETION VERIFICATIONsuccess_metrics:  execution_success: ">95%"<!-- END META-LOOP -->

Complete guide to all 54 available agent types in Claude Flow.

## Core Development Agents
- `coder` - Implementation specialist
- `reviewer` - Code quality assurance
- `tester` - Test creation and validation
- `planner` - Strategic planning
- `researcher` - Information gathering

## Swarm Coordination Agents
- `hierarchical-coordinator` - Queen-led coordination
- `mesh-coordinator` - Peer-to-peer networks
- `adaptive-coordinator` - Dynamic topology

## Specialized Agents
- `backend-dev` - API development
- `mobile-dev` - React Native development
- `ml-developer` - Machine learning
- `system-architect` - High-level design

For full list and details:
```bash
npx claude-flow agents list
```
