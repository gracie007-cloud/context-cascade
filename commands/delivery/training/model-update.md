# model-update
<!-- META-LOOP v2.1 INTEGRATION -->## Phase 0: Expertise Loadingexpertise_check:  domain: agent-creation  file: .claude/expertise/agent-creation.yaml  fallback: discovery_mode## Recursive Improvement Integration (v2.1)benchmark: model-update-benchmark-v1  tests:    - training_validation    - pattern_verification  success_threshold: 0.9namespace: "commands/delivery/training/model-update/{project}/{timestamp}"uncertainty_threshold: 0.85coordination:  related_skills: [agent-creator, micro-skill-creator]  related_agents: [coder, skill-auditor]## COMMAND COMPLETION VERIFICATIONsuccess_metrics:  execution_success: ">95%"<!-- END META-LOOP -->

Update neural models with new data.

## Usage
```bash
npx claude-flow training model-update [options]
```

## Options
- `--model <name>` - Model to update
- `--incremental` - Incremental update
- `--validate` - Validate after update

## Examples
```bash
# Update all models
npx claude-flow training model-update

# Specific model
npx claude-flow training model-update --model agent-selector

# Incremental with validation
npx claude-flow training model-update --incremental --validate
```
