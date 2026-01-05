---
name: pair-programming
description: Structured AI-assisted pairing with clear roles, cadence, and validation to keep quality and knowledge flow high.
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
Deliver collaborative coding sessions (driver/navigator/switch/TDD) with explicit guardrails, shared context, and validated output.

### Trigger Conditions
- **Positive:** collaborative coding, live code review, debugging together, mentoring/onboarding, TDD sessions.
- **Negative:** solo quick fixes or documentation-only asks.

### Guardrails
- **Structure-first:** maintain `examples/`, `tests/`, `resources/`, `references/` to capture session artifacts.
- **Constraint extraction:** HARD (timebox, repo rules, CI gates), SOFT (tooling preferences), INFERRED (communication cadence) — confirm inferred.
- **Cadence:** rotate roles every 20–30 minutes; schedule breaks; keep decisions in notes.
- **Confidence ceilings:** `{inference/report:0.70, research:0.85, observation/definition:0.95}` for recommendations and reviews.
- **Psychological safety:** critique code, not people; narrate reasoning.

### Execution Phases
1. **Session Setup**
   - Define goal, CTA (e.g., implement test, fix bug), and done criteria.
   - Choose mode (driver/navigator/switch/TDD) and tools; record constraints.
2. **Context Load**
   - Review relevant files/tests; capture open questions; store in `resources/`.
3. **Collaborative Build**
   - Driver codes aloud; navigator challenges assumptions and tracks constraints.
   - Keep diffs small; log decisions and TODOs; add/adjust tests in `tests/`.
4. **Review & Validation**
   - Swap roles; run tests/linters; perform quick perf/security sanity checks.
   - Note confidence with ceilings for approvals or concerns.
5. **Close & Handoff**
   - Summarize changes, risks, and next steps; ensure commits/notes ready.
   - Save snippets and lessons in `examples/`; cite references.

### Output Format
- Goal + constraints (HARD/SOFT/INFERRED) with confirmations.
- Mode chosen, decisions made, and validation results.
- Action items/next steps with owners.
- Evidence and **Confidence: X.XX (ceiling: TYPE Y.YY)**.

### Validation Checklist
- [ ] Constraints agreed; mode + cadence set.
- [ ] Tests/linters run; results captured.
- [ ] Decisions and risks documented; references linked.
- [ ] Confidence ceilings noted for approvals/concerns.
- [ ] Artifacts saved to `examples/` or `resources/`.

### MCP / Memory Tags
- Namespace: `skills/delivery/pair-programming/{project}/{session}`
- Tags: `WHO=pair-programming-{session}`, `WHY=skill-execution`, `WHAT=collab-coding`

Confidence: 0.70 (ceiling: inference 0.70) - SOP integrates skill-forge structure-first and prompt-architect constraint/ceiling guidance.

---

## VCL COMPLIANCE APPENDIX
- [[HON:teineigo]] [[MOR:root:P-R-P]] [[COM:Pair+Programming]] [[CLS:ge_skill]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:path:/skills/delivery/pair-programming]]
  - Structure-first directories enforced for session artifacts.
- [[HON:teineigo]] [[MOR:root:C-N-S]] [[COM:Constraint+Extraction]] [[CLS:ge_principle]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:axis:analysis]]
  - HARD/SOFT/INFERRED constraints documented and confirmed.
- [[HON:teineigo]] [[MOR:root:E-P-S]] [[COM:Epistemic+Ceiling]] [[CLS:ge_rule]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:coord:EVD-CONF]]
  - Confidence ceilings applied to pairing decisions and approvals.

## Prerequisites

**Required:**
- Claude Flow CLI installed (`npm install -g claude-flow@alpha`)
- Git repository (optional but recommended)

**Recommended:**
- Testing framework (Jest, pytest, etc.)
- Linter configured (ESLint, pylint, etc.)
- Code formatter (Prettier, Black, etc.)

## Quick Start

### Basic Session
```bash
# Start simple pair programming
claude-flow pair --start
```

### TDD Session
```bash
# Test-driven development
claude-flow pair --start \
  --mode tdd \
  --test-first \
  --coverage 90
```

---

## Complete Guide

### Session Control Commands

#### Starting Sessions
```bash
# Basic start
claude-flow pair --start

# Expert refactoring session
claude-flow pair --start \
 

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
  pattern: "skills/delivery/pair-programming/{project}/{timestamp}",
  store: ["executions", "decisions", "patterns"],
  retrieve: ["similar_tasks", "proven_patterns"]
} [ground:system-policy] [conf:1.0] [state:confirmed]

[define|neutral] MEMORY_TAGGING := {
  WHO: "pair-programming-{session_id}",
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

[commit|confident] <promise>PAIR_PROGRAMMING_VERILINGUA_VERIX_COMPLIANT</promise> [ground:self-validation] [conf:0.99] [state:confirmed]
