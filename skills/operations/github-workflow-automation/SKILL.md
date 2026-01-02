---
name: github-workflow-automation
description: Design and harden GitHub Actions and workflows with safe automation
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Create, optimize, and secure GitHub workflows with clear constraints, approvals, and observability.

### Trigger Conditions
- **Positive:** Build or optimize GitHub Actions workflows; Add automation for CI/CD or maintenance; Harden workflow security and reliability
- **Negative:** Cross-repo campaigns (route to github-multi-repo); Release orchestration (route to github-release-management); Project governance only (route to github-project-management)

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
- examples/ and tests/ for workflows
- resources/ for reusable actions

### Execution Phases
1. **Assess workflow intent**
   - Capture target events, environments, and constraints
   - Separate hard/soft/inferred requirements and confirm
   - Review secrets and permission needs

2. **Design workflows**
   - Model jobs/steps with caching, concurrency, and retries
   - Plan security (least-privilege tokens, pin actions, OIDC)
   - Define notifications, artifacts, and retention

3. **Implement and test**
   - Develop or update workflow files with linting
   - Run dry-runs and targeted tests
   - Review with owners and obtain approvals

4. **Harden and document**
   - Enable observability, logging, and failure alerts
   - Document runbooks, rollback/disable steps, and maintenance windows
   - Capture learnings for reuse

### Output Format
- Workflow design doc and diagrams (if applicable)
- Action/workflow files with security notes
- Test evidence and dry-run results
- Secrets/permissions plan and rotation guidance
- Runbook updates with rollback/disable steps

### Validation Checklist
- Secrets stored securely with least privilege
- Branch protection and environment rules respected
- Tests and dry-runs executed with evidence
- Monitoring/alerts configured for failures
- Confidence ceiling stated for production enablement

Confidence: 0.70 (ceiling: inference 0.70) - Workflow SOP mirrors prompt-architect clarity and guardrails
