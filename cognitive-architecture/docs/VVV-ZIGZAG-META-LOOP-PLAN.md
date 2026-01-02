# VVV Zig-Zag Meta-Loop Plan (RMIS)

## Recursive Meta-Improvement System (RMIS)

This document describes the formalized recursive improvement strategy for the foundry meta-tools.

---

## Foundational Axioms

### A0 - Everything is an Artifact
Every skill/agent/command/script prompt is an **artifact** with:
- `source` (text/spec/prompt)
- `tests/evals` (how we measure "better")
- `version` (git hash)

### A1 - Improvements Must Be Measurable
No patch merges without running evals. "Better" means **score up** on a defined scorecard.

### A2 - Local Optimization First, Then Cross-Pollination
Each component is improved **in isolation** until diminishing returns, *then* you use it to improve other components.

### A3 - Dogfooding is Mandatory at Each Tier
A tool must eventually try to improve **itself** (prompt level first, then architecture level).

### A4 - Zig-Zag Beats One-Way Updates
Alternating improvements across components (PA - SF - AM) discovers gains a linear pipeline misses.

### A5 - Stop Criteria Are Explicit
A loop ends when improvement is below threshold for N iterations (or fails significance tests).

### A6 - Safety Rail: Reversible, Logged, Bounded
All changes are:
- reversible (git)
- logged (what changed + why)
- bounded (token budget / iteration caps)

---

## Components (Named Labels)

| Label | Full Name | Function |
|-------|-----------|----------|
| **PA** | Prompt Architect | Rewrites prompts/docs for clarity/power/consistency |
| **SF** | Skill Forge | Creates/edits skills; engineering focus |
| **AM** | Agent Maker | Creates/edits agents; structural composition |
| **CMD** | Commands | Plugin commands' prompts/docs (245 total) |
| **DOCS** | Documents | Skill/agent documents and specs |
| **HOOKS** | Hooks | Scripts/hooks with embedded prompts |

---

## The Loop System (L0-L8)

### Loop L0: Baseline and Scorecard (Foundation)

**Purpose:** Establish "what is better" before recursion.

```
Inputs: current artifacts
Process: run eval suite, record baseline metrics
Outputs: baseline scorecard + regression gates
```

**Metrics:**
- Task success rate
- Constraint adherence
- VVV compliance (VERIX grounding ratio)
- Token cost
- L2 purity
- Schema validity

---

### Loop L1: Prompt Architect Self-Refinement (PA -> PA)

**Purpose:** Make PA maximally strong as a prompt rewriter.

```
Operation: PA reviews its own docs/prompts and improves them
Stop: delta < 2% (diminishing returns)
```

---

### Loop L2: Prompt-Upgrade Skill Forge (PA -> SF)

**Purpose:** Rewrite SF's prompts/docs using best PA.

```
1. PA rewrites SF prompts/docs
2. Run SF unit tests/evals
3. Accept patch if score increases
```

---

### Loop L3: Skill Forge Dogfooding (SF -> SF)

**Purpose:** SF improves its own architecture/prompt structure once prompt-level is saturated.

```
Operation: SF proposes structural changes to itself
           (templates, modules, eval hooks, prompt composition)
Stop: delta < 2%
```

---

### Loop L4: Core Zig-Zag Co-Evolution (SF <-> PA)

**Purpose:** The engine that produces "gains we aren't imagining."

```
CYCLE:
1. SF improves PA (structural + operational improvements)
2. PA improves SF (prompt clarity, language consistency)
3. Each side dogfoods after being updated
4. Repeat until convergence
```

This is the critical loop - alternating improvements discover compound gains.

---

### Loop L5: Add Agent Maker (PA+SF -> AM -> AM)

**Purpose:** Once PA and SF are "strong," bring AM into the co-evolution.

```
Stages:
1. PA rewrites AM prompts/docs
2. SF improves AM architecture/tooling
3. AM dogfoods (AM -> AM)
4. Repeat until diminishing returns
```

---

### Loop L6: Global Prompt Rewrite (PA -> CMD + DOCS)

**Purpose:** Apply evolved "language" across the whole plugin.

```
Operation:
- PA rewrites ALL commands (245)
- PA rewrites ALL agent docs (217)
- PA rewrites ALL skill docs (226)
- Run eval suite for regressions
```

---

### Loop L7: Global Structural Upgrade (AM + SF -> Agents + Skills)

**Purpose:** Do structural improvements now that prompt-level is unified.

```
Operation:
- AM improves all agents (roles, interfaces, IO schemas)
- SF improves all skills (tool contracts, modularity, test harness)
- Run integration tests + scenario evals
```

---

### Loop L8: Embedded Prompt Sweep (PA -> HOOKS)

**Purpose:** Find "hidden prompts" in scripts/hooks and upgrade them.

```
Operation:
- Scan repo for prompt-like strings
- PA rewrites
- Run relevant tests
```

---

## Visual Loop Map

