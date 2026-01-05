---
name: feature-dev-complete
description: End-to-end feature delivery (discovery → design → build → test → release) with explicit quality gates and confidence ceilings.
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
Deliver production-ready features with clear scope, architecture, validated code, docs, and release notes.

### Trigger Conditions
- **Positive:** net-new feature requests, multi-story implementations, end-to-end delivery ownership.
- **Negative:** pure bugfix (route to `debugging`/`smart-bug-fix`) or doc-only asks (route to `documentation`).

### Guardrails
- **Structure-first:** ensure `examples/`, `tests/`, `resources/` exist; `references/` recommended for ADRs.
- **Constraint extraction:** HARD (scope, deadlines, SLAs), SOFT (tech preferences), INFERRED (UX tone); confirm inferred.
- **Confidence ceilings:** `{inference/report:0.70, research:0.85, observation/definition:0.95}` for requirements, estimates, and validation claims.
- **Quality gates:** architecture review, security/perf considerations, test coverage, rollback and release notes.

### Execution Phases
1. **Discovery & Framing**
   - Clarify intent, success metrics, dependencies, and blockers.
   - Produce acceptance criteria and definition of done; tag constraints.
2. **Design**
   - Draft architecture, sequence diagrams, and data contracts; store in `resources/`.
   - Validate feasibility; capture alternatives with ceilings on risk/effort.
3. **Plan & Traceability**
   - Break down into stories/tasks/subtasks with ownership and status.
   - Define tests to add; map them to acceptance criteria.
4. **Build**
   - Implement smallest viable increments; keep code + tests paired.
   - Maintain changelog notes and migration steps if schema/config changes occur.
5. **Validate**
   - Run unit/integration/e2e and non-functional checks as applicable.
   - Ensure rollback plan; document results in `tests/` artifacts.
6. **Document & Release**
   - Update READMEs/API docs as needed; prepare release notes.
   - Store decisions in `references/`; add reusable flows to `examples/`.

### Output Format
- Feature summary + constraints (HARD/SOFT/INFERRED) and confirmations.
- Design decisions, task breakdown, and planned/actual validation.
- Delivery state (ready/requires follow-up) and **Confidence: X.XX (ceiling: TYPE Y.YY)**.

### Validation Checklist
- [ ] Acceptance criteria confirmed; constraints logged and resolved/waived.
- [ ] Design reviewed; risks and alternatives recorded.
- [ ] Tests added/updated; results captured; rollback path defined.
- [ ] Docs/release notes updated; artifacts stored in `resources/` and `references/`.
- [ ] Confidence ceilings attached to estimates and claims.

### MCP / Memory Tags
- Namespace: `skills/delivery/feature-dev-complete/{project}/{feature}`
- Tags: `WHO=feature-dev-complete-{session}`, `WHY=skill-execution`, `WHAT=delivery`

Confidence: 0.70 (ceiling: inference 0.70) - SOP follows skill-forge structure-first and prompt-architect constraint/ceiling requirements.

---

## VCL COMPLIANCE APPENDIX
- [[HON:teineigo]] [[MOR:root:F-T-R]] [[COM:Feature+Delivery]] [[CLS:ge_skill]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:path:/skills/delivery/feature-dev-complete]]
  - Structure-first directories enforced.
- [[HON:teineigo]] [[MOR:root:C-N-S]] [[COM:Constraint+Extraction]] [[CLS:ge_principle]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:axis:analysis]]
  - HARD/SOFT/INFERRED constraints confirmed before build.
- [[HON:teineigo]] [[MOR:root:E-P-S]] [[COM:Epistemic+Ceiling]] [[CLS:ge_rule]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:coord:EVD-CONF]]
  - Confidence ceilings bound estimates, designs, and validation claims.

1. **EPIC Level**: Overall feature (e.g., "User Authentication System")
2. **STORY Level**: User-facing value (e.g., "As a user, I can log in securely")
3. **TASK Level**: Technical implementation (e.g., "Implement JWT middleware")
4. **SUBTASK Level**: Atomic work units (e.g., "Write token validation function")

### Stage-to-Hierarchy Mapping

Each 12-stage workflow maps to hierarchical levels:

| Stage | Hierarchy Level | Example |
|-------|----------------|---------|
| 1-2 (Research) | EPIC planning | Define feature scope |
| 3-5 (Architecture) | STORY breakdown | User stories + design |
| 6-8 (Implementation) | TASK execution | Code, test, fix |
| 9-11 (Quality) | SUBTASK refinement | Polish, docs, security |
| 12 (Production) | EPIC completion | Deploy, validate |

## When to Use This Skill

- **Full Feature Development**: Complete end-to-end feature implementation
- **Greenfield Features**: Building new functionality from scratch
- **Research Required**: Features needing best practice research
- **Multi-Layer Changes**: Features spanning frontend, backend, database
- **Production Deployment**: Features requiring full testing and documentation
- **Architecture Design**: Features needing upfront design decisions

## When NOT to Use This Skill

- **Bug Fixes**: Use debugging or smart-bug-fix skills instead
- **Quick Prototypes**: Exploratory coding without production requirements
- **Refactoring**: Code restructuring without new features
- **Documentation Only**: Pure documen

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
  pattern: "skills/delivery/feature-dev-complete/{project}/{timestamp}",
  store: ["executions", "decisions", "patterns"],
  retrieve: ["similar_tasks", "proven_patterns"]
} [ground:system-policy] [conf:1.0] [state:confirmed]

[define|neutral] MEMORY_TAGGING := {
  WHO: "feature-dev-complete-{session_id}",
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

[commit|confident] <promise>FEATURE_DEV_COMPLETE_VERILINGUA_VERIX_COMPLIANT</promise> [ground:self-validation] [conf:0.99] [state:confirmed]
