---
name: when-testing-code-use-testing-framework
description: SOP for running the testing framework to validate code changes with reproducible commands and evidence.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality/testing
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Guide reviewers and developers to execute the testing framework for code validation, ensuring evidence capture, reproducibility, and confidence ceilings.

### Trigger Conditions
- **Positive:** validating changes before merge, reproducing reported bugs, or establishing baselines for new features.
- **Negative:** style-only polish (use style-audit) or verification of claims without execution (use verification-quality).

### Guardrails
- **Confidence ceiling:** Include `Confidence: X.XX (ceiling: TYPE Y.YY)` using ceilings {inference/report 0.70, research 0.85, observation/definition 0.95}.
- **Reproducibility:** Document commands, environment, fixtures, and seeds; attach logs.
- **Structure-first:** Maintain `readme.md`, `process.md`, and scripts to run/generate tests; keep examples/tests synced with the current framework.
- **Adversarial validation:** Run boundary/negative cases in addition to happy paths.

### Execution Phases
1. **Setup**
   - Review `readme.md` and scripts (`slash-command-test-run.sh`, `slash-command-test-generate.sh`).
   - Prepare environment per `subagent-testing-framework.md` and ensure dependencies are installed.
2. **Test Selection & Generation**
   - Identify suites relevant to the change; generate missing cases using provided scripts if needed.
3. **Execution**
   - Run tests with reproducible commands; capture outputs and failures with file:line references.
   - Re-run flaky tests to confirm stability; note nondeterminism.
4. **Reporting & Confidence**
   - Summarize pass/fail counts, failing cases, and reproduction steps.
   - Recommend fixes or reruns; provide confidence with ceiling.

### Output Format
- Environment and commands used.
- Test results (pass/fail, logs, failing file:line).
- Flaky cases and follow-up actions.
- Confidence statement using ceiling syntax.

### Validation Checklist
- [ ] Environment and dependencies prepared.
- [ ] Relevant suites selected and/or generated.
- [ ] Tests executed with logs captured; flakiness noted.
- [ ] Confidence ceiling provided; English-only output.

Confidence: 0.72 (ceiling: inference 0.70) – SOP rewritten using Prompt Architect confidence discipline and Skill Forge structure-first testing workflow.
