---
name: when-releasing-software-use-github-release-management
description: Route release requests to the github-release-management skill
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Ensure software releases follow the github-release-management SOP with approvals, automation, and rollback protections.

### Trigger Conditions
- **Positive:** Release planning or tagging; Changelog and artifact publication; Coordinated rollout across environments
- **Negative:** Pipeline incident recovery (route to cicd-intelligent-recovery); Project governance only (route to github-project-management); Single workflow edits (route to github-workflow-automation)

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
- release-management-process.dot

### Execution Phases
1. **Confirm release scope**
   - Validate request is release execution
   - List environments, approvals, and timelines
   - Redirect mismatched asks to correct skill

2. **Package context**
   - Link repos, changes, risks, and owners
   - Reference github-release-management SKILL and runbooks
   - Capture rollback expectations

3. **Plan checkpoints**
   - Set gates for tagging/building/publishing
   - Define communication cadence and escalation
   - State confidence ceiling expectations

4. **Track completion**
   - Record execution evidence and outcomes
   - Note incidents or deviations
   - Update MCP trace with residual risks

### Output Format
- Routing confirmation to github-release-management
- Release context packet (repos, risks, approvals)
- Checkpoint plan with gates and communications
- Completion summary with evidence and risks

### Validation Checklist
- Scope confirmed as release work
- Approvals and risks captured
- Checkpoints and comms defined
- Confidence ceiling reiterated
- MCP traceability recorded

Confidence: 0.70 (ceiling: inference 0.70) - Routing SOP keeps releases on the dedicated skill path
