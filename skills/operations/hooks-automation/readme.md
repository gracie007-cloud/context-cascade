# Hooks Automation

Create and operate event/webhook automation with secure routing and observability.

## When to Use
- Building event-driven connectors between services
- Implementing retries/backoff and DLQ handling
- Enforcing signing/auth and data minimization for hooks

## When Not to Use
- GitHub-only automation (use github-integration or github-workflow-automation)
- Simple scheduled tasks without hooks (use platform-integration)

## Workflow Snapshot
1. Inventory events, payloads, SLAs, and security needs.
2. Design routing, transformation, retries, and idempotency.
3. Implement connectors with logging and correlation IDs.
4. Validate failure modes, monitor, and document fallbacks.

## Artifacts
- SKILL.md SOP, examples/, tests/, resources/, and this readme

## Quality Gates
- Signature/auth verification and data minimization proven
- Retry/backoff and idempotency tested
- Confidence ceiling declared for production rollout
