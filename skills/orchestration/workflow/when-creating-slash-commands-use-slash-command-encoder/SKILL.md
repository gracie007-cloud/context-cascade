---
name: when-creating-slash-commands-use-slash-command-encoder
description: Create ergonomic slash commands for fast access to micro-skills with
  auto-discovery and parameter validation
version: 1.0.0
tags:
- slash-commands
- cli
- automation
- micro-skills
- encoding
category: workflow
agents:
- coder
- base-template-generator
complexity: intermediate
estimated_duration: 20-40 minutes
prerequisites:
- Claude Flow installed
- Understanding of command-line interfaces
- Micro-skills knowledge
outputs:
- Slash command definitions
- Command handlers
- Documentation
- Validation logic
author: ruv
---

## Orchestration Skill Guidelines

### When to Use This Skill
- **Multi-agent coordination** requiring centralized orchestration
- **Complex workflows** with multiple dependent tasks
- **Parallel execution** benefiting from concurrent agent spawning
- **Quality-controlled delivery** needing validation and consensus
- **Production workflows** requiring audit trails and state management

### When NOT to Use This Skill
- **Single-agent tasks** with no coordination requirements
- **Simple sequential work** completing in <30 minutes
- **Trivial operations** with no quality gates
- **Exploratory work** not needing formal orchestration

### Success Criteria
- **All agents complete successfully** with 100% task completion
- **Coordination overhead minimal** (<20% of total execution time)
- **No orphaned agents** - All spawned agents tracked and terminated
- **State fully recoverable** - Can resume from any failure point
- **Quality gates pass** - All validation checks successful

### Edge Cases to Handle
- **Agent failures** - Detect and replace failed agents automatically
- **Timeout scenarios** - Configure per-agent timeout with escalation
- **Resource exhaustion** - Limit concurrent agents, queue excess work
- **Conflicting results** - Implement conflict resolution strategy
- **Partial completion** - Support incremental progress with rollback

### Guardrails (NEVER Violate)
- **NEVER lose orchestration state** - Persist to memory after each phase
- **ALWAYS track all agents** - Maintain real-time agent registry
- **ALWAYS cleanup resources** - Terminate agents and free memory on completion
- **NEVER skip validation** - Run quality checks before marking complete
- **ALWAYS handle errors** - Every orchestration step needs error handling

### Evidence-Based Validation
- **Verify all agent outputs** - Check actual results vs expected contracts
- **Validate execution order** - Confirm dependencies respected
- **Measure performance** - Track execution time vs baseline
- **Check resource usage** - Monitor memory, CPU, network during execution
- **Audit state consistency** - Verify orchestration state matches reality


# Slash Command Encoder SOP

## Overview

Create ergonomic slash commands (/command) for fast, unambiguous access to micro-skills with auto-discovery, intelligent routing, parameter validation, and command chaining.

## Agents & Responsibilities

### coder
**Role:** Command implementation and handler logic
**Responsibilities:**
- Implement command handlers
- Create validation logic
- Build routing mechanisms
- Test command functionality

### base-template-generator
**Role:** Generate command templates and boilerplate
**Responsibilities:**
- Create command templates
- Generate documentation
- Build example commands
- Create test scaffolding

## Phase 1: Design Command Interface

### Objective
Design command syntax, parameters, and behavior specifications.

### Scripts

```bash
# Generate command template
npx claude-flow@alpha command template \
  --name "analyze" \
  --description "Analyze codebase for patterns" \
  --output commands/analyze.js

# Define command schema
cat > command-schema.json <<EOF
{
  "name": "analyze",
  "alias": "a",
  "description": "Analyze codebase for patterns",
  "parameters": [
    {
      "name": "path",
      "type": "string",
      "required": true,
      "description": "Path to analyze"
    },
    {
      "name": "depth",
      "type": "number",
      "required": false,
      "default": 3,
      "description": "Analysis depth"
    }
  ],
  "examples": [
    "/analyze ./src",
    "/analyze ./src --depth 5"
  ]
}
EOF

# Validate schema
npx claude-flow@alpha command validate --schema command-schema.json
```

