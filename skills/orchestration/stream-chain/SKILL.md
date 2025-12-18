---
name: stream-chain
description: Stream-JSON chaining for multi-agent pipelines, data transformation,
  and sequential workflows
version: 1.0.0
category: workflow
tags:
- streaming
- pipeline
- chaining
- multi-agent
- workflow
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


# Stream-Chain Skill

Execute sophisticated multi-step workflows where each agent's output flows into the next, enabling complex data transformations and sequential processing pipelines.

## Overview

Stream-Chain provides two powerful modes for orchestrating multi-agent workflows:

1. **Custom Chains** (`run`): Execute custom prompt sequences with full control
2. **Predefined Pipelines** (`pipeline`): Use battle-tested workflows for common tasks

Each step in a chain receives the complete output from the previous step, enabling sophisticated multi-agent coordination through streaming data flow.

---

## Quick Start

### Run a Custom Chain

```bash
claude-flow stream-chain run \
  "Analyze codebase structure" \
  "Identify improvement areas" \
  "Generate action plan"
```

### Execute a Pipeline

```bash
claude-flow stream-chain pipeline analysis
```

---

## Custom Chains (`run`)

Execute custom stream chains with your own prompts for maximum flexibility.

### Syntax

```bash
claude-flow stream-chain run <prompt1> <prompt2> [...] [options]
```

**Requirements:**
- Minimum 2 prompts required
- Each prompt becomes a step in the chain
- Output flows sequentially through all steps

### Options

| Option | Description | Default |
|--------|-------------|---------|
| `--verbose` | Show detailed execution information | `false` |
| `--timeout <seconds>` | Timeout per step | `30` |
| `--debug` | Enable debug mode with full logging | `false` |

### How Context Flows

Each step receives the previous output as context:

```
Step 1: "Write a sorting function"
Output: [function implementation]

Step 2 receives:
  "Previous step output:
  [function implementation]

  Next task: Add comprehensive tests"

Step 3 receives:
  "Previous steps output:
  [function + tests]

  Next task: Optimize performance"
```

### Examples

#### Basic Development Chain

```bash
claude-flow stream-chain run \
  "Write a user authentication function" \
  "Add input validation and error handling" \
  "Create unit tests with edge cases"
```

#### Security Audit Workflow

```bash
claude-flow stream-chain run \
  "Analyze authentication system for vulnerabilities" \
  "Identify and categorize security issues by severity" \
  "Propose fixes with implementation priority" \
  "Generate security test cases" \
  --timeout 45 \
  --verbose
```

#### Code Refactoring Chain

```bash
claude-flow stream-chain run \
  "Identify code smells in src/ directory" \
  "Create refactoring plan with specific changes" \
  "Apply refactoring to top 3 priority items" \
  "Verify refactored code maintains behavior" \
  --debug
```

#### Data Processing Pipeline

```bash
claude-flow stream-chain run \
  "Extract data from API responses" \
  "Transform data into normalized format" \
  "Validate data against schema" \
  "Generate data quality report"
```

---

## Predefined Pipelines (`pipeline`)

Execute battle-tested workflows optimized for common development tasks.

### Syntax

```bash
claude-flow stream-chain pipeline <type> [options]
```

### Available Pipelines

#### 1. Analysis Pipeline

Comprehensive codebase analysis and improvement identification.

```bash
claude-flow stream-chain pipeline analysis
```

**Workflow Steps:**
1. **Structure Analysis**: Map directory structure and identify components
2. **Issue Detection**: Find potential improvements and problems
3. **Recommendations**: Generate actionable improvement report

**Use Cases:**
- New codebase onboarding
- Technical debt assessment
- Architecture review
- Code quality audits

#### 2. Refactor Pipeline

Systematic code refactoring with prioritization.

```bash
claude-flow stream-chain pipeline refactor
```

