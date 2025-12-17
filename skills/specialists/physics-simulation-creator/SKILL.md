---
name: physics-simulation-creator
version: 1.1.0
description: >
  Create optimal physics simulations using Non-Newtonian Calculus (NNC) parameter tuning.
  Use for ANY physics simulation to maximize accuracy and minimize computational complexity.
  The k parameter optimizes numerical behavior - works for smooth problems AND singularities.
  Automatically detects if singularities exist and handles them appropriately.
category: specialists
tags:
  - physics
  - simulation
  - numerical-methods
  - optimization
  - NNC
  - scientific-computing
  - accuracy
author: meta-calculus-toolkit
orchestration:
  primary_agent: coder-enhanced
  support_agents:
    - quantum-computing-researcher  # Quantum physics, numerical algorithms
    - model-evaluation-agent        # Rigorous accuracy comparison vs k=0
    - experiment-tracking-agent     # Track simulation experiments
    - evaluator                     # Quality gate validation
    - root-cause-analyzer           # Debug failed simulations
    - sublinear-goal-planner        # Complex problem decomposition
  coordination: sequential
mcp_servers:
  required: [memory-mcp]
  optional: [flow-nexus]
---

# Physics Simulation Creator

Create optimal physics simulations with automatic parameter tuning using Non-Newtonian Calculus (NNC).

## Overview

This skill helps AI agents create **ANY numerical physics simulation** with optimal accuracy and minimal computational complexity. The k parameter from NNC provides a tuning knob that:

1. **Maximizes accuracy** for your specific problem type
2. **Minimizes computational steps** needed for convergence
3. **Handles singularities automatically** (if present)

**Key Insight**: Classical calculus (k=0) is not always optimal. Different physics problems benefit from different k values - even smooth problems without singularities.

## When to Use This Skill

### ALWAYS USE FOR (Significant gains):
- Problems with singularities (1/r, 1/r^2, crack tips, etc.)
- Molecular dynamics (atomic scale, L ~ 1e-10 m)
- Quantum simulations near singularities (hydrogen atom)
- Fracture mechanics (crack tip singularities)
- Gravitational simulations (black holes, 1/r potentials)

### USE FOR COMPUTATIONAL EFFICIENCY (Same accuracy, fewer steps):
- **Large simulations on consumer hardware** - 7-100x step reduction
- Long-time molecular dynamics (run 10x longer trajectories)
- Real-time physics in games/VR (same accuracy, faster)
- Parameter sweeps (run 10x more configurations)
- Stiff ODEs (dramatically fewer steps to converge)

### CONSIDER USING FOR (Moderate accuracy gains):
- Microscale simulations (L < 1e-6 m)
- Ultra-high precision requirements (>6 digits)
- Rapid scale-change problems

### k=0 IS OPTIMAL FOR (No NNC needed):
- Smooth quantum mechanics (harmonic oscillator)
- Human-scale engineering (1mm - 1km)
- Large-scale cosmology (smooth metrics)
- Problems with adequate engineering tolerance

### The Process

```
1. Analyze problem -> Does it have singularities? What length scale?
2. Select optimal k -> For accuracy AND complexity, not just singularity handling
3. Generate code -> With NNC transforms at optimal k
4. Validate -> Compare accuracy vs classical (k=0)
```

### Singularity Detection (Part of Process, Not the Only Use)

The skill automatically checks: **"Does this problem have a singularity I need to watch out for?"**

- If YES: k is tuned to handle it (e.g., k=-1 for 1/r)
- If NO: k is still optimized for accuracy/complexity (often k != 0)

---

## When k != 0 Provides Meaningful Gains

### Understanding the k(L) Formula

The k(L) formula from multi-objective optimization shows optimal k varies by scale:

| Scale | Optimal k | Accuracy Gain | Step Reduction | Recommendation |
|-------|-----------|---------------|----------------|----------------|
| Planck (1e-35 m) | 0.64 | 50%+ | 50-100x | **ALWAYS use NNC** |
| Atomic (1e-10 m) | 0.30 | 15-30% | 7-22x | **Use NNC** - significant |
| Micro (1e-6 m) | 0.24 | 10-20% | 5-10x | Use NNC for large sims |
| Human (1 m) | 0.16 | <5% | 1.5-3x | k=0 unless need speed |
| Solar (1e11 m) | 0.01 | <1% | ~1x | k=0 optimal |
| Galactic (1e21 m) | -0.13 | <5% | ~1x | k=0 optimal |

### Practical Decision Rule

**Use NNC (k != 0) when:**
1. Problem has explicit singularities (1/r, 1/r^2, etc.) - **ALWAYS**
2. Length scale < 1e-6 m (microscale and smaller) - **accuracy gains > 10%**
3. **Need to reduce computational steps** - 7-100x fewer steps at small scales
4. **Running large simulations on limited hardware** - same accuracy, faster
5. Ultra-high precision required (>6 digits) - even for smooth problems

