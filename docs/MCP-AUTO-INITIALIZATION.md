# MCP Auto-Initialization System

**Version**: 1.0.0
**Date**: 2025-11-25

## Overview

The MCP Auto-Initialization system ensures that MCP servers are automatically enabled when agents or skills that require them are loaded. This eliminates the need for users to manually manage MCP configurations.

## How It Works

```
User invokes agent/skill
        |
        v
Parse agent YAML frontmatter
        |
        v
Extract mcp_servers.required[]
        |
        v
Check if MCPs are enabled (claude mcp list)
        |
        v
+-------+-------+
|               |
v               v
All enabled    Missing MCPs
|               |
v               v
Proceed        Prompt user OR auto-enable
```

## Agent MCP Requirements Schema

Every agent can declare its MCP requirements in the YAML frontmatter:

```yaml
---
name: "agent-name"
mcp_servers:
  required:           # MCPs that MUST be enabled for this agent to function
    - memory-mcp      # Always required for cross-session memory
    - playwright      # Required for E2E testing agents
  optional:           # MCPs that enhance functionality but aren't required
    - ruv-swarm       # For swarm coordination
    - flow-nexus      # For cloud features
  auto_enable: true   # If true, prompt user to enable missing MCPs
---
```

## MCP Server Categories

### Core MCPs (Always On by Default)
These MCPs have minimal token cost and are essential:

| MCP | Tokens | Purpose |
|-----|--------|---------|
| memory-mcp | ~1.2k | Cross-session persistence, vector search |
| sequential-thinking | ~1.5k | Complex reasoning chains |

**Total Core**: ~2.7k tokens (1.4% of context)

### Situational MCPs (Load On Demand)

| MCP | Tokens | Required By |
|-----|--------|-------------|
| playwright | ~14.5k | e2e-testing-specialist, accessibility-tester, visual-regression-agent |
| ruv-swarm | ~15.5k | hierarchical-coordinator, mesh-coordinator, consensus agents |
| flow-nexus | ~58k | automl-optimizer, neural-trainer, distributed ML agents |
| agentic-payments | ~6.6k | payment agents, e-commerce specialists |
| focused-changes | ~1.8k | code-review agents, refactoring specialists |

### Redundant MCPs (Removed)
These MCPs duplicate Claude Code built-in tools and should NOT be used:

| MCP | Replace With |
|-----|--------------|
| filesystem | Claude Code's Read, Write, Edit, Glob, Grep |
| fetch | Claude Code's WebFetch |

## Agent-to-MCP Mapping

### Orchestration Agents
```yaml
# hierarchical-coordinator, mesh-coordinator, adaptive-coordinator
mcp_servers:
  required: [memory-mcp, ruv-swarm]
  optional: [flow-nexus]
```

### Testing Agents
```yaml
# e2e-testing-specialist, visual-regression-agent, accessibility-tester
mcp_servers:
  required: [memory-mcp, playwright]
  optional: [ruv-swarm]
```

### ML/AI Agents
```yaml
# automl-optimizer, neural-trainer, model-evaluation-agent
mcp_servers:
  required: [memory-mcp, flow-nexus]
  optional: [ruv-swarm]
```

### Development Agents
```yaml
# backend-dev, frontend-dev, coder, sparc-coder
mcp_servers:
  required: [memory-mcp]
  optional: []  # Core development doesn't need extra MCPs
```

### Code Quality Agents
```yaml
# code-analyzer, reviewer, clarity-linter
mcp_servers:
  required: [memory-mcp]
  optional: [focused-changes]
```

## Implementation

### Pre-Task Hook (Recommended)

Add to your hooks configuration to auto-check MCPs before agent execution:

```json
{
  "PreToolUse": [
    {
      "matcher": "Task",
      "hooks": [
        {
          "type": "command",
          "command": "node scripts/check-agent-mcps.js"
        }
      ]
    }
  ]
}
```

### check-agent-mcps.js Script

