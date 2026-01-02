---
name: when-reviewing-github-pr-use-github-code-review
description: Routing skill that ensures GitHub PR reviews use the GitHub Code Review SOP with evidential standards.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality/routing
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Direct PR review requests to the `github-code-review` skill and restate the essential guardrails and outputs expected for GitHub reviews.

### Trigger Conditions
- **Positive:** any request to review a GitHub pull request or provide merge feedback.
- **Negative:** non-GitHub platforms or non-review tasks (route accordingly).

### Guardrails
- **Confidence ceiling:** Provide `Confidence: X.XX (ceiling: TYPE Y.YY)` using ceilings {inference/report 0.70, research 0.85, observation/definition 0.95}.
- **Evidence expectations:** Require file:line references, severity, and supporting standards for each finding.
- **Structure-first:** Confirm `github-code-review` artifacts (examples/tests) are present before routing.

### Execution Phases
1. **Route & Confirm**
   - Confirm the task is GitHub PR review; if yes, hand off to `github-code-review`.
   - If not applicable, suggest the correct skill (code-review-assistant, functionality-audit, etc.).
2. **Remind Guardrails**
   - Restate evidence, severity, and confidence ceiling requirements.
   - Ensure English-only, concise review output.
3. **Handoff**
   - Provide the link or branch info and any exclusions to the downstream skill.

### Output Format
- Routing confirmation and downstream skill name.
- Quick reminder of evidence/format requirements.
- Confidence statement using ceiling syntax.

### Validation Checklist
- [ ] Platform confirmed as GitHub.
- [ ] Downstream skill identified and guardrails restated.
- [ ] Confidence ceiling provided; English-only output.

Confidence: 0.70 (ceiling: inference 0.70) - Routing SOP rewritten with Prompt Architect confidence discipline and Skill Forge structure-first checks.
