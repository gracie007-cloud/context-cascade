---
name: bootstrap-loop
description: Orchestrates the recursive self-improvement cycle where Prompt Forge improves Skill Forge, Skill Forge improves Prompt Forge, and both audit/improve everything else. All changes gated by frozen eval harness.
version: 1.0.0
category: foundry
tags:
  - recursive
  - self-improvement
  - dogfooding
  - orchestration
---

# Bootstrap Loop (Recursive Self-Improvement Orchestrator)

## Purpose

Orchestrate the recursive improvement cycle:

```
+------------------+         +------------------+
|   PROMPT FORGE   |-------->|   SKILL FORGE    |
| (Meta-Prompt)    |<--------|   (Meta-Skill)   |
+------------------+         +------------------+
         |                            |
         |   Improved tools audit     |
         |   and improve everything   |
         v                            v
+--------------------------------------------------+
|              AUDITOR AGENTS                       |
|  [Prompt] [Skill] [Expertise] [Output]           |
+--------------------------------------------------+
         |                            |
         |   All changes gated by     |
         v                            v
+--------------------------------------------------+
|              EVAL HARNESS (FROZEN)               |
|  Benchmarks | Regression Tests | Human Gates     |
+--------------------------------------------------+
```

**CRITICAL**: The eval harness does NOT self-improve. It is the anchor that prevents Goodhart's Law.

## When to Use

- Running a recursive improvement cycle
- Improving meta-tools (Prompt Forge, Skill Forge)
- Auditing and improving system-wide prompts/skills
- Measuring improvement over time

## MCP Requirements

### memory-mcp (Required)

**Purpose**: Store proposals, test results, version history, metrics

**Activation**:
```bash
claude mcp add memory-mcp npx @modelcontextprotocol/server-memory
```

---

## Core Operations

### Operation 1: Run Single Improvement Cycle

Execute one full cycle of recursive improvement.

```yaml
cycle:
  id: "cycle-{timestamp}"
  target: "prompt-forge|skill-forge|all"

  phases:
    1_analyze:
      action: "Prompt Forge analyzes target for weaknesses"
      output: "Analysis with improvement opportunities"

    2_propose:
      action: "Prompt Forge generates improvement proposals"
      output: "Concrete proposals with diffs"

    3_apply:
      action: "Skill Forge applies proposals (builds new version)"
      output: "New version of target"

    4_evaluate:
      action: "Eval Harness tests new version"
      output: "Benchmark + regression results"

    5_decide:
      action: "Compare results, decide ACCEPT or REJECT"
      output: "Decision with reasoning"

    6_commit_or_rollback:
      action: "If ACCEPT: commit + archive. If REJECT: rollback"
      output: "Final state + audit log"
```

### Operation 2: Improve Prompt Forge

Use Skill Forge to improve Prompt Forge.

```yaml
improve_prompt_forge:
  process:
    - step: "Analyze Prompt Forge with prompt-auditor"
      agent: "prompt-auditor"
      output: "Audit report with issues"

    - step: "Generate improvement proposals"
      agent: "prompt-forge" (self-analysis)
      output: "Proposals for self-improvement"

    - step: "Apply improvements with Skill Forge"
      agent: "skill-forge"
      output: "prompt-forge-v{N+1}"

    - step: "Test against eval harness"
      eval: "prompt-generation-benchmark-v1"
      regression: "prompt-forge-regression-v1"

    - step: "If improved: commit. If regressed: reject"

  safeguards:
    - "Previous version archived before changes"
    - "Requires eval harness pass"
    - "Rollback available for 30 days"
    - "Auditor agents must agree on improvement"

  forbidden_changes:
    - "Removing safeguards"
    - "Bypassing eval harness"
    - "Modifying frozen benchmarks"
```

### Operation 3: Improve Skill Forge

Use Prompt Forge to improve Skill Forge.

```yaml
improve_skill_forge:
  process:
    - step: "Analyze Skill Forge with skill-auditor"
      agent: "skill-auditor"
      output: "Audit report with issues"

    - step: "Generate improvement proposals with Prompt Forge"
      agent: "prompt-forge"
      output: "Proposals with rationale"

    - step: "Apply improvements (Skill Forge rebuilds itself)"
      agent: "skill-forge" (self-rebuild)
      output: "skill-forge-v{N+1}"

    - step: "Test against eval harness"
      eval: "skill-generation-benchmark-v1"
      regression: "skill-forge-regression-v1"

    - step: "If improved: commit. If regressed: reject"

  safeguards:
    - "Previous version archived before changes"
    - "Requires eval harness pass"
    - "Self-rebuild uses PREVIOUS version (not new)"
    - "Human gate for breaking changes"
```

### Operation 4: Audit Everything

Use improved meta-tools to audit and improve all prompts/skills.

