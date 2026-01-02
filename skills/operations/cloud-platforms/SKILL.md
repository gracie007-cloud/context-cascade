---
name: cloud-platforms
description: Design and govern multi-cloud operations with validated landing zones
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Provide repeatable multi-cloud operating models, landing zones, and governance that enable secure delivery across providers.

### Trigger Conditions
- **Positive:** multi-cloud rollout or migration; baseline review for cloud governance; shared services enablement across clouds
- **Negative:** AWS-only deep dive (route to aws-specialist); Kubernetes cluster-first asks (route to kubernetes-specialist); pure performance tuning (route to performance-analysis)

### Guardrails
- Structure-first: keep SKILL.md aligned with examples/, tests/, and any resources/references so downstream agents always have scaffolding.
- Adversarial validation is mandatory: cover boundary cases, failure paths, and rollback drills before declaring the SOP complete.
- Prompt hygiene: separate hard vs. soft vs. inferred constraints and confirm inferred constraints before acting.
- Explicit confidence ceilings: format as 'Confidence: X.XX (ceiling: TYPE Y.YY)' and never exceed the ceiling for the claim type.
- MCP traceability: tag sessions WHO=operations-{name}-{session_id}, WHY=skill-execution, and capture evidence links in outputs.
- Avoid anti-patterns: undocumented changes, missing rollback paths, skipped tests, or unbounded automation without approvals.

### Required Artifacts
- SKILL.md (this SOP)
- readme.md with usage quickstart
- examples/ covering multi-cloud deployments
- tests/ validating landing zone controls
- resources/ scripts/templates
- references/ to provider standards

### Execution Phases
1. **Discover and classify workloads**
   - Inventory applications, data domains, and compliance constraints
   - Map target clouds, regions, and shared services
   - Surface reuse from existing patterns or templates

2. **Design landing zone and controls**
   - Define network topology, IAM model, and org structure
   - Select guardrails for security, cost, and compliance
   - Plan observability, backup, and DR baselines

3. **Execute rollout**
   - Implement IaC modules and pipelines for accounts/projects
   - Configure shared services (network hubs, identity, secrets)
   - Pilot workloads with canaries and rollback checkpoints

4. **Validate and hand off**
   - Run drift, policy, and security checks
   - Capture SLOs and operational readiness notes
   - Document runbooks, ownership, and escalation paths

### Output Format
- Target platform blueprint with account/project layout
- Control plane and IAM model with guardrails
- Migration or rollout plan with milestones and checkpoints
- Validation report (drift, security, performance) with evidence links
- Runbook and escalation contacts for steady state

### Validation Checklist
- Landing zone documented and tied to compliance needs
- Security and IAM controls mapped to least-privilege patterns
- IaC plan tested or reviewed with rollback noted
- Observability, backup, and DR hooks defined
- Confidence ceiling stated for rollout readiness

Confidence: 0.70 (ceiling: inference 0.70) - multi-cloud SOP mirrors validated skill-forge guardrails
