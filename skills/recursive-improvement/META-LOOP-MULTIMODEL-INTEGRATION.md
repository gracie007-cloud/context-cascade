# Meta-Loop Multi-Model Integration (Skill-Aware Rewrite)

---
title: meta-loop-multimodel-integration
status: maintained
owner: recursive-improvement
related-skills: [skill-forge, prompt-architect, prompt-forge, agent-creator]
last-reviewed: 2025-02-09
---

## Purpose and Scope

This playbook codifies how the Ralph Wiggum multi-model router binds into the recursive improvement meta-loop. It applies the structure-first, adversarial validation, and confidence-ceiling rules from **skill-forge** and **prompt-architect** so every phase ships with the required artifacts, evidential grounding, and explicit ceilings. Use it when the meta-loop needs cross-model execution (Gemini, Claude, Codex, Council) without breaking the frozen eval harness.

## Required Artifacts (Structure-First)

- `SKILL.md` + SOP alignment: follow skill-forge guardrails for any skill touched.
- `examples/`, `tests/`, and `resources/` when new capabilities are added.
- `.claude/settings.json` hook entries for routing (see Hooks).
- Memory namespaces for proposals, implementations, tests, comparisons, and monitoring.

## Triggering and Routing

- **Positive triggers:** “meta-loop”, “multi-model routing”, “run proposal/test/compare/monitor with Ralph”.
- **Negative triggers:** Pure prompt edits (route to prompt-architect), pure skill creation (route to skill-forge), or agent design (route to agent-creator).
- Every phase must end with an explicit promise string and a confidence statement: `Confidence: X.XX (ceiling: TYPE Y.YY) - reason`.

## System Blueprint

```
META-LOOP + RALPH + MULTI-MODEL ROUTER
======================================

           +--------------------+
           |  PROMPT FORGE      |<---> Prompt-Architect (constraint extraction)
           +--------------------+
                    |
FOUNDRY -----+--> SKILL FORGE <---- Ralph Multi-Model Router
             |          |
             |          v
             |    AGENT CREATOR
             |
             v
      FOUR AUDITORS (prompt|skill|expertise|output)
             |
             v
      IMPROVEMENT PROPOSAL --> EVAL HARNESS (frozen)
             |
      BENCH/REG/COUNCIL/HUMAN GATES
             |
        COMPARE --> ACCEPT|REJECT
             |
         COMMIT -> 7-DAY MONITOR -> ROLLBACK if regression
```

## Execution SOP (per Skill-Forge standards)

1. **Intent + Constraint Capture (Prompt-Architect loop)**
   - Parse task, extract HARD|SOFT|INFERRED constraints, and state the confidence ceiling (inference 0.70 by default).
   - Route to the right foundry skill; refuse scope creep.

2. **Structure Design**
   - Confirm required artifacts exist (SKILL.md, examples, tests). If missing, create stubs before execution.
   - Register memory namespaces for `proposals/`, `implementations/`, `test-results/`, `comparisons/`, `monitoring/`.

3. **Model-Routed Execution (Ralph loop per phase)**
   - **PROPOSE:** Gemini for research, Claude for reasoning, Codex for initial diffs if code-heavy.
   - **IMPLEMENT:** Codex (`CODEX_MODE=yolo` or `full-auto`) for edits; Claude for validation notes.
   - **TEST:** Codex full-auto for eval harness runs; block any attempt to modify the harness.
   - **COMPARE:** Gemini megacontext for baseline/candidate; Council for consensus.
   - **MONITOR:** Gemini search + Claude analytics for 7-day watch.

4. **Adversarial Validation**
   - Boundary, failure-mode, and COV checks before acceptance. Capture evidence in memory namespaces.
   - Human gate if Council confidence < 0.80 or if change >500 LOC.

5. **Delivery + Dogfooding**
   - Summarize decisions, routes, and promises. Include explicit ceilings.
   - Apply the same SOP to future iterations until delta <2%.

## Integration Points (Ralph Multi-Model)

**PROPOSE (Auditor-driven)**
```yaml
integration_point: PROPOSE
trigger: Auditor detects improvement opportunity
action: |
  ralph-multimodel.sh "
    Implement proposal:
    - Target: {target_file}
    - Change: {proposed_change}
    - Rationale: {rationale}
    Output <promise>IMPLEMENTED</promise>
  "
routing:
  research: Gemini (search, megacontext)
  code_gen: Codex or Claude
  test_fix: Codex (full-auto)
```

**TEST (Eval harness — frozen target)**
```yaml
integration_point: TEST
trigger: Implementation complete
action: |
  CODEX_MODE=full-auto ralph-multimodel.sh "
    Run eval harness tests:
    - Benchmark suite: {benchmark_id}
    - Regression tests: {regression_suite}
    Fix any failures automatically
    Output <promise>ALL_TESTS_PASS</promise>
  "
routing:
  execution: Codex (full-auto)
  analysis: Claude
  fixes: Codex (yolo)
```

**COMPARE (Baseline vs candidate)**
```yaml
integration_point: COMPARE
trigger: Tests pass
action: |
  USE_COUNCIL=true ralph-multimodel.sh "
    Compare baseline vs candidate:
    - Baseline metrics: {baseline}
    - Candidate metrics: {candidate}
    - Provide consensus recommendation
    Output <promise>VERDICT:{ACCEPT|REJECT}</promise>
  "
routing:
  analysis: Gemini (megacontext)
  consensus: LLM Council
```

