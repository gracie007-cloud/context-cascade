---
name: skill-builder
description: Create new Claude Code Skills with proper YAML frontmatter, progressive disclosure structure, and complete directory organization. Use when you need to build custom skills for specific workflows, generate skill templates, or understand the Claude Skills specification.
allowed-tools: Read, Write, Edit, Task, TodoWrite, Glob, Grep
---

## Phase 0: Expertise Loading


# Skill Builder

## What This Skill Does

Creates production-ready Claude Code Skills with proper YAML frontmatter, progressive disclosure architecture, and complete file/folder structure. This skill guides you through building skills that Claude can autonomously discover and use across all surfaces (Claude.ai, Claude Code, SDK, API).

## Prerequisites

- Claude Code 2.0+ or Claude.ai with Skills support
- Basic understanding of Markdown and YAML
- Text editor or IDE

## Quick Start

### Creating Your First Skill

```bash
# 1. Create skill directory (MUST be at top level, NOT in subdirectories!)
mkdir -p ~/.claude/skills/my-first-skill

# 2. Create SKILL.md with proper format
cat > ~/.claude/skills/my-first-skill/SKILL.md << 'EOF'
---
name: "My First Skill"
description: "Brief description of what this skill does and when Claude should use it. Maximum 1024 characters."
---

# My First Skill

## What This Skill Does
[Your instructions here]

## Quick Start
[Basic usage]
EOF

# 3. Verify skill is detected
# Restart Claude Code or refresh Claude.ai
```

---

## Complete Specification

### 📋 YAML Frontmatter (REQUIRED)

Every SKILL.md **must** start with YAML frontmatter containing exactly two required fields:

```yaml
---
name: "Skill Name"                    # REQUIRED: Max 64 chars
description: "What this skill does    # REQUIRED: Max 1024 chars
and when Claude should use it."       # Include BOTH what & when
---
```

#### Field Requirements

**`name`** (REQUIRED):
- **Type**: String
- **Max Length**: 64 characters
- **Format**: Human-friendly display name
- **Usage**: Shown in skill lists, UI, and loaded into Claude's system prompt
- **Best Practice**: Use Title Case, be concise and descriptive
- **Examples**:
  - ✅ "API Documentation Generator"
  - ✅ "React Component Builder"
  - ✅ "Database Schema Designer"
  - ❌ "skill-1" (not descriptive)
  - ❌ "This is a very long skill name that exceeds sixty-four characters" (too long)

**`description`** (REQUIRED):
- **Type**: String
- **Max Length**: 1024 characters
- **Format**: Plain text or minimal markdown
- **Content**: MUST include:
  1. **What** the skill does (functionality)
  2. **When** Claude should invoke it (trigger conditions)
- **Usage**: Loaded into Claude's system prompt for autonomous matching
- **Best Practice**: Front-load key trigger words, be specific about use cases
- **Examples**:
  - ✅ "Generate OpenAPI 3.0 documentation from Express.js routes. Use when creating API docs, documenting endpoints, or building API specifications."
  - ✅ "Create React functional components with TypeScript, hooks, and tests. Use when scaffolding new components or converting class components."
  - ❌ "A comprehensive guide to API documentation" (no "when" clause)
  - ❌ "Documentation tool" (too vague)

#### YAML Formatting Rules

```yaml
---
# ✅ CORRECT: Simple string
name: "API Builder"
description: "Creates REST APIs with Express and TypeScript."

# ✅ CORRECT: Multi-line description
name: "Full-Stack Generator"
description: "Generates full-stack applications with React frontend and Node.js backend. Use when starting new projects or scaffolding applications."

# ✅ CORRECT: Special characters quoted
name: "JSON:API Builder"
description: "Creates JSON:API compliant endpoints: pagination, filtering, relationships."

# ❌ WRONG: Missing quotes with special chars
name: API:Builder  # YAML parse error!

# ❌ WRONG: Extra fields (ignored but discouraged)
name: "My Skill"
description: "My description"
version: "1.0.0"       # NOT part of spec
author: "Me"           # NOT part of spec
tags: ["dev", "api"]   # NOT part of spec
---
```

**Critical**: Only `name` and `description` are used by Claude. Additional fields are ignored.

