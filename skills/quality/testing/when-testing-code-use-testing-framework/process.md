# Testing Framework Process

1. **Prepare**
   - Read `SKILL.md` and `subagent-testing-framework.md` for dependencies and environment setup.
   - Export necessary variables and ensure required tools are installed.
2. **Select or Generate Tests**
   - Identify suites impacted by the change.
   - Use `slash-command-test-generate.sh` to create missing cases if needed.
3. **Execute**
   - Run `slash-command-test-run.sh` (or equivalent commands) and capture full logs.
   - Re-run failing or flaky tests to confirm behavior; note nondeterminism.
4. **Report**
   - Summarize pass/fail counts, failing cases (file:line), and reproduction commands.
   - Recommend fixes or reruns; include `Confidence: X.XX (ceiling: TYPE Y.YY)`.

Confidence: 0.70 (ceiling: inference 0.70) – Process rewritten using Prompt Architect confidence discipline and Skill Forge structure-first flow.
