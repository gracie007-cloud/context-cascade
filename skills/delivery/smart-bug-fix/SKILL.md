---
name: smart-bug-fix
description: Advanced defect eradication with hypothesis-driven RCA, guarded fixes, and comprehensive validation.
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
Handle complex or high-risk bugs with structured root-cause analysis, evidence-backed fixes, and regression protection.

### Trigger Conditions
- **Positive:** production-grade defects, performance degradations, security/regression issues, multi-service failures.
- **Negative:** simple fixes or greenfield work (route to `debugging` or `feature-dev-complete` respectively).

### Guardrails
- **Structure-first:** maintain `examples/`, `tests/`, `resources/`, `references/` for each incident.
- **Constraint extraction:** HARD (blast radius, uptime targets, data safety), SOFT (tooling preferences), INFERRED (rollback tolerance) — confirm inferred.
- **Hypothesis discipline:** every suspected cause must include evidence and ceilinged confidence.
- **Confidence ceilings:** `{inference/report:0.70, research:0.85, observation/definition:0.95}` on diagnosis and fix claims.
- **Safety:** avoid production mutations without backups; preserve audit logs.

### Execution Phases
1. **Intake & Repro**
   - Capture signals, incidents, and constraints; build minimal repro.
   - Store logs/traces in `resources/`.
2. **Root-Cause Analysis**
   - Form hypotheses with evidence; iterate 5-Whys; tag ceilings.
   - Document rejected hypotheses in `references/` for reuse.
3. **Fix Design**
   - Choose minimal, reversible change; plan rollout + rollback.
   - Define required tests; stage diff for review.
4. **Implement & Validate**
   - Implement fix; add regression tests in `tests/`.
   - Run unit/integration/perf/security checks as applicable; record outputs.
5. **Stabilize & Document**
   - Monitor post-fix signals; ensure no secondary failures.
   - Summarize cause, fix, validation, residual risk, and **Confidence: X.XX (ceiling: TYPE Y.YY)**.

### Output Format
- Constraints ledger (HARD/SOFT/INFERRED) with confirmations.
- Hypotheses, evidence, and status (accepted/rejected) with confidence ceilings.
- Fix plan, validation results, rollback path.
- Artifacts/links and next steps.

### Validation Checklist
- [ ] Repro confirmed; blast radius understood.
- [ ] Hypotheses evidenced; ceilings stated; rejected items logged.
- [ ] Tests added/updated and passing; monitoring plan noted.
- [ ] Rollback path defined; artifacts stored in `resources/` and `references/`.
- [ ] Confidence ceilings attached to diagnosis and validation claims.

### MCP / Memory Tags
- Namespace: `skills/delivery/smart-bug-fix/{project}/{incident}`
- Tags: `WHO=smart-bug-fix-{session}`, `WHY=skill-execution`, `WHAT=complex-fix`

Confidence: 0.70 (ceiling: inference 0.70) - SOP incorporates skill-forge structure-first and prompt-architect constraint/ceiling discipline.

---

## VCL COMPLIANCE APPENDIX
- [[HON:teineigo]] [[MOR:root:S-M-T]] [[COM:Smart+Fix]] [[CLS:ge_skill]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:path:/skills/delivery/smart-bug-fix]]
  - Structure-first directories enforced for incident artifacts.
- [[HON:teineigo]] [[MOR:root:C-N-S]] [[COM:Constraint+Extraction]] [[CLS:ge_principle]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:axis:analysis]]
  - HARD/SOFT/INFERRED constraints documented and confirmed.
- [[HON:teineigo]] [[MOR:root:E-P-S]] [[COM:Epistemic+Ceiling]] [[CLS:ge_rule]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:coord:EVD-CONF]]
  - Confidence ceilings applied to RCA and fix validation.

- **Legacy Integration**: Working with older codebases or deprecated APIs
- **Missing Dependencies**: Unavailable libraries or external services
- **Version Conflicts**: Dependency version incompatibilities
- **Data Issues**: Malformed input or edge case data
- **Concurrency**: Race conditions or synchronization challenges
- **Error Handling**: Graceful degradation and recovery

## Guardrails

- **NEVER** skip testing to ship faster
- **ALWAYS** follow domain-specific best practices
- **NEVER** commit untested or broken code
- **ALWAYS** document complex logic and decisions
- **NEVER** hardcode sensitive data or credentials
- **ALWAYS** validate input and handle errors gracefully
- **NEVER** deploy without reviewing changes

## Evidence-Based Validation

- [ ] Automated tests passing
- [ ] Code linter/formatter passing
- [ ] Security scan completed
- [ ] Performance within acceptable range
- [ ] Manual testing completed
- [ ] Peer review approved
- [ ] Documentation reviewed

## Purpose

Systematically debug and fix bugs using root cause analysis, multi-model reasoning, 

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
  pattern: "skills/delivery/smart-bug-fix/{project}/{timestamp}",
  store: ["executions", "decisions", "patterns"],
  retrieve: ["similar_tasks", "proven_patterns"]
} [ground:system-policy] [conf:1.0] [state:confirmed]

[define|neutral] MEMORY_TAGGING := {
  WHO: "smart-bug-fix-{session_id}",
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

[commit|confident] <promise>SMART_BUG_FIX_VERILINGUA_VERIX_COMPLIANT</promise> [ground:self-validation] [conf:0.99] [state:confirmed]
