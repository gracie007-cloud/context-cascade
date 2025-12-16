# performance-report

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


Generate comprehensive performance reports for swarm operations.

## Usage
```bash
npx claude-flow analysis performance-report [options]
```

## Options
- `--format <type>` - Report format (json, html, markdown)
- `--include-metrics` - Include detailed metrics
- `--compare <id>` - Compare with previous swarm

## Examples
```bash
# Generate HTML report
npx claude-flow analysis performance-report --format html

# Compare swarms
npx claude-flow analysis performance-report --compare swarm-123

# Full metrics report
npx claude-flow analysis performance-report --include-metrics --format markdown
```
