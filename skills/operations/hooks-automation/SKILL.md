---
name: hooks-automation
description: Manage event hooks and connectors with secure routing and backoff
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
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
