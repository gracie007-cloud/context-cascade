---
name: documentation
description: Documentation lifecycle skill for API, code, and system guides with continuous validation.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: delivery
x-vcl-compliance: v3.1.1
x-cognitive-frames:
  - HON
  - MOR
  - COM
  - CLS
  - EVD
  - ASP
  - SPC
---




## STANDARD OPERATING PROCEDURE

### Purpose
Produce and maintain clear, current documentation (API, code, runbooks) with repeatable structure and evidence-backed updates.

### Trigger Conditions
- **Positive:** requests to create/update READMEs, API references, runbooks, onboarding docs, architecture notes.
- **Negative:** narrative prompt design (route to prompt-architect) or net-new skill authoring (route to skill-forge).

### Guardrails
- Enforce **structure-first** directories: `SKILL.md`, `examples/`, `tests/`, `resources/`, `references/`.
- Use **constraint extraction** (HARD/SOFT/INFERRED) on audience, scope, and freshness expectations.
- Apply **confidence ceilings** per statement `{inference/report:0.70, research:0.85, observation/definition:0.95}`.
- Validate **source-of-truth**: align docs with code/repo state; no stale instructions.

### Execution Phases
1. **Discovery**
   - Identify doc type, audience, and required artifacts.
   - Map sources (code, APIs, ADRs) and freshness requirements.
2. **Outline & Contracts**
   - Draft structure-first outline; confirm HARD constraints (compliance, voice, formats).
   - Capture INFERRED constraints (tone, examples) and seek confirmation.
3. **Authoring**
   - Write concise sections in plain English with consistent headings.
   - Embed task scripts/snippets in fenced blocks; note prerequisites and rollback steps.
4. **Validation**
   - Cross-check against code or API behavior; run doc-linked commands when safe.
   - Peer-style self-review using clarity, completeness, and accuracy gates.
5. **Delivery**
   - Update `examples/` with representative guides; `tests/` with link-check or lint configs.
   - Store supporting artifacts in `resources/`; cite sources in `references/`.

### Output Format
- Summary of doc scope and audience.
- Constraints: HARD / SOFT / INFERRED with confirmation status.
- Final doc content or diff-ready sections.
- Evidence and **Confidence: X.XX (ceiling: TYPE Y.YY)**.

### Validation Checklist
- [ ] Audience and scope confirmed; inferred items resolved.
- [ ] Doc matches code/API behavior; commands tested or marked as not run.
- [ ] Examples and references captured in their directories.
- [ ] Confidence ceilings attached to claims and procedures.

### MCP / Memory Tags
- Namespace: `skills/delivery/documentation/{project}/{doc-type}/{timestamp}`
- Tags: `WHO=documentation-{session}`, `WHY=skill-execution`, `WHAT=doc-lifecycle`

Confidence: 0.70 (ceiling: inference 0.70) - SOP mirrors prompt-architect clarity rules and skill-forge structure-first enforcement.

---

## VCL COMPLIANCE APPENDIX
- [[HON:teineigo]] [[MOR:root:D-C-M]] [[COM:Doc+Lifecycle]] [[CLS:ge_skill]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:path:/skills/delivery/documentation]]
  - Structure-first directories required before authoring.
- [[HON:teineigo]] [[MOR:root:C-N-S]] [[COM:Constraint+Extraction]] [[CLS:ge_principle]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:axis:analysis]]
  - HARD/SOFT/INFERRED constraints logged and confirmed.
- [[HON:teineigo]] [[MOR:root:E-P-S]] [[COM:Epistemic+Ceiling]] [[CLS:ge_rule]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:coord:EVD-CONF]]
  - Confidence ceilings enforced for all statements.