**Workflow Steps:**
1. **Candidate Identification**: Find code needing refactoring
2. **Prioritization**: Create ranked refactoring plan
3. **Implementation**: Provide refactored code for top priorities

**Use Cases:**
- Technical debt reduction
- Code quality improvement
- Legacy code modernization
- Design pattern implementation

#### 3. Test Pipeline

Comprehensive test generation with coverage analysis.

```bash
claude-flow stream-chain pipeline test
```

**Workflow Steps:**
1. **Coverage Analysis**: Identify areas lacking tests
2. **Test Design**: Create test cases for critical functions
3. **Implementation**: Generate unit tests with assertions

**Use Cases:**
- Increasing test coverage
- TDD workflow support
- Regression test creation
- Quality assurance

#### 4. Optimize Pipeline

Performance optimization with profiling and implementation.

```bash
claude-flow stream-chain pipeline optimize
```

**Workflow Steps:**
1. **Profiling**: Identify performance bottlenecks
2. **Strategy**: Analyze and suggest optimization approaches
3. **Implementation**: Provide optimized code

**Use Cases:**
- Performance improvement
- Resource optimization
- Scalability enhancement
- Latency reduction

### Pipeline Options

| Option | Description | Default |
|--------|-------------|---------|
| `--verbose` | Show detailed execution | `false` |
| `--timeout <seconds>` | Timeout per step | `30` |
| `--debug` | Enable debug mode | `false` |

### Pipeline Examples

#### Quick Analysis

```bash
claude-flow stream-chain pipeline analysis
```

#### Extended Refactoring

```bash
claude-flow stream-chain pipeline refactor --timeout 60 --verbose
```

#### Debug Test Generation

```bash
claude-flow stream-chain pipeline test --debug
```

#### Comprehensive Optimization

```bash
claude-flow stream-chain pipeline optimize --timeout 90 --verbose
```

### Pipeline Output

Each pipeline execution provides:

- **Progress**: Step-by-step execution status
- **Results**: Success/failure per step
- **Timing**: Total and per-step execution time
- **Summary**: Consolidated results and recommendations

---

## Custom Pipeline Definitions

Define reusable pipelines in `.claude-flow/config.json`:

### Configuration Format

```json
{
  "streamChain": {
    "pipelines": {
      "security": {
        "name": "Security Audit Pipeline",
        "description": "Comprehensive security analysis",
        "prompts": [
          "Scan codebase for security vulnerabilities",
          "Categorize issues by severity (critical/high/medium/low)",
          "Generate fixes with priority and implementation steps",
          "Create security test suite"
        ],
        "timeout": 45
      },
      "documentation": {
        "name": "Documentation Generation Pipeline",
        "prompts": [
          "Analyze code structure and identify undocumented areas",
          "Generate API documentation with examples",
          "Create usage guides and tutorials",
          "Build architecture diagrams and flow charts"
        ]
      }
    }
  }
}
```

### Execute Custom Pipeline

```bash
claude-flow stream-chain pipeline security
claude-flow stream-chain pipeline documentation
```

---

## Advanced Use Cases

### Multi-Agent Coordination

Chain different agent types for complex workflows:

```bash
claude-flow stream-chain run \
  "Research best practices for API design" \
  "Design REST API with discovered patterns" \
  "Implement API endpoints with validation" \
  "Generate OpenAPI specification" \
  "Create integration tests" \
  "Write deployment documentation"
```

### Data Transformation Pipeline

Process and transform data through multiple stages:

```bash
claude-flow stream-chain run \
  "Extract user data from CSV files" \
  "Normalize and validate data format" \
  "Enrich data with external API calls" \
  "Generate analytics report" \
  "Create visualization code"
```

### Code Migration Workflow

Systematic code migration with validation:

```bash
claude-flow stream-chain run \
  "Analyze legacy codebase dependencies" \
  "Create migration plan with risk assessment" \
  "Generate modernized code for high-priority modules" \
  "Create migration tests" \
  "Document migration steps and rollback procedures"
```

