---
name: hooks-automation
description: Manage event hooks and connectors with secure routing and backoff
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.1
x-last-reflection: 2026-01-09T12:00:00Z
x-reflection-count: 1
x-category: operations
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
Design and operate automation hooks across systems with validated routing, retries, and observability.

### Trigger Conditions
- **Positive:** Need event/webhook automation; Bridge between services with callbacks; Establish retries/backoff for event processing
- **Negative:** GitHub-only automation (route to github-workflow-automation or github-integration); Simple cron job without hooks (route to platform-integration); Performance debugging (route to performance-analysis)

### Guardrails
- Structure-first: keep SKILL.md aligned with examples/, tests/, and any resources/references so downstream agents always have scaffolding.
- Adversarial validation is mandatory: cover boundary cases, failure paths, and rollback drills before declaring the SOP complete.
- Prompt hygiene: separate hard vs. soft vs. inferred constraints and confirm inferred constraints before acting.
- Explicit confidence ceilings: format as 'Confidence: X.XX (ceiling: TYPE Y.YY)' and never exceed the ceiling for the claim type.
- MCP traceability: tag sessions WHO=operations-{name}-{session_id}, WHY=skill-execution, and capture evidence links in outputs.
- Avoid anti-patterns: undocumented changes, missing rollback paths, skipped tests, or unbounded automation without approvals.

### Required Artifacts
- SKILL.md (this SOP)
- readme.md
- examples/ and tests/ for connectors
- resources/ for scripts

### Execution Phases
1. **Discover events and constraints**
   - Inventory event sources, payloads, and SLAs
   - Define security requirements (signing, auth, data minimization)
   - Identify throughput, ordering, and retry needs

2. **Design routing and processing**
   - Specify routing rules, transformations, and deduplication
   - Plan retry/backoff, DLQs, and idempotency keys
   - Establish observability (metrics, traces, alerts)

3. **Implement connectors**
   - Build handlers or use managed connectors with least privilege
   - Add structured logging and correlation IDs
   - Test failure modes (timeouts, malformed payloads, spikes)

4. **Operate and improve**
   - Deploy with staged rollout and feature flags
   - Monitor error budgets and tune policies
   - Document runbooks and fallback/disable procedures

### Output Format
- Event catalog with schemas, auth, and SLAs
- Routing/processing spec including retries and DLQ handling
- Implemented connectors/handlers with tests
- Observability plan with dashboards and alerts
- Runbook with fallback and disablement steps

### Validation Checklist
- Signature/auth validation and data minimization in place
- Idempotency and retry/backoff tested
- DLQ or failure handling path configured
- Monitoring/alerts active with owners
- Confidence ceiling stated for production rollout

Confidence: 0.70 (ceiling: inference 0.70) - Hook design follows adversarial validation and rollback guardrails

---

## LEARNED PATTERNS

### High Confidence [conf:0.90]

#### Plan Mode Enhancement Hook Pattern
UserPromptSubmit hooks can detect plan mode via `permission_mode` field in JSON input or by matching planning keywords in the prompt text. This enables mode-specific behavior injection.

**Detection Pattern:**
```bash
PERMISSION_MODE=$(echo "$INPUT" | jq -r '.permission_mode // empty')
if [ "$PERMISSION_MODE" = "plan" ]; then
    # Plan mode detected via API field
fi
# Fallback: keyword detection
if echo "$PROMPT" | grep -iqE "(plan mode|architecture|strategy)"; then
    # Plan mode detected via keywords
fi
```

**Key Insight:** Injecting keywords like "ultrathink" in hook output triggers extended reasoning in Claude. Hook stdout acts as additional context prepended to Claude's reasoning.
[ground:user-correction:2026-01-09]

### Medium Confidence [conf:0.75]

- **Dual Enhancement Synergy**: Combining multiple reasoning enhancements (e.g., ultrathink + sequential-thinking MCP) creates synergy but risks overthinking simple tasks. Recommend conditional application based on task complexity. [ground:approval-pattern:2026-01-09]

- **Quantitative Estimation**: Users value quantitative estimates of improvement when creating enhancement hooks (e.g., "30-50% better edge case coverage at 200-400% token cost"). Provide these estimates even if approximate. [ground:approval-pattern:2026-01-09]

- **A/B Validation Strategy**: When creating reasoning enhancement hooks, recommend A/B testing: run same prompt with/without hook and compare outputs on completeness, risk identification, actionability. [ground:approval-pattern:2026-01-09]

### Low Confidence [conf:0.55]

- Plan mode users likely prefer quality over speed - willing to accept 2-4x token cost for deeper analysis [ground:observation:2026-01-09]
- Hook registration in settings.local.json works for project-specific customization without affecting global settings [ground:observation:2026-01-09]
