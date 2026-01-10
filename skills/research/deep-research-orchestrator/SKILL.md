---
name: deep-research-orchestrator
description: End-to-end orchestration of the deep research lifecycle across discovery, experimentation, and production gates.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: research
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
- Coordinate multi-pipeline deep research work from question framing to productionized insights.
- Enforce quality gates, evidence hygiene, and explicit confidence ceilings at each stage.
- Maintain structure-first artifacts (SKILL, README, examples, references) and log handoffs.

### Trigger Conditions
- **Positive:** multi-week research programs, academic-grade studies, or cross-pipeline coordination needs.
- **Negative:** single-question quick looks (use `researcher`) or pure prompt shaping (use `prompt-architect`).

### Guardrails
- Constraint extraction in HARD / SOFT / INFERRED buckets for scope, ethics, compute, and timelines.
- Two-pass refinement per deliverable: structure/coverage then epistemic/validation.
- Quality gates: Discovery (literature + gap clarity), Experimentation (replication + ablations), Production (deployment + monitoring).
- Explicit confidence ceilings on all claims; do not exceed evidence tier.

### Inputs
- Research objective, success metrics, and timeline.
- Available datasets/resources, compute budget, and risk constraints.
- Required stakeholders and integration points.

### Workflow
1. **Frame & Route**: Define goal, success metrics, constraint buckets; map to pipelines (literature, replication, method dev, eval, publication).
2. **Plan Handoffs**: Assign roles/agents, memory tags, and deliverable owners; schedule quality gates.
3. **Execute Pipelines**: Run discovery → replication → experimentation → synthesis; use sub-skills as needed.
4. **Adversarial Validation**: Challenge assumptions, run boundary cases, and verify reproducibility before exit.
5. **Package & Communicate**: Consolidate artifacts, COV notes, risks, and next actions; ensure README/examples reflect latest practice.

### Validation & Quality Gates
- Gate readiness recorded with evidence for discovery, experimentation, and production.
- Constraint coverage tracked; unresolved INFERRED items flagged.
- Deliverables include logs of handoffs, decisions, and confidence ceilings.
- Storage paths and tags recorded for recall.

### Response Template
```
**Goal & Constraints**
- HARD: ...
- SOFT: ...
- INFERRED (confirm): ...

**Pipelines & Owners**
- Discovery → Replication → Experimentation → Production.

**Status**
- Gate checkpoints and evidence summaries.
- Risks / blockers / follow-ups.

**Artifacts**
- Links to notes, datasets, models, dashboards.

Confidence: 0.80 (ceiling: research 0.85) - based on validated gate evidence and logged handoffs.
```

Confidence: 0.80 (ceiling: research 0.85) - Reflects orchestrated, evidence-backed stage tracking.
