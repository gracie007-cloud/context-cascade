# Routing Process: Theater Detection

1. **Qualify the request** – Ensure the objective is detecting stubs/placeholders/mock data; otherwise reroute.
2. **Activate guardrails** – Require file:line evidence, snippet context, classification, and confidence ceiling.
3. **Package context** – Provide relevant files, high-risk paths, and exclusions.
4. **Hand off to `theater-detection-audit`** – Trigger the SOP and share needed artifacts.
5. **Close** – Capture outcomes, waivers, and `Confidence: X.XX (ceiling: TYPE Y.YY)`.

Confidence: 0.70 (ceiling: inference 0.70) – Process rewritten to reflect Prompt Architect confidence discipline and Skill Forge structure-first routing.
