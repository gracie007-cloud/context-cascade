---
name: quick-quality-check
description: Fast, evidence-backed quality scan for small diffs or time-boxed reviews.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Deliver a concise quality sweep when time or scope is limited, ensuring high-signal findings with clear evidence and confidence ceilings.

### Trigger Conditions
- **Positive:** small PRs, hotfix reviews, or pre-merge spot checks.
- **Negative:** large rewrites or release audits (use holistic-evaluation or audit-pipeline).

### Guardrails
- **Confidence ceiling:** Include `Confidence: X.XX (ceiling: TYPE Y.YY)` using ceilings {inference/report 0.70, research 0.85, observation/definition 0.95}.
- **Evidence minimal but sufficient:** Each finding must include file:line and brief rationale; avoid speculative claims.
- **Scope discipline:** Cap to top N (e.g., 5) highest-severity findings; note what was not reviewed.
- **Structure-first:** Maintain examples/tests that illustrate constrained reviews and reporting templates.

### Execution Phases
1. **Scope & Constraints**
   - Time-box and define max findings; state excluded areas.
   - Identify risk hot spots (security-sensitive, complex functions, migrations).
2. **Focused Review Pass**
   - Scan diffs for obvious regressions, risky patterns, and missing tests.
   - Prioritize blockers: security, correctness, data integrity.
3. **Reporting**
   - Document findings with file:line, severity, and succinct fixes.
   - State skipped areas and recommend deeper audits if needed.
4. **Confidence & Handoff**
   - Provide residual risk summary and confidence with ceiling.

### Output Format
- Scope/time-box declaration and exclusions.
- Short list of findings (severity, file:line, rationale, fix).
- Uncovered areas and recommendations for follow-up.
- Confidence statement using ceiling syntax.

### Validation Checklist
- [ ] Scope/time-box recorded; exclusions noted.
- [ ] Findings include file:line and severity with evidence.
- [ ] High-risk areas prioritized; skipped areas listed.
- [ ] Confidence ceiling provided; English-only output.

Confidence: 0.71 (ceiling: inference 0.70) - SOP rewritten to reflect Prompt Architect confidence discipline and Skill Forge structure-first reporting.
