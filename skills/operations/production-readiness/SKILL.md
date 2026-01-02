---
name: production-readiness
description: Assess and harden services for production with SLOs, resilience, and ops hygiene
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Verify services meet production standards across reliability, security, observability, and operational excellence with clear go-live posture.

### Trigger Conditions
- **Positive:** Production launch readiness review; Operational maturity assessment; Service hardening for SLO/DR
- **Negative:** Release execution only (route to github-release-management); Marketing launch orchestration (route to sop-product-launch); Acute incident triage (route to cicd-intelligent-recovery)

### Guardrails
- Structure-first: keep SKILL.md aligned with examples/, tests/, and any resources/references so downstream agents always have scaffolding.
- Adversarial validation is mandatory: cover boundary cases, failure paths, and rollback drills before declaring the SOP complete.
- Prompt hygiene: separate hard vs. soft vs. inferred constraints and confirm inferred constraints before acting.
- Explicit confidence ceilings: format as 'Confidence: X.XX (ceiling: TYPE Y.YY)' and never exceed the ceiling for the claim type.
- MCP traceability: tag sessions WHO=operations-{name}-{session_id}, WHY=skill-execution, and capture evidence links in outputs.
- Avoid anti-patterns: undocumented changes, missing rollback paths, skipped tests, or unbounded automation without approvals.

### Required Artifacts
- SKILL.md (this SOP)
- examples/ for readiness checks
- tests/ for operational validation
- resources/ for runbooks

### Execution Phases
1. **Review architecture and risks**
   - Assess reliability, security, and dependency posture
   - Confirm data protection, backups, and DR
   - Map ownership and on-call coverage

2. **Validate operations hygiene**
   - Check observability coverage and alert quality
   - Review runbooks, automation, and access controls
   - Ensure change management and config hygiene

3. **Test resilience**
   - Run smoke/chaos tests where safe
   - Verify rollback/roll-forward mechanics
   - Validate capacity and rate-limit protections

4. **Decide readiness**
   - Summarize gaps, risks, and mitigations
   - Set go/no-go with owners and time boxes
   - Publish documentation and escalation paths

### Output Format
- Production readiness report with risks and mitigations
- SLOs, alerts, and runbook verification notes
- Resilience/rollback test results
- Access/governance review outcomes
- Go/no-go decision with approvals and follow-ups

### Validation Checklist
- SLOs and alerts defined with owners
- Backup/DR and rollback validated or scheduled
- Security and access controls reviewed
- Runbooks and escalation contacts documented
- Confidence ceiling stated for readiness decision

Confidence: 0.70 (ceiling: inference 0.70) - Production readiness SOP couples guardrails with resilience checks
