# token-usage

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: quality
  file: .claude/expertise/quality.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: FILENAME-benchmark-v1
  tests:
    - audit_validation
    - quality_gate_pass
  success_threshold: 0.9
namespace: "commands/quality/SUBDIR/FILENAME/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [clarity-linter, functionality-audit]
  related_agents: [code-analyzer, reviewer]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


Analyze token usage patterns and optimize for efficiency.

## Usage
```bash
npx claude-flow analysis token-usage [options]
```

## Options
- `--period <time>` - Analysis period (1h, 24h, 7d, 30d)
- `--by-agent` - Break down by agent
- `--by-operation` - Break down by operation type

## Examples
```bash
# Last 24 hours token usage
npx claude-flow analysis token-usage --period 24h

# By agent breakdown
npx claude-flow analysis token-usage --by-agent

# Export detailed report
npx claude-flow analysis token-usage --period 7d --export tokens.csv
```