### Quality Assurance Chain

Comprehensive code quality workflow:

```bash
claude-flow stream-chain pipeline analysis
claude-flow stream-chain pipeline refactor
claude-flow stream-chain pipeline test
claude-flow stream-chain pipeline optimize
```

---

## Best Practices

### 1. Clear and Specific Prompts

**Good:**
```bash
"Analyze authentication.js for SQL injection vulnerabilities"
```

**Avoid:**
```bash
"Check security"
```

### 2. Logical Progression

Order prompts to build on previous outputs:
```bash
1. "Identify the problem"
2. "Analyze root causes"
3. "Design solution"
4. "Implement solution"
5. "Verify implementation"
```

### 3. Appropriate Timeouts

- Simple tasks: 30 seconds (default)
- Analysis tasks: 45-60 seconds
- Implementation tasks: 60-90 seconds
- Complex workflows: 90-120 seconds

### 4. Verification Steps

Include validation in your chains:
```bash
claude-flow stream-chain run \
  "Implement feature X" \
  "Write tests for feature X" \
  "Verify tests pass and cover edge cases"
```

### 5. Iterative Refinement

Use chains for iterative improvement:
```bash
claude-flow stream-chain run \
  "Generate initial implementation" \
  "Review and identify issues" \
  "Refine based on issues found" \
  "Final quality check"
```

---

## Integration with Claude Flow

### Combine with Swarm Coordination

```bash
# Initialize swarm for coordination
claude-flow swarm init --topology mesh

# Execute stream chain with swarm agents
claude-flow stream-chain run \
  "Agent 1: Research task" \
  "Agent 2: Implement solution" \
  "Agent 3: Test implementation" \
  "Agent 4: Review and refine"
```

### Memory Integration

Stream chains automatically store context in memory for cross-session persistence:

```bash
# Execute chain with memory
claude-flow stream-chain run \
  "Analyze requirements" \
  "Design architecture" \
  --verbose

# Results stored in .claude-flow/memory/stream-chain/
```

### Neural Pattern Training

Successful chains train neural patterns for improved performance:

```bash
# Enable neural training
claude-flow stream-chain pipeline optimize --debug

# Patterns learned and stored for future optimizations
```

---

## Troubleshooting

### Chain Timeout

If steps timeout, increase timeout value:

```bash
claude-flow stream-chain run "complex task" --timeout 120
```

### Context Loss

If context not flowing properly, use `--debug`:

```bash
claude-flow stream-chain run "step 1" "step 2" --debug
```

### Pipeline Not Found

Verify pipeline name and custom definitions:

```bash
# Check available pipelines
cat .claude-flow/config.json | grep -A 10 "streamChain"
```

---

## Performance Characteristics

- **Throughput**: 2-5 steps per minute (varies by complexity)
- **Context Size**: Up to 100K tokens per step
- **Memory Usage**: ~50MB per active chain
- **Concurrency**: Supports parallel chain execution

---

## Related Skills

- **SPARC Methodology**: Systematic development workflow
- **Swarm Coordination**: Multi-agent orchestration
- **Memory Management**: Persistent context storage
- **Neural Patterns**: Adaptive learning

---

## Examples Repository

### Complete Development Workflow

```bash
# Full feature development chain
claude-flow stream-chain run \
  "Analyze requirements for user profile feature" \
  "Design database schema and API endpoints" \
  "Implement backend with validation" \
  "Create frontend components" \
  "Write comprehensive tests" \
  "Generate API documentation" \
  --timeout 60 \
  --verbose
```

### Code Review Pipeline

```bash
# Automated code review workflow
claude-flow stream-chain run \
  "Analyze recent git changes" \
  "Identify code quality issues" \
  "Check for security vulnerabilities" \
  "Verify test coverage" \
  "Generate code review report with recommendations"
```

### Migration Assistant