**Use classical (k = 0) when:**
1. Smooth problem at human scale (1mm - 1km) AND speed not critical
2. Engineering tolerance is adequate (3-4 digits)
3. Simplicity preferred AND not computationally constrained

### Accuracy vs Complexity Trade-off

The CASCADE algorithm (61.9% win rate vs classical) proves that:
- Optimal k reduces step count by 7-100x (at microscale)
- Optimal k improves accuracy by 10-40,000x (for singularities) or 10-30% (for smooth microscale)
- These gains apply to BOTH singular and smooth problems (but magnitude differs)

---

## Bundled Script: ai_simulation_helper.py

**Location**: `skills/specialists/physics-simulation-creator/ai_simulation_helper.py`

### For ANY Physics Problem

```bash
# Get optimal k from length scale (works for ALL problems)
python ai_simulation_helper.py --length-scale 1e-10 --json

# Check if problem has singularity AND get optimal k
python ai_simulation_helper.py --problem "molecular dynamics" --json

# Generate optimized code
python ai_simulation_helper.py --length-scale 1e-10 --generate python --json

# Lookup k across all scales
python ai_simulation_helper.py --lookup all --json
```

### Script Output Structure

```json
{
  "k": 0.2963,
  "source": "length_scale",
  "length_scale": 1e-10,
  "has_singularity": false,
  "singularity_type": "none",
  "expected_accuracy_gain": "15-30% over classical",
  "expected_speedup": "1.5-3x fewer steps"
}
```

Or with singularity:
```json
{
  "k": -1.0,
  "source": "singularity_type",
  "singularity_type": "1/r",
  "has_singularity": true,
  "expected_accuracy_gain": "10,000x+ over classical",
  "expected_speedup": "7-22x fewer steps"
}
```

---

## Core Formula

### k from Length Scale (Universal)

```
k_optimal(L) = -0.0137 * log10(L) + 0.1593
```

This works for ALL problems - singular or smooth.

### k from Singularity Type (When Present)

| Singularity | k | Use When |
|-------------|---|----------|
| 1/r | -1.0 | Coulomb, gravitational |
| 1/r^2 | -2.0 | Radiation intensity |
| 1/sqrt(r) | -0.5 | Crack tip stress |
| none | Use k(L) formula | Smooth problems |

**Decision Rule**:
- If explicit singularity exists: use singularity-based k
- If smooth/unknown: use k(L) formula based on length scale
- NEVER assume k=0 without checking

---

## Workflow Phases

### Phase 1: Problem Analysis (Researcher Agent)

**Questions to answer**:
1. What is the characteristic length scale?
2. Does the problem have any singularities? (1/r, 1/r^2, etc.)
3. What are the accuracy requirements?
4. What are the performance requirements?

**Output**:
```yaml
problem_analysis:
  length_scale: 1e-10  # meters
  has_singularity: false
  singularity_type: null
  accuracy_target: 1e-6
  performance_target: real-time
```

### Phase 2: k-Value Selection (CLI Script)

```bash
# Always run this - it works for ALL problems
python ai_simulation_helper.py --length-scale {L} --json
```

**If singularity detected**:
```bash
python ai_simulation_helper.py --singularity "1/r" --json
```

### Phase 3: Code Generation (Coder Agent)

Generate simulation with optimal k, whether singular or smooth.

### Phase 4: Validation (Tester Agent)

Compare against classical (k=0) to verify improvement:
- Accuracy comparison
- Step count comparison
- Convergence rate comparison

---

## Sub-Agents (From 206-Agent Registry)

| Agent | Path | Role | When Used |
|-------|------|------|-----------|
| **coder-enhanced** | `foundry/core/` | Generate complex numerical simulation code with TDD | Phase 3: Code generation |
| **quantum-computing-researcher** | `research/emerging/quantum/` | Quantum physics, algorithm design, numerical methods expertise | Phase 1: Quantum problems |
| **model-evaluation-agent** | `platforms/ai-ml/evaluation/` | Rigorous statistical comparison (k=optimal vs k=0), metrics | Phase 4: Accuracy validation |
| **experiment-tracking-agent** | `platforms/ai-ml/experiments/` | Track simulation experiments, log parameters, reproducibility | Phase 3-4: Experiment logging |
| **evaluator** | `research/` | Quality gate validation, GO/NO-GO decisions | Phase 4: Final validation |
| **root-cause-analyzer** | `quality/analysis/` | Debug failed simulations, identify numerical issues | Phase 4: Error diagnosis |
| **sublinear-goal-planner** | `research/reasoning/` | Complex problem decomposition, multi-step planning | Phase 1: Problem analysis |

