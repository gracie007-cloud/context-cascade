---
name: theater-detection-audit
description: Detect fake or placeholder code (theater) and ensure real implementations replace stubs before deeper audits.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Identify theater—mock data, hardcoded responses, TODOs, stubs, or dead code—that could mask real functionality gaps before testing or styling work proceeds.

### Trigger Conditions
- **Positive:** pre-release sweeps, onboarding to unfamiliar code, or before running functionality/style audits.
- **Negative:** runtime debugging of known features (use functionality-audit) or style-only passes (use style-audit).

### Guardrails
- **Confidence ceiling:** Include `Confidence: X.XX (ceiling: TYPE Y.YY)` using ceilings {inference/report 0.70, research 0.85, observation/definition 0.95}.
- **Evidence-first:** Cite file:line with snippet context; distinguish intentional scaffolding from regressions.
- **Structure-first:** Maintain examples/tests showing true positives, intentional fakes, and clean code for contrast.
- **Escalation:** Block downstream audits on unresolved blockers or document waivers with owners.

### Execution Phases
1. **Scan & Detection**
   - Search for TODO/FIXME, stubbed functions, hardcoded returns, placeholder data, unreachable branches.
   - Note test doubles leaking into production paths.
2. **Classification**
   - Label each finding as blocker, risky, or intentional (with rationale and expiry).
   - Map impact to downstream audits (functionality, performance, security).
3. **Remediation Guidance**
   - Recommend concrete replacements (real integrations, data sources, error handling) and owners.
4. **Validation & Confidence**
   - Revisit after fixes; confirm removal or proper gating.
   - Provide residual risks and confidence with ceiling.

### Output Format
- List of theater findings with file:line, classification, and context snippet.
- Recommended fixes and blocking status.
- Waivers with expiry and owner, if any.
- Confidence statement using ceiling syntax.

### Validation Checklist
- [ ] Theater patterns scanned and documented.
- [ ] Intentional vs. accidental theater distinguished.
- [ ] Remediation steps and blockers recorded.
- [ ] Confidence ceiling provided; English-only output.

Confidence: 0.72 (ceiling: inference 0.70) - SOP rewritten to align with Prompt Architect confidence discipline and Skill Forge structure-first detection.
