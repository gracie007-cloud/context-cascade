# Master Skills Index - Context Cascade Skill Library

**Total Skills:** 237
**Total Agents:** 217
**Total Commands:** 245
**Packaged Skills:** 218 (.skill archives)
**Last Updated:** 2026-01-02
**Version:** 4.0.0 (Post-Reconciliation)

---

## Quick Stats

| Component | Count | Location |
|-----------|-------|----------|
| Skills (directory-based) | 237 | `skills/` |
| Skills (packaged) | 218 | `skills/packaged/` |
| Agents | 217 | `agents/` |
| Commands | 245 | `commands/` |
| Playbooks | 7 | `playbooks/` |
| Hooks | 39 | `hooks/` |

---

## Skill Categories (10 Primary)

| Category | Description | Count | Key Skills |
|----------|-------------|-------|------------|
| delivery | Build and implementation workflows | 10+ | feature-dev-complete, smart-bug-fix |
| foundry | Agent, skill, and prompt creation | 22+ | agent-creator, skill-forge, prompt-architect |
| operations | DevOps, infrastructure, releases | 23+ | production-readiness, cicd-intelligent-recovery |
| orchestration | Multi-agent coordination, swarms | 23+ | cascade-orchestrator, swarm-orchestration |
| platforms | AgentDB, Flow Nexus, ML services | 18+ | agentdb-advanced, flow-nexus-platform |
| quality | Testing, auditing, code review | 22+ | code-review-assistant, functionality-audit |
| research | Research pipelines, synthesis | 21+ | deep-research-orchestrator, literature-synthesis |
| security | Security, compliance, reverse engineering | 13+ | network-security-setup, reverse-engineering-deep |
| specialists | Domain experts (languages, ML) | 11+ | python-specialist, ml-expert |
| tooling | Utilities and adapters | 17+ | web-cli-teleport, pptx-generation |

---

## Skill Format (VCL v3.1.1 Compliant)

All skills follow the standardized SKILL.md format:

```yaml
---
name: skill-name
description: Brief description of the skill
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-category: category-name
x-version: X.Y.Z
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
[What this skill accomplishes]

### Triggers
- **Positive:** [When to use this skill]
- **Negative:** [When NOT to use - redirect to other skills]

### Guardrails
[Safety constraints and quality requirements]

### Execution Phases
[Step-by-step workflow]

### Output Format
[Expected deliverables]

### Validation Checklist
[Quality gates]
```

---

## Core Workflows

### Development Lifecycle
1. `intent-analyzer` - Analyze user intent
2. `prompt-architect` - Optimize prompts
3. `research-driven-planning` - Strategic planning
4. `feature-dev-complete` - 12-stage feature lifecycle
5. `testing-framework` - Comprehensive testing
6. `production-readiness` - Deployment validation

### Quality Assurance
1. `functionality-audit` - Verify code works
2. `theater-detection-audit` - Detect fake code
3. `code-review-assistant` - Multi-agent review
4. `quick-quality-check` - Fast parallel checks

### Multi-Agent Orchestration
1. `cascade-orchestrator` - Multi-skill pipelines
2. `swarm-orchestration` - Complex workflow management
3. `hive-mind-advanced` - Queen-led collective intelligence
4. `parallel-swarm-implementation` - 54-agent parallel execution

### Research Pipeline
1. `literature-synthesis` - PRISMA-compliant review
2. `baseline-replication` - Statistical validation
3. `method-development` - Novel algorithm design
4. `deep-research-orchestrator` - Full pipeline coordination

---

## Three-Loop Integrated Development

### Loop 1: Planning (research-driven-planning)
- Research + 5x pre-mortem
- Output: Risk-mitigated plan
- Time: 6-11 hours

### Loop 2: Implementation (parallel-swarm-implementation)
- 9-step swarm with 54 agents
- Output: Theater-free code
- Time: 4-6 hours
- Speedup: 8.3x

### Loop 3: CI/CD (cicd-intelligent-recovery)
- 8-step intelligent recovery
- Output: 100% test success
- Time: 1.5-2 hours

**Total System:** 11.5-19 hours (vs 45-51 hours traditional)

---

## Skill Invocation Pattern

```
Skill("skill-name")           // Load the SOP
    |
    v
Task("Agent", "desc", "type") // Execute via registry agent
    |
    v
TodoWrite({ todos })          // Track progress
```

**Golden Rule:** 1 MESSAGE = ALL PARALLEL Task() calls

---

## Recent Updates (2026-01-02)

### Skill Reconciliation Complete
- Merged LOCAL skills (rich content) with GitHub skills (VCL format)
- 218 skills packaged as .skill archives
- Zero content loss from reconciliation

### Hook Fixes Applied
- Fixed blocking stdin reads in 9 hooks
- Added timeout protection (3-5 seconds)
- All hooks validated against Anthropic specs

### Documentation Updated
- MASTER-SKILLS-INDEX.md (this file)
- README.md
- SKILL-CONSOLIDATION-AUDIT-REPORT.md
- All supporting files

---

## Resources

- **Plugin Location:** `C:\Users\17175\claude-code-plugins\context-cascade\`
- **Skill Index:** `scripts/skill-index/skill-index.json`
- **Agent Registry:** `agents/foundry/registry/registry.json`
- **Hook Configuration:** `hooks/hooks.json`

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 4.0.0 | 2026-01-02 | Post-reconciliation update, 237 skills, hook fixes |
| 3.2.0 | 2025-12-17 | VCL v3.1.1 compliance, skill consolidation |
| 3.0.0 | 2025-11-02 | Three-Loop system, 93 skills |
| 2.0.0 | 2025-10-30 | Trigger-first naming, 62 skills |

---

**Maintained By:** Context Cascade Team
**Repository:** github.com/DNYoussef/context-cascade