```bash
# Framework migration helper
claude-flow stream-chain run \
  "Analyze current Vue 2 codebase" \
  "Identify Vue 3 breaking changes" \
  "Create migration checklist" \
  "Generate migration scripts" \
  "Provide updated code examples"
```

---

## Common Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Circular Dependencies** | Step 3 depends on Step 5's output, creating deadlock. Chain execution requires strict DAG (directed acyclic graph). | Design chains as unidirectional flows. If bidirectional refinement needed, use multiple chains or explicit iteration loops with termination conditions. |
| **Context Explosion** | Each step adds 50KB+ of output, causing later steps to hit token limits and lose early context. | Use summarization steps between major phases. Compress verbose outputs into key findings before passing to next step. Consider splitting into multiple chains with cross-chain memory storage. |
| **Premature Parallelization** | Converting sequential chain into parallel execution loses the context flow that makes chains valuable. | If tasks are truly independent, use swarm coordination instead. Chains are for dependent tasks where output N feeds input N+1. Parallelization destroys this dependency graph. |

## Conclusion

Stream-Chain enables sophisticated multi-step workflows by:

- **Sequential Processing**: Each step builds on previous results
- **Context Preservation**: Full output history flows through chain
- **Flexible Orchestration**: Custom chains or predefined pipelines
- **Agent Coordination**: Natural multi-agent collaboration pattern
- **Data Transformation**: Complex processing through simple steps

Use `run` for custom workflows and `pipeline` for battle-tested solutions.
---

## Core Principles

### 1. Context Continuity
Every step receives the complete output from all previous steps, creating an unbroken chain of context. This eliminates information loss and enables each agent to build upon prior work without requiring external state management. The chain itself is the state.

### 2. Progressive Refinement
Tasks flow from broad to specific - research leads to design, design leads to implementation, implementation leads to validation. Each step narrows scope and increases precision. This natural progression prevents premature optimization and ensures decisions are informed by prior analysis.

### 3. Agent Specialization Through Sequencing
Rather than creating generalist agents, stream chains leverage specialist agents in sequence. A researcher finds information, an architect designs solutions, a coder implements, a tester validates. Sequential execution turns specialist outputs into integrated solutions without requiring any single agent to master all domains.

---

## Anti-Patterns

| Anti-Pattern | Why It Fails | Correct Approach |
|-------------|--------------|------------------|
| **Circular Dependencies** | Step 3 depends on Step 5's output, creating deadlock. Chain execution requires strict DAG (directed acyclic graph). | Design chains as unidirectional flows. If bidirectional refinement needed, use multiple chains or explicit iteration loops with termination conditions. |
| **Context Explosion** | Each step adds 50KB+ of output, causing later steps to hit token limits and lose early context. | Use summarization steps between major phases. Compress verbose outputs into key findings before passing to next step. Consider splitting into multiple chains with cross-chain memory storage. |
| **Premature Parallelization** | Converting sequential chain into parallel execution loses the context flow that makes chains valuable. | If tasks are truly independent, use swarm coordination instead. Chains are for dependent tasks where output N feeds input N+1. Parallelization destroys this dependency graph. |

---

## Enhanced Conclusion

Stream-Chain solves the fundamental challenge of multi-step reasoning: maintaining context across transformations. Traditional approaches either lose context (separate agents) or overwhelm context (single agent with all tasks). Stream chains provide a middle path - sequential execution with cumulative context, where each step builds on validated prior work.

The chain architecture naturally enforces best practices: verification before progression, specialization over generalization, and incremental refinement over big-bang delivery. When tasks have natural dependencies and each step produces context valuable to subsequent steps, stream chains transform sequential constraints from limitations into architectural advantages.

Use `run` for custom workflows requiring flexible step definitions. Use `pipeline` for battle-tested domain-specific workflows (analysis, refactoring, testing, optimization). Choose chains when task output quality depends on understanding prior results - when "what came before" matters as much as "what to do next."