### Command Design Patterns

**Simple Command:**
```
/deploy
```

**Command with Arguments:**
```
/analyze ./src
```

**Command with Flags:**
```
/test --watch --coverage
```

**Command with Subcommands:**
```
/git commit -m "message"
/git push origin main
```

### Memory Patterns

```bash
# Store command definition
npx claude-flow@alpha memory store \
  --key "commands/analyze/schema" \
  --file command-schema.json
```

## Phase 2: Generate Command Code

### Objective
Implement command handler with validation, routing, and execution logic.

### Scripts

```bash
# Generate command handler
npx claude-flow@alpha command generate \
  --schema command-schema.json \
  --output commands/analyze-handler.js

# Implement validation logic
npx claude-flow@alpha command add-validation \
  --command analyze \
  --rules validation-rules.json

# Add routing logic
npx claude-flow@alpha command add-routing \
  --command analyze \
  --route-to "task-orchestrator"

# Build command registry
npx claude-flow@alpha command registry build \
  --commands ./commands \
  --output command-registry.json
```

### Command Handler Template

```javascript
// commands/analyze-handler.js
module.exports = {
  name: 'analyze',
  alias: 'a',
  description: 'Analyze codebase for patterns',

  parameters: [
    {
      name: 'path',
      type: 'string',
      required: true,
      validate: (value) => {
        if (!fs.existsSync(value)) {
          throw new Error(`Path not found: ${value}`);
        }
        return true;
      }
    },
    {
      name: 'depth',
      type: 'number',
      required: false,
      default: 3,
      validate: (value) => {
        if (value < 1 || value > 10) {
          throw new Error('Depth must be between 1 and 10');
        }
        return true;
      }
    }
  ],

  async execute(args) {
    const { path, depth } = args;

    // Validate parameters
    this.validateParameters(args);

    // Route to appropriate agent
    const result = await this.routeToAgent('code-analyzer', {
      action: 'analyze',
      path,
      depth
    });

    return result;
  },

  validateParameters(args) {
    for (const param of this.parameters) {
      const value = args[param.name];

      if (param.required && value === undefined) {
        throw new Error(`Required parameter missing: ${param.name}`);
      }

      if (value !== undefined && param.validate) {
        param.validate(value);
      }
    }
  },

  async routeToAgent(agentType, payload) {
    // Implementation of agent routing
    return await claudeFlow.agent.execute(agentType, payload);
  }
};
```

## Phase 3: Test Command

### Objective
Validate command functionality with comprehensive testing.

### Scripts

```bash
# Test command registration
npx claude-flow@alpha command test-register --command analyze

# Test parameter validation
npx claude-flow@alpha command test \
  --command analyze \
  --input '{"path": "./src", "depth": 3}'

# Test error handling
npx claude-flow@alpha command test \
  --command analyze \
  --input '{"path": "./nonexistent"}' \
  --expect-error

# Run integration tests
npx claude-flow@alpha command test-suite \
  --commands ./commands \
  --output test-results.json
```

### Test Cases

```javascript
// tests/analyze-command.test.js
describe('analyze command', () => {
  it('should validate required parameters', async () => {
    await expect(
      commands.analyze.execute({})
    ).rejects.toThrow('Required parameter missing: path');
  });

  it('should validate path exists', async () => {
    await expect(
      commands.analyze.execute({ path: './nonexistent' })
    ).rejects.toThrow('Path not found');
  });

  it('should use default depth', async () => {
    const result = await commands.analyze.execute({ path: './src' });
    expect(result.config.depth).toBe(3);
  });

  it('should accept custom depth', async () => {
    const result = await commands.analyze.execute({
      path: './src',
      depth: 5
    });
    expect(result.config.depth).toBe(5);
  });
});
```

## Phase 4: Document Usage

### Objective
Create comprehensive documentation for command usage.

### Scripts

