---

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: hooks
  file: .claude/expertise/hooks.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: on-push-benchmark-v1
  tests:
    - deployment_success
    - hook_execution_validation
  success_threshold: 0.9
namespace: "commands/operations/hooks/automation/on-push/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [hooks-automation, deployment-readiness]
  related_agents: [cicd-engineer, kubernetes-specialist]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->

name: hook:on-push
description: Git push hook with CI trigger and deployment
category: Automation Hooks
version: 1.0.0
requires:
  - git
  - github-cli (optional)
usage: |
  /hook:on-push --trigger-ci --notify-team
  /hook:on-push --deploy-env "staging" --run-integration-tests
---

# Hook: On-Push (Pre-Push)

**Category**: Automation Hooks
**Purpose**: Validate and prepare code before pushing to remote repository.

## Implementation

```bash
#!/bin/bash
# Git pre-push hook

echo "🚀 Preparing to push..."

# Run full test suite
echo "🧪 Running full test suite..."
npm test

# Check for secrets
echo "🔐 Checking for secrets..."
git diff origin/main...HEAD | grep -iE '(api_key|password|secret|token)' && exit 1 || true

# Trigger CI
echo "⚙️  Triggering CI pipeline..."
gh workflow run ci.yml

echo "✅ Push checks passed!"
exit 0
```

---

**Status**: Production Ready
**Version**: 1.0.0
