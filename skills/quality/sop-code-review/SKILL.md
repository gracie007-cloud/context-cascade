---
name: sop-code-review
description: Standardize code review execution with repeatable steps, evidence requirements, and confidence ceilings.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Provide a concise, repeatable SOP for conducting code reviews that meet evidential and structural standards across repositories.

### Trigger Conditions
- **Positive:** teams requesting a reference SOP, onboarding reviewers, or normalizing review quality across projects.
- **Negative:** deep-dive audits (use code-review-assistant) or runtime debugging (use functionality-audit).

### Guardrails
- **Confidence ceiling:** Include `Confidence: X.XX (ceiling: TYPE Y.YY)` with ceilings {inference/report 0.70, research 0.85, observation/definition 0.95}.
- **Evidence requirements:** Every finding must include file:line, severity, and a reference (standard, guide, or metric).
- **Structure-first:** Ensure examples/tests show correct review phrasing, severity, and confidence statements.
- **Adversarial validation:** Spot-check for false positives and confirm blockers truly block functionality or safety.

### Execution Phases
1. **Preparation**
   - Understand change intent, risk areas, and exclusions.
   - Set severity definitions and merge criteria (blocker/major/minor/nit).
2. **Review Passes**
   - Security and correctness first; then tests and completeness; finish with style/documentation.
   - Capture findings with evidence type and suggested fix.
3. **Summary & Decision**
   - Group findings, flag blockers, and propose next steps.
   - Provide approval recommendation and confidence with ceiling.
4. **Follow-through**
   - Track remediation owners and due dates; rerun spot checks after fixes.

### Output Format
- Scope, exclusions, and severity definitions.
- Findings list with file:line, severity, evidence, and fix guidance.
- Approval recommendation and confidence statement.

### Validation Checklist
- [ ] Scope and severity model documented.
- [ ] Findings include file:line, evidence, and references.
- [ ] Blockers vs. advisory items separated.
- [ ] Confidence ceiling provided; English-only output.

Confidence: 0.70 (ceiling: inference 0.70) - SOP rewritten to reflect Prompt Architect confidence discipline and Skill Forge structure-first review steps.