---

### 📂 Directory Structure

#### Minimal Skill (Required)
```
~/.claude/skills/                    # Personal skills location
└── my-skill/                        # Skill directory (MUST be at top level!)
    └── SKILL.md                     # REQUIRED: Main skill file
```

**IMPORTANT**: Skills MUST be directly under `~/.claude/skills/[skill-name]/`.
Claude Code does NOT support nested subdirectories or namespaces!

#### Full-Featured Skill (Recommended)
```
~/.claude/skills/
└── my-skill/                        # Top-level skill directory
        ├── SKILL.md                 # REQUIRED: Main skill file
        ├── README.md                # Optional: Human-readable docs
        ├── scripts/                 # Optional: Executable scripts
        │   ├── setup.sh
        │   ├── validate.js
        │   └── deploy.py
        ├── resources/               # Optional: Supporting files
        │   ├── templates/
        │   │   ├── api-template.js
        │   │   └── component.tsx
        │   ├── examples/
        │   │   └── sample-output.json
        │   └── schemas/
        │       └── config-schema.json
        └── docs/                    # Optional: Additional documentation
            ├── ADVANCED.md
            ├── TROUBLESHOOTING.md
            └── API_REFERENCE.md
```

#### Skills Locations

**Personal Skills** (available across all projects):
```
~/.claude/skills/
└── [your-skills]/
```
- **Path**: `~/.claude/skills/` or `$HOME/.claude/skills/`
- **Scope**: Available in all projects for this user
- **Version Control**: NOT committed to git (outside repo)
- **Use Case**: Personal productivity tools, custom workflows

**Project Skills** (team-shared, version controlled):
```
<project-root>/.claude/skills/
└── [team-skills]/
```
- **Path**: `.claude/skills/` in project root
- **Scope**: Available only in this project
- **Version Control**: SHOULD be committed to git
- **Use Case**: Team workflows, project-specific tools, shared knowledge

---

### 🎯 Progressive Disclosure Architecture

Claude Code uses a **3-level progressive disclosure system** to scale to 100+ skills without context penalty:

#### Level 1: Metadata (Name + Description)
**Loaded**: At Claude Code startup, always
**Size**: ~200 chars per skill
**Purpose**: Enable autonomous skill matching
**Context**: Loaded into system prompt for ALL skills

```yaml
---
name: "API Builder"                   # 11 chars
description: "Creates REST APIs..."   # ~50 chars
---
# Total: ~61 chars per skill
# 100 skills = ~6KB context (minimal!)
```

#### Level 2: SKILL.md Body
**Loaded**: When skill is triggered/matched
**Size**: ~1-10KB typically
**Purpose**: Main instructions and procedures
**Context**: Only loaded for ACTIVE skills

```markdown
# API Builder

## What This Skill Does
[Main instructions - loaded only when skill is active]

## Quick Start
[Basic procedures]

## Step-by-Step Guide
[Detailed instructions]
```

#### Level 3+: Referenced Files
**Loaded**: On-demand as Claude navigates
**Size**: Variable (KB to MB)
**Purpose**: Deep reference, examples, schemas
**Context**: Loaded only when Claude accesses specific files

```markdown
# In SKILL.md
See [Advanced Configuration](docs/ADVANCED.md) for complex scenarios.
See [API Reference](docs/API_REFERENCE.md) for complete documentation.
Use template: `resources/templates/api-template.js`

# Claude will load these files ONLY if needed
```

**Benefit**: Install 100+ skills with ~6KB context. Only active skill content (1-10KB) enters context.

---

### 📝 SKILL.md Content Structure

#### Recommended 4-Level Structure