### Agent Selection Rationale

**Why coder-enhanced over coder?**
- Better for complex numerical code
- TDD-focused approach for validation
- Handles scientific computing patterns

**Why model-evaluation-agent?**
- Statistical comparison expertise (paired t-test, effect size)
- Quantifies improvement: k=optimal vs k=0
- Generates evaluation reports

**Why experiment-tracking-agent?**
- Logs k values, length scales, singularity types
- Tracks accuracy/performance metrics across runs
- Enables reproducibility

**Why root-cause-analyzer?**
- When simulations fail or produce wrong results
- Identifies numerical issues (NaN, overflow, divergence)
- Maps to ERROR-DETECTION.md patterns

---

## Input/Output Contracts

### Input Contract

```yaml
input_contract:
  required:
    - problem_description: string
  optional:
    - length_scale: float  # If known
    - singularity_type: string  # If known ("none" for smooth)
    - accuracy_target: float
    - performance_target: string
    - target_language: string  # "python" or "typescript"
```

### Output Contract

```yaml
output_contract:
  required:
    - optimal_k: float
    - k_source: string  # "length_scale" or "singularity_type"
    - has_singularity: boolean
    - simulation_code: string
  optional:
    - accuracy_comparison: object  # vs k=0
    - performance_comparison: object  # vs k=0
    - validation_report: object
```

---

## Examples

### Example 1: Smooth Quantum Problem (No Singularity)

**Problem**: Harmonic oscillator simulation

```bash
python ai_simulation_helper.py --length-scale 1e-10 --json
```

**Output**:
```json
{
  "k": 0.2963,
  "has_singularity": false,
  "expected_accuracy_gain": "15-30% over classical"
}
```

**Result**: Even though there's no singularity, k=0.30 gives better accuracy than k=0.

### Example 2: Problem WITH Singularity

**Problem**: Molecular dynamics with Lennard-Jones

```bash
python ai_simulation_helper.py --problem "molecular dynamics" --json
```

**Output**:
```json
{
  "k": -1.0,
  "has_singularity": true,
  "singularity_type": "1/r",
  "expected_accuracy_gain": "10,000x+ over classical"
}
```

**Result**: Singularity detected, k tuned to handle it.

### Example 3: Large-Scale Cosmology

**Problem**: Galaxy formation simulation

```bash
python ai_simulation_helper.py --length-scale 1e21 --json
```

**Output**:
```json
{
  "k": -0.1284,
  "has_singularity": false,
  "expected_accuracy_gain": "5-10% over classical"
}
```

**Result**: At galactic scales, k goes slightly negative but is still not exactly 0.

---

## Key Mindset Shift

### OLD (Incomplete) Thinking:
> "Use NNC only for singularities. Otherwise use classical (k=0)."

### NEW (Complete) Thinking:
> "NNC with optimal k provides significant gains for singularities and microscale problems. For smooth human-scale problems, k=0 remains optimal. Always CHECK rather than ASSUME."

### Decision Summary:
| Condition | Action |
|-----------|--------|
| Singularity present | Use k from singularity table (k=-1 for 1/r, etc.) |
| L < 1e-6 m, smooth | Use k from k(L) formula (gains > 10%) |
| Human scale, smooth | k=0 is optimal (gains < 5%) |
| Need ultra-precision | Consider k(L) even for smooth problems |

---

## Guardrails

### ALWAYS
- Run the CLI script to get optimal k (even for smooth problems)
- Check if singularities exist (but don't ONLY use skill for singularities)
- Compare results against k=0 baseline
- Document the k value and why it was chosen

### NEVER
- Assume k=0 is optimal without checking
- Skip k optimization because "there's no singularity"
- Use this skill ONLY for singular problems

---

## Success Metrics

| Metric | Target |
|--------|--------|
| k-value selection | Use CLI script output |
| Accuracy vs k=0 | Document improvement |
| Performance vs k=0 | Document step reduction |
| Singularity detection | Correctly identify if present |

---

## References

- Meta-Calculus Portfolio: https://meta-calculus-portfolio-production.up.railway.app/
- k(L) Formula: https://meta-calculus-portfolio-production.up.railway.app/results/multiscale
- CASCADE Results: https://meta-calculus-portfolio-production.up.railway.app/cascade
- GUD Benchmarks: https://meta-calculus-portfolio-production.up.railway.app/proof/gud-benchmarks

---

## Memory Namespace

```yaml
namespaces:
  - physics-simulation-creator/problems/{id}: Analyzed problems
  - physics-simulation-creator/simulations/{id}: Generated simulations
  - physics-simulation-creator/comparisons/{id}: k=optimal vs k=0 results
```
