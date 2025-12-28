---
name: when-gathering-requirements-use-interactive-planner
description: ---
allowed-tools: Read, Glob, Grep, WebSearch, WebFetch, Task, TodoWrite
---

## SKILL-SPECIFIC GUIDANCE

### When to Use This Skill
- Triggering interactive-planner skill when gathering requirements detected
- Auto-invoking structured multi-select questions for architecture decisions
- Ensuring comprehensive requirements collection before planning
- Reducing assumption-based design by collecting explicit user choices
- Specialized tool wrapper for requirements gathering scenarios

### When NOT to Use This Skill
- Requirements already defined (skip to planner)
- Single-choice decisions (not multi-select)
- When interactive-planner already invoked directly
- Follow-up scenarios where context exists

### Success Criteria
- Interactive-planner skill successfully invoked
- User presented with 5-10 multi-select questions
- All critical choices captured before planning proceeds
- Requirements document exported
- Plan reflects user selections accurately

### Edge Cases & Limitations
- User bypasses questions: respect preference, document assumptions made
- Skill invocation fails: fallback to manual requirements gathering
- Too many nested tool calls: simplify to direct interactive-planner invocation
- Contradictory selections: flag for resolution before proceeding
- Missing context: gather minimal required info before invoking

### Critical Guardrails
- NEVER invoke if interactive-planner already active (avoid recursion)
- ALWAYS verify requirements gathering truly needed
- NEVER force questions if user has clear requirements
- ALWAYS respect user preference to skip
- NEVER proceed to planning without confirmation

### Evidence-Based Validation
- Validate invocation appropriateness: is requirements gathering truly needed?
- Cross-check skill availability: is interactive-planner accessible?
- Test user intent: does user want structured questions or prefer freeform?
- Verify context: is this right moment to invoke (not mid-execution)?
- Confirm fallback: if invocation fails, can manual gathering proceed?

---
name: when-gathering-requirements-use-interactive-planner
description: '```yaml'
version: 1.0.0
category: research
tags:
- research
- analysis
- planning
author: ruv
---

# Interactive Requirements Planning SOP

```yaml
metadata:
  skill_name: when-gathering-requirements-use-interactive-planner
  version: 1.0.0
  category: specialized-tools
  difficulty: beginner
  estimated_duration: 15-30 minutes
  trigger_patterns:
    - "gather requirements"
    - "interactive questions"
    - "requirements gathering"
    - "clarify requirements"
  agents:
    - planner
    - researcher
    - system-architect
  success_criteria:
    - Requirements gathered
    - Specifications documented
    - Stakeholder approval
    - Action plan created
```

## Overview

Use Claude Code's AskUserQuestion tool to gather comprehensive requirements through structured multi-select questions.

## Phases

### Phase 1: Discover Needs (3-5 min)
Ask initial questions about project goals and scope using AskUserQuestion tool.

### Phase 2: Clarify Details (5-10 min)
Follow up with detailed technical and timeline questions.

### Phase 3: Structure Requirements (3-5 min)
Organize responses into formal specifications document.

### Phase 4: Validate Completeness (2-5 min)
Review with stakeholders and get approval.

### Phase 5: Document Specifications (2-5 min)
Create final documentation and action plan.

## Best Practices

1. Ask open, clear questions
2. Provide descriptive options
3. Use multi-select for priorities
4. Document all responses
5. Validate with stakeholders
6. Create actionable plans

## Workflow Summary

**Duration:** 15-30 minutes

**Deliverables:**
- Requirements specification
- Technical architecture
- Action plan
- Validation report

---

## Core Principles

### 1. Structured Question Design Over Freeform Discussion
Unstructured requirements gathering leads to incomplete specifications and missed assumptions. Multi-select questions with predefined options ensure comprehensive coverage while maintaining efficiency.

**In practice:**
- Design 5-10 focused multi-select questions covering key decision points (architecture, technology stack, constraints)
- Provide descriptive options that explain trade-offs (e.g., "PostgreSQL - ACID compliance, mature ecosystem" vs "MongoDB - flexible schema, horizontal scaling")
- Group questions logically (first scope, then technical, then non-functional requirements)
- Use AskUserQuestion tool to present all options simultaneously for comparison
- Allow open-ended follow-up for edge cases not covered by predefined options

### 2. Explicit Over Implicit Requirements
Most project failures stem from unspoken assumptions. This skill forces explicit articulation of constraints, priorities, and success criteria through targeted questioning.

**In practice:**
- Ask about non-functional requirements explicitly (performance targets, security compliance, scalability needs)
- Probe for hidden constraints (budget limits, timeline pressures, team skill gaps)
- Require priority ranking when multiple goals conflict (speed vs quality, features vs stability)
- Validate assumptions by presenting them as questions ("Are we assuming cloud deployment?")
- Document all responses in structured format (SPEC.md) for future reference

### 3. Stakeholder Validation Before Planning Proceeds
Gathering requirements is only valuable if stakeholders confirm completeness and accuracy. This skill builds in explicit approval checkpoints.

**In practice:**
- Generate requirements specification document after question gathering
- Present specification back to stakeholders for review ("Is this what you meant?")
- Iterate on clarifications until stakeholders explicitly approve ("Yes, this captures everything")
- Store validated requirements in memory-mcp for project lifecycle tracking
- Block planning phase until validation checkpoint passes

---

## Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Asking too many granular questions (>15) | Causes decision fatigue; stakeholders rush through later questions providing lower-quality answers; creates false sense of thoroughness while missing strategic issues | Limit to 5-10 high-impact questions. Focus on decisions that constrain architecture (cloud vs on-prem, SQL vs NoSQL, sync vs async). Leave implementation details for later planning phases. |
| Using single-select for multi-dimensional requirements | Forces false choices when multiple options are valid simultaneously; misses hybrid approaches that combine strengths of different options | Use multi-select for all questions unless truly mutually exclusive. Ask separate questions for orthogonal concerns (storage tech AND deployment target AND performance requirements). |
| Skipping validation checkpoint | Planner assumes questions captured all requirements; discovers misunderstandings mid-implementation; causes expensive rework when scope changes | ALWAYS generate specification document and get explicit stakeholder approval. Use checklist format for validation ("Requirements complete? Success criteria clear? Constraints documented?"). Store approval timestamp in metadata. |

---

## Conclusion

Interactive requirements planning represents a critical bridge between vague user requests and concrete implementation plans. By systematically extracting decisions through structured multi-select questions, this skill prevents the assumption-driven failures that plague software projects. The 15-30 minute investment in comprehensive questioning saves hours or days of rework caused by missed requirements or misunderstood constraints.

The power of this approach lies in its ability to make implicit knowledge explicit. Users often know what they want but struggle to articulate it completely. Well-designed questions serve as prompts that trigger consideration of aspects the user might not have mentioned initially - security requirements, performance targets, scalability constraints. By presenting options with explanatory descriptions, this skill educates stakeholders about trade-offs while capturing their preferences.

As projects increase in complexity and stakeholder ecosystems expand, the need for systematic requirements gathering intensifies. Interactive planning with structured questions provides a repeatable, efficient mechanism for ensuring all parties align on project goals before significant resources are committed. This skill demonstrates that proper requirements engineering need not be a lengthy, bureaucratic process - when done with focused, well-designed questions, it can be both comprehensive and efficient.