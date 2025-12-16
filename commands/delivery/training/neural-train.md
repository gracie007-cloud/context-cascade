# neural-train
<!-- META-LOOP v2.1 INTEGRATION -->## Phase 0: Expertise Loadingexpertise_check:  domain: agent-creation  file: .claude/expertise/agent-creation.yaml  fallback: discovery_mode## Recursive Improvement Integration (v2.1)benchmark: neural-train-benchmark-v1  tests:    - training_validation    - pattern_verification  success_threshold: 0.9namespace: "commands/delivery/training/neural-train/{project}/{timestamp}"uncertainty_threshold: 0.85coordination:  related_skills: [agent-creator, micro-skill-creator]  related_agents: [coder, skill-auditor]## COMMAND COMPLETION VERIFICATIONsuccess_metrics:  execution_success: ">95%"<!-- END META-LOOP -->

Train neural patterns from operations.

## Usage
```bash
npx claude-flow training neural-train [options]
```

## Options
- `--data <source>` - Training data source
- `--model <name>` - Target model
- `--epochs <n>` - Training epochs

## Examples
```bash
# Train from recent ops
npx claude-flow training neural-train --data recent

# Specific model
npx claude-flow training neural-train --model task-predictor

# Custom epochs
npx claude-flow training neural-train --epochs 100
```
