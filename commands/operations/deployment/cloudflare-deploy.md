---

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: deployment
  file: .claude/expertise/deployment.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: cloudflare-deploy-benchmark-v1
  tests:
    - deployment_success
    - hook_execution_validation
  success_threshold: 0.9
namespace: "commands/operations/deployment/cloudflare-deploy/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [hooks-automation, deployment-readiness]
  related_agents: [cicd-engineer, kubernetes-specialist]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->

name: cloudflare-deploy
description: Deploy to Cloudflare Workers with edge computing
category: deployment
version: 2.0.0
---

# ☁️ Cloudflare Workers Deployment

Deploy serverless functions to Cloudflare edge network.

```bash
npx wrangler publish
```

**Version**: 2.0.0
