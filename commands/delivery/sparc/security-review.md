---

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: agent-creation
  file: .claude/expertise/agent-creation.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: security-review-benchmark-v1
  tests:
    - command_execution_success
    - output_validation
  success_threshold: 0.9
namespace: "commands/delivery/sparc/security-review/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [sparc-methodology, coder]
  related_agents: [coder, reviewer, tester]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->

name: sparc-security-review
description: 🛡️ Security Reviewer - You perform static and dynamic audits to ensure secure code practices. You flag secrets, poor mod...
---

# 🛡️ Security Reviewer

## Role Definition
You perform static and dynamic audits to ensure secure code practices. You flag secrets, poor modular boundaries, and oversized files.

## Custom Instructions
Scan for exposed secrets, env leaks, and monoliths. Recommend mitigations or refactors to reduce risk. Flag files > 500 lines or direct environment coupling. Use `new_task` to assign sub-audits. Finalize findings with `attempt_completion`.

## Available Tools
- **read**: File reading and viewing
- **edit**: File modification and creation

## Usage

### Option 1: Using MCP Tools (Preferred in Claude Code)
```javascript
mcp__claude-flow__sparc_mode {
  mode: "security-review",
  task_description: "audit API security",
  options: {
    namespace: "security-review",
    non_interactive: false
  }
}
```

### Option 2: Using NPX CLI (Fallback when MCP not available)
```bash
# Use when running from terminal or MCP tools unavailable
npx claude-flow sparc run security-review "audit API security"

# For alpha features
npx claude-flow@alpha sparc run security-review "audit API security"

# With namespace
npx claude-flow sparc run security-review "your task" --namespace security-review

# Non-interactive mode
npx claude-flow sparc run security-review "your task" --non-interactive
```

### Option 3: Local Installation
```bash
# If claude-flow is installed locally
./claude-flow sparc run security-review "audit API security"
```

## Memory Integration

### Using MCP Tools (Preferred)
```javascript
// Store mode-specific context
mcp__claude-flow__memory_usage {
  action: "store",
  key: "security-review_context",
  value: "important decisions",
  namespace: "security-review"
}

// Query previous work
mcp__claude-flow__memory_search {
  pattern: "security-review",
  namespace: "security-review",
  limit: 5
}
```

### Using NPX CLI (Fallback)
```bash
# Store mode-specific context
npx claude-flow memory store "security-review_context" "important decisions" --namespace security-review

# Query previous work
npx claude-flow memory query "security-review" --limit 5
```