```javascript
#!/usr/bin/env node
// scripts/check-agent-mcps.js
// Checks if required MCPs for an agent are enabled

const { execSync } = require('child_process');
const fs = require('fs');
const yaml = require('yaml');

// Read agent definition
const agentPath = process.env.AGENT_PATH;
if (!agentPath) process.exit(0);

const content = fs.readFileSync(agentPath, 'utf8');
const frontmatter = content.match(/^---\n([\s\S]*?)\n---/);
if (!frontmatter) process.exit(0);

const metadata = yaml.parse(frontmatter[1]);
const required = metadata.mcp_servers?.required || [];

if (required.length === 0) process.exit(0);

// Get current MCP list
const mcpList = execSync('claude mcp list', { encoding: 'utf8' });

// Check each required MCP
const missing = required.filter(mcp => !mcpList.includes(mcp));

if (missing.length > 0) {
  console.log(`Missing required MCPs for ${metadata.name}:`);
  missing.forEach(mcp => console.log(`  - ${mcp}`));
  console.log('\nTo enable:');
  missing.forEach(mcp => {
    const enableCmd = MCP_ENABLE_COMMANDS[mcp];
    if (enableCmd) console.log(`  ${enableCmd}`);
  });
  process.exit(1);
}

const MCP_ENABLE_COMMANDS = {
  'playwright': 'claude mcp add playwright npx -y @anthropic/mcp-playwright',
  'ruv-swarm': 'claude mcp add ruv-swarm npx ruv-swarm mcp start',
  'flow-nexus': 'claude mcp add flow-nexus npx flow-nexus@latest mcp start',
  'agentic-payments': 'claude mcp add agentic-payments npx agentic-payments@latest mcp',
  'focused-changes': 'claude mcp add focused-changes npx -y @anthropic/mcp-focused-changes',
};
```

## Skill MCP Requirements

Skills can also declare MCP requirements in their SKILL.md frontmatter:

```yaml
---
name: "e2e-testing-complete"
mcp_servers:
  required: [memory-mcp, playwright]
  optional: [ruv-swarm]
---
```

## Playbook MCP Requirements

Playbooks can declare aggregate MCP requirements based on the skills/agents they use:

```yaml
---
playbook: "three-loop-system"
mcp_requirements:
  loop1_planning: [memory-mcp]
  loop2_implementation: [memory-mcp, ruv-swarm]
  loop3_cicd: [memory-mcp]
---
```

## Best Practices

1. **Minimize Required MCPs**: Only mark MCPs as required if the agent literally cannot function without them.

2. **Use Optional for Enhancement**: MCPs that add features but aren't essential should be optional.

3. **Document MCP Purpose**: Always comment why an MCP is required in the agent definition.

4. **Test Without Optional MCPs**: Ensure agents degrade gracefully without optional MCPs.

5. **Keep Core Lean**: The core MCPs (memory-mcp, sequential-thinking) should stay small.

## Troubleshooting

### MCP Not Found
```bash
# Check if MCP is installed
claude mcp list

# Add missing MCP
claude mcp add <mcp-name> <command>
```

### MCP Connection Failed
```bash
# Remove and re-add
claude mcp remove <mcp-name>
claude mcp add <mcp-name> <command>
```

### High Token Usage
```bash
# Check which MCPs are consuming tokens
# Run /context in Claude Code

# Disable non-essential MCPs
.\scripts\Manage-MCPs.ps1 disable-all-situational
```

## Migration Guide

If your agents use the old flat mcp_servers format:

```yaml
# OLD FORMAT (deprecated)
mcp_servers:
  - memory-mcp
  - ruv-swarm
  - filesystem  # REMOVE - redundant

# NEW FORMAT (use this)
mcp_servers:
  required:
    - memory-mcp
    - ruv-swarm
  optional: []
  auto_enable: true
```

## Related Documentation

- [MCP Quick Reference](../../../docs/MCP-QUICK-REFERENCE.md)
- [Agent Schema](./agents/README.md)
- [Skill Definitions](./skills/README.md)
- [Playbook System](./docs/ENHANCED-PLAYBOOK-SYSTEM.md)
