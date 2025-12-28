---
name: interactive-planner
description: Skill for interactive-planner
allowed-tools: Read, Glob, Grep, WebSearch, WebFetch, Task, TodoWrite
---

name: interactive-planner
description: Use Claude Code's interactive question tool to gather comprehensive requirements
  through structured multi-select questions
tags:
- planning
- requirements
- questions
- scoping
- interactive
version: 1.0.0
category: research
author: ruv
---

# Interactive Planner

## Purpose
Leverage Claude Code's AskUserQuestion tool to systematically gather project requirements through structured, interactive questions with multiple choice and multi-select options.

## Specialist Agent

I am a requirements gathering specialist with expertise in:
- Structured question design for maximum clarity
- Breaking complex projects into scopable decisions
- Multi-dimensional requirement analysis
- Balancing detail with user experience
- Converting vague ideas into concrete specifications

### Methodology (Plan-and-Solve Pattern)

1. **Parse Request**: Understand the high-level goal and domain
2. **Design Question Strategy**: Plan 4-question batches for comprehensive coverage
3. **Generate Questions**: Create clear, non-overlapping questions with 2-4 options each
4. **Collect Responses**: Use AskUserQuestion tool for interactive gathering
5. **Synthesize Specification**: Convert answers into actionable requirements

### Question Design Principles

**Effective Questions**:
- ✅ Clear, specific, single-dimensional
- ✅ 2-4 mutually exclusive options (unless multiSelect)
- ✅ Each option has helpful description
- ✅ Cover different aspects (no overlap)
- ✅ Short headers (max 12 chars) for UI
- ✅ Enable multiSelect when choices aren't exclusive

**Poor Questions**:
- ❌ Vague or ambiguous wording
- ❌ Too many options (>4)
- ❌ Options overlap in meaning
- ❌ Missing descriptions
- ❌ Multiple concerns in one question

### Question Categories

**Category 1: Core Functionality**
- What is the primary purpose?
- What are the key features?
- What user actions are supported?
- What data is being managed?

**Category 2: Technical Architecture**
- What tech stack/framework?
- What database/storage?
- What authentication method?
- What deployment target?

**Category 3: User Experience**
- Who are the users?
- What's the interaction model?
- What's the visual style?
- What accessibility level?

**Category 4: Quality & Scale**
- What performance requirements?
- What testing coverage?
- What documentation level?
- What scalability needs?

**Category 5: Constraints & Context**
- What existing systems integrate?
- What timeline/deadlines?
- What budget/resource limits?
- What compliance requirements?

### Interactive Planning Workflow

**Phase 1: Initial Exploration (4 questions)**
```
Question 1: Project Type
- Web application
- Mobile application
- API/Backend service
- Library/Package

Question 2: Primary Goal
- New feature
- Refactoring
- Bug fix
- Performance optimization

Question 3: Complexity
- Simple (1-2 files)
- Moderate (3-10 files)
- Complex (10+ files)
- Large-scale (architecture change)

Question 4: Timeline
- Urgent (today)
- This week
- This month
- Flexible
```

**Phase 2: Technical Details (4 questions)**
```
Question 1: Framework
- React/Next.js
- Vue/Nuxt
- Angular
- Vanilla JS/Custom

Question 2: Backend (multiSelect enabled)
- REST API
- GraphQL
- WebSockets
- Database direct

Question 3: Testing (multiSelect enabled)
- Unit tests
- Integration tests
- E2E tests
- None needed

Question 4: Deployment
- Vercel/Netlify
- AWS/GCP/Azure
- Docker/Kubernetes
- Self-hosted
```

**Phase 3: Requirements Refinement (4 questions)**
```
Question 1: Authentication
- OAuth2 (Google, GitHub)
- Email/Password
- Magic links
- None needed

Question 2: Data Storage
- PostgreSQL
- MongoDB
- Firebase
- Local/None

Question 3: Features Needed (multiSelect enabled)
- User management
- Real-time updates
- File uploads
- Search/filtering

Question 4: Quality Level
- Quick prototype
- Production MVP
- Enterprise grade
- Research/experimental
```

### Working with Tool Limitations

**AskUserQuestion Tool Constraints**:
- Maximum 4 questions per call
- 2-4 options per question
- "Other" option automatically added
- Headers limited to 12 characters
- multiSelect available for non-exclusive choices

**Multi-Batch Strategy** (20-30 questions total):
```
Batch 1 (4 questions): High-level project scope
Batch 2 (4 questions): Technical architecture
Batch 3 (4 questions): Feature prioritization
Batch 4 (4 questions): Quality/testing requirements
Batch 5 (4 questions): Integration/deployment
[Continue until comprehensive coverage]
```

