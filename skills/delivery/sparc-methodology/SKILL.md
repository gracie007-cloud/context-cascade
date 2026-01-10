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




---

## LIBRARY-FIRST PROTOCOL (MANDATORY)

**Before writing ANY code, you MUST check:**

### Step 1: Library Catalog
- Location: `.claude/library/catalog.json`
- If match >70%: REUSE or ADAPT

### Step 2: Patterns Guide
- Location: `.claude/docs/inventories/LIBRARY-PATTERNS-GUIDE.md`
- If pattern exists: FOLLOW documented approach

### Step 3: Existing Projects
- Location: `D:\Projects\*`
- If found: EXTRACT and adapt

### Decision Matrix
| Match | Action |
|-------|--------|
| Library >90% | REUSE directly |
| Library 70-90% | ADAPT minimally |
| Pattern exists | FOLLOW pattern |
| In project | EXTRACT |
| No match | BUILD (add to library after) |

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
