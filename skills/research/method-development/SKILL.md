---
name: method-development
description: Design and iterate on new research methods with structured checkpoints, baselines, and validation.
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
- Develop, refine, and validate novel methods anchored to baselines and constraints.
- Apply constraint hygiene and explicit ceilings to prevent premature claims.
- Keep structure-first artifacts current for handoff and reproducibility.

### Trigger Conditions
- **Positive:** creating or adapting algorithms/pipelines; designing ablations; exploring new research ideas.
- **Negative:** pure replication (use `baseline-replication`) or publication packaging (`research-publication`).

### Guardrails
- HARD / SOFT / INFERRED constraint buckets (compute, data, metrics, ethics) with sources.
- Two-pass refinement on designs: structure vs. baselines, then epistemic/risks.
- Require baseline parity before claiming improvements; document variance sources.
- Confidence ceilings enforced per claim.

### Inputs
- Problem statement and success metrics.
- Baselines to beat and constraints (data, compute, deadlines).
- Risk tolerances and evaluation protocols.

### Workflow
1. **Problem Framing**: Capture objectives, constraints, and baselines; confirm INFERRED assumptions.
2. **Design Options**: Propose candidates with expected impact; map to constraints.
3. **Experiment Plan**: Define ablations, datasets, metrics, and stopping rules.
4. **Run & Observe**: Execute experiments, log configs/seeds; compare to baselines.
5. **Validate & Iterate**: Analyze results, run adversarial checks, and refine or stop.
6. **Package**: Summarize findings, risks, and next steps; store artifacts and update references/examples.

### Validation & Quality Gates
- Baseline beat or variance explained; claims tied to evidence with ceilings.
- Ablations cover key hypotheses; failures documented.
- Reproducibility assets stored (configs, logs, seeds).

### Response Template
```
**Objective & Constraints**
- HARD / SOFT / INFERRED.

**Design Candidates**
- Option → rationale → expected impact.

**Experiment Status**
- Runs, metrics vs. baseline, issues.

**Next Steps**
- Iterate, stop, or expand.

Confidence: 0.80 (ceiling: research 0.85) - based on current evidence and validation checks.
```

Confidence: 0.80 (ceiling: research 0.85) - reflects validated comparisons to baselines and logged experiments.