**When NOT to Use Interactive Questions**:
- User has already provided detailed spec
- Exploratory/research phase (needs open discussion)
- Single, simple change requested
- Follow-up questions on existing work

**When to Use Open Questions Instead**:
```
For new complex projects:
"Before using interactive questions, let me ask 20-30 clarifying questions
to fully understand your requirements. Please answer each one thoroughly."

[Ask detailed questions in conversation]
[Then summarize into structured specification]
```

### Example Question Sets

**For Landing Page Translation**:
```yaml
questions:
  - question: "Which languages should we support?"
    header: "Languages"
    multiSelect: true
    options:
      - label: "Japanese"
        description: "Full Japanese localization"
      - label: "Spanish"
        description: "Spanish (Spain & Latin America)"
      - label: "French"
        description: "French localization"
      - label: "German"
        description: "German localization"

  - question: "What translation approach should we use?"
    header: "Approach"
    multiSelect: false
    options:
      - label: "i18n library"
        description: "Use react-i18n or next-intl"
      - label: "JSON files"
        description: "Simple key-value JSON files"
      - label: "Database"
        description: "Store translations in database"

  - question: "Which content should be translated?"
    header: "Content"
    multiSelect: true
    options:
      - label: "UI text"
        description: "Buttons, labels, navigation"
      - label: "Marketing"
        description: "Headlines, descriptions, CTAs"
      - label: "Metadata"
        description: "SEO titles, descriptions, og tags"
      - label: "Error messages"
        description: "Validation and error text"

  - question: "How should language be selected?"
    header: "Selection"
    multiSelect: false
    options:
      - label: "Auto-detect"
        description: "Use browser language preference"
      - label: "Dropdown"
        description: "User selects from menu"
      - label: "URL-based"
        description: "/en/, /ja/, etc."
      - label: "Subdomain"
        description: "ja.site.com, en.site.com"
```

**For OAuth Implementation**:
```yaml
questions:
  - question: "Which OAuth providers should we support?"
    header: "Providers"
    multiSelect: true
    options:
      - label: "Google"
        description: "Google OAuth 2.0"
      - label: "GitHub"
        description: "GitHub OAuth"
      - label: "Microsoft"
        description: "Microsoft/Azure AD"
      - label: "Facebook"
        description: "Facebook Login"

  - question: "What OAuth library should we use?"
    header: "Library"
    multiSelect: false
    options:
      - label: "NextAuth.js"
        description: "Full-featured, Next.js optimized"
      - label: "Passport.js"
        description: "Flexible, many strategies"
      - label: "Auth0"
        description: "Managed service"
      - label: "Custom"
        description: "Build from OAuth2 spec"

  - question: "What user data should we request?"
    header: "Scopes"
    multiSelect: true
    options:
      - label: "Basic profile"
        description: "Name, email, avatar"
      - label: "Email verified"
        description: "Verified email address"
      - label: "Extended profile"
        description: "Location, bio, etc."
      - label: "API access"
        description: "Access user's provider data"

  - question: "How should we handle sessions?"
    header: "Sessions"
    multiSelect: false
    options:
      - label: "JWT tokens"
        description: "Stateless JWT tokens"
      - label: "Database sessions"
        description: "Server-side session storage"
      - label: "Cookies"
        description: "Encrypted cookie sessions"
      - label: "Redis"
        description: "Redis-backed sessions"
```

## Input Contract

```yaml
project_description: string
project_type: web | mobile | api | library | cli | other
complexity_estimate: simple | moderate | complex
has_existing_spec: boolean
planning_depth: shallow | normal | deep
```

## Output Contract

```yaml
gathered_requirements:
  project_scope: object
  technical_decisions: object
  feature_list: array[string]
  constraints: array[string]
  quality_requirements: object

specification_document: markdown
question_batches_used: number
confidence_level: high | medium | low
missing_information: array[string] (what still needs clarification)
```

## Integration Points

- **Cascades**: First step in feature development workflows
- **Commands**: `/plan-interactive`, `/scope-project`
- **Other Skills**: Works with web-cli-teleport, sparc-methodology, feature-dev-complete

## Usage Examples

**New Project Planning**:
```
Use interactive-planner to scope out a new e-commerce checkout flow with payment integration
```

**Feature Addition**:
```
I want to add real-time collaboration to my app. Use interactive questions to understand requirements.
```

**Comprehensive Scoping**:
```
Use interactive-planner with deep planning for a complete rewrite of the authentication system.
Ask 20-30 questions across multiple batches to ensure we cover everything.
```

