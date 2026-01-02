---
name: when-reviewing-code-comprehensively-use-code-review-assistant
description: Route comprehensive code reviews to the Code Review Assistant SOP with evidential guardrails.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality/routing
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Direct comprehensive code review requests to `code-review-assistant` while reiterating evidence, severity, and confidence expectations.

### Trigger Conditions
- **Positive:** requests for full-spectrum reviews across security, correctness, performance, tests, and style.
- **Negative:** platform-specific GitHub-only reviews (use the GitHub router) or narrow debugging tasks.

### Guardrails
- **Confidence ceiling:** Provide `Confidence: X.XX (ceiling: TYPE Y.YY)` using ceilings {inference/report 0.70, research 0.85, observation/definition 0.95}.
- **Evidence expectations:** Findings need file:line, severity, and reference.
- **Structure-first:** Confirm `code-review-assistant` examples/tests are present; log gaps.

### Execution Phases
1. **Confirm Fit** – Validate that a comprehensive review is requested; reroute otherwise.
2. **Restate Guardrails** – Evidence, severity model, English-only output, and confidence ceilings.
3. **Handoff** – Provide PR info, priorities, and exclusions to `code-review-assistant`.

### Output Format
- Routing confirmation and downstream skill.
- Guardrail summary and scope/priorities.
- Confidence statement using ceiling syntax.

### Validation Checklist
- [ ] Comprehensive review confirmed.
- [ ] Guardrails restated; downstream skill identified.
- [ ] Confidence ceiling provided; English-only output.

Confidence: 0.70 (ceiling: inference 0.70) – Routing SOP rewritten with Prompt Architect confidence discipline and Skill Forge structure-first routing.