```yaml
audit_all:
  scope:
    prompts: [".claude/skills/**/SKILL.md"]
    expertise: [".claude/expertise/*.yaml"]

  process:
    - step: "Run prompt-auditor on all skills"
      parallel: true
      output: "Audit reports per skill"

    - step: "Run skill-auditor on all skills"
      parallel: true
      output: "Compliance reports per skill"

    - step: "Run expertise-auditor on all expertise"
      parallel: true
      output: "Drift reports per domain"

    - step: "Prioritize issues by severity"
      output: "Prioritized issue list"

    - step: "Generate improvement proposals for top issues"
      max_proposals: 10
      output: "Proposal queue"

    - step: "Process proposals through eval harness"
      sequential: true  # One at a time
      output: "ACCEPT/REJECT decisions"
```

### Operation 5: Monitor Improvement Trend

Track improvement over time.

```yaml
monitoring:
  metrics:
    - name: "prompt_generation_quality"
      source: "prompt-generation-benchmark-v1"
      target: "> 0.85"

    - name: "skill_generation_quality"
      source: "skill-generation-benchmark-v1"
      target: "> 0.85"

    - name: "regression_rate"
      source: "rollback events / commits"
      target: "< 5%"

    - name: "cycle_time"
      source: "proposal to commit duration"
      target: "< 4 hours"

    - name: "improvement_acceptance_rate"
      source: "accepted / proposed"
      target: "> 60%"

  alerts:
    - trigger: "regression_rate > 10%"
      action: "Pause improvement cycles, human review"

    - trigger: "improvement_acceptance_rate < 40%"
      action: "Review proposal quality, adjust auditor sensitivity"

    - trigger: "3 consecutive rejections"
      action: "Analyze patterns, possible eval harness gap"
```

---

## Cycle Protocol

### Full Cycle Execution

```javascript
async function runBootstrapCycle(target, options = {}) {
  const cycle = {
    id: `cycle-${Date.now()}`,
    target,
    timestamp: new Date().toISOString(),
    phases: {},
    result: null
  };

  // Phase 1: Analyze
  cycle.phases.analyze = await runPhase('analyze', target, {
    agent: 'prompt-auditor',
    action: `Analyze ${target} for improvement opportunities`
  });

  // Phase 2: Propose
  cycle.phases.propose = await runPhase('propose', target, {
    agent: 'prompt-forge',
    input: cycle.phases.analyze.output,
    action: 'Generate improvement proposals'
  });

  // Check if any proposals generated
  if (cycle.phases.propose.proposals.length === 0) {
    cycle.result = 'NO_PROPOSALS';
    return cycle;
  }

  // Phase 3: Apply
  cycle.phases.apply = await runPhase('apply', target, {
    agent: 'skill-forge',
    input: cycle.phases.propose.proposals,
    action: 'Apply improvements, generate new version'
  });

  // Archive current version before testing
  await archiveVersion(target, cycle.id);

  // Phase 4: Evaluate
  cycle.phases.evaluate = await runPhase('evaluate', target, {
    tool: 'eval-harness',
    candidate: cycle.phases.apply.output,
    benchmarks: getRelevantBenchmarks(target),
    regressions: getRelevantRegressions(target)
  });

  // Phase 5: Decide
  cycle.phases.decide = decideOnResults(cycle.phases.evaluate);

  // Phase 6: Commit or Rollback
  if (cycle.phases.decide.verdict === 'ACCEPT') {
    await commitVersion(target, cycle.phases.apply.output, cycle.id);
    cycle.result = 'ACCEPTED';
  } else {
    await rollbackVersion(target, cycle.id);
    cycle.result = 'REJECTED';
    cycle.rejection_reason = cycle.phases.decide.reason;
  }

  // Store cycle results
  await storeInMemory(`improvement/cycles/${cycle.id}`, cycle);

  return cycle;
}
```

### Decision Logic

```javascript
function decideOnResults(evalResults) {
  const decision = {
    verdict: null,
    reason: null,
    details: {}
  };

  // Check regression tests (must ALL pass)
  if (evalResults.regressions.failed > 0) {
    decision.verdict = 'REJECT';
    decision.reason = `Regression test failed: ${evalResults.regressions.failed_tests.join(', ')}`;
    return decision;
  }

  // Check benchmarks (must meet minimum)
  for (const [benchmark, result] of Object.entries(evalResults.benchmarks)) {
    if (!result.minimum_met) {
      decision.verdict = 'REJECT';
      decision.reason = `Benchmark ${benchmark} below minimum: ${result.score} < ${result.minimum}`;
      return decision;
    }
  }

  // Check for improvement (must be positive)
  if (evalResults.improvement_delta < 0) {
    decision.verdict = 'REJECT';
    decision.reason = `No improvement detected: delta = ${evalResults.improvement_delta}`;
    return decision;
  }

  // Check human gates
  if (evalResults.human_gates_triggered.length > 0) {
    decision.verdict = 'PENDING_HUMAN_REVIEW';
    decision.reason = `Human review required: ${evalResults.human_gates_triggered.join(', ')}`;
    return decision;
  }

  // All checks passed
  decision.verdict = 'ACCEPT';
  decision.reason = `All checks passed. Improvement: +${evalResults.improvement_delta}%`;
  decision.details = {
    benchmark_scores: evalResults.benchmarks,
    regression_passed: evalResults.regressions.passed,
    improvement: evalResults.improvement_delta
  };

  return decision;
}
```

