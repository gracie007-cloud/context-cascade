---
name: when-reviewing-pull-request-orchestrate-comprehensive-code-review
description: Routing skill to orchestrate comprehensive PR reviews via code-review-assistant with evidential standards.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality/routing
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Ensure pull-request review requests are routed to `code-review-assistant` and carry forward the required guardrails, structure, and confidence rules.

### Trigger Conditions
- **Positive:** any request for a comprehensive pull-request review.
- **Negative:** platform-specific GitHub reviews (use `when-reviewing-github-pr-use-github-code-review`) or execution debugging (use functionality-audit).

### Guardrails
- **Confidence ceiling:** Include `Confidence: X.XX (ceiling: TYPE Y.YY)` with ceilings {inference/report 0.70, research 0.85, observation/definition 0.95}.
- **Evidence expectations:** Findings must include file:line, severity, and references.
- **Structure-first:** Verify `code-review-assistant` artifacts (examples/tests) are available; log gaps.

### Execution Phases
1. **Qualification**
   - Confirm the request is a comprehensive PR review; otherwise reroute.
2. **Guardrail Reminder**
   - Reiterate evidence, severity, and confidence requirements.
   - Note exclusions or priorities (security, performance, tests).
3. **Handoff**
   - Direct to `code-review-assistant` with context, repo link, and constraints.

### Output Format
- Routing confirmation with downstream skill.
- Guardrail summary and any priorities/exclusions.
- Confidence statement using ceiling syntax.

### Validation Checklist
- [ ] Task confirmed as comprehensive PR review.
- [ ] Guardrails restated; downstream skill identified.
- [ ] Confidence ceiling provided; English-only output.

Confidence: 0.70 (ceiling: inference 0.70) - Routing SOP rewritten with Prompt Architect confidence discipline and Skill Forge structure-first checks.
