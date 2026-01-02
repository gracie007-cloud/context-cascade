---
name: when-detecting-fake-code-use-theater-detection
description: Route fake-code/theater investigations to the Theater Detection Audit SOP.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality/routing
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Ensure tasks about detecting stubs, placeholders, or mock implementations are handled by `theater-detection-audit` with proper evidence and confidence rules.

### Trigger Conditions
- **Positive:** suspicion of fake code, mock data leaking to prod, or pre-audit sweeps for theater.
- **Negative:** style-only feedback (use style-audit) or runtime debugging (use functionality-audit).

### Guardrails
- **Confidence ceiling:** Add `Confidence: X.XX (ceiling: TYPE Y.YY)` using ceilings {inference/report 0.70, research 0.85, observation/definition 0.95}.
- **Evidence expectations:** Require file:line plus snippet context and classification (blocker/risky/intentional).
- **Structure-first:** Confirm `theater-detection-audit` examples/tests exist; log gaps.

### Execution Phases
1. **Qualify** – Confirm the task is about detecting theater; reroute if not.
2. **Remind Guardrails** – Evidence, classification, and confidence ceiling.
3. **Handoff** – Supply scope, high-risk paths, and exclusions to `theater-detection-audit`.

### Output Format
- Routing confirmation with downstream skill.
- Guardrail summary and scope notes.
- Confidence statement using ceiling syntax.

### Validation Checklist
- [ ] Theater detection confirmed as the goal.
- [ ] Guardrails restated; downstream skill identified.
- [ ] Confidence ceiling provided; English-only output.

Confidence: 0.70 (ceiling: inference 0.70) – Routing SOP aligned with Prompt Architect confidence discipline and Skill Forge structure-first routing.
