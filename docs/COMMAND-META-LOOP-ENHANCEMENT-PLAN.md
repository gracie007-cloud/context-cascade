# Command Meta-Loop Enhancement Plan

## Overview
Apply Meta-Loop v2.1 system to all 223 slash commands in the ruv-sparc-three-loop-system plugin.

## Command Distribution (223 total)

| Category | Count | Subcategories |
|----------|-------|---------------|
| operations | 80 | github, automation, memory, monitoring, optimization, deployment, hooks |
| delivery | 69 | sparc (35), workflows (13), essential-commands (10), training (6), workflow-commands (2) |
| orchestration | 29 | swarm (10), coordination (10), hive-mind (9) |
| quality | 17 | analysis, audit-commands, reports |
| foundry | 14 | agent-commands (5), agents (5), expertise (3), recursive-improvement (1) |
| security | 11 | re (reverse engineering), compliance, scanning |
| research | 9 | research commands |
| platforms | 4 | multi-model-commands |
| tooling | 3 | claude-flow |

## Meta-Loop Sections to Add

Each command will receive these sections after line 1:

```markdown
<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: {DOMAIN}
  file: .claude/expertise/{DOMAIN}.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: {COMMAND_NAME}-benchmark-v1
  tests:
    - command_execution_success
    - output_validation
    - integration_test
  success_threshold: 0.9
namespace: "commands/{category}/{COMMAND_NAME}/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [{RELATED_SKILLS}]
  related_agents: [{RELATED_AGENTS}]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
  user_satisfaction: ">90%"
  integration_compatibility: ">95%"
<!-- END META-LOOP -->
```

## Batch Processing Plan

### Batch 1: delivery/sparc (35 commands) - PARALLEL
Agents: prompt-auditor, skill-auditor, coder
Domain: agent-creation
Files: analyzer.md, api-designer.md, architect.md, ask.md, backend-specialist.md, batch-executor.md, code.md, coder.md, database-architect.md, debug.md, debugger.md, designer.md, devops.md, docs-writer.md, documenter.md, frontend-specialist.md, innovator.md, integration.md, mcp.md, memory-manager.md, mobile-specialist.md, optimizer.md, post-deployment-monitoring-mode.md, refinement-optimization-mode.md, researcher.md, reviewer.md, security-review.md, sparc.md, spec-pseudocode.md, supabase-admin.md, swarm-coordinator.md, tdd.md, tester.md, tutorial.md, workflow-manager.md

### Batch 2: delivery/workflows + essential (22 commands) - PARALLEL
Agents: prompt-auditor, output-auditor, coder
Domain: deployment
Files: deployment.md, development.md, docker-build.md, docker-deploy.md, github-release.md, hotfix.md, k8s-deploy.md, research.md, testing.md, workflow-cicd.md, workflow-create.md, workflow-deployment.md, workflow-execute.md, workflow-export.md, workflow-rollback.md, build-feature.md, deploy-check.md, e2e-test.md, fix-bug.md, integration-test.md, load-test.md, quick-check.md, regression-test.md, review-pr.md, smoke-test.md

### Batch 3: delivery/training + workflow-commands (8 commands) - PARALLEL
Agents: skill-auditor, coder
Domain: agent-creation
Files: model-update.md, neural-patterns.md, neural-train.md, pattern-learn.md, specialization.md, create-cascade.md, create-micro-skill.md

### Batch 4: operations/github + automation (17 commands) - PARALLEL
Agents: prompt-auditor, output-auditor, coder
Domain: deployment
Files: ansible-deploy.md, aws-deploy.md, code-review.md, docker-compose.md, github-actions.md, github-pages.md, github-swarm.md, issue-triage.md, multi-repo.md, pr-review.md, release.md, auto-agent.md, self-healing.md, session-memory.md, smart-agents.md, smart-spawn.md, workflow-select.md

### Batch 5: operations/memory + monitoring + optimization (25 commands) - PARALLEL
Agents: prompt-auditor, skill-auditor, coder
Domain: deployment
Files: All commands in memory/, monitoring/, optimization/

### Batch 6: operations/deployment + hooks (30 commands) - PARALLEL
Agents: output-auditor, coder
Domain: deployment
Files: All commands in deployment/, hooks/

### Batch 7: orchestration (29 commands) - PARALLEL
Agents: prompt-auditor, skill-auditor, coder
Domain: orchestration
Files: All commands in swarm/, coordination/, hive-mind/

### Batch 8: quality + security (28 commands) - PARALLEL
Agents: prompt-auditor, output-auditor, coder
Domain: quality + security
Files: All commands in quality/ and security/

### Batch 9: foundry + research + platforms + tooling (30 commands) - PARALLEL
Agents: skill-auditor, coder
Domain: agent-creation + research
Files: All commands in foundry/, research/, platforms/, tooling/

## Execution Strategy

Use bash/sed for all modifications (per user preference from agent enhancements).

### Sed Command Template
```bash
sed -i '1a\\n<!-- META-LOOP v2.1 INTEGRATION -->\n## Phase 0: Expertise Loading\nexpertise_check:\n  domain: {DOMAIN}\n  file: .claude/expertise/{DOMAIN}.yaml\n  fallback: discovery_mode\n\n## Recursive Improvement Integration (v2.1)\nbenchmark: {CMD}-benchmark-v1\n  tests:\n    - command_execution_success\n    - output_validation\n  success_threshold: 0.9\nnamespace: "commands/{category}/{CMD}/{project}/{timestamp}"\nuncertainty_threshold: 0.85\n\n## COMMAND COMPLETION VERIFICATION\nsuccess_metrics:\n  execution_success: ">95%"\n<!-- END META-LOOP -->\n' "{FILE}"
```

## Parallel Agent Assignments

| Batch | Primary Agent | Secondary Agent | Tertiary Agent |
|-------|---------------|-----------------|----------------|
| 1 | prompt-auditor | skill-auditor | coder |
| 2 | prompt-auditor | output-auditor | coder |
| 3 | skill-auditor | coder | - |
| 4 | prompt-auditor | output-auditor | coder |
| 5 | prompt-auditor | skill-auditor | coder |
| 6 | output-auditor | coder | - |
| 7 | prompt-auditor | skill-auditor | coder |
| 8 | prompt-auditor | output-auditor | coder |
| 9 | skill-auditor | coder | - |

## Success Criteria
- All 223 commands have Meta-Loop v2.1 sections
- No syntax errors in modified files
- Git commit and push successful
- Commands remain functional

## Timeline
- Batch processing: ~30 minutes (parallel)
- Verification: ~10 minutes
- Git operations: ~5 minutes
- Total: ~45 minutes
