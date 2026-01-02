# Context Cascade Skills Directory

**Status:** 237 skills organized into 10 functional categories
**Packaged:** 218 skills as .skill archives
**Last Updated:** 2026-01-02
**VCL Compliance:** v3.1.1

---

## Quick Category Overview

| Category | Description | Count | Example Skills |
|----------|-------------|-------|----------------|
| delivery | Build and implementation workflows | 10+ | feature-dev-complete, smart-bug-fix |
| foundry | Tooling for creating agents, skills, prompts | 22+ | agent-creator, prompt-architect |
| operations | DevOps, infrastructure, release management | 23+ | production-readiness, cloud-platforms |
| orchestration | Multi-agent coordination, swarms, workflows | 23+ | cascade-orchestrator, swarm-orchestration |
| platforms | Core platform components, data services | 18+ | agentdb-advanced, flow-nexus-platform |
| quality | Testing, audit, review, verification | 22+ | code-review-assistant, quick-quality-check |
| research | Research pipelines, analysis, discovery | 21+ | deep-research-orchestrator, literature-synthesis |
| security | Security, compliance, reverse engineering | 13+ | network-security-setup, reverse-engineering-deep |
| specialists | Domain specialists for languages, ML | 11+ | python-specialist, ml-expert |
| tooling | Supporting utilities and adapters | 17+ | web-cli-teleport, pptx-generation |

---

## Directory Layout

```
skills/
  delivery/                  # Build and implementation workflows
  foundry/                   # Skill and prompt creation toolchain
  operations/                # DevOps, infrastructure, release automation
  orchestration/             # Swarms, cascades, and workflow control
  platforms/                 # AgentDB, Flow Nexus, ReasoningBank, ML
  quality/                   # Audits, testing SOPs, code review pipelines
  research/                  # Discovery, replication, and analysis tracks
  security/                  # Compliance, sandboxing, reverse engineering
  specialists/               # Domain experts and specialist stacks
  tooling/                   # Utilities, presentation, CLI bridges
  packaged/                  # .skill archive files (218 skills)
  references/                # Master index and shared reference docs
  _pipeline-automation/      # Enhancement scripts and audit reports
```

---

## Standard Skill Structure

Every skill follows the VCL v3.1.1 format:

```
skill-name/
  SKILL.md          # YAML front matter + SOP playbook
  README.md         # Quick start guide
  examples/         # Worked examples
  references/       # Best practices, API notes
  resources/        # Templates, scripts (optional)
  tests/            # Validation scenarios (optional)
```

### SKILL.md Format

```yaml
---
name: skill-name
description: Brief description
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-category: category-name
x-version: X.Y.Z
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
### Triggers (Positive/Negative)
### Guardrails
### Execution Phases
### Output Format
### Validation Checklist
```

---

## Finding Skills

1. **Browse by category** - Navigate to the relevant top-level directory
2. **Use the master index** - `skills/MASTER-SKILLS-INDEX.md`
3. **Use skill router** - Automatic matching via `skill-router-hook.sh`
4. **Search by keyword** - `rg "skill-name"` from repository root

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

## Packaged Skills

The `packaged/` directory contains 218 .skill files (ZIP archives):

```
packaged/
  intent-analyzer.skill
  feature-dev-complete.skill
  code-review-assistant.skill
  ...
```

Each .skill file contains the complete skill directory structure.

---

## Recent Updates (2026-01-02)

- **Skill Reconciliation:** Merged LOCAL (rich content) + GitHub (VCL format)
- **218 Skills Packaged:** Complete .skill archive generation
- **Hook Fixes:** All hooks validated with timeout protection
- **Documentation:** Updated all index and report files

---

## Contributing

1. Place new skills in the matching category directory
2. Follow the VCL v3.1.1 SKILL.md format
3. Include README.md with quick start
4. Update MASTER-SKILLS-INDEX.md
5. Run `scripts/update-counts.sh` to sync counts

---

**Repository:** github.com/DNYoussef/context-cascade
**Plugin Location:** `C:\Users\17175\claude-code-plugins\context-cascade\`
