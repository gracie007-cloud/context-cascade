# Infrastructure

Design and deliver core infrastructure with secure, observable, and validated IaC.

## When to Use
- Building or modernizing environments
- Establishing network/identity/storage baselines
- Hardening operations with observability and DR

## When Not to Use
- Container packaging only (use docker-containerization)
- Kubernetes-first asks (use kubernetes-specialist)
- Performance debugging (use performance-analysis)

## Workflow Snapshot
1. Capture requirements, constraints, and SLOs.
2. Design architecture and delivery patterns (IaC, pipelines, access).
3. Implement in non-prod with reviews and monitoring.
4. Validate security/performance, document runbooks, and hand off.

## Artifacts
- SKILL.md SOP, examples/, tests/, resources/, and this readme

## Quality Gates
- Security/compliance controls reviewed and tested
- Backups/DR and observability in place
- Confidence ceiling included in readiness statements