```markdown
---
name: "Your Skill Name"
description: "What it does and when to use it"
---

# Your Skill Name

## Level 1: Overview (Always Read First)
Brief 2-3 sentence description of the skill.

## Prerequisites
- Requirement 1
- Requirement 2

## What This Skill Does
1. Primary function
2. Secondary function
3. Key benefit

---

## Level 2: Quick Start (For Fast Onboarding)

### Basic Usage
```bash
# Simplest use case
command --option value
```

### Common Scenarios
1. **Scenario 1**: How to...
2. **Scenario 2**: How to...

---

## Level 3: Detailed Instructions (For Deep Work)

### Step-by-Step Guide

#### Step 1: Initial Setup
```bash
# Commands
```
Expected output:
```
Success message
```

#### Step 2: Configuration
- Configuration option 1
- Configuration option 2

#### Step 3: Execution
- Run the main command
- Verify results

### Advanced Options

#### Option 1: Custom Configuration
```bash
# Advanced usage
```

#### Option 2: Integration
```bash
# Integration steps
```

---

## Level 4: Reference (Rarely Needed)

### Troubleshooting

#### Issue: Common Problem
**Symptoms**: What you see
**Cause**: Why it happens
**Solution**: How to fix
```bash
# Fix command
```

#### Issue: Another Problem
**Solution**: Steps to resolve

### Complete API Reference
See [API_REFERENCE.md](docs/API_REFERENCE.md)

### Examples
See [examples/](resources/examples/)

### Related Skills
- [Related Skill 1](#)
- [Related Skill 2](#)

### Resources
- [External Link 1](https://example.com)
- [Documentation](https://docs.example.com)
```

---

### 🎨 Content Best Practices

#### Writing Effective Descriptions

**Front-Load Keywords**:
```yaml
# ✅ GOOD: Keywords first
description: "Generate TypeScript interfaces from JSON schema. Use when converting schemas, creating types, or building API clients."

# ❌ BAD: Keywords buried
description: "This skill helps developers who need to work with JSON schemas by providing a way to generate TypeScript interfaces."
```

**Include Trigger Conditions**:
```yaml
# ✅ GOOD: Clear "when" clause
description: "Debug React performance issues using Chrome DevTools. Use when components re-render unnecessarily, investigating slow updates, or optimizing bundle size."

# ❌ BAD: No trigger conditions
description: "Helps with React performance debugging."
```

**Be Specific**:
```yaml
# ✅ GOOD: Specific technologies
description: "Create Express.js REST endpoints with Joi validation, Swagger docs, and Jest tests. Use when building new APIs or adding endpoints."

# ❌ BAD: Too generic
description: "Build API endpoints with proper validation and testing."
```

#### Progressive Disclosure Writing

**Keep Level 1 Brief** (Overview):
```markdown
## What This Skill Does
Creates production-ready React components with TypeScript, hooks, and tests in 3 steps.
```

**Level 2 for Common Paths** (Quick Start):
```markdown
## Quick Start
```bash
# Most common use case (80% of users)
generate-component MyComponent
```
```

**Level 3 for Details** (Step-by-Step):
```markdown
## Step-by-Step Guide

### Creating a Basic Component
1. Run generator
2. Choose template
3. Customize options
[Detailed explanations]
```

**Level 4 for Edge Cases** (Reference):
```markdown
## Advanced Configuration
For complex scenarios like HOCs, render props, or custom hooks, see [ADVANCED.md](docs/ADVANCED.md).
```

---

### 🛠️ Adding Scripts and Resources

#### Scripts Directory

**Purpose**: Executable scripts that Claude can run
**Location**: `scripts/` in skill directory
**Usage**: Referenced from SKILL.md

Example:
```bash
# In skill directory
scripts/
├── setup.sh          # Initialization script
├── validate.js       # Validation logic
├── generate.py       # Code generation
└── deploy.sh         # Deployment script
```

Reference from SKILL.md:
```markdown
## Setup
Run the setup script:
```bash
./scripts/setup.sh
```

## Validation
Validate your configuration:
```bash
node scripts/validate.js config.json
```
```

#### Resources Directory

**Purpose**: Templates, examples, schemas, static files
**Location**: `resources/` in skill directory
**Usage**: Referenced or copied by scripts

Example:
```bash
resources/
├── templates/
│   ├── component.tsx.template
│   ├── test.spec.ts.template
│   └── story.stories.tsx.template
├── examples/
│   ├── basic-example/
│   ├── advanced-example/
│   └── integration-example/
└── schemas/
    ├── config.schema.json
    └── output.schema.json
```