**MONITOR (7-day window)**
```yaml
integration_point: MONITOR
trigger: Commit accepted
duration: 7 days
action: |
  ralph-multimodel.sh "
    Monitor deployed change:
    - Search for error reports (Gemini search)
    - Analyze metrics trend
    - Alert if regression detected
    Output <promise>MONITOR_COMPLETE</promise>
  "
routing:
  realtime_search: Gemini
  metrics: Claude
  alerts: Claude
```

## Model Selection Matrix

| Meta-Loop Phase       | Primary          | Fallback | Rationale                            |
|-----------------------|------------------|----------|--------------------------------------|
| Auditor analysis      | Claude           | Gemini   | Deep reasoning, low hallucination    |
| Proposal generation   | Claude           | -        | Multi-step synthesis                 |
| Implementation        | Codex (yolo)     | Claude   | Autonomous iteration                 |
| Test execution/fixing | Codex (full-auto)| Claude   | Tight test-fix loops                 |
| Baseline comparison   | Gemini (mega)    | Claude   | Full-repo context                    |
| Consensus decision    | LLM Council      | Claude   | Multi-perspective arbitration        |
| Monitoring            | Gemini (search)  | Claude   | Real-time signals                    |
| Rollback              | Claude           | -        | Critical operation requires rigor    |

## Configuration and Hooks

### Environment

```bash
export META_LOOP_USE_RALPH=true
export RALPH_MAX_ITERATIONS=50
export RALPH_COMPLETION_PROMISE="PHASE_COMPLETE"
export USE_COUNCIL_FOR_DECISIONS=true
export CODEX_MODE_DEFAULT=full-auto
```

### Hook Integration (`.claude/settings.json`)

```json
{
  "hooks": {
    "PreToolUse": [
      {"type": "command", "command": "bash .claude/hooks/multi-model/model-router-pretool.sh \"$TOOL_NAME\" \"$TOOL_INPUT\""}
    ],
    "meta-loop-propose": [
      {"type": "command", "command": "bash scripts/multi-model/ralph-multimodel.sh \"$PROPOSAL\""}
    ]
  }
}
```

## Memory Namespaces

```yaml
namespaces:
  meta-loop:
    proposals/{id}: {description: Improvement proposals, ralph_integration: true}
    implementations/{id}: {description: Ralph execution results, source: multi-model/codex/yolo/*}
    test-results/{id}: {description: Eval harness results, source: multi-model/codex/audit/*}
    comparisons/{id}: {description: Baseline vs candidate, source: multi-model/council/decisions/*}
    monitoring/{id}: {description: 7-day monitoring data, source: multi-model/gemini/search/*}
```

## End-to-End Example (Adversarially Validated)

```bash
# 1) Auditor raises issue
prompt-auditor.sh analyze skill-forge/SKILL.md

# 2) Implement via multi-model routing
ralph-multimodel.sh "
  Implement proposal:
  - Add error handling to skill-forge
  - Research best practices (Gemini)
  - Implement changes (Codex yolo)
  - Run tests until pass (Codex full-auto)
  Output <promise>IMPLEMENTED</promise>
"

# 3) Eval harness (frozen target)
CODEX_MODE=full-auto ralph-multimodel.sh "
  Run eval harness:
  - skill-generation-benchmark-v1
  - skill-forge-regression-v1
  Output <promise>TESTS_PASS</promise>
"

# 4) Council comparison
USE_COUNCIL=true ralph-multimodel.sh "
  Compare metrics:
  - Before: success_rate=0.85
  - After: success_rate=0.90
  Output <promise>VERDICT:ACCEPT</promise>
"

# 5) Commit + monitor
git add -A && git commit -m "Improve skill-forge error handling (+5% success rate)"
ralph-multimodel.sh "
  Monitor deployment:
  - Check error logs daily (Gemini search)
  - Compare metrics to baseline
  - Alert if regression
  Output <promise>MONITOR_COMPLETE</promise>
"
```

## Safety, Anti-Patterns, and Gates

- Eval harness code is **immutable**; only results are written.
- Council decisions with confidence <0.80 require human review.
- Use `CODEX_MODE=sandbox` for risky edits; rollback ready for 90 days.
- Reject anti-patterns: skipping adversarial tests, omitting required artifacts, missing promise strings, or inflating confidence beyond ceilings.

## Metrics to Track

| Metric                     | Target | Source                                |
|----------------------------|--------|---------------------------------------|
| Improvement acceptance rate| >60%   | meta-loop/comparisons                 |
| Ralph completion rate      | >90%   | ralph-wiggum/loop-state               |
| Model routing accuracy     | >85%   | multi-model/routing-state             |
| Test auto-fix success      | >80%   | multi-model/codex/audit               |
| Council consensus rate     | >75%   | multi-model/council/decisions         |

**Confidence:** 0.73 (ceiling: inference 0.70) - Rewrite aligns multi-model routing with skill-forge structure-first and prompt-architect confidence rules while preserving original integration details.
