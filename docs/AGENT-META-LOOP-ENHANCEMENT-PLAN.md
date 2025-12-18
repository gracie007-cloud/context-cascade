# Agent Meta-Loop Enhancement Plan

## Overview

Apply the full meta-loop improvement system (agent-creator + skill-forge + prompt-architect patterns) to all 216 sub-agents in the ruv-sparc three-loop plugin.

## Current State

- **Total Agents**: 211 agents markdown files
- **Categories**: 10 functional categories
- **Current Structure**: YAML frontmatter + markdown documentation

## Meta-Loop Improvements to Apply

Each agent will receive:

1. **Phase 0: Expertise Loading** - Check for domain expertise before execution
2. **Recursive Improvement Integration (v2.1)**
   - Eval Harness Integration
   - Memory Namespace
   - Uncertainty Handling
   - Cross-Agent Coordination
3. **AGENT COMPLETION VERIFICATION** - Success metrics and output validation
4. **Supporting Files** (where missing):
   - CHANGELOG.md
   - Evidence-based prompting techniques

## Agent Categories and Counts

| Category | Count | Expertise Domain | Priority |
|----------|-------|------------------|----------|
| platforms | 44 | platform.yaml | Medium |
| operations | 29 | deployment.yaml | High |
| foundry | 25 | agent-creation.yaml | Critical |
| tooling | 24 | tooling.yaml | Medium |
| orchestration | 23 | orchestration.yaml | High |
| specialists | 19 | specialist.yaml | Medium |
| quality | 18 | quality.yaml | High |
| delivery | 18 | delivery.yaml | High |
| research | 11 | research.yaml | High |
| security | 5 | security.yaml | Critical |

## Batch Processing Plan

### Batch 1: Foundry Core (25 agents) - CRITICAL
Most important as these create other agents.

```
foundry/
  core/ (9 agents)
    - api-designer.md
    - base-template-generator.md
    - coder-enhanced.md
    - coder.md
    - planner.md
    - researcher.md
    - reviewer.md
    - technical-debt-manager.md
    - tester.md
  expertise/ (2 agents)
    - domain-expert.md
    - expertise-adversary.md
  recursive-improvement/ (4 agents)
    - expertise-auditor.md
    - output-auditor.md
    - prompt-auditor.md
    - skill-auditor.md
  templates/ (9 agents)
    - automation-smart-agent.md
    - coordinator-swarm-init.md
    - github-pr-manager.md
    - implementer-sparc-coder.md
    - memory-coordinator.md
    - migration-plan.md
    - orchestrator-task.md
    - performance-analyzer.md
    - sparc-coordinator.md
  registry/ (1 file - MIGRATION_SUMMARY.md)
```

### Batch 2: Security (5 agents) - CRITICAL
Security agents need robust verification.

```
security/
  compliance/
    - soc-compliance-auditor.md
  containers/
    - container-security-scanner.md
  pentest/
    - penetration-testing-agent.md
  secrets/
    - secrets-management-agent.md
  zero-trust/
    - zero-trust-architect.md
```

### Batch 3: Quality (18 agents) - HIGH
Quality agents enforce standards.

```
quality/
  analysis/ (4 agents)
    - audit-pipeline-orchestrator.md
    - code-analyzer.md
    - code-review/analyze-code-quality.md
    - root-cause-analyzer.md
  audit/ (5 agents)
    - code-audit/code-audit-specialist.md
    - compliance/compliance-validation-agent.md
    - production-readiness/production-readiness-checker.md
    - quality-gates/quality-gate-enforcer.md
    - technical-debt/technical-debt-auditor.md
  testing/ (9 agents)
    - chaos-engineering-agent.md
    - contract-testing-agent.md
    - e2e-testing-specialist.md
    - performance-testing-agent.md
    - security-testing-agent.md
    - unit/tdd-london-swarm.md
    - validation/production-validator.md
    - visual-regression-agent.md
```

### Batch 4: Orchestration (23 agents) - HIGH
Swarm coordination agents.

```
orchestration/
  consensus/ (10 agents)
  goal/ (2 agents)
  hive-mind/ (5 agents)
  swarm/ (6 agents)
```

### Batch 5: Operations (29 agents) - HIGH
DevOps and infrastructure.

```
operations/
  devops/ (10 agents)
  infrastructure/ (11 agents)
  monitoring/ (5 agents)
  optimization/ (3 agents + README)
```

### Batch 6: Research (11 agents) - HIGH
Research and discovery agents.

```
research/
  emerging/ (5 agents)
  reasoning/ (2 agents)
  - archivist.md
  - data-steward.md
  - ethics-agent.md
  - evaluator.md
```

