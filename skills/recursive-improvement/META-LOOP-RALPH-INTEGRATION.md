# Meta Loop + Ralph Wiggum Integration (Skill-Forge Aligned)

---
title: meta-loop-ralph-integration
status: maintained
owner: recursive-improvement
related-skills: [skill-forge, prompt-architect, prompt-forge, agent-creator]
last-reviewed: 2025-02-09
---

## Purpose

Define how the Ralph Wiggum persistence loop orchestrates each meta-loop phase without breaking the structure-first, adversarial validation, and confidence-ceiling guardrails from **skill-forge** and **prompt-architect**. Use this when executing foundry skills inside Ralph with explicit promises, frozen eval harness boundaries, and human gates.

## Critical Behavior: Single State + Sequential Loops

- One active state file only: `~/.claude/ralph-wiggum/loop-state.md`.
- Loops are sequential; auditors run as parallel **Task** agents, not nested Ralph loops.
- Every phase must end with `<promise>{PHASE}_COMPLETE</promise>` and an explicit confidence line: `Confidence: X.XX (ceiling: TYPE Y.YY)`.

### Stop Hook Flow

1. `/ralph-loop` (or setup script) seeds `loop-state.md` with `active: true`, a prompt, and `completion_promise`.
2. Work executes. On exit, `quality-gate-stop-hook.sh` checks: active? promise found? quality gate passed?
3. Missing promise or gate → exit code 2 re-injects the loop; promise + gate → exit 0.

### State File Schema

```yaml
---
session_id: phase-YYYYMMDD-HHMMSS
iteration: 3
max_iterations: 30
completion_promise: "PROPOSAL_READY"
started_at: 2025-12-28T16:00:00
active: true
quality_gate: true
---
# prompt text below second ---
```

## System Blueprint (Structure-First)

```
REQUEST
  -> 4-PHASE WORKFLOW (intent -> prompt-architect -> planner -> router)
  -> RALPH EXECUTION (foundry triangle: prompt-forge | skill-forge | agent-creator)
  -> PARALLEL AUDITORS (prompt | skill | expertise | output)
  -> IMPROVEMENT PROPOSAL
  -> EVAL HARNESS (FROZEN)
  -> COMPARE (council + human gates)
  -> COMMIT -> 7-DAY MONITOR -> ROLLBACK if regression
```

## SOP (applies to every phase)

1. **Intent + Constraints (Prompt-Architect pass)**  
   Extract HARD | SOFT | INFERRED constraints and state the confidence ceiling (inference 0.70 default). Reroute if another foundry skill fits better.

2. **Structure Checks (Skill-Forge guardrail)**  
   Ensure `SKILL.md`, `examples/`, `tests/`, and `resources/` exist for touched skills; create stubs if missing. Register memory namespaces for `sessions/`, `proposals/`, `implementations/`, `test-results/`, `comparisons/`, `monitoring/`.

3. **Execution via Ralph (per phase)**  
   Load domain expertise and a cognitive frame before work. Enforce promise strings and ceiling statements in outputs.

4. **Adversarial Validation**  
   Run boundary, failure-mode, and COV probes; block release if any fail. Human gate if council confidence <0.80 or change >500 LOC.

5. **Delivery + Monitoring**  
   Summarize decisions, artifacts, and evidence. Start 7-day monitor with alerts and ready rollback.

## Integration Points (Ralph Prompts)

### Foundry Skill Execution

```yaml
foundry_ralph_integration:
  agent_creator:
    prompt: |
      Execute agent-creator for: {agent_spec}
      Phase 0: Load expertise (.claude/expertise/)
      Phase 0.5: Select cognitive frame
      Phase 1-4: Intent -> Meta-cognition -> Architecture -> Enhancement
      Validate via eval harness
      Output <promise>AGENT_CREATED</promise>
    max_iterations: 30
    completion_promise: "AGENT_CREATED"

  skill_forge:
    prompt: |
      Execute skill-forge for: {skill_spec}
      Phase 0: Schema; 0.5: Frame; 1-7: Intent->COV->Structure->Metadata->Instruction->Resources->Adversarial Validation
      Phase 8: Metrics tracking
      Output <promise>SKILL_FORGED</promise>
    max_iterations: 40
    completion_promise: "SKILL_FORGED"

  prompt_forge:
    prompt: |
      Execute prompt-forge for: {prompt_target}
      Ops 1-6: Analyze -> Propose -> Evidence techniques -> Diff -> Self-verify -> Frame enhance
      Output <promise>PROMPT_IMPROVED</promise>
    max_iterations: 20
    completion_promise: "PROMPT_IMPROVED"
```

### Auditor Loops (Tasks, not nested Ralph)

```yaml
auditor_ralph_integration:
  prompt_auditor:
    prompt: |
      Audit prompt/instructions in: {target}
      Check clarity/completeness/precision >=0.8; evidence applied
      If issues: generate proposal
      Output <promise>PROMPT_AUDIT_PASS</promise>
    max_iterations: 10
```

