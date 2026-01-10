# Agent-to-Subagent Type Mapping Guide

## Root Cause Analysis

**Problem Identified**: 2026-01-08

The Context Cascade documentation describes 217 "agents" (e.g., `bug-fixer`, `coder`, `researcher`) as if they are directly invocable via the Task tool's `subagent_type` parameter. This is architecturally incorrect.

### The Mismatch

**What Documentation Says**:
```javascript
Task("Fix bug", "Fix the auth issue", "bug-fixer")  // INCORRECT
Task("Research API", "Find best practices", "researcher")  // INCORRECT
```

**What Actually Works**:
```javascript
Task("Fix bug", "Acting as a bug-fixer specialist: Fix the auth issue...", "general-purpose")
Task("Research API", "Acting as a researcher: Find best practices...", "general-purpose")
```

### Valid Task Tool subagent_types

The Task tool in Claude Code only accepts these 6 values for `subagent_type`:

| subagent_type | Purpose | When to Use |
|---------------|---------|-------------|
| `general-purpose` | Multi-step tasks, research, coding, analysis | **Most agent work** - default choice |
| `Explore` | Fast codebase exploration | File searches, pattern matching, architecture understanding |
| `Plan` | Implementation planning | Designing approaches, architectural decisions |
| `Bash` | Command execution | git, npm, docker, system commands |
| `claude-code-guide` | Claude Code help | Questions about Claude Code features |
| `statusline-setup` | Status line config | UI configuration |

### The 217 Agents Are Personas, Not Subagent Types

The Context Cascade agents are **conceptual roles** with specialized:
- System prompts
- Domain expertise
- Quality gates
- Tool permissions
- MCP configurations

They should be **embedded into the prompt parameter**, not the subagent_type parameter.

## Correct Invocation Pattern

### Pattern 1: Persona-Embedded Prompt

Include the agent's role and expertise in the prompt:

```javascript
// Bug Fixer Agent
Task(
  "Fix authentication bug",
  `Acting as a bug-fixer agent with expertise in debugging and root cause analysis:

  Context: Authentication is failing for OAuth users

  SOP:
  1. Reproduce the issue
  2. Identify root cause
  3. Implement fix
  4. Verify with tests

  Constraints:
  - Don't break existing auth flows
  - Add regression tests`,
  "general-purpose"
)
```

### Pattern 2: Skill Then Task

Use Skills for SOP loading, then Task for execution:

```javascript
// First, load the SOP
Skill("fix-bug")

// The skill provides context, then you execute with:
Task(
  "Fix the issue",
  "Following the fix-bug SOP, address the authentication failure...",
  "general-purpose"
)
```

### Pattern 3: Parallel Agent Execution

For multi-agent workflows, use parallel Task calls with different personas in prompts:

```javascript
// Single message with multiple parallel tasks
Task("Security review", "Acting as security-auditor: Check for vulnerabilities in...", "general-purpose")
Task("Code quality", "Acting as code-reviewer: Review patterns and maintainability of...", "general-purpose")
Task("Test coverage", "Acting as tester: Analyze test coverage for...", "general-purpose")
```

## Mapping Reference

### Category: Delivery

| Conceptual Agent | subagent_type | Prompt Prefix |
|------------------|---------------|---------------|
| `feature-builder` | general-purpose | "Acting as a feature-builder agent..." |
| `bug-fixer` | general-purpose | "Acting as a bug-fixer agent with debugging expertise..." |
| `coder` | general-purpose | "Acting as a coder agent focused on implementation..." |
| `planner` | Plan | "Design an implementation plan for..." |
| `tester` | general-purpose | "Acting as a tester agent writing comprehensive tests..." |
| `reviewer` | general-purpose | "Acting as a code-reviewer agent analyzing..." |
| `deployer` | general-purpose | "Acting as a deployer agent handling deployment..." |

### Category: Research

| Conceptual Agent | subagent_type | Prompt Prefix |
|------------------|---------------|---------------|
| `researcher` | general-purpose | "Acting as a researcher agent conducting deep research..." |
| `literature-reviewer` | general-purpose | "Acting as a literature-reviewer using PRISMA methodology..." |
| `synthesizer` | general-purpose | "Acting as a synthesizer agent combining findings..." |

### Category: Exploration

| Conceptual Agent | subagent_type | Prompt Prefix |
|------------------|---------------|---------------|
| `code-explorer` | Explore | (Use Explore agent directly) |
| `architecture-mapper` | Explore | (Use Explore with architecture focus) |
| `dependency-tracer` | Explore | (Use Explore with dependency patterns) |

### Category: Operations

| Conceptual Agent | subagent_type | Prompt Prefix |
|------------------|---------------|---------------|
| `cicd-engineer` | Bash | (Use Bash for CI/CD commands) |
| `docker-specialist` | Bash | (Use Bash for docker commands) |
| `kubernetes-operator` | Bash | (Use Bash for kubectl commands) |
| `aws-specialist` | general-purpose | "Acting as an AWS specialist..." |

## Migration Checklist

When updating skills/commands that reference conceptual agents:

- [ ] Replace `Task("desc", "prompt", "conceptual-agent")` with `Task("desc", "persona-embedded prompt", "valid-subagent-type")`
- [ ] Choose appropriate subagent_type based on primary task type
- [ ] Embed agent expertise/constraints into prompt parameter
- [ ] Update skill documentation to reflect correct pattern
- [ ] Add TASK_SUBAGENT_RULE to VCL appendix

## Examples of Fixed Skills

### Before (Incorrect)
```markdown
### Execution
Task("Analyze code", "Find bugs in auth.js", "code-analyzer")
```

### After (Correct)
```markdown
### Execution
Task("Analyze code", "Acting as a code-analyzer agent with expertise in static analysis and bug detection: Analyze auth.js for potential bugs, security issues, and code smells. Report findings with severity levels.", "general-purpose")
```

## Summary

The 217 documented agents are valuable as **personas with domain expertise** - they define WHAT expertise an agent should have. The 6 subagent_types define HOW the agent executes. Combine both:

```
WHAT (Persona) + HOW (Subagent Type) = Effective Agent Invocation
```

---

*Document created: 2026-01-08*
*Root cause fix for Context Cascade agent architecture*
