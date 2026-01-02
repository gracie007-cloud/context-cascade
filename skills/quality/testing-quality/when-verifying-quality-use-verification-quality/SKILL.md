---
name: when-verifying-quality-use-verification-quality
description: Route quality verification tasks to the Verification Quality SOP with constraint and evidence guardrails.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality/routing
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Ensure verification tasks (checking accuracy, grounding, or policy compliance) are handled by `verification-quality` with proper constraint handling and confidence ceilings.

### Trigger Conditions
- **Positive:** verifying claims, outputs, or analyses; confirming adherence to requirements or policies.
- **Negative:** code execution debugging or style-only reviews (use other skills accordingly).

### Guardrails
- **Confidence ceiling:** Provide `Confidence: X.XX (ceiling: TYPE Y.YY)` using ceilings {inference/report 0.70, research 0.85, observation/definition 0.95}.
- **Evidence expectations:** Map claims to sources; categorize constraints as hard/soft/inferred and flag unresolved inferences.
- **Structure-first:** Confirm `verification-quality` examples/tests exist; log gaps.

### Execution Phases
1. **Qualify** – Confirm the request is verification/grounding; reroute otherwise.
2. **Restate Guardrails** – Evidence mapping, constraint categories, and confidence ceilings.
3. **Handoff** – Provide scope, sources, and policies to `verification-quality`.

### Output Format
- Routing confirmation and downstream skill.
- Guardrail summary and scope/sources.
- Confidence statement using ceiling syntax.

### Validation Checklist
- [ ] Verification scope confirmed.
- [ ] Guardrails restated; downstream skill identified.
- [ ] Confidence ceiling provided; English-only output.

Confidence: 0.70 (ceiling: inference 0.70) – Routing SOP rewritten with Prompt Architect confidence discipline and Skill Forge structure-first routing.
