# Example 4: Plan Mode Enhancement Hook

## Purpose
Inject extended reasoning requirements (ultrathink + sequential-thinking MCP) when Claude enters plan mode.

## Use Case
Ensure all planning tasks get maximum reasoning depth without requiring the user to remember to add special keywords.

## Implementation

### Hook Script: plan-mode-enhancer.sh

```bash
#!/bin/bash
# plan-mode-enhancer.sh
# Hook: UserPromptSubmit
# Purpose: Enhance plan mode with ultrathink and sequential-thinking MCP

# Read input from stdin
INPUT=$(timeout 5 cat 2>/dev/null || echo '{}')

# Detect plan mode via permission_mode field
PERMISSION_MODE=$(echo "$INPUT" | jq -r '.session.permission_mode // .permission_mode // empty' 2>/dev/null)
PROMPT_TEXT=$(echo "$INPUT" | jq -r '.prompt // empty' 2>/dev/null)
IS_PLANNING=false

# Method 1: API field detection
if [ "$PERMISSION_MODE" = "plan" ]; then
    IS_PLANNING=true
fi

# Method 2: Keyword fallback detection
if echo "$PROMPT_TEXT" | grep -iqE "(plan mode|/plan|planning phase|architecture|strategy)"; then
    IS_PLANNING=true
fi

# Inject enhancements if in plan mode
if [ "$IS_PLANNING" = true ]; then
    cat << 'EOF'
================================================================
!! PLAN MODE ENHANCEMENT ACTIVE !!
================================================================

REQUIRED ENHANCEMENTS:

1. ULTRATHINK ACTIVATION
   Extended thinking mode is now ACTIVE.
   ultrathink

2. SEQUENTIAL-THINKING MCP REQUIRED
   Use mcp__sequential-thinking__sequentialthinking for structured reasoning.

================================================================
EOF
fi

exit 0
```

### Registration (settings.local.json)

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR\"/.claude/hooks/enforcement/plan-mode-enhancer.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

## Expected Outcomes

| Metric | Without Hook | With Hook | Change |
|--------|--------------|-----------|--------|
| Reasoning depth | Baseline | +30-50% | Better edge case coverage |
| Token usage | Baseline | +200-400% | Extended thinking cost |
| Response time | Baseline | +150-250% | Longer processing |
| Risk identification | ~60% | ~85% | More comprehensive |

## Validation

A/B test by:
1. Running planning prompt without hook
2. Running same prompt with hook enabled
3. Comparing outputs on: completeness, dependencies identified, risks flagged

## Related Patterns
- See reflect skill for capturing learnings from planning sessions
- See sequential-thinking MCP documentation for thought chain usage

Confidence: 0.75 (ceiling: observation 0.95) - Based on single implementation session
[ground:witnessed:2026-01-09]
