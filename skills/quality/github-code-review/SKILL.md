---
name: github-code-review
description: Execute evidence-backed GitHub PR reviews with severity tagging, references, and merge-blocking guidance.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Provide a GitHub-native code review that cites file:line evidence, maps to standards, and outputs actionable comments or summaries suitable for PR discussion threads.

### Trigger Conditions
- **Positive:** reviewing GitHub PRs, generating review summaries, or preparing merge-blocking feedback.
- **Negative:** single-file lint fixes or runtime debugging (route to functionality-audit).

### Guardrails
- **Confidence ceiling:** Include `Confidence: X.XX (ceiling: TYPE Y.YY)` with ceilings {inference/report 0.70, research 0.85, observation/definition 0.95}.
- **Evidence discipline:** Each comment must include file:line, severity (blocker/major/minor/nit), and a reference (style guide, security rule, performance budget).
- **Structure-first:** Keep `examples/` and `tests/` aligned with GitHub review formats (inline comments and summaries).
- **Adversarial validation:** Re-check for false positives; mark ambiguous items as “needs maintainer confirmation.”

### Execution Phases
1. **Scope & Context**
   - Identify PR intent, risk areas, and excluded paths (generated/vendor).
   - Determine which findings are merge-blocking vs. advisory.
2. **Review Passes**
   - Pass 1: High-risk scan (security, data integrity, migrations).
   - Pass 2: Correctness and test adequacy.
   - Pass 3: Performance, maintainability, readability.
3. **Evidence & Comment Drafting**
   - For each finding, capture file:line, evidence type, severity, and fix guidance.
   - Group related issues to reduce comment noise.
4. **Summary & Confidence**
   - Provide an overall recommendation (approve/request-changes/comment) with rationale.
   - State residual risks and confidence with explicit ceiling.

### Output Format
- Per-finding entries with severity, file:line, evidence type, and references.
- Consolidated PR summary with blockers and follow-ups.
- Confidence statement using ceiling syntax.

### Validation Checklist
- [ ] Scope, exclusions, and merge criteria documented.
- [ ] Findings include file:line, severity, and references.
- [ ] Blockers vs. advisories separated; noise minimized.
- [ ] Confidence ceiling provided; output in English.

Confidence: 0.72 (ceiling: inference 0.70) - SOP rewritten with Prompt Architect confidence discipline and Skill Forge structure-first review steps.
