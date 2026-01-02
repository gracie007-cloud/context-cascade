---
name: github-release-management
description: Plan and execute GitHub-driven releases with safe rollout and rollback
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Coordinate releases across branches, tags, and environments with clear approvals, automation, and recovery plans.

### Trigger Conditions
- **Positive:** Software release planning; Tagging/versioning and changelog creation; Coordinated rollout across environments
- **Negative:** Pipeline failure response (route to cicd-intelligent-recovery); Single-workflow automation (route to github-workflow-automation); Project tracking only (route to github-project-management)

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
- examples/ and tests/ for release workflows
- resources/ for templates

### Execution Phases
1. **Scope the release**
   - Identify changes, risks, and owners
   - Confirm environments, freeze windows, and approvals
   - Plan communications and documentation needs

2. **Plan branches and automation**
   - Define branching/tagging strategy and versioning
   - Prepare CI/CD workflows and gates
   - Pre-stage artifacts and release notes templates

3. **Execute rollout**
   - Run dry-run or canary where possible
   - Tag, build, and publish artifacts with sign-offs
   - Monitor metrics and errors during rollout

4. **Validate and close**
   - Run post-release checks and verification
   - Document outcomes, incidents, and rollback usage
   - Publish release notes and handoff to support

### Output Format
- Release plan with scope, risks, and approvals
- Branching/tagging strategy and automation checklist
- Release notes and deployment checklist
- Rollback instructions and contingency plans
- Post-release report with metrics and incidents

### Validation Checklist
- Approvals and freezes honored
- CI/CD gates defined and passing
- Rollback path validated and documented
- Communications posted to stakeholders
- Confidence ceiling stated for release go/no-go

Confidence: 0.70 (ceiling: inference 0.70) - Release SOP mirrors skill-forge guardrails and validation loops
