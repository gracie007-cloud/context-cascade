# repo-analyze

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: deployment
  file: .claude/expertise/deployment.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: repo-analyze-benchmark-v1
  tests:
    - github_integration_success
    - automation_validation
  success_threshold: 0.9
namespace: "commands/operations/github/repo-analyze/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [github-workflow-automation, github-release-management]
  related_agents: [github-actions-specialist, release-orchestration-agent]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


Deep analysis of GitHub repository with AI insights.

## Usage
```bash
npx claude-flow github repo-analyze [options]
```

## Options
- `--repository <owner/repo>` - Repository to analyze
- `--deep` - Enable deep analysis
- `--include <areas>` - Include specific areas (issues, prs, code, commits)

## Examples
```bash
# Basic analysis
npx claude-flow github repo-analyze --repository myorg/myrepo

# Deep analysis
npx claude-flow github repo-analyze --repository myorg/myrepo --deep

# Specific areas
npx claude-flow github repo-analyze --repository myorg/myrepo --include issues,prs
```