```bash
# Generate command documentation
npx claude-flow@alpha command docs \
  --command analyze \
  --output docs/commands/analyze.md

# Generate help text
npx claude-flow@alpha command help-text \
  --command analyze \
  --output commands/analyze-help.txt

# Build command catalog
npx claude-flow@alpha command catalog \
  --all \
  --output docs/command-catalog.md

# Generate usage examples
npx claude-flow@alpha command examples \
  --command analyze \
  --count 5 \
  --output docs/examples/analyze-examples.md
```

### Documentation Template

```markdown
# /analyze Command

## Description
Analyze codebase for patterns, complexity, and improvement opportunities.

## Syntax
```
/analyze <path> [--depth <number>]
```

## Parameters

### path (required)
- Type: string
- Description: Path to analyze
- Example: `./src`, `./components`

### --depth (optional)
- Type: number
- Default: 3
- Range: 1-10
- Description: Analysis depth level

## Examples

```bash
# Basic usage
/analyze ./src

# With custom depth
/analyze ./src --depth 5

# Analyze specific directory
/analyze ./components --depth 2
```

## Output

Returns analysis report with:
- Complexity metrics
- Pattern detection results
- Improvement recommendations
- File statistics

## Related Commands

- `/test` - Run tests on analyzed code
- `/optimize` - Apply optimization recommendations
- `/refactor` - Refactor based on analysis
```

## Phase 5: Deploy Command

### Objective
Install command to system and verify functionality.

### Scripts

```bash
# Build command package
npx claude-flow@alpha command build \
  --commands ./commands \
  --output dist/commands.bundle.js

# Install to system
npx claude-flow@alpha command install \
  --from dist/commands.bundle.js \
  --global

# Verify installation
npx claude-flow@alpha command list --installed

# Test installed command
npx claude-flow@alpha analyze ./src --depth 3

# Update command registry
npx claude-flow@alpha command registry update

# Generate shell completions
npx claude-flow@alpha command completions \
  --shell bash \
  --output ~/.bash_completion.d/claude-flow-commands
```

### Installation Validation

```bash
# Check command is registered
if npx claude-flow@alpha command exists analyze; then
  echo "✓ Command installed successfully"
else
  echo "✗ Command installation failed"
  exit 1
fi

# Test command execution
RESULT=$(npx claude-flow@alpha analyze ./src)
if [ $? -eq 0 ]; then
  echo "✓ Command execution successful"
else
  echo "✗ Command execution failed"
  exit 1
fi
```

## Success Criteria

- [ ] Command interface designed
- [ ] Handler implemented
- [ ] Tests passing
- [ ] Documentation complete
- [ ] Command deployed

### Performance Targets
- Command registration: <100ms
- Parameter validation: <50ms
- Command execution: <2s
- Help text generation: <100ms

## Best Practices

1. **Clear Naming:** Use descriptive command names
2. **Parameter Validation:** Validate all inputs
3. **Error Messages:** Provide helpful error messages
4. **Documentation:** Include examples and usage
5. **Testing:** Comprehensive test coverage
6. **Versioning:** Version commands properly
7. **Backwards Compatibility:** Maintain compatibility
8. **Auto-Discovery:** Support command discovery

## Common Issues & Solutions

### Issue: Command Not Found
**Symptoms:** Command not recognized
**Solution:** Run `command install` and verify registry

### Issue: Parameter Validation Fails
**Symptoms:** Unexpected validation errors
**Solution:** Check parameter types and validation rules

### Issue: Command Execution Timeout
**Symptoms:** Command hangs
**Solution:** Add timeout handling, check agent availability

## Integration Points

- **micro-skills:** Commands trigger micro-skills
- **task-orchestrator:** Route to orchestrator
- **memory-coordinator:** Store command history

## References

- CLI Design Patterns
- Command Interface Best Practices
- Parameter Validation Techniques
## Core Principles

### 1. Ergonomics Through Convention
Commands should feel natural and consistent, following established CLI patterns that users already know.

**In practice:**
- Use verb-noun naming convention: /deploy-app, /test-suite, /analyze-code
- Provide short aliases for frequently used commands: /a for /analyze, /d for /deploy
- Support both positional arguments and named flags: /analyze ./src or /analyze --path ./src
- Implement tab completion for command names and parameter values
- Follow Unix conventions for flag naming: --help, --version, --verbose

