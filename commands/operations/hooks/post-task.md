# hook post-task

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: hooks
  file: .claude/expertise/hooks.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: post-task-benchmark-v1
  tests:
    - deployment_success
    - hook_execution_validation
  success_threshold: 0.9
namespace: "commands/operations/hooks/post-task/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [hooks-automation, deployment-readiness]
  related_agents: [cicd-engineer, kubernetes-specialist]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


Execute post-task cleanup, performance analysis, and memory storage.

## Usage

```bash
npx claude-flow hook post-task [options]
```

## Options

- `--task-id, -t <id>` - Task identifier for tracking
- `--analyze-performance` - Generate performance metrics (default: true)
- `--store-decisions` - Save task decisions to memory
- `--export-learnings` - Export neural pattern learnings
- `--generate-report` - Create task completion report

## Examples

### Basic post-task hook

```bash
npx claude-flow hook post-task --task-id "auth-implementation"
```

### With full analysis

```bash
npx claude-flow hook post-task -t "api-refactor" --analyze-performance --generate-report
```

### Memory storage

```bash
npx claude-flow hook post-task -t "bug-fix-123" --store-decisions --export-learnings
```

### Quick cleanup

```bash
npx claude-flow hook post-task -t "minor-update" --analyze-performance false
```

## Features

### Performance Analysis

- Measures execution time
- Tracks token usage
- Identifies bottlenecks
- Suggests optimizations

### Decision Storage

- Saves key decisions made
- Records implementation choices
- Stores error resolutions
- Maintains knowledge base

### Neural Learning

- Exports successful patterns
- Updates coordination models
- Improves future performance
- Trains on task outcomes

### Report Generation

- Creates completion summary
- Documents changes made
- Lists files modified
- Tracks metrics achieved

## Integration

This hook is automatically called by Claude Code when:

- Completing a task
- Switching to a new task
- Ending a work session
- After major milestones

Manual usage in agents:

```bash
# In agent coordination
npx claude-flow hook post-task --task-id "your-task-id" --analyze-performance true
```

## Output

Returns JSON with:

```json
{
  "taskId": "auth-implementation",
  "duration": 1800000,
  "tokensUsed": 45000,
  "filesModified": 12,
  "performanceScore": 0.92,
  "learningsExported": true,
  "reportPath": "/reports/task-auth-implementation.md"
}
```

## See Also

- `hook pre-task` - Pre-task setup
- `performance report` - Detailed metrics
- `memory usage` - Memory management
- `neural patterns` - Pattern analysis
