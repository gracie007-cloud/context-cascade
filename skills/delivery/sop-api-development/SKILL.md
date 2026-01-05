---
name: sop-api-development
description: End-to-end REST/HTTP API delivery SOP with clear contracts, TDD focus, and deployment readiness.
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
Design, build, and release APIs with reliable contracts, tests, documentation, and rollout controls.

### Trigger Conditions
- **Positive:** new REST endpoints, breaking changes, contract updates, or API hardening.
- **Negative:** doc-only requests (route to `documentation`) or non-API feature builds (route to `feature-dev-complete`).

### Guardrails
- **Structure-first:** ensure `examples/`, `tests/`, `resources/`, `references/` accompany `SKILL.md`.
- **Constraint extraction:** HARD (SLAs, auth, compliance), SOFT (style, versioning), INFERRED (traffic patterns, migration risk); confirm inferred.
- **Contract-first:** define OpenAPI/JSON schema before coding; keep error model and versioning explicit.
- **Confidence ceilings:** `{inference/report:0.70, research:0.85, observation/definition:0.95}` across design, performance, and rollout claims.

### Execution Phases
1. **Intent & Contract**
   - Capture objectives, consumers, and constraints; produce OpenAPI/JSON schema; store in `resources/`.
   - Define auth, rate limits, idempotency, and error formats.
2. **Plan & Test Design**
   - Outline endpoints, data flows, and dependencies; map acceptance criteria to tests in `tests/`.
   - Identify migration/deprecation plan; log in `references/`.
3. **Implement**
   - Build handlers, validation, and persistence with smallest increments.
   - Keep logging/observability consistent; add feature flags if needed.
4. **Validate**
   - Run unit/integration/contract tests; fuzz critical inputs; load/perf sample if relevant.
   - Verify backward compatibility and security (authz/authn, input sanitization).
5. **Document & Release**
   - Update API docs and changelog; provide rollout/rollback steps.
   - Summarize evidence and **Confidence: X.XX (ceiling: TYPE Y.YY)**.

### Output Format
- Constraint ledger (HARD/SOFT/INFERRED) with confirmations.
- Contract artifacts, implementation status, and validation results.
- Release/rollback guidance and evidence links.
- Confidence statement with ceiling.

### Validation Checklist
- [ ] Contracts defined and versioned; constraints confirmed.
- [ ] Tests mapped to acceptance criteria; results captured.
- [ ] Security, auth, and error models validated.
- [ ] Docs and changelog updated; references stored.
- [ ] Confidence ceilings applied to claims and rollout readiness.

### MCP / Memory Tags
- Namespace: `skills/delivery/sop-api-development/{service}/{version}`
- Tags: `WHO=sop-api-development-{session}`, `WHY=skill-execution`, `WHAT=api-delivery`

Confidence: 0.70 (ceiling: inference 0.70) - SOP mirrors skill-forge structure-first and prompt-architect constraint/ceiling rules.

---

## VCL COMPLIANCE APPENDIX
- [[HON:teineigo]] [[MOR:root:A-P-I]] [[COM:API+SOP]] [[CLS:ge_skill]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:path:/skills/delivery/sop-api-development]]
  - Structure-first directories enforced for API delivery.
- [[HON:teineigo]] [[MOR:root:C-N-S]] [[COM:Constraint+Extraction]] [[CLS:ge_principle]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:axis:analysis]]
  - HARD/SOFT/INFERRED constraints documented and confirmed.
- [[HON:teineigo]] [[MOR:root:E-P-S]] [[COM:Epistemic+Ceiling]] [[CLS:ge_rule]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:coord:EVD-CONF]]
  - Confidence ceilings bound design and rollout assertions.

### Day 1: Requirements & Architecture

**Sequential Workflow**:

```javascript
// Step 1: Gather Requirements
await Task("Product Manager", `
Define API requirements:
- List all endpoints needed
- Define data models and relationships
- Specify authentication/authorization
- Define rate limiting and quotas
- Identify third-party integrations

Store requirements: api-dev/rest-api-v2/requirements
`, "planner");

// Step 2: API Design
await Task("System Architect", `
Using requirements: api-dev/rest-api-v2/requirements

Design:
- RESTful API structure (resources, HTTP methods)
- URL patterns and versioning strategy
- Request/response formats (JSON schemas)
- Error handling patterns
- API security architecture

Generate OpenAPI 3.0 specification
Store: api-dev/rest-api-v2/openapi-spec
`, "system-architect");

// Step 3: Database Design
await Task("Database Architect", `
Using API spec: api-dev/rest-api-v2/openapi-spec

Design database:
- Schema design (tables, columns, types)
- Relationships and foreign keys
- Indexes for performance
- Migration strategy
- Backup and recovery plan

Generate SQL schema
Store: api-dev/rest-api-v2/db-schema
`, "code-analyzer");
```

### Day 2: Test Planning

```javascript
// Step 4: Test Strategy
await Task("QA Engineer", `
Using:
- API spec: api-dev/rest-api-v2/openapi-spec
- DB schema: api-dev/rest-api-v2/db-schema

Create test plan:
- Unit test strategy (per endpoint)
- Integration test scenarios
- E2E test workflows
- Performance test targets
- Security test cases

Store test plan: api-dev/rest-api-v2/test-plan
`, "tester");

// 

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
  pattern: "skills/delivery/sop-api-development/{project}/{timestamp}",
  store: ["executions", "decisions", "patterns"],
  retrieve: ["similar_tasks", "proven_patterns"]
} [ground:system-policy] [conf:1.0] [state:confirmed]

[define|neutral] MEMORY_TAGGING := {
  WHO: "sop-api-development-{session_id}",
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

[commit|confident] <promise>SOP_API_DEVELOPMENT_VERILINGUA_VERIX_COMPLIANT</promise> [ground:self-validation] [conf:0.99] [state:confirmed]
