---
name: sparc-methodology
description: SPARC (Specification, Pseudocode, Architecture, Refinement, Completion) delivery framework with explicit constraints, checkpoints, and confidence ceilings.
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
Guide complex delivery work through SPARC phases with structure-first discipline, adversarial validation, and clear evidence trails.

### Trigger Conditions
- **Positive:** multi-step builds needing formal specification → pseudocode → architecture → refinement → completion flow.
- **Negative:** narrow bug fixes (route to `debugging`/`smart-bug-fix`) or pure documentation tasks.

### Guardrails
- **Structure-first:** ensure `examples/`, `tests/`, `resources/`, `references/` exist.
- **Constraint extraction:** HARD (scope, timelines, compliance), SOFT (patterns, style), INFERRED (risk appetite) — confirm inferred.
- **SPARC discipline:** do not skip phases; maintain traceability between artifacts.
- **Confidence ceilings:** `{inference/report:0.70, research:0.85, observation/definition:0.95}` on specs, designs, and validation claims.
- **Adversarial checks:** boundary/negative cases and change-impact review before completion.

### Execution Phases (SPARC)
1. **Specification**
   - Clarify problem, success metrics, and constraints; produce concise spec stored in `resources/`.
2. **Pseudocode**
   - Draft algorithm/process steps; highlight unknowns; keep in `examples/`.
3. **Architecture**
   - Define modules, data flows, interfaces; consider performance/security/operability.
   - Record decisions and alternatives with ceilings; cite sources in `references/`.
4. **Refinement**
   - Implement incrementally; pair code with tests; resolve edge cases and perf/security concerns.
5. **Completion**
   - Validate against spec; run tests in `tests/`; prepare docs and rollout/rollback notes; issue final confidence statement.

### Output Format
- Constraints ledger (HARD/SOFT/INFERRED) + confirmations.
- SPARC artifacts (spec, pseudocode, architecture, refinement notes, completion checklist).
- Validation results and evidence with **Confidence: X.XX (ceiling: TYPE Y.YY)**.

### Validation Checklist
- [ ] Spec approved; constraints confirmed.
- [ ] Pseudocode and architecture captured with alternatives.
- [ ] Tests cover happy/edge/negative paths; results stored.
- [ ] Security/perf considerations addressed; rollback available.
- [ ] Documentation and references updated; confidence ceilings applied.

### MCP / Memory Tags
- Namespace: `skills/delivery/sparc-methodology/{project}/{artifact}`
- Tags: `WHO=sparc-methodology-{session}`, `WHY=skill-execution`, `WHAT=sp-arc-flow`

Confidence: 0.70 (ceiling: inference 0.70) - SOP reflects skill-forge structure-first and prompt-architect ceiling/constraint rigor.

---

## VCL COMPLIANCE APPENDIX
- [[HON:teineigo]] [[MOR:root:S-P-R]] [[COM:SPARC+Flow]] [[CLS:ge_skill]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:path:/skills/delivery/sparc-methodology]]
  - Structure-first directories required.
- [[HON:teineigo]] [[MOR:root:C-N-S]] [[COM:Constraint+Extraction]] [[CLS:ge_principle]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:axis:analysis]]
  - HARD/SOFT/INFERRED constraints confirmed through phases.
- [[HON:teineigo]] [[MOR:root:E-P-S]] [[COM:Epistemic+Ceiling]] [[CLS:ge_rule]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:coord:EVD-CONF]]
  - Confidence ceilings bound claims for specs, designs, and validation.
9. [Common Workflows](#common-workflows)

---

## Core Philosophy

SPARC methodology emphasizes:

- **Systematic Approach**: Structured phases from specification to completion
- **Test-Driven Development**: Tests written before implementation
- **Parallel Execution**: Concurrent agent coordination for 2.8-4.4x speed improvements
- **Memory Integration**: Persistent knowledge sharing across agents and sessions
- **Quality First**: Comprehensive reviews, testing, and validation
- **Modular Design**: Clean separation of concerns with clear interfaces

### Key Principles

1. **Specification Before Code**: Define requirements and constraints clearly
2. **Design Before Implementation**: Plan architecture and components
3. **Tests Before Features**: Write failing tests, then make them pass
4. **Review Everything**: Code quality, security, and performance checks
5. **Document Continuously**: Maintain current documentation throughout

---

## Development Phases

### Phase 1: Specification
**Goal**: Define requirements, constraints, and success criteria

- Requirements analysis
- User story mapping
- Constraint identification
- Success metrics definition


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
  pattern: "skills/development/sparc-methodology/{project}/{timestamp}",
  store: ["executions", "decisions", "patterns"],
  retrieve: ["similar_tasks", "proven_patterns"]
} [ground:system-policy] [conf:1.0] [state:confirmed]

[define|neutral] MEMORY_TAGGING := {
  WHO: "sparc-methodology-{session_id}",
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

[commit|confident] <promise>SPARC_METHODOLOGY_VERILINGUA_VERIX_COMPLIANT</promise> [ground:self-validation] [conf:0.99] [state:confirmed]