## Best Practices

**Question Design**:
1. Start broad, get specific in later batches
2. Use multiSelect when user might want multiple options
3. Keep options truly distinct (no overlap)
4. Provide helpful context in descriptions
5. Keep headers under 12 characters for UI

**Multi-Batch Planning**:
1. Batch 1: Project type, goal, complexity
2. Batch 2: Tech stack, architecture
3. Batch 3: Core features, priorities
4. Batch 4: Quality, testing, docs
5. Batch 5+: Domain-specific details

**Synthesis**:
1. Summarize all answers clearly
2. Identify conflicts or gaps
3. Ask follow-up questions if needed
4. Create actionable specification
5. Confirm understanding before proceeding

## Failure Modes & Mitigations

- **Too few questions**: Use multiple batches, aim for 20-30 total
- **Questions overlap**: Design orthogonal question dimensions
- **User picks "Other" repeatedly**: Questions too restrictive, use open discussion
- **Vague answers**: Ask for clarification before proceeding
- **Missing critical info**: Always ask about constraints, integrations, timeline

## Validation Checklist

- [ ] Questions cover all critical dimensions
- [ ] No overlapping options within questions
- [ ] Headers are under 12 characters
- [ ] Descriptions provide helpful context
- [ ] multiSelect enabled where appropriate
- [ ] Specification document is complete
- [ ] No critical gaps in requirements
- [ ] User confirmed understanding

## Neural Training Integration

```yaml
training:
  pattern: convergent
  feedback_collection: true
  success_metrics:
    - questions_needed_for_completeness
    - user_satisfaction_with_process
    - specification_clarity
    - downstream_rework_rate
```

---

**Quick Reference**:
- Max 4 questions per batch
- Use multiSelect for non-exclusive choices
- "Other" option always available
- Plan 5-8 batches for complex projects

**Pro Tips**:
- Better to ask more questions upfront than iterate later
- Use in Planning Mode for automatic activation
- Combine with open discussion for best results
- Save complex projects for CLI, simple tasks for Web
## Core Principles

Interactive Planning operates on 3 fundamental principles:

### Principle 1: Question-Driven Requirements Elicitation
Every project begins with structured, multi-dimensional questions that systematically explore scope, architecture, features, quality, and constraints. This prevents assumption-driven planning and ensures user preferences are captured explicitly.

In practice:
- 5-10 multi-select questions covering critical decision points (framework, database, auth, deployment, testing)
- Questions designed to be clear, non-overlapping, with 2-4 mutually exclusive options
- Multi-batch strategy for complex projects (20-30 questions across 5-8 batches)

### Principle 2: Progressive Refinement Through Batches
Requirements gathering proceeds in waves from broad to specific, with each batch building on previous answers. This balances comprehensiveness with user experience, avoiding overwhelming users while ensuring complete coverage.

In practice:
- Batch 1: Project type, goal, complexity (high-level scope)
- Batch 2: Tech stack, architecture (technical foundations)
- Batch 3: Core features, priorities (functionality)
- Batch 4: Quality, testing, documentation (non-functional requirements)
- Batch 5+: Domain-specific details (context-dependent refinement)

### Principle 3: Synthesis Into Actionable Specifications
Gathered answers are transformed into concrete, validated specifications that directly inform downstream planning and execution. This ensures interactive questions produce tangible value rather than surface-level data collection.

In practice:
- Requirements document exports all selections with explanations
- Conflicts and gaps are identified and resolved before proceeding
- User confirmation required before moving to execution phase
- Specifications include explicit technical decisions (no lingering ambiguities)

## Common Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Assumption-Driven Planning** | Proceeding with technical choices (framework, database, cloud provider) without explicit user input leads to misaligned implementations and rework | Use interactive questions to gather ALL critical decisions upfront - NEVER assume user preferences |
| **Question Overload** | Asking >15 questions in a single batch or poorly organized questions overwhelms users and reduces response quality | Limit to 4 questions per batch, use 5-8 batches for complex projects, group related questions into coherent phases |
| **Overlapping Options** | Question options that aren't mutually exclusive or cover the same concept confuse users and produce ambiguous requirements | Design orthogonal question dimensions - each option must be distinct, use multiSelect when choices aren't exclusive |

## Conclusion

Interactive Planner provides a structured framework for gathering comprehensive requirements through multi-select questions that systematically explore all critical project dimensions. By enforcing question-driven elicitation, progressive refinement through batches, and synthesis into actionable specifications, this skill ensures projects begin with clear, validated requirements rather than assumptions.

