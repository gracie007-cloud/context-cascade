---
name: api-docs
description: Generate, validate, and maintain API documentation (REST/OpenAPI and GraphQL) with reproducible structure and evidence-backed confidence.
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
Ship accurate, consumable API docs with validated schemas, runnable examples, and clear auth/error guidance.

### Trigger Conditions
- **Positive:** REST/GraphQL doc creation or updates, versioned API rollouts, deprecation notices, interactive explorer setup.
- **Negative:** Narrative/internal docs (route to `documentation`) or prompt-focused tasks (route to `prompt-architect`).

### Guardrails
- **Structure-first:** maintain `examples/`, `tests/`, `resources/`, `references/` alongside `SKILL.md`.
- **Constraint extraction:** capture HARD/SOFT/INFERRED constraints on audience, security posture, and versioning; confirm inferred.
- **Validation:** run spec validators (OpenAPI/GraphQL), exercise examples, and note unrun commands.
- **Confidence ceilings:** apply `{inference/report:0.70, research:0.85, observation/definition:0.95}` to all claims.
- **Safety:** no secret exposure; redact internal endpoints when producing public docs.

### Execution Phases
1. **Scope & Sources**
   - Identify surfaces (REST/GraphQL), auth schemes, target audience, and supported versions.
   - Gather schemas, code annotations, and existing references; log constraints.
2. **Outline & Contracts**
   - Define required sections: overview, auth, endpoints/operations, errors, rate limits, changelog.
   - Confirm INFERRED needs (SDK snippets, language coverage).
3. **Author & Validate**
   - Draft OpenAPI/GraphQL artifacts; generate runnable examples in `examples/`.
   - Validate specs (swagger-cli, graphql-schema-linter) and sample requests.
4. **Publish & Harden**
   - Wire interactive explorer (Swagger UI/GraphQL Playground) if in scope.
   - Add tests in `tests/` (lint, link check, example execution) and store outputs in `resources/`.
5. **Review & Deliver**
   - Summarize deltas, risks, and next steps; cite sources in `references/`.
   - Provide confidence statement with ceiling.

### Output Format
- Scope summary + constraints (HARD/SOFT/INFERRED, confirmed).
- Spec status and validation results.
- Example calls and changelog notes.
- Evidence with **Confidence: X.XX (ceiling: TYPE Y.YY)**.

### Validation Checklist
- [ ] Audience and version coverage confirmed; inferred asks resolved.
- [ ] Specs validated; examples executed or annotated as not run.
- [ ] Auth, errors, and rate limits documented.
- [ ] Tests present in `tests/`; artifacts stored in `resources/`; references recorded.
- [ ] Confidence ceilings applied to claims and guidance.

### MCP / Memory Tags
- Namespace: `skills/delivery/api-docs/{api}/{version}`
- Tags: `WHO=api-docs-{session}`, `WHY=skill-execution`, `WHAT=spec+docs`

Confidence: 0.70 (ceiling: inference 0.70) - SOP integrates skill-forge structure-first and prompt-architect constraint/ceiling rules.

---

## VCL COMPLIANCE APPENDIX
- [[HON:teineigo]] [[MOR:root:A-P-I]] [[COM:API+Docs]] [[CLS:ge_skill]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:path:/skills/delivery/api-docs]]
  - Structure-first directories must exist before doc work.
- [[HON:teineigo]] [[MOR:root:C-N-S]] [[COM:Constraint+Extraction]] [[CLS:ge_principle]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:axis:analysis]]
  - HARD/SOFT/INFERRED constraints documented and confirmed.
- [[HON:teineigo]] [[MOR:root:E-P-S]] [[COM:Epistemic+Ceiling]] [[CLS:ge_rule]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:coord:EVD-CONF]]
  - Confidence ceilings enforced for specs, examples, and guidance.
- Schema definitions
- Query and mutation documentation
- Type system reference
- Resolver documentation

## Process

1. **Analyze API structure**
   - Identify all endpoints/operations
   - Document request/response schemas
   - Define authentication requirements
   - Catalog error responses

2. **Generate OpenAPI/GraphQL spec**
   - Write structured YAML/SDL definitions
   - Include comprehensive examples
   - Document edge cases
   - Add usage guidelines

3. **Create interactive documentation**
   - Configure Swagger UI for REST APIs
   - Set up GraphQL Playground
   - Add authentication testing support
   - Enable "Try It Out" fu

---
<!-- S4 SUCCESS CRITERIA                                                          -->
---

[define|neutral] SUCCESS_CRITERIA := {
  primary: "Skill execution completes successfully",
  quality: "Output meets quality thresholds",
  verification: "Results validated against requirements"
} [ground:given] [conf:1.0] [state:confirmed]

---
<!-- S5 MCP INTEGRATION                                                           -->
---

[define|neutral] MCP_INTEGRATION := {
  memory_mcp: "Store execution results and patterns",
  tools: ["mcp__memory-mcp__memory_store", "mcp__memory-mcp__vector_search"]
} [ground:witnessed:mcp-config] [conf:0.95] [state:confirmed]

---
<!-- S6 MEMORY NAMESPACE                                                          -->
---

[define|neutral] MEMORY_NAMESPACE := {
  pattern: "skills/delivery/api-docs/{project}/{timestamp}",
  store: ["executions", "decisions", "patterns"],
  retrieve: ["similar_tasks", "proven_patterns"]
} [ground:system-policy] [conf:1.0] [state:confirmed]

[define|neutral] MEMORY_TAGGING := {
  WHO: "api-docs-{session_id}",
  WHEN: "ISO8601_timestamp",
  PROJECT: "{project_name}",
  WHY: "skill-execution"
} [ground:system-policy] [conf:1.0] [state:confirmed]

---
<!-- S7 SKILL COMPLETION VERIFICATION                                             -->
---

[direct|emphatic] COMPLETION_CHECKLIST := {
  agent_spawning: "Spawn agents via Task()",
  registry_validation: "Use registry agents only",
  todowrite_called: "Track progress with TodoWrite",
  work_delegation: "Delegate to specialized agents"
} [ground:system-policy] [conf:1.0] [state:confirmed]

---
<!-- S8 ABSOLUTE RULES                                                            -->
---

[direct|emphatic] RULE_NO_UNICODE := forall(output): NOT(unicode_outside_ascii) [ground:windows-compatibility] [conf:1.0] [state:confirmed]

[direct|emphatic] RULE_EVIDENCE := forall(claim): has(ground) AND has(confidence) [ground:verix-spec] [conf:1.0] [state:confirmed]

[direct|emphatic] RULE_REGISTRY := forall(agent): agent IN AGENT_REGISTRY [ground:system-policy] [conf:1.0] [state:confirmed]

---
<!-- PROMISE                                                                      -->
---

[commit|confident] <promise>API_DOCS_VERILINGUA_VERIX_COMPLIANT</promise> [ground:self-validation] [conf:0.99] [state:confirmed]