---

## Version Management

### Archive Protocol

```yaml
archive_protocol:
  location: ".claude/skills/{skill}/.archive/"
  naming: "SKILL-v{version}.md"
  retention: "90 days minimum"

  metadata:
    - version: "semantic version"
    - timestamp: "ISO-8601"
    - cycle_id: "cycle that created this"
    - improvement_delta: "measured improvement"
    - changes_summary: "brief description"
```

### Rollback Protocol

```yaml
rollback_protocol:
  trigger: "regression_detected OR manual_request"

  process:
    - step: "Identify version to restore"
      source: ".archive/ directory"

    - step: "Copy archived version to active location"

    - step: "Verify restoration"

    - step: "Log rollback event"
      namespace: "improvement/rollbacks/{id}"

    - step: "Increment rollback counter"

  alerts:
    - "3+ rollbacks in 24 hours = pause cycles"
    - "Rollback of same skill 2x = human review"
```

---

## Multi-Agent Coordination

### Auditor Disagreement Handling

```yaml
disagreement_protocol:
  threshold: 3  # 3+ auditors disagree = human review

  process:
    - step: "Collect all auditor assessments"
    - step: "Identify disagreements"
    - step: "If disagreements > threshold: trigger human gate"
    - step: "Log disagreement details for learning"

  example:
    prompt_auditor: "APPROVE - clarity improved"
    skill_auditor: "REJECT - contract violation introduced"
    expertise_auditor: "NEUTRAL - no expertise impact"
    output_auditor: "REJECT - premature coherence detected"

    verdict: "HUMAN_REVIEW - 2 REJECT, 1 APPROVE, 1 NEUTRAL"
```

### Consensus Requirements

```yaml
consensus:
  for_auto_accept:
    - "All regression tests pass"
    - "All benchmarks meet minimum"
    - "Improvement delta > 0"
    - "No auditor REJECT votes"
    - "No human gates triggered"

  for_auto_reject:
    - "Any regression test fails"
    - "Any benchmark below minimum"
    - "Improvement delta < 0"

  for_human_review:
    - "Auditor disagreement > threshold"
    - "Novel pattern detected"
    - "Breaking change detected"
    - "High-risk change detected"
```

---

## Output Format

```yaml
bootstrap_cycle_output:
  cycle_id: "cycle-{timestamp}"
  target: "{skill|prompt}"
  timestamp: "ISO-8601"

  phases:
    analyze:
      status: "completed"
      duration: "Xms"
      output: {...}
    propose:
      status: "completed"
      duration: "Xms"
      proposals: [...]
    apply:
      status: "completed"
      duration: "Xms"
      new_version: "v{N+1}"
    evaluate:
      status: "completed"
      duration: "Xms"
      results: {...}
    decide:
      status: "completed"
      verdict: "ACCEPT|REJECT|PENDING_HUMAN_REVIEW"
      reason: "..."
    commit_or_rollback:
      status: "completed"
      action: "committed|rolled_back"

  result: "ACCEPTED|REJECTED|PENDING"
  improvement_delta: "+X%"
  cycle_duration: "Xms"

  next_steps:
    - "Step 1"
    - "Step 2"

  metrics_update:
    total_cycles: N
    accepted: M
    rejected: K
    acceptance_rate: M/N
```

---

## Anti-Patterns

### NEVER:

1. **Skip eval harness** - Every change must pass
2. **Modify eval during cycle** - Keep eval frozen per cycle
3. **Auto-commit on disagreement** - Human review required
4. **Skip archiving** - Always archive before apply
5. **Run concurrent cycles on same target** - Sequential only

### ALWAYS:

1. **Archive before apply**
2. **Run full eval harness**
3. **Log all decisions**
4. **Track metrics over time**
5. **Respect human gates**

---

## Memory Namespaces

| Namespace | Purpose | Retention |
|-----------|---------|-----------|
| `improvement/cycles/{id}` | Full cycle details | 90 days |
| `improvement/proposals/{id}` | Pending proposals | Until resolved |
| `improvement/commits/{id}` | Committed changes | Permanent |
| `improvement/rollbacks/{id}` | Rollback events | Permanent |
| `improvement/metrics` | Aggregate metrics | Permanent |

