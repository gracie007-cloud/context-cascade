---
name: when-auditing-code-style-use-style-audit
description: Route style-focused reviews to the Style Audit SOP with evidence and confidence requirements.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality/routing
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Ensure style-focused review requests are handled by `style-audit`, carrying forward evidential and confidence guardrails.

### Trigger Conditions
- **Positive:** requests to check naming, readability, documentation, or code organization.
- **Negative:** functionality debugging (use functionality-audit) or platform-specific GitHub reviews (use github-code-review route).

### Guardrails
- **Confidence ceiling:** Provide `Confidence: X.XX (ceiling: TYPE Y.YY)` using ceilings {inference/report 0.70, research 0.85, observation/definition 0.95}.
- **Evidence expectations:** Findings must include file:line, rule/reference, and suggested fix.
- **Structure-first:** Confirm `style-audit` examples/tests are available; log gaps.

### Execution Phases
1. **Confirm Fit**
   - Verify the request is style/readability/doc focused; otherwise reroute.
2. **Remind Guardrails**
   - Restate evidence and confidence requirements for `style-audit`.
3. **Handoff**
   - Provide relevant files/paths and priorities to `style-audit`.

### Output Format
- Routing confirmation and downstream skill.
- Guardrail summary and scope notes.
- Confidence statement using ceiling syntax.

### Validation Checklist
- [ ] Task qualified as style-focused.
- [ ] Guardrails restated; downstream skill identified.
- [ ] Confidence ceiling provided; English-only output.

Confidence: 0.70 (ceiling: inference 0.70) – Routing SOP aligned with Prompt Architect confidence discipline and Skill Forge structure-first cues.