Reference from SKILL.md:
```markdown
## Templates
Use the component template:
```bash
cp resources/templates/component.tsx.template src/components/MyComponent.tsx
```

## Examples
See working examples in `resources/examples/`:
- `basic-example/` - Simple component
- `advanced-example/` - With hooks and context
```

---

### 🔗 File References and Navigation

Claude can navigate to referenced files automatically. Use these patterns:

#### Markdown Links
```markdown
See [Advanced Configuration](docs/ADVANCED.md) for complex scenarios.
See [Troubleshooting Guide](docs/TROUBLESHOOTING.md) if you encounter errors.
```

#### Relative File Paths
```markdown
Use the template located at `resources/templates/api-template.js`
See examples in `resources/examples/basic-usage/`
```

#### Inline File Content
```markdown
## Example Configuration
See `resources/examples/config.json`:
```json
{
  "option": "value"
}
```
```

**Best Practice**: Keep SKILL.md lean (~2-5KB). Move lengthy content to separate files and reference them. Claude will load only what's needed.

---

### ✅ Validation Checklist

Before publishing a skill, verify:

**YAML Frontmatter**:
- [ ] Starts with `---`
- [ ] Contains `name` field (max 64 chars)
- [ ] Contains `description` field (max 1024 chars)
- [ ] Description includes "what" and "when"
- [ ] Ends with `---`
- [ ] No YAML syntax errors

**File Structure**:
- [ ] SKILL.md exists in skill directory
- [ ] Directory is DIRECTLY in `~/.claude/skills/[skill-name]/` or `.claude/skills/[skill-name]/`
- [ ] Uses clear, descriptive directory name
- [ ] **NO nested subdirectories** (Claude Code requires top-level structure)

**Content Quality**:
- [ ] Level 1 (Overview) is brief and clear
- [ ] Level 2 (Quick Start) shows common use case
- [ ] Level 3 (Details) provides step-by-step guide
- [ ] Level 4 (Reference) links to advanced content
- [ ] Examples are concrete and runnable
- [ ] Troubleshooting section addresses common issues

**Progressive Disclosure**:
- [ ] Core instructions in SKILL.md (~2-5KB)
- [ ] Advanced content in separate docs/
- [ ] Large resources in resources/ directory
- [ ] Clear navigation between levels

**Testing**:
- [ ] Skill appears in Claude's skill list
- [ ] Description triggers on relevant queries
- [ ] Instructions are clear and actionable
- [ ] Scripts execute successfully (if included)
- [ ] Examples work as documented

---

## Skill Builder Templates

### Template 1: Basic Skill (Minimal)

```markdown
---
name: "My Basic Skill"
description: "One sentence what. One sentence when to use."
---

# My Basic Skill

## What This Skill Does
[2-3 sentences describing functionality]

## Quick Start
```bash
# Single command to get started
```

## Step-by-Step Guide

### Step 1: Setup
[Instructions]

### Step 2: Usage
[Instructions]

### Step 3: Verify
[Instructions]

## Troubleshooting
- **Issue**: Problem description
  - **Solution**: Fix description
```

### Template 2: Intermediate Skill (With Scripts)

```markdown
---
name: "My Intermediate Skill"
description: "Detailed what with key features. When to use with specific triggers: scaffolding, generating, building."
---

# My Intermediate Skill

## Prerequisites
- Requirement 1
- Requirement 2

## What This Skill Does
1. Primary function
2. Secondary function
3. Integration capability

## Quick Start
```bash
./scripts/setup.sh
./scripts/generate.sh my-project
```

## Configuration
Edit `config.json`:
```json
{
  "option1": "value1",
  "option2": "value2"
}
```

## Step-by-Step Guide

### Basic Usage
[Steps for 80% use case]

### Advanced Usage
[Steps for complex scenarios]

## Available Scripts
- `scripts/setup.sh` - Initial setup
- `scripts/generate.sh` - Code generation
- `scripts/validate.sh` - Validation

## Resources
- Templates: `resources/templates/`
- Examples: `resources/examples/`

## Troubleshooting
[Common issues and solutions]
```

### Template 3: Advanced Skill (Full-Featured)