### Batch 7: Delivery (18 agents) - HIGH
Feature implementation specialists.

```
delivery/
  architecture/ (1 agent)
  development/ (7 agents)
  frontend/ (6 agents)
  sparc/ (4 agents)
```

### Batch 8: Tooling (24 agents) - MEDIUM
Documentation and GitHub tooling.

```
tooling/
  documentation/ (6 agents)
  github/ (18 agents)
```

### Batch 9: Specialists (19 agents) - MEDIUM
Domain specialists.

```
specialists/
  business/ (13 agents)
  finance/ (4 agents + README)
  specialized/ (2 agents)
```

### Batch 10: Platforms (44 agents) - MEDIUM
Data, ML, and platform services.

```
platforms/
  ai-ml/ (10 agents)
  data/ (6 agents)
  database/ (6 agents)
  flow-nexus/ (17 agents)
  neural/ (1 agent)
  platform/ (5 agents)
```

## Meta-Loop Template for Agents

Add after the YAML frontmatter, before the main content:

```markdown
## Phase 0: Expertise Loading

Before executing any task, this agent checks for domain expertise:

```yaml
expertise_check:
  domain: [DOMAIN]
  file: .claude/expertise/[DOMAIN].yaml

  if_exists:
    - Load domain patterns
    - Apply best practices
    - Use known configurations

  if_not_exists:
    - Flag discovery mode
    - Document patterns learned
    - Create expertise file after successful task
```

## Recursive Improvement Integration (v2.1)

### Eval Harness Integration

```yaml
benchmark: [AGENT]-benchmark-v1
  tests:
    - test-001: Task completion
    - test-002: Output quality
    - test-003: Error handling
  success_threshold: 0.9
```

### Memory Namespace

```yaml
namespace: "agents/[CATEGORY]/[AGENT]/{project}/{timestamp}"
store:
  - execution_context
  - decisions_made
  - patterns_discovered
  - errors_encountered
retrieve:
  - similar_past_executions
  - proven_patterns
  - known_issues
```

### Uncertainty Handling

```yaml
uncertainty_protocol:
  confidence_threshold: 0.8

  below_threshold:
    - Consult domain expertise
    - Request human clarification
    - Document uncertainty

  above_threshold:
    - Proceed with execution
    - Log confidence level
```

### Cross-Agent Coordination

```yaml
coordination:
  reports_to: [COORDINATOR_AGENT]
  collaborates_with: [LIST_OF_RELATED_AGENTS]
  shares_memory: true
  memory_namespace: "swarm/shared/[CATEGORY]"
```

## AGENT COMPLETION VERIFICATION

```yaml
completion_checklist:
  - task_objectives_met: boolean
  - outputs_validated: boolean
  - quality_gates_passed: boolean
  - memory_updated: boolean
  - errors_handled: boolean

success_metrics:
  task_completion_rate: ">95%"
  output_quality_score: ">85%"
  error_rate: "<5%"
```
```

## Expertise Files to Create

Create these domain expertise files in `.claude/expertise/`:

1. **agent-creation.yaml** - For foundry agents
2. **security.yaml** - For security agents
3. **orchestration.yaml** - For swarm/coordination agents
4. **platform.yaml** - For platform service agents
5. **tooling.yaml** - For GitHub/documentation agents
6. **specialist.yaml** - For business/domain specialists

(quality.yaml, deployment.yaml, testing.yaml, research.yaml already exist)

## Execution Strategy

1. **Process in batches of 7 agents** per session
2. **Verify each agent has**:
   - Phase 0: Expertise Loading
   - Recursive Improvement Integration (v2.1)
   - AGENT COMPLETION VERIFICATION
3. **Create missing supporting files**
4. **Update CHANGELOG.md** in each category
5. **Run validation** after each batch

## Estimated Timeline

| Batch | Agents | Est. Time |
|-------|--------|-----------|
| 1 | 25 | 4 sessions |
| 2 | 5 | 1 session |
| 3 | 18 | 3 sessions |
| 4 | 23 | 4 sessions |
| 5 | 29 | 5 sessions |
| 6 | 11 | 2 sessions |
| 7 | 18 | 3 sessions |
| 8 | 24 | 4 sessions |
| 9 | 19 | 3 sessions |
| 10 | 44 | 7 sessions |

**Total**: ~36 sessions (processing 7 agents per session)

## Success Criteria

All 211 agents have:
- [ ] Phase 0: Expertise Loading section
- [ ] Recursive Improvement Integration (v2.1) section
- [ ] AGENT COMPLETION VERIFICATION section
- [ ] Expertise domain file exists
- [ ] Evidence-based prompting techniques applied
