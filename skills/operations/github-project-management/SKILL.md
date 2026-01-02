---
name: github-project-management
description: Run GitHub Projects with clear governance, automation, and reporting
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Design and operate GitHub Projects that align roadmap goals, workflows, and metrics with auditable automation.

### Trigger Conditions
- **Positive:** Need structured project/workflow in GitHub Projects; Portfolio/roadmap tracking in GitHub; Automated status reporting from issues/PRs
- **Negative:** Release-only work (route to github-release-management); Multi-repo code changes (route to github-multi-repo); Simple workflow edits (route to github-workflow-automation)

### Guardrails
- Structure-first: keep SKILL.md aligned with examples/, tests/, and any resources/references so downstream agents always have scaffolding.
- Adversarial validation is mandatory: cover boundary cases, failure paths, and rollback drills before declaring the SOP complete.
- Prompt hygiene: separate hard vs. soft vs. inferred constraints and confirm inferred constraints before acting.
- Explicit confidence ceilings: format as 'Confidence: X.XX (ceiling: TYPE Y.YY)' and never exceed the ceiling for the claim type.
- MCP traceability: tag sessions WHO=operations-{name}-{session_id}, WHY=skill-execution, and capture evidence links in outputs.
- Avoid anti-patterns: undocumented changes, missing rollback paths, skipped tests, or unbounded automation without approvals.

### Required Artifacts
- SKILL.md (this SOP)
- readme.md usage guide
- examples/ and tests/ for automation

### Execution Phases
1. **Intake goals and constraints**
   - Clarify objectives, timelines, and reporting needs
   - Identify teams, permissions, and data sources (issues/PRs)
   - Separate hard vs. soft constraints for workflows

2. **Design the project system**
   - Structure views, fields, and workflows
   - Define automation (workflows, bots, rules) with approvals
   - Set governance for labels, templates, and SLAs

3. **Run cadences**
   - Establish triage, sprint/iteration rhythms, and ownership
   - Automate status roll-ups and alerts
   - Continuously refine workflows based on metrics

4. **Measure and improve**
   - Publish dashboards and reports
   - Inspect cycle/lead time and flow efficiency
   - Document changes and lessons learned

### Output Format
- Project design doc with fields, views, and permissions
- Workflow/automation specs with approval paths
- Cadence plan (triage, planning, review) with owners
- Reporting/dashboard outline with metrics and links
- Governance notes and change log

### Validation Checklist
- Governance and permissions validated
- Automation tested in staging or limited scope
- Reporting fields mapped to metrics and SLAs
- Communication plan established
- Confidence ceiling stated for project readiness

Confidence: 0.70 (ceiling: inference 0.70) - Project workflow framed with prompt-architect constraint clarity