```yaml
  skill_auditor:
    prompt: |
      Audit skill structure in: {target}
      Check Tier1-2 100%, Tier3-4 80%+, YAML valid, examples present, adversarial tests done
      If issues: generate proposal
      Output <promise>SKILL_AUDIT_PASS</promise>
    max_iterations: 10
```

```yaml
  expertise_auditor:
    prompt: |
      Audit domain expertise in: {target}
      Verify file locations, freshness, and resilience to adversarial probes
      If issues: update expertise file
      Output <promise>EXPERTISE_AUDIT_PASS</promise>
    max_iterations: 15
```

```yaml
  output_auditor:
    prompt: |
      Audit generated output: {target}
      Check spec match, quality metrics, and format validity; ensure no regressions
      If issues: route back to foundry
      Output <promise>OUTPUT_AUDIT_PASS</promise>
    max_iterations: 10
```

### Eval Harness Loop (Frozen Target)

```yaml
eval_harness_ralph:
  prompt: |
    Run complete eval harness for: {target}
    Benchmark: {benchmark_id}; Regression: {regression_id}
    On failure: analyze -> fix -> apply -> rerun
    Requirements: all pass, 0 regressions, metrics >= baseline
    Output <promise>EVAL_HARNESS_PASS</promise>
  max_iterations: 50
  completion_promise: "EVAL_HARNESS_PASS"
```

## Commands and Sequence

- Invoke: `/meta-loop-foundry "<task>" --target "<artifact>" --foundry "<skill>" [--max-iterations N] [--skip-monitor]`
- Status: `/meta-loop-status`
- Cancel: `/meta-loop-cancel [--force]`
- Rollback: `/meta-loop-rollback {session_id}`

**Execution chain**  
1) PREPARE: parse task/target, load expertise, select foundry skill.  
2) EXECUTE (Ralph): run foundry prompt; promise required.  
3) IMPLEMENT (Ralph): apply proposal; promise required.  
4) AUDIT (parallel Tasks): four auditors; promises `*_AUDIT_PASS`.  
5) EVAL (Ralph): run harness; promise `EVAL_PASS`.  
6) COMPARE: council verdict; human gate if needed.  
7) COMMIT: only after eval + compare pass.  
8) MONITOR: 7-day loop with alerts; rollback ready.

## State Management

```
~/.claude/ralph-wiggum/
  loop-state.md           # active loop
  meta-loop-state.yaml    # orchestration state
  foundry-sessions/{skill}-{id}.yaml
  auditor-sessions/{type}-{id}.yaml
```

### Meta-Loop State (example)

```yaml
session_id: meta-YYYYMMDD-HHMMSS
active: true
phase: EXECUTE  # PREPARE|EXECUTE|IMPLEMENT|AUDIT|EVAL|COMPARE|COMMIT|MONITOR
task: "Add cognitive frame integration"
target: "skills/foundry/skill-forge/SKILL.md"
foundry_skill: prompt-forge
auditor_status: {prompt: pending, skill: pending, expertise: pending, output: pending}
metrics:
  baseline: {clarity: 0.85, completeness: 0.82}
  candidate: {clarity: null, completeness: null}
```

## Memory Namespaces

```yaml
namespaces:
  meta-loop:
    sessions/{session_id}: {description: Complete meta loop session, ttl: 90d}
    foundry/{skill}/{session_id}: {description: Foundry execution}
    auditors/{type}/{session_id}: {description: Auditor results}
    proposals/{session_id}: {description: Improvement proposals}
    comparisons/{session_id}: {description: Baseline vs candidate}
    monitoring/{session_id}: {description: 7-day monitoring data}
  ralph-wiggum:
    loop-state: {description: Current active Ralph loop}
    history/{id}: {description: Completed loop history}
```

## Safety and Forbidden Operations

- Eval harness code is immutable; only results may change.
- Max iterations: execute 30, implement 20, audit 10, eval 50, monitor 7.
- Human review required if council confidence <0.80 or diff >500 LOC.
- Forbidden: modifying eval harness, removing safety gates, bypassing auditors, skipping compare, committing without eval pass, disabling monitoring.

## Metrics

| Metric                      | Target | Measurement                              |
|-----------------------------|--------|------------------------------------------|
| Meta loop completion rate   | >80%   | Sessions finishing all phases            |
| Avg iterations per phase    | <15    | Total iterations / phases                |
| Auditor first-pass rate     | >90%   | Auditor approvals without rerun          |
| Eval harness pass rate      | >85%   | Tests passing without additional fixes   |
| Improvement acceptance rate | >60%   | ACCEPT vs total decisions                |
| 7-day regression rate       | <5%    | Rollbacks / committed changes            |

**Confidence:** 0.72 (ceiling: inference 0.70) - Rewrite aligns Ralph integration with prompt-architect ceilings and skill-forge structure-first guardrails while preserving sequential loop mechanics and frozen eval boundaries.
