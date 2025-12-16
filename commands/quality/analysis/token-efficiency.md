# Token Usage Optimization

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: quality
  file: .claude/expertise/quality.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: FILENAME-benchmark-v1
  tests:
    - audit_validation
    - quality_gate_pass
  success_threshold: 0.9
namespace: "commands/quality/SUBDIR/FILENAME/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [clarity-linter, functionality-audit]
  related_agents: [code-analyzer, reviewer]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


## Purpose
Reduce token consumption while maintaining quality through intelligent coordination.

## Optimization Strategies

### 1. Smart Caching
- Search results cached for 5 minutes
- File content cached during session
- Pattern recognition reduces redundant searches

### 2. Efficient Coordination
- Agents share context automatically
- Avoid duplicate file reads
- Batch related operations

### 3. Measurement & Tracking

```bash
# Check token savings after session
Tool: mcp__claude-flow__token_usage
Parameters: {"operation": "session", "timeframe": "24h"}

# Result shows:
{
  "metrics": {
    "tokensSaved": 15420,
    "operations": 45,
    "efficiency": "343 tokens/operation"
  }
}
```

## Best Practices
1. **Use Task tool** for complex searches
2. **Enable caching** in pre-search hooks
3. **Batch operations** when possible
4. **Review session summaries** for insights

## Token Reduction Results
- 📉 32.3% average token reduction
- 🎯 More focused operations
- 🔄 Intelligent result reuse
- 📊 Cumulative improvements