### 2. Fail Fast with Helpful Errors
Invalid commands should fail immediately with clear, actionable error messages that guide users to correct usage.

**In practice:**
- Validate all parameters before execution, not during
- Provide specific error messages: "Path './nonexistent' does not exist" instead of "Invalid input"
- Suggest corrections for typos: "Unknown command '/analize'. Did you mean '/analyze'?"
- Include usage examples in error output: "Usage: /analyze <path> [--depth <number>]"
- Return non-zero exit codes for errors to enable scripting and automation

### 3. Composability and Chaining
Commands should output structured data that can be consumed by other commands or tools.

**In practice:**
- Support JSON output format for machine-readable results: /analyze --format json
- Enable piping results to other commands: /analyze ./src | /optimize
- Provide filtering and transformation flags: /list --filter "status=active"
- Implement consistent exit codes for success/failure detection in scripts
- Design commands to be atomic and side-effect free where possible

## Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Generic error messages without context** | Users cannot diagnose what went wrong, trial-and-error debugging, frustration and reduced adoption | Provide specific error messages with parameter name, actual value, expected format, and example of correct usage |
| **No parameter validation** | Commands execute with invalid inputs, partial execution with corrupted state, difficult rollback scenarios | Validate all parameters before execution, fail fast with clear messages, use type coercion where sensible (string to number) |
| **Inconsistent naming across commands** | Cognitive load increases, users must remember arbitrary variations, reduced discoverability, confusion | Establish naming conventions (verb-noun), document in style guide, enforce with linting, refactor existing commands for consistency |
| **Commands without help text** | Users must guess parameter meanings, undiscoverable flags, poor developer experience, reduced adoption | Implement --help flag for every command, generate help text from schema, include examples, auto-generate documentation |
| **Blocking execution without progress feedback** | Users cannot tell if command is working or hung, no indication of time remaining, frustration and premature cancellation | Show progress indicators for long-running commands, print incremental output, support --quiet flag to disable for scripting |

## Common Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Generic Error Messages** | Users cannot diagnose what went wrong, leading to trial-and-error debugging, frustration, and reduced adoption of command system. | Provide specific error messages with parameter name, actual value received, expected format, and example of correct usage. Include context about what failed and why. |
| **No Parameter Validation** | Commands execute with invalid inputs causing partial execution with corrupted state, making difficult rollback scenarios and unpredictable failures. | Validate all parameters before execution begins using type checking and schema validation. Fail fast with clear messages. Use type coercion where sensible (string to number conversions). |
| **Inconsistent Naming Across Commands** | Cognitive load increases as users must remember arbitrary variations, reducing discoverability and causing confusion about command purpose. | Establish naming conventions (verb-noun pattern). Document in style guide. Enforce with linting tools. Refactor existing commands for consistency. Use similar flags across related commands. |

## Conclusion

Slash command systems represent a powerful paradigm for exposing micro-skills and agent capabilities through ergonomic, discoverable interfaces. When designed well, these command systems become force multipliers for developer productivity, enabling rapid access to complex functionality through simple, memorable syntax. The three core principles - ergonomics through convention, fail-fast error handling, and composability - form the foundation of successful command interfaces that users actually enjoy using.

The key differentiator between good and great command systems lies in attention to detail: clear error messages that guide users to solutions, consistent naming conventions that reduce cognitive load, and validation logic that catches mistakes before execution. The anti-patterns highlighted above - particularly generic errors and lack of help text - represent missed opportunities to delight users and reduce friction. Every moment spent improving error messages and documentation pays dividends in reduced support burden and increased adoption.

As you build slash command systems, remember that you are designing a user interface, not just a technical API. Users will form mental models of your command system based on patterns they have learned from Git, npm, Docker, and other CLI tools they use daily. By following established conventions and prioritizing user experience, you can create command systems that feel intuitive and powerful. Test your commands with real users, iterate on error messages, and continuously improve discoverability through better help text and auto-completion. A well-designed command system becomes an invisible interface that users rely on without thinking about it.
