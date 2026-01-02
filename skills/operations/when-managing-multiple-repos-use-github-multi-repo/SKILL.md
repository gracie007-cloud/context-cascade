---
name: when-managing-multiple-repos-use-github-multi-repo
description: Route multi-repo GitHub work to the github-multi-repo skill
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Ensure cross-repo initiatives use the github-multi-repo SOP with batching, approvals, and rollback guardrails.

### Trigger Conditions
- **Positive:** Coordinated changes across several repos; Fleetwide dependency or policy updates; Need batched automation with approvals
- **Negative:** Single repo workflows (route to github-workflow-automation); Release-only orchestration (route to github-release-management); Project board setup (route to github-project-management)

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
- multi-repo-process.dot

### Execution Phases
1. **Confirm scope**
   - Validate request spans multiple repositories
   - Capture constraints, risks, and deadlines
   - Route mismatches to the right skill

2. **Assemble context**
   - Collect repo lists, owners, protections, and dependencies
   - Reference github-multi-repo SKILL and templates
   - Clarify success criteria and rollback posture

3. **Coordinate execution**
   - Set batches, approvals, and checkpoints
   - Align communications and escalation paths
   - Maintain confidence ceiling messaging

4. **Close out**
   - Record outcomes and evidence
   - Note residual risks and follow-ups
   - Update MCP logs for traceability

### Output Format
- Routing confirmation to github-multi-repo
- Repo/dependency context packet
- Execution plan with batches and approvals
- Completion summary with evidence and risks

### Validation Checklist
- Scope validated as multi-repo
- Repo protections and approvals accounted for
- Checkpoints and communication defined
- Confidence ceiling applied to readiness calls
- MCP traceability recorded

Confidence: 0.70 (ceiling: inference 0.70) - Routing SOP mirrors skill-forge guardrails for cross-repo work
