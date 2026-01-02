# GitHub Multi-Repo

Coordinate changes across repositories with batching, approvals, and rollback controls.

## When to Use
- Fleetwide dependency or policy updates
- Cross-repo automation and coordination
- Sequenced rollouts that need dashboards and checkpoints

## When Not to Use
- Single-repo workflow tweaks (use github-workflow-automation)
- Release execution only (use github-release-management)
- Portfolio governance (use github-project-management)

## Workflow Snapshot
1. Map repos, owners, dependencies, and protections.
2. Plan batches with pause/rollback gates and templates.
3. Execute automation with dry-runs and per-repo status logging.
4. Validate checks, communicate progress, and document outcomes.

## Artifacts
- SKILL.md SOP plus examples/, tests/, resources/, and this readme

## Quality Gates
- Dry-run evidence before fleet rollout
- Approvals for protected branches and environments
- Confidence ceilings stated at each rollout stage