Use this skill when starting new projects with vague or underspecified requirements, when technical stack decisions need user input, or when planning complex features where preferences are unknown. The multi-batch workflow (4 questions per batch across 5-8 batches) balances thoroughness with user experience, while the guardrails prevent common pitfalls like assumption-driven planning, question overload, and ambiguous options. The result is a complete requirements document with explicit technical decisions ready for downstream planning and execution.

---

## Core Principles

### 1. Structured Multi-Select Questions Eliminate Assumption Debt
Vague requirements lead to assumption-based planning where critical choices (framework, database, auth method) get implicitly decided without user input. This creates assumption debt - hidden decisions that surface as rework when user expectations don't match agent choices. Interactive multi-select questions make technical choices explicit upfront, converting implicit assumptions into validated requirements. Better to spend 5 minutes gathering requirements than hours rebuilding with wrong tech stack.

### 2. Batch Questions by Decision Category for Cognitive Flow
Randomly ordered questions create cognitive whiplash as users jump between unrelated concerns. Group questions into coherent batches: Project Scope (4 questions), Technical Architecture (4 questions), Feature Prioritization (4 questions), Quality Requirements (4 questions). This categorical structure helps users think systematically through decision dimensions without mental context switching, improving response quality and reducing decision fatigue.

### 3. Progressive Refinement from Broad to Specific
Start with high-level questions (project type, primary goal, complexity) that establish context, then progressively refine into technical details (framework, database, deployment). This funnel structure prevents asking technical questions without sufficient context and enables adaptive question paths where later questions depend on earlier answers. Early broad questions guide which specific technical questions are relevant, avoiding irrelevant choices.

---

## Anti-Patterns

| Anti-Pattern | Why It Fails | Correct Approach |
|--------------|--------------|------------------|
| **Asking too few questions (<10 total)** | Insufficient coverage leaves critical decisions unstated. Common gaps: testing strategy, deployment target, authentication method, scalability requirements. Under-specified requirements lead to rework when user reveals missing constraints mid-implementation. | Plan 20-30 questions across 5-7 batches for complex projects. Cover all decision dimensions: functionality, architecture, UX, quality, constraints. Better to gather comprehensive requirements upfront than iterate on wrong assumptions. Use multi-select to capture nuanced choices efficiently. |
| **Non-orthogonal options that overlap** | Options like "REST API" and "Backend Service" aren't mutually exclusive - confusion about which to choose. Overlapping options signal unclear question design and produce ambiguous responses that don't clarify actual intent. | Design questions with distinct, non-overlapping options. Each option should be clearly different from others. Good: "REST API", "GraphQL", "WebSockets", "Database Direct". Bad: "API Service", "Backend API", "RESTful Service" (all mean similar things). Test: can user pick multiple without contradiction? |
| **Overwhelming users with 40+ questions in one batch** | Tool constraint is 4 questions per call, but even 8-10 batches (32-40 questions) causes fatigue. Users rush through later questions, provide low-quality responses, or abandon the process. Diminishing returns after 30 questions. | Cap at 20-30 questions (5-7 batches) for complex projects, 12-16 (3-4 batches) for moderate scope. Prioritize highest-impact questions. For extremely complex projects, split into multi-session gathering or supplement with open discussion. Quality over exhaustive coverage. |

---

## Conclusion

Interactive Planner transforms requirement gathering from unstructured conversation into systematic multi-dimensional scoping through Claude Code's AskUserQuestion tool. This structured approach converts vague project ideas into concrete specifications by making technical choices explicit through strategic multi-select questions organized into coherent decision categories. The skill's value lies in preventing assumption debt - eliminating hidden technical choices that cause rework when user expectations diverge from agent decisions.

The power emerges from three integrated patterns: structured multi-select questions eliminate implicit assumptions by forcing explicit technical choices; categorical batching (scope, architecture, features, quality, constraints) creates cognitive flow that helps users think systematically; and progressive refinement from broad to specific enables adaptive question paths where early answers guide later technical specificity. Together, these patterns enable comprehensive requirement gathering in 20-30 well-designed questions spanning 5-7 batches.

Successful implementation requires balancing thoroughness with user experience. Too few questions leave critical gaps; too many cause fatigue. The sweet spot: 20-30 questions for complex projects, 12-16 for moderate scope, organized into decision categories that minimize context switching. Master question design (clear, specific, non-overlapping options with helpful descriptions), leverage multiSelect for non-exclusive choices, and maintain progressive refinement from project scope to technical details. This systematic approach transforms ambiguous project requests into actionable specifications that align agent implementation with user intent from the start.