```markdown
---
name: "My Advanced Skill"
description: "Comprehensive what with all features and integrations. Use when [trigger 1], [trigger 2], or [trigger 3]. Supports [technology stack]."
---

# My Advanced Skill

## Overview
[Brief 2-3 sentence description]

## Prerequisites
- Technology 1 (version X+)
- Technology 2 (version Y+)
- API keys or credentials

## What This Skill Does
1. **Core Feature**: Description
2. **Integration**: Description
3. **Automation**: Description

---

## Quick Start (60 seconds)

### Installation
```bash
./scripts/install.sh
```

### First Use
```bash
./scripts/quickstart.sh
```

Expected output:
```
✓ Setup complete
✓ Configuration validated
→ Ready to use
```

---

## Configuration

### Basic Configuration
Edit `config.json`:
```json
{
  "mode": "production",
  "features": ["feature1", "feature2"]
}
```

### Advanced Configuration
See [Configuration Guide](docs/CONFIGURATION.md)

---

## Step-by-Step Guide

### 1. Initial Setup
[Detailed steps]

### 2. Core Workflow
[Main procedures]

### 3. Integration
[Integration steps]

---

## Advanced Features

### Feature 1: Custom Templates
```bash
./scripts/generate.sh --template custom
```

### Feature 2: Batch Processing
```bash
./scripts/batch.sh --input data.json
```

### Feature 3: CI/CD Integration
See [CI/CD Guide](docs/CICD.md)

---

## Scripts Reference

| Script | Purpose | Usage |
|--------|---------|-------|
| `install.sh` | Install dependencies | `./scripts/install.sh` |
| `generate.sh` | Generate code | `./scripts/generate.sh [name]` |
| `validate.sh` | Validate output | `./scripts/validate.sh` |
| `deploy.sh` | Deploy to environment | `./scripts/deploy.sh [env]` |

---

## Resources

### Templates
- `resources/templates/basic.template` - Basic template
- `resources/templates/advanced.template` - Advanced template

### Examples
- `resources/examples/basic/` - Simple example
- `resources/examples/advanced/` - Complex example
- `resources/examples/integration/` - Integration example

### Schemas
- `resources/schemas/config.schema.json` - Configuration schema
- `resources/schemas/output.schema.json` - Output validation

---

## Troubleshooting

### Issue: Installation Failed
**Symptoms**: Error during `install.sh`
**Cause**: Missing dependencies
**Solution**:
```bash
# Install prerequisites
npm install -g required-package
./scripts/install.sh --force
```

### Issue: Validation Errors
**Symptoms**: Validation script fails
**Solution**: See [Troubleshooting Guide](docs/TROUBLESHOOTING.md)

---

## API Reference
Complete API documentation: [API_REFERENCE.md](docs/API_REFERENCE.md)

## Related Skills
- [Related Skill 1](../related-skill-1/)
- [Related Skill 2](../related-skill-2/)

## Resources
- [Official Documentation](https://example.com/docs)
- [GitHub Repository](https://github.com/example/repo)
- [Community Forum](https://forum.example.com)

---

**Created**: 2025-10-19
**Category**: Advanced
**Difficulty**: Intermediate
**Estimated Time**: 15-30 minutes
```

---

## Examples from the Wild

### Example 1: Simple Documentation Skill

```markdown
---
name: "README Generator"
description: "Generate comprehensive README.md files for GitHub repositories. Use when starting new projects, documenting code, or improving existing READMEs."
---

# README Generator

## What This Skill Does
Creates well-structured README.md files with badges, installation, usage, and contribution sections.

## Quick Start
```bash
# Answer a few questions
./scripts/generate-readme.sh

# README.md created with:
# - Project title and description
# - Installation instructions
# - Usage examples
# - Contribution guidelines
```

## Customization
Edit sections in `resources/templates/sections/` before generating.
```

### Example 2: Code Generation Skill

```markdown
---
name: "React Component Generator"
description: "Generate React functional components with TypeScript, hooks, tests, and Storybook stories. Use when creating new components, scaffolding UI, or following component architecture patterns."
---

# React Component Generator

## Prerequisites
- Node.js 18+
- React 18+
- TypeScript 5+

## Quick Start
```bash
./scripts/generate-component.sh MyComponent

