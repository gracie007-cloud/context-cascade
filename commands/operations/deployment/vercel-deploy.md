---

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: deployment
  file: .claude/expertise/deployment.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: vercel-deploy-benchmark-v1
  tests:
    - deployment_success
    - hook_execution_validation
  success_threshold: 0.9
namespace: "commands/operations/deployment/vercel-deploy/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [hooks-automation, deployment-readiness]
  related_agents: [cicd-engineer, kubernetes-specialist]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->

name: vercel-deploy
description: Deploy to Vercel with automatic previews
category: deployment
version: 2.0.0
---

# ▲ Vercel Deployment

Deploy to Vercel with automatic preview deployments.

```bash
npx vercel --prod
```

**Version**: 2.0.0
