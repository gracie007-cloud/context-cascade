---
name: when-validating-code-works-use-functionality-audit
description: Route correctness validation tasks to the Functionality Audit SOP with reproducibility guardrails.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality/routing
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Direct requests to validate that code works into `functionality-audit`, preserving evidence, reproducibility, and confidence requirements.

### Trigger Conditions
- **Positive:** confirming behavior after changes, debugging regressions, or validating fixes.
- **Negative:** style-only reviews (use style-audit) or GitHub-specific review routing.

### Guardrails
- **Confidence ceiling:** Add `Confidence: X.XX (ceiling: TYPE Y.YY)` using ceilings {inference/report 0.70, research 0.85, observation/definition 0.95}.
- **Evidence expectations:** Require reproduction steps, commands, inputs/outputs, and file:line mapping when possible.
- **Structure-first:** Confirm `functionality-audit` examples/tests exist; log gaps.

### Execution Phases
1. **Qualify** – Ensure the goal is validating functionality; reroute otherwise.
2. **Restate Guardrails** – Evidence, reproducibility, and confidence requirements.
3. **Handoff** – Provide scope, environment notes, and known failures to `functionality-audit`.

### Output Format
- Routing confirmation and downstream skill.
- Guardrail reminder and scope/environment notes.
- Confidence statement using ceiling syntax.

### Validation Checklist
- [ ] Functionality validation confirmed.
- [ ] Guardrails restated; downstream skill identified.
- [ ] Confidence ceiling provided; English-only output.

Confidence: 0.70 (ceiling: inference 0.70) – Routing SOP rewritten to reflect Prompt Architect confidence discipline and Skill Forge structure-first routing.
