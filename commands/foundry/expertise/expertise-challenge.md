---
<!-- META-LOOP v2.1 INTEGRATION -->## Phase 0: Expertise Loadingexpertise_check:  domain: agent-creation  file: .claude/expertise/agent-creation.yaml  fallback: discovery_mode## Recursive Improvement Integration (v2.1)benchmark: expertise-challenge-benchmark-v1  tests:    - command_execution_success    - domain_validation  success_threshold: 0.9namespace: "commands/foundry/expertise/expertise-challenge/{project}/{timestamp}"uncertainty_threshold: 0.85coordination:  related_skills: [agent-creator, micro-skill-creator]  related_agents: [prompt-auditor, skill-auditor]## COMMAND COMPLETION VERIFICATIONsuccess_metrics:  execution_success: ">95%"<!-- END META-LOOP -->
name: expertise-challenge
binding: agent:expertise-adversary
category: foundry
version: 1.0.0
---

# /expertise-challenge

Run adversarial validation to actively try to DISPROVE expertise claims. Prevents confident drift.

## Usage

```bash
/expertise-challenge <domain> [options]
```

## Parameters

- `domain` - Domain to challenge (required)
- `--claim` - Challenge specific claim only
- `--thoroughness` - "quick" | "standard" | "exhaustive"
- `--survival-threshold` - Minimum survival rate (default: 0.7)

## What It Does

**Critical for Preventing Confident Drift**

Unlike `/expertise-validate` which checks if claims are TRUE, this command actively tries to PROVE claims are FALSE.

**5-Point Adversarial Protocol**:

1. **Find Contradicting Code**
   - Search for code that violates stated patterns
   - Look for files in wrong locations
   - Check for architecture violations

2. **Find Edge Cases**
   - Look for exceptions to patterns
   - Find legacy code that doesn't follow rules
   - Check for config flags that change behavior

3. **Check Historical Contradictions**
   - Search git history for recent changes
   - Find commits that modified patterns
   - Look for reverts and TODOs

4. **Test Assumption Conflicts**
   - Compare against test assumptions
   - Check mock behavior vs. claimed behavior
   - Look for integration test contradictions

5. **Run Falsifiable Checks**
   - Execute all validation commands
   - Record exact pass/fail results

## Survival Rate Interpretation

| Rate | Meaning | Action |
|------|---------|--------|
| > 90% | Strong expertise | Accept updates |
| 70-90% | Acceptable | Correct weak claims |
| < 70% | Major issues | Reject updates, refresh |

## Examples

```bash
# Standard adversarial challenge
/expertise-challenge authentication

# Challenge specific claim
/expertise-challenge database --claim "Services don't import controllers"

# Exhaustive challenge (before major releases)
/expertise-challenge payments --thoroughness exhaustive

# Strict threshold for CI/CD
/expertise-challenge api --survival-threshold 0.9
```

## Output

```
ADVERSARIAL CHALLENGE: authentication

Challenger: expertise-adversary
Thoroughness: standard
Threshold: 70%

Running 5-Point Adversarial Protocol...

1. Finding contradicting code...
   [DISPROVEN] Claim: "Controllers don't access database directly"
   Evidence: src/auth/controllers/admin.ts:45 imports 'typeorm'

2. Finding edge cases...
   [WEAKENED] Claim: "All routes use auth middleware"
   Exception: /health endpoint bypasses auth (intentional)

3. Checking historical contradictions...
   [OK] No recent contradicting commits

4. Testing assumption conflicts...
   [OK] Tests align with claims

5. Running falsifiable checks...
   21/23 passed

Results:
  Claims challenged: 25
  Claims survived: 18
  Claims disproven: 3
  Claims weakened: 4
  Survival rate: 72%

Verdict: CONDITIONAL_ACCEPT
  - Must correct 3 disproven claims
  - Should clarify 4 weakened claims
  - Then expertise can be trusted

Disproven claims:
  1. "Controllers don't access database directly"
     Fix: Update claim or fix code

Weakened claims (add exceptions):
  1. "All routes use auth middleware"
     Add exception: /health, /metrics (monitoring endpoints)
```

## Why This Matters

Without adversarial validation, auto-learning creates confident drift:

```
Build 1: Learn pattern A -> Expertise says "we use A"
Build 2: Code actually uses B -> But self-improve sees "A works" -> Confirms A
Build 3: More code uses B -> Expertise still says A -> Drift increases
Build N: Expertise completely wrong -> Agents make bad decisions
```

Adversarial validation breaks this cycle by actively challenging claims BEFORE they're reinforced.

## Integration

Called automatically by:
- Self-improve hook (before applying updates)
- Loop 2 Step 9.5 (before expertise update)
- Scheduled weekly audits

## See Also

- `/expertise-validate` - Basic validation
- `/expertise-refresh` - Rebuild expertise
- `/expertise-history` - View challenge history
