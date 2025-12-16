# smart-spawn

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: deployment
  file: .claude/expertise/deployment.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: smart-spawn-benchmark-v1
  tests:
    - github_integration_success
    - automation_validation
  success_threshold: 0.9
namespace: "commands/operations/automation/smart-spawn/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [github-workflow-automation, github-release-management]
  related_agents: [github-actions-specialist, release-orchestration-agent]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


Intelligently spawn agents based on workload analysis.

## Usage
```bash
npx claude-flow automation smart-spawn [options]
```

## Options
- `--analyze` - Analyze before spawning
- `--threshold <n>` - Spawn threshold
- `--topology <type>` - Preferred topology

## Examples
```bash
# Smart spawn with analysis
npx claude-flow automation smart-spawn --analyze

# Set spawn threshold
npx claude-flow automation smart-spawn --threshold 5

# Force topology
npx claude-flow automation smart-spawn --topology hierarchical
```
