# GitHub Workflow Automation

Build and harden GitHub Actions and workflows with security and observability.

## When to Use
- Creating or improving Actions workflows
- Adding automation for CI/CD or maintenance
- Hardening secrets/permissions and reliability

## When Not to Use
- Fleetwide changes (use github-multi-repo)
- Release orchestration (use github-release-management)
- Project governance (use github-project-management)

## Workflow Snapshot
1. Capture intent, constraints, and permissions.
2. Design jobs/steps with caching, retries, and security controls.
3. Implement and run dry-runs/tests.
4. Harden with monitoring and document rollback steps.

## Artifacts
- SKILL.md SOP, examples/, tests/, resources/, and this readme

## Quality Gates
- Least-privilege secrets/tokens and pinned actions
- Dry-run/test evidence recorded
- Confidence ceilings applied before enabling in production
