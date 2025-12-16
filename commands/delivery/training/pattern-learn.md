# pattern-learn
<!-- META-LOOP v2.1 INTEGRATION -->## Phase 0: Expertise Loadingexpertise_check:  domain: agent-creation  file: .claude/expertise/agent-creation.yaml  fallback: discovery_mode## Recursive Improvement Integration (v2.1)benchmark: pattern-learn-benchmark-v1  tests:    - training_validation    - pattern_verification  success_threshold: 0.9namespace: "commands/delivery/training/pattern-learn/{project}/{timestamp}"uncertainty_threshold: 0.85coordination:  related_skills: [agent-creator, micro-skill-creator]  related_agents: [coder, skill-auditor]## COMMAND COMPLETION VERIFICATIONsuccess_metrics:  execution_success: ">95%"<!-- END META-LOOP -->

Learn patterns from successful operations.

## Usage
```bash
npx claude-flow training pattern-learn [options]
```

## Options
- `--source <type>` - Pattern source
- `--threshold <score>` - Success threshold
- `--save <name>` - Save pattern set

## Examples
```bash
# Learn from all ops
npx claude-flow training pattern-learn

# High success only
npx claude-flow training pattern-learn --threshold 0.9

# Save patterns
npx claude-flow training pattern-learn --save optimal-patterns
```