---

## Integration Points

**Depends On**:
- `prompt-forge`: For generating proposals
- `skill-forge`: For applying changes
- `eval-harness`: For testing (FROZEN)
- `prompt-auditor`: For prompt analysis
- `skill-auditor`: For skill analysis
- `expertise-auditor`: For expertise analysis
- `output-auditor`: For output validation

**Coordinates With**:
- `domain-expert`: For domain-specific improvements
- `expertise-adversary`: For adversarial validation

---

**Status**: Production-Ready
**Version**: 1.0.0
**Key Constraint**: All changes gated by frozen eval harness
**Safety**: Eval harness NEVER self-improves

---

## Core Principles

### 1. The Eval Harness is Immutable
The eval harness serves as the objective anchor that prevents Goodhart's Law. It measures improvement without being subject to improvement itself.

**In practice:**
- The eval harness (benchmarks + regression tests) NEVER self-improves
- Prompt Forge and Skill Forge cannot modify eval criteria
- Benchmarks are frozen per improvement cycle
- New benchmarks can be added, but existing benchmarks never change
- Human gates are the only mechanism to update eval harness
- All improvement proposals must pass unchanged eval standards
- If eval harness needs updating, it requires manual approval outside the loop

### 2. Improvement Requires Consensus and Evidence
No change is accepted based on a single metric or agent opinion. Improvements must demonstrate measurable gains and pass multi-agent validation.

**In practice:**
- All regression tests must pass (100% pass rate required)
- All benchmarks must meet minimum thresholds
- Improvement delta must be positive (better than previous version)
- Multiple auditor agents must agree (prompt-auditor, skill-auditor, etc.)
- Disagreement among auditors triggers human review
- Previous version is archived before applying changes
- Rollback capability maintained for 90 days minimum
- Metrics tracked over time to detect improvement trends

### 3. Recursive Improvement is Bounded and Observable
The bootstrap loop improves tools recursively, but every cycle is logged, versioned, and reversible to prevent runaway optimization.

**In practice:**
- Every improvement cycle has a unique ID and timestamp
- All phases (analyze, propose, apply, evaluate, decide, commit/rollback) are logged
- Version history maintained with semantic versioning (v1.0, v1.1, v2.0)
- Rollback protocol triggers on regression or manual request
- Alerts fire on 3+ rollbacks in 24 hours (pause cycles)
- Improvement acceptance rate tracked (target: >60%)
- Cycle time monitored (target: <4 hours per cycle)
- No concurrent cycles on same target (sequential only)

---

## Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Skipping eval harness** | Changes applied without validation, regressions introduced, quality degrades over time | NEVER skip eval harness. Every change must pass benchmarks and regression tests. Auto-reject on any regression test failure. |
| **Modifying eval during cycle** | Moving goalposts, Goodhart's Law takes effect, metrics become meaningless | Freeze eval harness per cycle. New benchmarks require human approval. Eval harness never self-improves. |
| **Auto-commit on disagreement** | Auditor disagreement signals risk, auto-commit bypasses validation, introduces breaking changes | Trigger human review when 3+ auditors disagree. Require consensus for auto-accept. Respect auditor REJECT votes. |
| **No archiving before apply** | Cannot rollback on regression, lost version history, no recovery path | Always archive previous version before applying changes. Maintain 90-day retention. Test rollback protocol quarterly. |
| **Concurrent cycles on same target** | Race conditions, conflicting changes, version chaos, merge conflicts | Run cycles sequentially on same target. Queue proposals, process one at a time. Lock target during cycle. |
| **Ignoring human gates** | Breaking changes deployed without review, high-risk changes bypass validation | Respect human gate triggers (novel patterns, breaking changes, high-risk). Pause for manual approval. |

---

## Conclusion

The Bootstrap Loop orchestrates recursive self-improvement with rigorous safeguards against Goodhart's Law and runaway optimization. By treating the eval harness as an immutable anchor, requiring multi-agent consensus for improvements, and maintaining comprehensive version history with rollback capabilities, this skill enables safe, evidence-based evolution of the meta-tools (Prompt Forge and Skill Forge) and all downstream skills and prompts.

The recursive improvement cycle - where Prompt Forge improves Skill Forge, Skill Forge improves Prompt Forge, and both audit everything else - creates a positive feedback loop for continuous quality improvement. However, this loop is carefully bounded by frozen evaluation criteria, transparent decision logging, and automatic rollback on regression. The result is a self-improving system that gets better over time without drifting from its core objectives.

Whether improving a single skill prompt or orchestrating a full audit of 196 skills, the Bootstrap Loop ensures that changes are validated, versioned, and reversible. The combination of automated improvement with human oversight at critical decision points strikes the balance between efficiency and safety, enabling rapid iteration without sacrificing quality or stability.
