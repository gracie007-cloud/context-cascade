---
name: dependencies
description: Dependency intelligence for analysis, upgrades, and risk controls across delivery projects.
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
Keep dependency stacks healthy by detecting risk, planning upgrades, and validating changes without breaking delivery timelines.

### Trigger Conditions
- **Positive:** dependency analysis, upgrade planning, license review, vulnerability remediation, supply-chain hygiene.
- **Negative:** pure feature design (route to feature-dev-complete), translation-focused asks (route to i18n-automation).

### Guardrails
- Apply **structure-first**: ensure `SKILL.md`, `examples/`, `tests/`, `resources/`, and `references/` exist before execution.
- Use **constraint extraction** (HARD / SOFT / INFERRED) before proposing changes; confirm inferred items.
- State **confidence with explicit ceiling** for every recommendation using `{inference/report:0.70, research:0.85, observation/definition:0.95}`.
- Run **adversarial checks**: breaking-change probes, integrity of lockfiles, and rollback readiness.

### Execution Phases
1. **Assessment**
   - Inventory dependencies (runtime + dev) and capture versions, sources, and licenses.
   - Identify blockers: private registries, platform limits, or pinned transitive deps.
2. **Risk & Priority**
   - Map CVEs, EOL packages, and license violations.
   - Score upgrade urgency (security > compatibility > performance) with confidence ceilings.
3. **Plan & Simulate**
   - Propose upgrade batches with rollback plans and test impact.
   - Stage changes in a branch; prefer minimal-delta upgrades before major jumps.
4. **Validate**
   - Run unit/integration smoke tests and dependency diff checksums.
   - Verify lockfile integrity and reproducible installs.
5. **Document & Deliver**
   - Summarize decisions, risks, and evidence.
   - Update `resources/` with diffs, `tests/` with regression coverage, `references/` with advisories.

### Output Format
- Intent + constraints (HARD/SOFT/INFERRED).
- Current vs target dependency map.
- Plan with validation steps and rollback notes.
- Evidence and **Confidence: X.XX (ceiling: TYPE Y.YY)**.

### Validation Checklist
- [ ] Inventory complete; sensitive registries noted.
- [ ] CVE/license review with sources stored in `references/`.
- [ ] Proposed upgrades validated by tests in `tests/`.
- [ ] Rollback path and lockfile verification captured.
- [ ] Confidence ceilings stated for each claim.

### MCP / Memory Tags
- Namespace: `skills/delivery/dependencies/{project}/{timestamp}`
- Tags: `WHO=dependencies-{session}`, `WHY=skill-execution`, `WHAT=dependency-hygiene`

Confidence: 0.70 (ceiling: inference 0.70) - SOP aligned to structure-first, constraint extraction, and ceiling rules from skill-forge + prompt-architect.

---

## VCL COMPLIANCE APPENDIX
- [[HON:teineigo]] [[MOR:root:D-P-D]] [[COM:Dependency+Discipline]] [[CLS:ge_skill]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:path:/skills/delivery/dependencies]]
  - Structure-first directories enforced before execution.
- [[HON:teineigo]] [[MOR:root:E-P-S]] [[COM:Epistemic+Tavan]] [[CLS:ge_rule]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:coord:EVD-CONF]]
  - Confidence ceilings: inference/report 0.70; research 0.85; observation/definition 0.95.
- [[HON:teineigo]] [[MOR:root:C-N-S]] [[COM:Constraint+Extraction]] [[CLS:ge_principle]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:axis:analysis]]
  - HARD/SOFT/INFERRED constraints documented and confirmed before changes proceed.
