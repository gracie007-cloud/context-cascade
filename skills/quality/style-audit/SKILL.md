---
name: style-audit
description: Evaluate style, readability, and documentation quality with evidence-backed findings and fix guidance.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Assess code style, naming, organization, and documentation to raise maintainability while respecting project conventions.

### Trigger Conditions
- **Positive:** pre-merge polish, refactoring support, documentation sweeps, or readability reviews.
- **Negative:** functionality debugging (use functionality-audit) or architectural coupling checks (use connascence-quality-gate).

### Guardrails
- **Confidence ceiling:** Add `Confidence: X.XX (ceiling: TYPE Y.YY)` with ceilings {inference/report 0.70, research 0.85, observation/definition 0.95}.
- **Evidence requirements:** Provide file:line, rule/reference (style guide, lint rule), and example fix.
- **Structure-first:** Keep `examples/` and `tests/` updated with preferred wording and format for findings.
- **Local conventions:** Respect project-specific standards; flag deviations separately from general best practices.

### Execution Phases
1. **Context & Standards**
   - Identify applicable style guides, lint rules, and documentation standards.
   - Note exceptions or overrides for the repository.
2. **Review Passes**
   - Naming & API clarity; comments and docs alignment.
   - Structure & readability (function size, duplication, complexity hints).
   - Documentation & developer experience (README, usage examples).
3. **Findings & Fixes**
   - Record issues with file:line, rule reference, and suggested rewrite or refactor.
   - Group by severity (blocker/major/minor/nit) and theme.
4. **Validation & Confidence**
   - Spot-check for false positives; ensure fixes do not change behavior.
   - Provide residual risks and confidence with ceiling.

### Output Format
- Scope and standards applied.
- Findings list with severity, evidence, and recommended fixes.
- Quick wins vs. structural refactors separated.
- Confidence statement using ceiling syntax.

### Validation Checklist
- [ ] Applicable standards identified; exceptions noted.
- [ ] Findings include file:line, rule reference, and fix guidance.
- [ ] Severity and behavior impact clarified.
- [ ] Confidence ceiling provided; output in English.

Confidence: 0.71 (ceiling: inference 0.70) - SOP rewritten per Prompt Architect confidence discipline and Skill Forge structure-first documentation.
