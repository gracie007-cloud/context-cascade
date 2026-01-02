---
name: sop-product-launch
description: Run product launches with coordinated go-to-market, operations, and risk controls
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Plan and execute product launches with aligned objectives, cross-functional readiness, and clear contingency paths.

### Trigger Conditions
- **Positive:** Product or feature launch planning; Cross-functional launch readiness; Need launch communications and risk plan
- **Negative:** Pure engineering release with no GTM (route to github-release-management); Ongoing incident handling (route to cicd-intelligent-recovery); Ops maturity review without launch (route to production-readiness)

### Guardrails
- Structure-first: keep SKILL.md aligned with examples/, tests/, and any resources/references so downstream agents always have scaffolding.
- Adversarial validation is mandatory: cover boundary cases, failure paths, and rollback drills before declaring the SOP complete.
- Prompt hygiene: separate hard vs. soft vs. inferred constraints and confirm inferred constraints before acting.
- Explicit confidence ceilings: format as 'Confidence: X.XX (ceiling: TYPE Y.YY)' and never exceed the ceiling for the claim type.
- MCP traceability: tag sessions WHO=operations-{name}-{session_id}, WHY=skill-execution, and capture evidence links in outputs.
- Avoid anti-patterns: undocumented changes, missing rollback paths, skipped tests, or unbounded automation without approvals.

### Required Artifacts
- SKILL.md (this SOP)
- metadata.json
- Add examples/tests/resources during execution if missing

### Execution Phases
1. **Align goals and constraints**
   - Capture launch objectives, audiences, and success metrics
   - List dependencies (product, marketing, support, ops)
   - Confirm budget, channels, and timelines

2. **Plan the launch**
   - Design run sheet with milestones, owners, and approvals
   - Prepare assets, messaging, and instrumentation
   - Define risk matrix with triggers and contingency actions

3. **Rehearse and harden**
   - Run dry runs or canaries
   - Validate support/readiness (runbooks, on-call, comms)
   - Lock fallback and rollback procedures

4. **Execute and review**
   - Launch with live monitoring and comms cadence
   - Capture metrics vs. targets
   - Run post-launch review and assign follow-ups

### Output Format
- Launch brief with objectives, metrics, and audiences
- Run sheet with milestones, owners, and approvals
- Communications and asset checklist
- Risk and contingency plan with triggers
- Post-launch report with metrics and follow-ups

### Validation Checklist
- Owners and approvals assigned for each milestone
- Contingency/rollback communications ready
- Monitoring and support coverage confirmed
- Launch metrics and success criteria defined
- Confidence ceiling stated for launch go/no-go

Confidence: 0.70 (ceiling: inference 0.70) - Launch SOP mirrors skill-forge structure with rehearsals and fallbacks
