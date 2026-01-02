# CI/CD Intelligent Recovery

Restore failing pipelines quickly while protecting release quality.

## When to Use
- Pipelines failing, flaking, or blocking release
- Rollback/hotfix needed after deployment
- You need a documented recovery path with evidence

## When Not to Use
- Designing net-new pipelines (use github-workflow-automation)
- Planning routine releases without incidents (use github-release-management)

## Workflow Snapshot
1. Triage and isolate failing stages with logs and owners.
2. Stabilize via rollback, flags, or minimal-change mitigations.
3. Fix root causes, rerun targeted checks, and coordinate cross-repo impacts.
4. Validate full pipeline, update runbooks, and publish readiness.

## Artifacts
- SKILL.md for the SOP and guardrails
- examples/ with recovery drills
- tests/ for rollback and smoke validation
- resources/ runbooks and scripts, references/ telemetry links

## Quality Gates
- Adversarial validation of rollback and retry paths
- Evidence links for reruns and logs
- Documented communication and confidence ceiling per prompt-architect
