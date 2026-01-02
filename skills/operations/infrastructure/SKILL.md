---
name: infrastructure
description: Design and deliver core infrastructure with resilient operations
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Create secure, scalable infrastructure foundations covering network, compute, storage, identity, and observability with validated IaC.

### Trigger Conditions
- **Positive:** New environment or platform build; Infrastructure modernization or consolidation; Baseline security/operations review
- **Negative:** Container packaging only (route to docker-containerization); Kubernetes-specific asks (route to kubernetes-specialist); Performance triage (route to performance-analysis)

### Guardrails
- Structure-first: keep SKILL.md aligned with examples/, tests/, and any resources/references so downstream agents always have scaffolding.
- Adversarial validation is mandatory: cover boundary cases, failure paths, and rollback drills before declaring the SOP complete.
- Prompt hygiene: separate hard vs. soft vs. inferred constraints and confirm inferred constraints before acting.
- Explicit confidence ceilings: format as 'Confidence: X.XX (ceiling: TYPE Y.YY)' and never exceed the ceiling for the claim type.
- MCP traceability: tag sessions WHO=operations-{name}-{session_id}, WHY=skill-execution, and capture evidence links in outputs.
- Avoid anti-patterns: undocumented changes, missing rollback paths, skipped tests, or unbounded automation without approvals.

### Required Artifacts
- SKILL.md (this SOP)
- readme.md
- examples/ for architectures
- tests/ for infrastructure checks
- resources/ scripts/templates

### Execution Phases
1. **Capture requirements**
   - Document workloads, data needs, compliance, and SLOs
   - Separate hard vs. soft constraints and confirm owners
   - Assess current state and gaps

2. **Design architecture**
   - Plan network, identity, compute, storage, and security controls
   - Select delivery patterns (IaC, pipelines, artifact strategy)
   - Define observability, backup, and DR baselines

3. **Implement and stage**
   - Codify infrastructure via IaC with peer review
   - Deploy to non-prod with smoke tests and drift detection
   - Harden access, secrets, and audit trails

4. **Validate and hand off**
   - Run security/performance/availability checks
   - Record capacity plans and cost expectations
   - Document runbooks, escalation, and change control

### Output Format
- Reference architecture and decision log
- IaC plan with modules, pipelines, and review points
- Capacity/performance profile with assumptions
- Operational runbook with monitoring and backups
- Risk register with mitigations and owners

### Validation Checklist
- Security and compliance controls mapped and tested
- Performance and capacity checks executed or planned
- Backup/DR and observability paths in place
- Change control and ownership documented
- Confidence ceiling stated for environment readiness

Confidence: 0.70 (ceiling: inference 0.70) - Infrastructure SOP mirrors skill-forge structure with IaC validation
