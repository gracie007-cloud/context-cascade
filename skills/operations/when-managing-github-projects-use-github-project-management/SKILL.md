---
name: when-managing-github-projects-use-github-project-management
description: Route GitHub project management asks to the dedicated skill
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Ensure GitHub project governance uses the github-project-management SOP with clear automation and reporting guardrails.

### Trigger Conditions
- **Positive:** Requests to organize work in GitHub Projects; Need governance, workflows, or reporting in Projects; Desire for automation around issues/PRs and fields
- **Negative:** Release execution (route to github-release-management); Cross-repo code campaigns (route to github-multi-repo); Single workflow tweaks (route to github-workflow-automation)

### Guardrails
- Structure-first: keep SKILL.md aligned with examples/, tests/, and any resources/references so downstream agents always have scaffolding.
- Adversarial validation is mandatory: cover boundary cases, failure paths, and rollback drills before declaring the SOP complete.
- Prompt hygiene: separate hard vs. soft vs. inferred constraints and confirm inferred constraints before acting.
- Explicit confidence ceilings: format as 'Confidence: X.XX (ceiling: TYPE Y.YY)' and never exceed the ceiling for the claim type.
- MCP traceability: tag sessions WHO=operations-{name}-{session_id}, WHY=skill-execution, and capture evidence links in outputs.
- Avoid anti-patterns: undocumented changes, missing rollback paths, skipped tests, or unbounded automation without approvals.

### Required Artifacts
- SKILL.md (routing SOP)
- metadata.json
- project-management-process.dot

### Execution Phases
1. **Identify intent**
   - Confirm the request matches GitHub Projects usage
   - List constraints and reporting needs
   - Redirect non-project asks to proper skills

2. **Prepare context**
   - Link to github-project-management SKILL and readme
   - Gather repos/boards, permissions, and current workflows
   - Capture success metrics expected

3. **Plan engagement**
   - Define milestones and automation needs
   - Set checkpoints and owners
   - Confirm confidence ceiling communication

4. **Validate routing**
   - Ensure governance/security considerations noted
   - Document communication plan
   - Record completion and residual risks

### Output Format
- Routing confirmation to github-project-management
- Context packet (repos, workflows, permissions, metrics)
- Engagement plan with checkpoints and owners
- Completion note with confidence statement

### Validation Checklist
- Non-qualifying asks rerouted appropriately
- Permissions/governance considerations captured
- Checkpoints and metrics defined
- Confidence ceiling stated
- MCP traceability recorded

Confidence: 0.70 (ceiling: inference 0.70) - Routing SOP keeps constraints explicit per prompt-architect guidance
