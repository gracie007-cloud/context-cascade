---
name: cicd-intelligent-recovery
description: Recover CI/CD pipelines safely with structured rollback and validation
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Stabilize failing CI/CD pipelines, contain blast radius, and restore healthy deploy paths with validated fixes and runbook updates.

### Trigger Conditions
- **Positive:** CI/CD pipeline failures or stuck runs; flaky stage blocking release; rollback or hotfix required after deployment
- **Negative:** greenfield pipeline design (route to github-workflow-automation); post-release incident already mitigated (route to production-readiness follow-up); org-wide release planning (route to github-release-management)

### Guardrails
- Structure-first: keep SKILL.md aligned with examples/, tests/, and any resources/references so downstream agents always have scaffolding.
- Adversarial validation is mandatory: cover boundary cases, failure paths, and rollback drills before declaring the SOP complete.
- Prompt hygiene: separate hard vs. soft vs. inferred constraints and confirm inferred constraints before acting.
- Explicit confidence ceilings: format as 'Confidence: X.XX (ceiling: TYPE Y.YY)' and never exceed the ceiling for the claim type.
- MCP traceability: tag sessions WHO=operations-{name}-{session_id}, WHY=skill-execution, and capture evidence links in outputs.
- Avoid anti-patterns: undocumented changes, missing rollback paths, skipped tests, or unbounded automation without approvals.

### Required Artifacts
- SKILL.md (this SOP)
- examples/ that show common recovery drills
- tests/ covering rollback and smoke validation
- resources/ with runbooks and scripts
- references/ linking telemetry and dashboards

### Execution Phases
1. **Triage and isolate**
   - Freeze risky deploy paths and capture failing pipeline context
   - Collect logs, artifacts, and test failure patterns to isolate the failing stage
   - Record blast radius, impacted repos, and owners

2. **Stabilize the delivery path**
   - Select rollback vs. hotfix vs. feature-flag disablement and align on owner
   - Apply minimal-change stabilizers (retries, retriable steps, temporary skips) with approvals
   - Document interim guardrails and time limits for temporary mitigations

3. **Remediate root cause**
   - Patch configuration/tests/infrastructure with smallest safe diff
   - Re-run targeted checks and rerun the failing pipeline segment before full pipeline
   - Coordinate with service owners for cross-repo impacts

4. **Validate and close out**
   - Run full pipeline and capture evidence links
   - Update runbooks, post-incident notes, and alerts
   - Communicate readiness, rollback posture, and remaining risks

### Output Format
- Recovery snapshot: what failed, when, and blast radius
- Stabilization plan with chosen rollback/flag path and owners
- Fix list with PRs/patch references and test coverage notes
- Verification results with links to rerun pipelines/logs
- Runbook and alert updates plus residual-risk callouts

### Validation Checklist
- Trigger confirmed and not better served by release-management or production-readiness
- Rollback or mitigation path is executable and time-bounded
- Critical tests re-run and passing; failures are explained with owners
- Documentation and communication posted with evidence links
- Confidence ceiling stated for overall readiness

Confidence: 0.70 (ceiling: inference 0.70) - recovery plan grounded in observable pipeline evidence
