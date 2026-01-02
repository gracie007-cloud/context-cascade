# GitHub Release Management

Plan and execute releases with safe tagging, automation, and rollback.

## When to Use
- Preparing or executing a release using GitHub
- Managing changelogs, tags, and artifacts
- Coordinated rollouts with approvals and monitoring

## When Not to Use
- Pipeline incident recovery (use cicd-intelligent-recovery)
- Single-workflow edits (use github-workflow-automation)
- Portfolio/project governance (use github-project-management)

## Workflow Snapshot
1. Scope release, risks, environments, and approvals.
2. Define branching/tagging and CI/CD gates.
3. Run dry-runs/canaries, then publish artifacts and notes.
4. Verify, communicate outcomes, and document learnings.

## Artifacts
- SKILL.md SOP, examples/, tests/, resources/, and this readme

## Quality Gates
- Approvals/freezes honored with evidence
- Rollback/contingency paths validated
- Confidence ceiling stated for go/no-go
