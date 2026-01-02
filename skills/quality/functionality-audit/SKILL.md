---
name: functionality-audit
description: Validate that code actually works by executing targeted tests, tracing failures, and prescribing fixes with evidence.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Assess functional correctness through sandbox execution, targeted probes, and iterative remediation. Prioritize reproducibility and evidential reporting.

### Trigger Conditions
- **Positive:** verifying behavior before release, debugging regressions, or confirming fixes after refactors.
- **Negative:** style-only reviews, architecture-level coupling checks (route to connascence-quality-gate), or documentation-only tasks.

### Guardrails
- **Confidence ceiling:** Use `Confidence: X.XX (ceiling: TYPE Y.YY)` with ceilings {inference/report 0.70, research 0.85, observation/definition 0.95}.
- **Evidence & reproducibility:** Provide commands, inputs, outputs, and environment notes for every finding.
- **Structure-first:** Keep `examples/` and `tests/` synchronized with current harnesses and fixtures.
- **Adversarial validation:** Include negative, boundary, and flaky-case probes; mark nondeterminism explicitly.
- **English-only output:** No VCL markers in user-facing text.

### Execution Phases
1. **Intake & Scoping**
   - Identify target components, entry points, and known failures; gather dependencies.
   - Exclude generated/vendor code unless it affects execution.
2. **Environment & Harness Prep**
   - Stand up sandbox or test harness; document commands and fixtures.
   - Mirror existing CI scripts when possible to ensure parity.
3. **Test Execution & Tracing**
   - Run happy-path tests first, then boundary and negative cases.
   - Capture logs, stack traces, and side effects; map to file:line when possible.
4. **Remediation & Re-test**
   - Propose fixes with rationale; rerun targeted tests to confirm resolution.
   - Track flaky behavior separately with reproduction steps.
5. **Validation & Reporting**
   - Summarize outcomes, remaining issues, and risk level.
   - Provide confidence statement with ceiling and explicit reproducibility notes.

### Output Format
- Scope, environment, and commands used.
- Finding list with reproduction steps, expected vs. actual results, and file:line pointers.
- Fix recommendations and retest results.
- Residual risks, flaky cases, and confidence statement.

### Validation Checklist
- [ ] Scope and exclusions captured with environment setup.
- [ ] Happy-path, boundary, and negative tests executed or justified.
- [ ] Reproduction steps and evidence recorded for each issue.
- [ ] Retests performed after proposed fixes (or blockers noted).
- [ ] Confidence ceiling provided; output in English.

Confidence: 0.73 (ceiling: inference 0.70) - SOP rewritten using Prompt Architect confidence discipline and Skill Forge structure-first validation.
