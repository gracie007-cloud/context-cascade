# issue-triage

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: deployment
  file: .claude/expertise/deployment.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: issue-triage-benchmark-v1
  tests:
    - github_integration_success
    - automation_validation
  success_threshold: 0.9
namespace: "commands/operations/github/issue-triage/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [github-workflow-automation, github-release-management]
  related_agents: [github-actions-specialist, release-orchestration-agent]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


Intelligent issue classification and triage.

## Usage
```bash
npx claude-flow github issue-triage [options]
```

## Options
- `--repository <owner/repo>` - Target repository
- `--auto-label` - Automatically apply labels
- `--assign` - Auto-assign to team members

## Examples
```bash
# Triage issues
npx claude-flow github issue-triage --repository myorg/myrepo

# With auto-labeling
npx claude-flow github issue-triage --repository myorg/myrepo --auto-label

# Full automation
npx claude-flow github issue-triage --repository myorg/myrepo --auto-label --assign
```
