# agent-capabilities
<!-- META-LOOP v2.1 INTEGRATION -->## Phase 0: Expertise Loadingexpertise_check:  domain: agent-creation  file: .claude/expertise/agent-creation.yaml  fallback: discovery_mode## Recursive Improvement Integration (v2.1)benchmark: agent-capabilities-benchmark-v1  tests:    - command_execution_success    - domain_validation  success_threshold: 0.9namespace: "commands/foundry/agents/agent-capabilities/{project}/{timestamp}"uncertainty_threshold: 0.85coordination:  related_skills: [agent-creator, micro-skill-creator]  related_agents: [prompt-auditor, skill-auditor]## COMMAND COMPLETION VERIFICATIONsuccess_metrics:  execution_success: ">95%"<!-- END META-LOOP -->

Matrix of agent capabilities and their specializations.

## Capability Matrix

| Agent Type | Primary Skills | Best For |
|------------|---------------|----------|
| coder | Implementation, debugging | Feature development |
| researcher | Analysis, synthesis | Requirements gathering |
| tester | Testing, validation | Quality assurance |
| architect | Design, planning | System architecture |

## Querying Capabilities
```bash
# List all capabilities
npx claude-flow agents capabilities

# For specific agent
npx claude-flow agents capabilities --type coder
```