```
                 +---------------------------+
                 | L0: BASELINE + SCORECARD  |
                 +-------------+-------------+
                               |
               +---------------+---------------+
               |                               |
       +-------v-------+               +-------v-------+
       | L1: PA -> PA  |               | L3: SF -> SF  |
       | (self-refine) |               | (dogfood)     |
       +-------+-------+               +-------+-------+
               |                               |
       +-------v-------+               +-------^-------+
       | L2: PA -> SF  |               |               |
       | (prompt fix)  +---------------+               |
       +---------------+                               |
                                                       |
               +---------------------------------------+
               |           L4: ZIG-ZAG                 |
               |                                       |
               |   SF* --[improve]--> PA  ===> PA*     |
               |                       |               |
               |   PA* --[dogfood]--> PA* ===> PA**    |
               |                       |               |
               |   PA** --[improve]--> SF* ===> SF**   |
               |                       |               |
               |   SF** --[dogfood]--> SF** ===> SF*** |
               |                       |               |
               |   REPEAT until diminishing returns    |
               +---------------+-----------------------+
                               |
               +---------------v---------------+
               | L5: PA+SF --> AM --> AM       |
               | (agent maker optimization)    |
               +---------------+---------------+
                               |
               +---------------v---------------+
               | L6: PA --> CMD + DOCS         |
               | (global prompt rewrite)       |
               +---------------+---------------+
                               |
               +---------------v---------------+
               | L7: AM+SF --> Agents + Skills |
               | (global structural upgrade)   |
               +---------------+---------------+
                               |
               +---------------v---------------+
               | L8: PA --> HOOKS              |
               | (embedded prompt sweep)       |
               +-------------------------------+
```

---

## Developer API (Pseudo-Code)

```python
Artifact = {
    id: str,
    type: str,          # "skill" | "agent" | "command" | "hook"
    source_text: str,
    tests: List[Test],
    metrics: Scorecard,
    version: str        # git hash
}

def Improve(improver: Artifact, target: Artifact) -> Patch:
    """Use improver to generate improvement patch for target."""
    pass

def Evaluate(patch: Patch, eval_suite: List[Test]) -> Scorecard:
    """Run tests and return scorecard."""
    pass

def Accept(scorecard: Scorecard, baseline: Scorecard) -> bool:
    """Returns True if scorecard beats baseline and passes gates."""
    return scorecard.overall > baseline.overall and scorecard.passes_gates()

def RunLoop(loop_name: str, improver: Artifact, target_set: List[Artifact]) -> Artifact:
    baseline = Evaluate(target_set)
    iteration = 0
    while not diminishing_returns(iteration):
        patch = Improve(improver, target_set)
        score = Evaluate(patch)
        if Accept(score, baseline):
            Commit(patch)
            baseline = score
        else:
            Reject(patch)
        iteration += 1
    return best_version

def diminishing_returns(iteration: int, threshold: float = 0.02) -> bool:
    """Returns True if delta < threshold for last 3 iterations."""
    pass
```

---

## Expected Compound Gains

| Phase | Loop | Prompt Gain | Structural Gain | Cumulative |
|-------|------|-------------|-----------------|------------|
| 1 | L1 (PA->PA) | 15-20% | - | 15-20% |
| 2 | L2 (PA->SF) | 15-20% | - | 30-40% |
| 3 | L3 (SF->SF) | - | 10-15% | 40-55% |
| 4 | L4 (zig-zag) | 10-15% | 10-15% | 60-85% |
| 5 | L5 (AM) | 10-15% | 10-15% | 80-115% |
| 6-8 | Global | 20-30% | 10-20% | 100-170% |

The final system could be **2-3x better** than the starting point.

---

## Execution Status

- [ ] L0: Baseline scorecard established
- [ ] L1: PA self-optimization (PA -> PA)
- [ ] L2: PA -> SF prompt upgrade
- [ ] L3: SF dogfooding (SF -> SF)
- [ ] L4: Zig-zag co-evolution (SF <-> PA)
- [ ] L5: Agent Maker optimization
- [ ] L6: Global prompt rewrite (245 commands, 217 agents, 226 skills)
- [ ] L7: Global structural upgrade
- [ ] L8: Embedded prompt sweep
- [ ] Post: Ultrathink analysis

---

## Key Insight: Why This Works

The system exploits **three orthogonal improvement dimensions**:

1. **Language/Prompt Quality (PA)** - How clearly instructions are expressed
2. **Architectural Structure (SF)** - How components are organized
3. **Behavioral Design (AM)** - How agents coordinate and act

By recursively improving each, then cross-applying, you capture gains that no single-pass optimization could find. The "zigzag" ensures improvements in one dimension get propagated to enhance the others.

---

## Biological Mental Model

Think: **adaptive immune system / evolution**

- **Mutations** = prompt/structure edits
- **Selection** = eval harness + scorecard
- **Inheritance** = committing the best patch
- **Speciation** = splitting skills/agents into specialized variants
- **Dogfooding** = organism evolves its own mutation operator

---

*This plan represents a systematic approach to recursive self-improvement that compounds gains across prompt, structural, and agent dimensions.*
