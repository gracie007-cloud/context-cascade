# hook post-edit

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: hooks
  file: .claude/expertise/hooks.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: post-edit-benchmark-v1
  tests:
    - deployment_success
    - hook_execution_validation
  success_threshold: 0.9
namespace: "commands/operations/hooks/post-edit/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [hooks-automation, deployment-readiness]
  related_agents: [cicd-engineer, kubernetes-specialist]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->


Execute post-edit processing including formatting, validation, and memory updates.

## Usage

```bash
npx claude-flow hook post-edit [options]
```

## Options

- `--file, -f <path>` - File path that was edited
- `--auto-format` - Automatically format code (default: true)
- `--memory-key, -m <key>` - Store edit context in memory
- `--train-patterns` - Train neural patterns from edit
- `--validate-output` - Validate edited file

## Examples

### Basic post-edit hook

```bash
npx claude-flow hook post-edit --file "src/components/Button.jsx"
```

### With memory storage

```bash
npx claude-flow hook post-edit -f "api/auth.js" --memory-key "auth/login-implementation"
```

### Format and validate

```bash
npx claude-flow hook post-edit -f "config/webpack.js" --auto-format --validate-output
```

### Neural training

```bash
npx claude-flow hook post-edit -f "utils/helpers.ts" --train-patterns --memory-key "utils/refactor"
```

## Features

### Auto Formatting

- Language-specific formatters
- Prettier for JS/TS/JSON
- Black for Python
- gofmt for Go
- Maintains consistency

### Memory Storage

- Saves edit context
- Records decisions made
- Tracks implementation details
- Enables knowledge sharing

### Pattern Training

- Learns from successful edits
- Improves future suggestions
- Adapts to coding style
- Enhances coordination

### Output Validation

- Checks syntax correctness
- Runs linting rules
- Validates formatting
- Ensures quality

## Integration

This hook is automatically called by Claude Code when:

- After Edit tool completes
- Following MultiEdit operations
- During file saves
- After code generation

Manual usage in agents:

```bash
# After editing files
npx claude-flow hook post-edit --file "path/to/edited.js" --memory-key "feature/step1"
```

## Output

Returns JSON with:

```json
{
  "file": "src/components/Button.jsx",
  "formatted": true,
  "formatterUsed": "prettier",
  "lintPassed": true,
  "memorySaved": "component/button-refactor",
  "patternsTrained": 3,
  "warnings": [],
  "stats": {
    "linesChanged": 45,
    "charactersAdded": 234
  }
}
```

## See Also

- `hook pre-edit` - Pre-edit preparation
- `Edit` - File editing tool
- `memory usage` - Memory management
- `neural train` - Pattern training
