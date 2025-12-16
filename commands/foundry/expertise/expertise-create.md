---
<!-- META-LOOP v2.1 INTEGRATION -->## Phase 0: Expertise Loadingexpertise_check:  domain: agent-creation  file: .claude/expertise/agent-creation.yaml  fallback: discovery_mode## Recursive Improvement Integration (v2.1)benchmark: expertise-create-benchmark-v1  tests:    - command_execution_success    - domain_validation  success_threshold: 0.9namespace: "commands/foundry/expertise/expertise-create/{project}/{timestamp}"uncertainty_threshold: 0.85coordination:  related_skills: [agent-creator, micro-skill-creator]  related_agents: [prompt-auditor, skill-auditor]## COMMAND COMPLETION VERIFICATIONsuccess_metrics:  execution_success: ">95%"<!-- END META-LOOP -->
name: expertise-create
binding: skill:expertise-manager
category: foundry
version: 1.0.0
---

# /expertise-create

Create a new domain expertise file with discovery, pattern extraction, and falsifiable validation rules.

## Usage

```bash
/expertise-create <domain> [options]
```

## Parameters

- `domain` - Domain identifier (required, e.g., "authentication", "database", "payments")
- `--primary-path` - Primary source directory (optional, auto-detected if not provided)
- `--discover-only` - Only discover, don't create file yet
- `--template` - Use minimal template without discovery

## What It Does

**4-Phase Discovery Process**:

1. **Structure Discovery**
   - Scan codebase for domain-related files
   - Identify primary source, test, config directories
   - Map file locations with falsifiable checks

2. **Pattern Extraction**
   - Analyze code for architectural patterns
   - Extract data flow patterns
   - Identify error handling approaches
   - Each pattern gets a falsifiable validation check

3. **Entity Mapping**
   - Discover key classes, functions, types
   - Document their purposes and signatures
   - Create falsifiable checks for each entity

4. **Expertise Generation**
   - Generate `.claude/expertise/{domain}.yaml`
   - Include all falsifiable checks
   - Set up learning objectives
   - Queue for adversarial validation

## Examples

```bash
# Create expertise for authentication domain
/expertise-create authentication

# Create with explicit path
/expertise-create payments --primary-path src/payments/

# Discovery only (preview what would be created)
/expertise-create database --discover-only

# Quick template (fill in manually)
/expertise-create websocket --template
```

## Output

```
Creating expertise for domain: authentication

Phase 1: Structure Discovery
  Found primary: src/auth/
  Found tests: tests/auth/
  Found config: config/auth.json
  Found 23 source files

Phase 2: Pattern Extraction
  Detected: Clean Architecture pattern
  Detected: JWT-based authentication
  Detected: Middleware validation pattern
  Created 5 falsifiable pattern checks

Phase 3: Entity Mapping
  Found 4 classes: AuthService, TokenManager, ...
  Found 12 functions: validateToken, refreshToken, ...
  Found 8 types: AuthUser, TokenPayload, ...
  Created 24 falsifiable entity checks

Phase 4: Expertise Generation
  Created: .claude/expertise/authentication.yaml
  Falsifiability coverage: 92% (23/25 claims)
  Trust level: provisional
  Status: needs_adversarial_validation

Next steps:
  1. Review generated expertise: /expertise-show authentication
  2. Run adversarial validation: /expertise-challenge authentication
  3. Use in tasks: /expertise-load authentication
```

## Schema Compliance

Generated expertise files follow Schema v2.0.0 with:

- **Correctability metadata** - Trust level, detection latency
- **Falsifiable claims** - Every claim has a validation command
- **Learning objectives** - Open questions to investigate
- **Adversarial section** - Ready for validation challenges
- **Routing templates** - Brief templates for task types

## See Also

- `/expertise-validate` - Validate expertise against code
- `/expertise-challenge` - Run adversarial validation
- `/expertise-show` - Display expertise details
- `/expertise-list` - List all expertise files
