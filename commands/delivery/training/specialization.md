# Agent Specialization Training
<!-- META-LOOP v2.1 INTEGRATION -->## Phase 0: Expertise Loadingexpertise_check:  domain: agent-creation  file: .claude/expertise/agent-creation.yaml  fallback: discovery_mode## Recursive Improvement Integration (v2.1)benchmark: specialization-benchmark-v1  tests:    - training_validation    - pattern_verification  success_threshold: 0.9namespace: "commands/delivery/training/specialization/{project}/{timestamp}"uncertainty_threshold: 0.85coordination:  related_skills: [agent-creator, micro-skill-creator]  related_agents: [coder, skill-auditor]## COMMAND COMPLETION VERIFICATIONsuccess_metrics:  execution_success: ">95%"<!-- END META-LOOP -->

## Purpose
Train agents to become experts in specific domains for better performance.

## Specialization Areas

### 1. By File Type
Agents automatically specialize based on file extensions:
- **.js/.ts**: Modern JavaScript patterns
- **.py**: Pythonic idioms
- **.go**: Go best practices
- **.rs**: Rust safety patterns

### 2. By Task Type
```
Tool: mcp__claude-flow__agent_spawn
Parameters: {
  "type": "coder",
  "capabilities": ["react", "typescript", "testing"],
  "name": "React Specialist"
}
```

### 3. Training Process
The system trains through:
- Successful edit operations
- Code review patterns
- Error fix approaches
- Performance optimizations

### 4. Specialization Benefits
```
# Check agent specializations
Tool: mcp__claude-flow__agent_list
Parameters: {"swarmId": "current"}

Result shows expertise levels:
{
  "agents": [
    {
      "id": "coder-123",
      "specializations": {
        "javascript": 0.95,
        "react": 0.88,
        "testing": 0.82
      }
    }
  ]
}
```

## Continuous Improvement
Agents share learnings across sessions for cumulative expertise!

## CLI Usage
```bash
# Train agent specialization via CLI
npx claude-flow train agent --type coder --capabilities "react,typescript"

# Check specializations
npx claude-flow agent list --specializations
```