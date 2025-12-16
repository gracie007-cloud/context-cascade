# Setting Up ruv-swarm Hooks

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: hooks
  file: .claude/expertise/hooks.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: setup-benchmark-v1
  tests:
    - deployment_success
    - hook_execution_validation
  success_threshold: 0.9
namespace: "commands/operations/hooks/setup/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [hooks-automation, deployment-readiness]
  related_agents: [cicd-engineer, kubernetes-specialist]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


## Quick Start

### 1. Initialize with Hooks
```bash
npx claude-flow init --hooks
```

This automatically creates:
- `.claude/settings.json` with hook configurations
- Hook command documentation
- Default hook handlers

### 2. Test Hook Functionality
```bash
# Test pre-edit hook
npx claude-flow hook pre-edit --file test.js

# Test session summary
npx claude-flow hook session-end --summary
```

### 3. Customize Hooks

Edit `.claude/settings.json` to customize:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "^Write$",
        "hooks": [{
          "type": "command",
          "command": "npx claude-flow hook pre-write --file '${tool.params.file_path}'"
        }]
      }
    ]
  }
}
```

## Hook Response Format

Hooks return JSON with:
- `continue`: Whether to proceed (true/false)
- `reason`: Explanation for decision
- `metadata`: Additional context

Example blocking response:
```json
{
  "continue": false,
  "reason": "Protected file - manual review required",
  "metadata": {
    "file": ".env.production",
    "protection_level": "high"
  }
}
```

## Performance Tips
- Keep hooks lightweight (< 100ms)
- Use caching for repeated operations
- Batch related operations
- Run non-critical hooks asynchronously

## Debugging Hooks
```bash
# Enable debug output
export CLAUDE_FLOW_DEBUG=true

# Test specific hook
npx claude-flow hook pre-edit --file app.js --debug
```

## Common Patterns

### Auto-Format on Save
Already configured by default for common file types.

### Protected File Detection
```json
{
  "matcher": "^(Write|Edit)$",
  "hooks": [{
    "type": "command",
    "command": "npx claude-flow hook check-protected --file '${tool.params.file_path}'"
  }]
}
```

### Automatic Testing
```json
{
  "matcher": "^Write$",
  "hooks": [{
    "type": "command",
    "command": "test -f '${tool.params.file_path%.js}.test.js' && npm test '${tool.params.file_path%.js}.test.js'"
  }]
}
```