# Creates:
# - src/components/MyComponent/MyComponent.tsx
# - src/components/MyComponent/MyComponent.test.tsx
# - src/components/MyComponent/MyComponent.stories.tsx
# - src/components/MyComponent/index.ts
```

## Step-by-Step Guide

### 1. Run Generator
```bash
./scripts/generate-component.sh ComponentName
```

### 2. Choose Template
- Basic: Simple functional component
- With State: useState hooks
- With Context: useContext integration
- With API: Data fetching component

### 3. Customize
Edit generated files in `src/components/ComponentName/`

## Templates
See `resources/templates/` for available component templates.
```

---

## Learn More

### Official Resources
- [Anthropic Agent Skills Documentation](https://docs.claude.com/en/docs/agents-and-tools/agent-skills)
- [GitHub Skills Repository](https://github.com/anthropics/skills)
- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)

### Community
- [Skills Marketplace](https://github.com/anthropics/skills) - Browse community skills
- [Anthropic Discord](https://discord.gg/anthropic) - Get help from community

### Advanced Topics
- Multi-file skills with complex navigation
- Skills that spawn other skills
- Integration with MCP tools
- Dynamic skill generation

---

**Created**: 2025-10-19
**Version**: 1.0.0
**Maintained By**: agentic-flow team
**License**: MIT

---

## !! SKILL COMPLETION VERIFICATION (MANDATORY) !!

**After invoking this skill, you MUST complete ALL items below before proceeding:**

### Completion Checklist

- [ ] **Agent Spawning**: Did you spawn at least 1 agent via Task()?
- [ ] **Agent Registry Validation**: Is your agent from the registry?
- [ ] **TodoWrite Called**: Did you call TodoWrite with 5+ todos?
- [ ] **Work Delegation**: Did you delegate to agents (not do work yourself)?

### Correct Pattern
```javascript
[Single Message - ALL in parallel]:
  Task("Agent 1", "Task description", "agent-type")
  Task("Agent 2", "Task description", "agent-type")
  TodoWrite({ todos: [5-10 items] })
```

**Remember: Skill() -> Task() -> TodoWrite() - ALWAYS**

## Recursive Improvement Integration (v2.1)

### Eval Harness Integration

benchmark: skill_builder-benchmark-v1
  tests:
    - skill_builder-001: Basic functionality
    - skill_builder-002: Edge case handling
  minimum_scores:
    functionality: 0.85
    safety: 0.90

### Memory Namespace

namespaces:
  - skill-builder/artifacts: Skill artifacts
  - skill-builder/metrics: Performance tracking
  - improvement/audits/skill-builder: Audits

### Uncertainty Handling

confidence_check:
  if confidence >= 0.8: Proceed
  if confidence 0.5-0.8: Present options
  if confidence < 0.5: Ask questions

### Cross-Skill Coordination

Works with: **agent-creator,skill-forge,micro-skill-creator**

---

## !! SKILL COMPLETION VERIFICATION (MANDATORY) !!

- [ ] Agent Spawning: Spawned agent via Task()
- [ ] Agent Registry: Agent from registry
- [ ] TodoWrite: Called with 5+ todos
- [ ] Delegation: Delegated to agents

**Remember: Skill() -> Task() -> TodoWrite() - ALWAYS**

---

## Core Principles

### 1. Progressive Disclosure Architecture
Skills must scale to 100+ without context penalty. Use a 3-level hierarchy: Level 1 (metadata: name + description, ~200 chars) loads at startup for autonomous matching; Level 2 (SKILL.md body, 1-10KB) loads only when skill triggers; Level 3+ (referenced files) loads on-demand as Claude navigates. This enables installing 100+ skills with only ~6KB baseline context, loading full instructions only for active skills.

### 2. Autonomous Discoverability Through Description Design
The description field is loaded into Claude's system prompt and drives autonomous skill matching. Front-load trigger keywords, include both WHAT the skill does and WHEN to use it, and be specific about technologies. Example: "Generate TypeScript interfaces from JSON schema. Use when converting schemas, creating types, or building API clients." Good descriptions enable Claude to select the right skill without human intervention.

### 3. Progressive Complexity with Graceful Degradation
Structure SKILL.md content in 4 levels: Overview (always read first), Quick Start (fast onboarding), Detailed Instructions (deep work), and Reference (rarely needed). Users consume only what they need. Keep core instructions lean (2-5KB) and move advanced content to separate docs. Complex skills should work for both novices (guided flow) and experts (quick reference) without forcing either to wade through irrelevant content.

---

## Anti-Patterns

| Anti-Pattern | Why It Fails | Correct Approach |
|--------------|--------------|------------------|
| **Vague descriptions without trigger conditions** (e.g., "Helps with API development") | Claude cannot autonomously match skills without clear WHEN clauses. Generic descriptions compete with every similar skill, causing match failures. | Include explicit trigger conditions: "Generate OpenAPI 3.0 documentation from Express.js routes. Use when creating API docs, documenting endpoints, or building API specifications." Front-load keywords Claude will search for. |
| **Nested skill directories** (.claude/skills/category/my-skill/) | Claude Code only scans top-level directories under .claude/skills/. Nested structures are invisible to skill detection, causing skills to never load. | Keep all skills directly under .claude/skills/[skill-name]/ with SKILL.md at the root. No subdirectories, no namespaces, no categories. Flat structure is required. |
| **Kitchen sink SKILL.md files** (50KB+ with every detail) | Massive skill files burden context on every invocation, slow Claude's processing, and create cognitive overload. Users cannot find relevant information in walls of text. | Keep SKILL.md under 5KB with core instructions only. Move advanced topics, examples, and reference material to separate docs/ files. Link with markdown references. Claude loads files only when needed. |

---

## Conclusion

The Skill Builder system transforms Claude from a conversational assistant into an extensible platform with domain-specific expertise. By adhering to the progressive disclosure architecture, you enable Claude to autonomously discover, load, and execute specialized workflows without human routing. The key insight is that skills are not documentation - they are executable instructions that guide Claude's behavior in real-time.

Success requires discipline in three areas: crafting descriptions that enable autonomous matching through clear trigger keywords, maintaining flat directory structures for reliable detection, and respecting context budgets through progressive disclosure. The 3-level hierarchy (metadata at startup, body on trigger, references on-demand) enables massive scale - 100+ skills with minimal baseline cost. Skills that violate these principles create friction: invisible skills that never trigger, context-heavy skills that slow every operation, or poorly-described skills that match incorrectly.

Treat skill creation as a form of meta-programming. You are not writing documentation for humans to read; you are programming Claude's autonomous behavior through structured instructions. Every word in the description field shapes Claude's skill selection. Every section in SKILL.md guides Claude's execution. The investment in thoughtful skill design pays compounding returns as skills accumulate, improving Claude's capabilities across all projects without manual intervention.

## Core Principles

### 1. Progressive Disclosure Scales Context Efficiency
Claude Code loads skill metadata (name + description) for ALL skills at startup but loads full SKILL.md content only when skills are triggered. This 3-level architecture (metadata -> SKILL.md -> referenced files) enables 100+ skills with minimal context penalty (~6KB for metadata vs 1-10KB per active skill). Front-load critical info in metadata, keep SKILL.md lean (2-5KB), and move advanced content to referenced files that load on-demand. Violating this creates context bloat where 10 skills consume 100KB instead of 6KB.

### 2. Description Quality Determines Discovery
The description field is the ONLY mechanism for autonomous skill matching. Claude reads descriptions to decide which skills apply to user requests. Vague descriptions ("helps with API development") fail to trigger on relevant queries. Specific descriptions with trigger keywords ("Generate OpenAPI 3.0 documentation from Express.js routes. Use when creating API docs, documenting endpoints, or building API specifications") match 4-5x more relevant queries. Front-load keywords, include both WHAT and WHEN clauses, and use technology-specific terms.

### 3. YAML Compliance Is Non-Negotiable
Claude Code's skill parser expects exactly two YAML fields: name (max 64 chars) and description (max 1024 chars). Malformed YAML (missing quotes around special characters, incorrect indentation, extra fields) causes silent parsing failures where skills appear missing. Additional fields like version, author, tags are ignored but clutter the frontmatter. Stick to the spec: name, description, nothing more. Validate with YAML linters before deployment.

---

## Anti-Patterns

| Anti-Pattern | Why It Fails | Correct Approach |
|-------------|--------------|------------------|
| **Nested Subdirectories** | Creating skills at paths like ~/.claude/skills/category/subcategory/my-skill/. Claude Code requires top-level structure (skills MUST be directly under ~/.claude/skills/[skill-name]/). Nested skills are silently ignored and never loaded. | Always create skills at top level: ~/.claude/skills/my-skill/SKILL.md. No subdirectories or namespaces. If you need organization, use naming conventions (api-docs-generator, api-testing-framework) not folder hierarchies. |
| **Bloated SKILL.md Files** | Embedding 50KB of examples, schemas, and references directly in SKILL.md. Loads entire content into context when skill triggers, consuming 10-50KB context per skill vs 2-5KB for lean skills. Multiplied across active skills, bloats context by 5-10x. | Keep SKILL.md lean (2-5KB): overview, quick start, step-by-step guide. Move advanced content to docs/ (linked via markdown), large resources to resources/ (referenced by path), schemas to resources/schemas/ (loaded on-demand). Claude navigates to files only when needed. |
| **Generic Descriptions** | Writing descriptions without trigger keywords or "when" clauses. "A tool for API development" matches poorly vs specific queries. Reduces autonomous discovery by 70%+, requiring users to manually invoke skills Claude should have auto-selected. | Front-load keywords: "Generate OpenAPI 3.0 docs from Express.js routes." Add "when" clause: "Use when creating API docs, documenting endpoints, building API specs." Use technology names (OpenAPI, Express.js) not generic terms (API tool). Test by searching for relevant queries. |

---

## Common Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Vague Descriptions Without Triggers** | Writing generic descriptions like "Helps with API development" without clear WHEN clauses. Claude cannot autonomously match skills without explicit trigger conditions. Skill rarely triggers on relevant queries. | Include explicit trigger conditions in description: "Generate OpenAPI 3.0 docs from Express routes. Use when creating API docs, documenting endpoints, building specs." Front-load keywords Claude searches for. Test description by searching for relevant queries. |
| **Nested Skill Directories** | Creating skills at paths like ~/.claude/skills/category/subcategory/my-skill/. Claude Code requires top-level structure - nested skills are silently ignored and never loaded. | Always create skills directly under ~/.claude/skills/[skill-name]/SKILL.md. No subdirectories or namespaces. If organization needed, use naming conventions (api-docs-generator, api-testing-framework) not folder hierarchies. Flat structure is non-negotiable. |
| **Bloated SKILL.md Files** | Embedding 50KB of examples, schemas, references directly in SKILL.md. Entire content loads into context when skill triggers, consuming 10-50KB per skill vs 2-5KB for lean skills. Multiplied across active skills, bloats context 5-10x. | Keep SKILL.md lean (2-5KB): overview, quick start, step-by-step guide. Move advanced content to docs/ (linked markdown), resources to resources/ (referenced by path), schemas to resources/schemas/ (loaded on-demand). Claude navigates files only when needed. |

---

## Conclusion

Skill Builder transforms the process of creating Claude Code skills from guesswork into systematic engineering. By codifying the official specification (YAML frontmatter, progressive disclosure, directory structure) and best practices (keyword-rich descriptions, lean SKILL.md, on-demand file loading), this skill ensures every created skill meets production standards for discovery, context efficiency, and usability.

The progressive disclosure architecture is the key innovation that enables Claude Code to scale to 100+ skills without context collapse. By loading only metadata at startup (6KB for 100 skills), full content on trigger (2-5KB per active skill), and referenced files on-demand (variable), the system maintains low context overhead while providing deep functionality when needed. Violating this architecture through bloated SKILL.md files or nested directories breaks the scaling properties.

Use this skill whenever creating new skills for Claude Code. Follow the 3-level structure religiously: lean metadata for discovery, concise SKILL.md for core instructions, referenced files for advanced content. Optimize descriptions for autonomous matching by front-loading keywords and including explicit "when" clauses. Validate YAML compliance before deployment. Skills built with this methodology integrate seamlessly into the Claude Code ecosystem and scale efficiently across 100+ skill libraries.