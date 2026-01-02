# Dogfooding System Index

Use this index to select dogfooding tracks and tag artifacts consistently.

## Session Types
- **Self-application:** Apply a target skill to itself to measure drift and convergence.
- **Cross-application:** Use one quality skill to pressure-test another (e.g., style-audit on functionality-audit outputs).
- **Adversarial probes:** Inject boundary inputs, noisy data, and negative cases to break assumptions.
- **Regression runs:** Replay prior sessions to confirm fixes hold and deltas stay <2%.

## Tagging & Storage
- Namespace: `skills/quality/dogfooding-system/{skill}/{date}`
- Tags: `WHO=dogfooding-system-{session}` `WHY=quality-improvement` `SCOPE={skill}` `RUN_TYPE={self|cross|adversarial|regression}`

## Quick Reminders
- Always cite evidence (file:line, log excerpt, metric) and include a confidence ceiling.
- Update `references/` with new heuristics; mirror changes into `tests/` when stabilized.
- Keep outputs in English and summarize residual risks before closure.

Confidence: 0.70 (ceiling: inference 0.70) – Index aligned to Prompt Architect evidence and Skill Forge structure-first rules.
