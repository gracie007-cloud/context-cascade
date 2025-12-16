---
<!-- META-LOOP v2.1 INTEGRATION -->## Phase 0: Expertise Loadingexpertise_check:  domain: agent-creation  file: .claude/expertise/agent-creation.yaml  fallback: discovery_mode## Recursive Improvement Integration (v2.1)benchmark: expertise-validate-benchmark-v1  tests:    - command_execution_success    - domain_validation  success_threshold: 0.9namespace: "commands/foundry/expertise/expertise-validate/{project}/{timestamp}"uncertainty_threshold: 0.85coordination:  related_skills: [agent-creator, micro-skill-creator]  related_agents: [prompt-auditor, skill-auditor]## COMMAND COMPLETION VERIFICATIONsuccess_metrics:  execution_success: ">95%"<!-- END META-LOOP -->
name: expertise-validate
binding: skill:expertise-manager
category: foundry
version: 1.0.0
---

# /expertise-validate

Validate domain expertise against current code reality. Run all falsifiable checks and detect drift.

## Usage

```bash
/expertise-validate <domain> [options]
```

## Parameters

- `domain` - Domain to validate (required)
- `--fix` - Auto-fix minor issues
- `--strict` - Fail on any validation error
- `--report` - Generate detailed validation report

## What It Does

**5-Phase Validation Process**:

1. **Load Expertise**
   - Read `.claude/expertise/{domain}.yaml`
   - Parse all falsifiable checks

2. **Run Falsifiable Checks**
   - Execute each validation command
   - Compare results to expected values
   - Track pass/fail/skip for each claim

3. **Detect Drift**
   - Compare expertise to current code
   - Calculate drift score (0.0 - 1.0)
   - Identify stale claims

4. **Check Staleness**
   - Compare git history to expertise timestamps
   - Flag outdated expertise

5. **Report & Update**
   - Update validation_status in expertise
   - Log to learning history
   - Flag issues for correction

## Validation Outcomes

| Outcome | Drift Score | Action |
|---------|-------------|--------|
| Valid | < 0.2 | Update timestamp, use as-is |
| Minor Drift | 0.2 - 0.5 | Auto-correct with --fix |
| Major Drift | > 0.5 | Flag for refresh |
| Stale | N/A | Needs refresh |

## Examples

```bash
# Basic validation
/expertise-validate authentication

# Validate and auto-fix minor issues
/expertise-validate database --fix

# Strict validation (CI/CD use)
/expertise-validate payments --strict

# Generate detailed report
/expertise-validate websocket --report
```

## Output

```
Validating expertise: authentication

Phase 1: Loading expertise
  Version: 1.2.0
  Last validated: 2025-12-10T14:30:00Z
  Claims: 25 total, 23 with falsifiable checks

Phase 2: Running falsifiable checks
  [PASS] file_locations.primary: src/auth/ exists
  [PASS] file_locations.tests: tests/auth/ exists
  [PASS] patterns.architecture: Controllers don't import repositories
  [FAIL] entities.classes.AuthService: Class moved to src/auth/service/
  ...
  Results: 21 passed, 2 failed, 2 skipped

Phase 3: Drift detection
  Drift score: 0.15 (minor)
  Changed since validation: 3 files

Phase 4: Staleness check
  Commits since validation: 12
  Status: Current

Phase 5: Update
  Validation status: valid
  Corrections needed: 2 (minor, auto-fixable)

Validation complete.
  Overall: VALID (minor corrections available)
  Run with --fix to auto-correct 2 issues
```

## Pre-Action Usage

This command should be run BEFORE any domain-specific action:

```javascript
// In agent workflow
const validation = await runCommand('/expertise-validate', domain);

if (validation.status === 'valid' || validation.status === 'minor_drift') {
  // Proceed with expertise
  const expertise = loadExpertise(domain);
  return executeWithExpertise(task, expertise);
} else {
  // Expertise too stale
  console.log('Running /expertise-refresh first');
  await runCommand('/expertise-refresh', domain);
}
```

## See Also

- `/expertise-challenge` - Adversarial validation
- `/expertise-refresh` - Rebuild stale expertise
- `/expertise-diff` - Show what's changed
