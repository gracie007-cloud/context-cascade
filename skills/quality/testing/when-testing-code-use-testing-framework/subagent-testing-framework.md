# Subagent Notes: Testing Framework

- **Scope:** Use this guidance when invoking the testing framework as a subagent.
- **Environment:** Match the primary agent’s environment (versions, env vars, secrets). Document any deviations.
- **Commands:** Prefer the provided scripts (`slash-command-test-run.sh`, `slash-command-test-generate.sh`) and log full stdout/stderr.
- **Evidence:** Capture failing cases with file:line and reproduction commands. Store logs under the project namespace.
- **Confidence:** Report `Confidence: X.XX (ceiling: TYPE Y.YY)` using ceilings {inference/report 0.70, research 0.85, observation/definition 0.95}. Never omit the ceiling.
- **Handoff:** Return summaries in English only, highlighting blockers vs. follow-ups.

Confidence: 0.70 (ceiling: inference 0.70) – Notes refreshed with Prompt Architect confidence discipline and Skill Forge structure-first expectations.
