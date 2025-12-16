# /run-improvement-cycle
<!-- META-LOOP v2.1 INTEGRATION -->## Phase 0: Expertise Loadingexpertise_check:  domain: agent-creation  file: .claude/expertise/agent-creation.yaml  fallback: discovery_mode## Recursive Improvement Integration (v2.1)benchmark: run-improvement-cycle-benchmark-v1  tests:    - command_execution_success    - domain_validation  success_threshold: 0.9namespace: "commands/foundry/recursive-improvement/run-improvement-cycle/{project}/{timestamp}"uncertainty_threshold: 0.85coordination:  related_skills: [agent-creator, micro-skill-creator]  related_agents: [prompt-auditor, skill-auditor]## COMMAND COMPLETION VERIFICATIONsuccess_metrics:  execution_success: ">95%"<!-- END META-LOOP -->

Run a single recursive improvement cycle on a target skill or prompt.

## Usage

```
/run-improvement-cycle <target-path>
```

## Examples

```bash
# Improve a specific skill
/run-improvement-cycle .claude/skills/micro-skill-creator/SKILL.md

# Improve prompt-forge itself
/run-improvement-cycle .claude/skills/recursive-improvement/prompt-forge/SKILL.md

# Improve skill-forge
/run-improvement-cycle .claude/skills/skill-forge/SKILL.md
```

## Process

This command executes the full improvement pipeline:

```
1. AUDIT    -> Run appropriate auditor on target
2. PROPOSE  -> Generate improvement proposals via prompt-forge
3. APPLY    -> Apply changes via skill-forge
4. TEST     -> Run eval-harness (benchmarks + regressions)
5. DECIDE   -> ACCEPT, REJECT, or PENDING_HUMAN_REVIEW
6. ACT      -> Commit if accepted, rollback if rejected
7. MONITOR  -> Setup 7-day metric tracking (if accepted)
```

## Output

```yaml
cycle_result:
  target: "<path>"
  cycle_id: "cycle-{timestamp}"

  audit:
    issues_found: N
    critical: X
    high: Y

  proposals:
    generated: N
    changes: [list]

  evaluation:
    benchmarks: PASS|FAIL
    regressions: PASS|FAIL

  decision:
    verdict: ACCEPT|REJECT|PENDING
    reason: "..."

  action:
    taken: committed|rolled_back|pending_review
    version: "v{N+1}" (if committed)

  monitoring:
    status: ACTIVE (if committed)
    window: "7 days"
```

## Safeguards

- Archived version created before any changes
- Full regression suite runs on every cycle
- Human gates triggered for breaking/high-risk changes
- Rollback available for 30 days

## Self-Improvement Mode

When targeting meta-skills (prompt-forge, skill-forge), additional safeguards apply:

```yaml
self_improvement_safeguards:
  - uses_previous_version: true  # Avoids infinite self-reference
  - human_gate_for_breaking: true
  - extra_regression_tests: true
  - auditor_consensus_required: true
```

## Related Commands

- `/audit-skill <path>` - Run skill-auditor only
- `/audit-prompt <path>` - Run prompt-auditor only
- `/rollback <commit-id>` - Manually rollback a change
- `/improvement-status` - Check current improvement metrics

---

**Version**: 1.0.0
**Category**: foundry/recursive-improvement
