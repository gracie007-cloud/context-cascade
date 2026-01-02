---
name: github-multi-repo
description: Coordinate changes across multiple GitHub repositories with traceable automation
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Plan and execute cross-repo initiatives with dependency mapping, batched changes, and safe rollout controls.

### Trigger Conditions
- **Positive:** Changes spanning multiple repositories; Dependency alignment across repos; Fleetwide automation in GitHub
- **Negative:** Single-repo workflow automation (route to github-workflow-automation); Release-specific orchestration (route to github-release-management); Project roadmap governance (route to github-project-management)

### Guardrails
- Structure-first: keep SKILL.md aligned with examples/, tests/, and any resources/references so downstream agents always have scaffolding.
- Adversarial validation is mandatory: cover boundary cases, failure paths, and rollback drills before declaring the SOP complete.
- Prompt hygiene: separate hard vs. soft vs. inferred constraints and confirm inferred constraints before acting.
- Explicit confidence ceilings: format as 'Confidence: X.XX (ceiling: TYPE Y.YY)' and never exceed the ceiling for the claim type.
- MCP traceability: tag sessions WHO=operations-{name}-{session_id}, WHY=skill-execution, and capture evidence links in outputs.
- Avoid anti-patterns: undocumented changes, missing rollback paths, skipped tests, or unbounded automation without approvals.

### Required Artifacts
- SKILL.md (this SOP)
- readme.md quickstart
- examples/ for swarm operations
- tests/ for scripts
- resources/ for shared helpers

### Execution Phases
1. **Map the fleet**
   - Enumerate repos, owners, and protection rules
   - Gather dependency graph and shared components
   - Bucket repositories by risk and sequencing

2. **Plan propagation**
   - Design batch/rolling strategy with pause and rollback gates
   - Prepare templates and shared scripts for repeatability
   - Secure approvals for protected branches and environments

3. **Execute coordinated changes**
   - Run dry-run on sample repos before full rollout
   - Automate changes with clear logging and per-repo status
   - Escalate blockers and adapt batches based on outcomes

4. **Validate and communicate**
   - Track PR/check status, tests, and merge criteria
   - Publish status dashboards and updates
   - Document lessons and next steps

### Output Format
- Repository map with dependencies and risk tiers
- Batching plan with sequencing, approvals, and rollback gates
- Automation artifacts and templates with usage notes
- Status/communication log with PRs and evidence
- Post-action report with residual risks and follow-ups

### Validation Checklist
- Repositories and branch protections accounted for
- Dry-run completed on sample set with results logged
- Required tests/checks passing per repo
- Communications and escalation paths active
- Confidence ceiling stated for rollout stage

Confidence: 0.70 (ceiling: inference 0.70) - Cross-repo SOP mirrors skill-forge structure with staged validation
