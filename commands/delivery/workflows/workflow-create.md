# workflow-create

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: deployment
  file: .claude/expertise/deployment.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: workflow-create-benchmark-v1
  tests:
    - command_execution_success
    - workflow_validation
  success_threshold: 0.9
namespace: "commands/delivery/workflows/workflow-create/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [deployment-readiness, cicd-intelligent-recovery]
  related_agents: [cicd-engineer, tester]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


Create reusable workflow templates.

## Usage
```bash
npx claude-flow workflow create [options]
```

## Options
- `--name <name>` - Workflow name
- `--from-history` - Create from history
- `--interactive` - Interactive creation

## Examples
```bash
# Create workflow
npx claude-flow workflow create --name "deploy-api"

# From history
npx claude-flow workflow create --name "test-suite" --from-history

# Interactive mode
npx claude-flow workflow create --interactive
```
