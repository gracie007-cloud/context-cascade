# Cloud Platforms

Multi-cloud operating model with validated landing zones and guardrails.

## When to Use
- Rolling out or migrating workloads across multiple clouds
- Establishing governance, IAM, and shared services baselines
- Standardizing observability, backup, and DR across providers

## When Not to Use
- AWS-only engagements (use aws-specialist)
- Kubernetes-first asks (use kubernetes-specialist)
- Pure performance triage (use performance-analysis)

## Workflow Snapshot
1. Discover workloads, constraints, and compliance needs.
2. Design landing zones, IAM, and guardrails.
3. Execute IaC-driven rollout with canaries and rollback points.
4. Validate drift/security/performance and hand off runbooks.

## Artifacts
- SKILL.md for the SOP
- readme.md (this file) plus examples/, tests/, resources/, and references/

## Quality Gates
- Policy and security checks on landing zones
- Documented rollback/contingency plans
- Confidence ceilings stated on readiness calls
