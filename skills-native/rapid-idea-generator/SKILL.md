---
name: rapid-idea-generator
description: Skill for rapid-idea-generator
allowed-tools: Read, Glob, Grep, WebSearch, WebFetch, Task, TodoWrite
---

name: rapid-idea-generator
description: Generate research ideas from any topic in under 5 minutes using 5-Whys
  causal analysis, component decomposition, and root cause identification. Features
  transparent reasoning and evidence-based methodology. Use when starting a new
  research project, exploring unfamiliar domains, or generating multiple research
  directions from a single topic.
version: 1.0.0
category: research
tags:
- research
- ideation
- analysis
- planning
- rapid
author: ruv
mcp_servers:
  required: [memory-mcp]
  optional: [sequential-thinking]
  auto_enable: true
---

# Rapid Idea Generator

## Purpose

Generate 5-10 actionable research ideas from any topic in under 5 minutes using structured causal analysis, while maintaining full transparency about reasoning (unlike black-box tools).

## When to Use This Skill

Activate this skill when:
- Starting a new research project and need direction
- Exploring an unfamiliar research domain
- Need multiple research directions from a single topic
- Want to quickly identify research gaps before deep literature review
- Brainstorming for grant proposals or thesis topics
- Need to pivot research direction rapidly

**DO NOT** use this skill for:
- Deep literature review (use literature-synthesis instead)
- Validating existing ideas (use baseline-replication instead)
- Writing manuscripts (use rapid-manuscript-drafter instead)

## Time Investment

- **Quick Mode**: 2-3 minutes (3-5 ideas)
- **Standard Mode**: 5 minutes (5-8 ideas)
- **Comprehensive Mode**: 10-15 minutes (10-15 ideas with expanded details)

## Specialist Agent

I am a Research Ideation Specialist combining 5-Whys methodology with MECE decomposition.

**Methodology (Plan-and-Solve + Self-Consistency)**:
1. Parse topic and identify core domain
2. Conduct Primary Analysis (situational assessment)
3. Perform Component Analysis (MECE decomposition)
4. Apply Causal Analysis (5-Whys for each component)
5. Identify Root Causes and research opportunities
6. Generate ranked ideas with confidence scores
7. Cross-validate ideas for novelty and feasibility

**Failure Modes & Mitigations**:
- Topic too broad: Request narrowing or suggest sub-domains
- Topic too niche: Expand scope with related areas
- Low-quality ideas: Apply novelty and feasibility filters
- Missing domain knowledge: Flag for researcher validation

## Input Contract

```yaml
input:
  topic: string (required)
    # Research topic or area of interest
    # Examples: "machine learning in healthcare", "sustainable energy storage"

  mode: enum[quick, standard, comprehensive] (default: standard)
    # Controls depth and number of ideas

  constraints:
    domain: string (optional)
      # Limit to specific field: "computer science", "biology", etc.
    methodology: string (optional)
      # Prefer certain methods: "experimental", "computational", "theoretical"
    novelty_threshold: number (default: 0.7)
      # 0-1 scale for idea novelty requirement

  output_preferences:
    expand_top_n: number (default: 3)
      # How many ideas to expand with full details
    include_literature_pointers: boolean (default: true)
      # Include suggested search terms for each idea
```

## Output Contract

```yaml
output:
  primary_analysis:
    domain: string
    current_state: string
    main_challenges: array[string]
    key_players: array[string]

  component_analysis:
    components: array[object]
      component: string
      importance: high | medium | low
      research_potential: string

  causal_analysis:
    chains: array[object]
      problem: string
      why_1: string
      why_2: string
      why_3: string
      why_4: string
      why_5: string
      root_cause: string

  ideas:
    ranked_ideas: array[object]
      id: number
      title: string
      description: string (2-3 sentences)
      research_type: experimental | computational | theoretical | mixed
      novelty_score: number (0-1)
      feasibility_score: number (0-1)
      impact_potential: high | medium | low
      suggested_methods: array[string]
      literature_pointers: array[string]

  expanded_ideas:
    ideas: array[object]
      id: number
      title: string
      detailed_description: string (paragraph)
      research_questions: array[string]
      hypotheses: array[string]
      required_resources: array[string]
      potential_challenges: array[string]
      related_work_keywords: array[string]
      estimated_timeline: string

  metadata:
    generation_time: number (seconds)
    mode_used: string
    total_ideas: number
    ideas_above_novelty_threshold: number
```

## SOP Phase 1: Primary Analysis

**Objective**: Understand the research landscape in 60 seconds.

```markdown
## Primary Analysis for [TOPIC]

### Domain Assessment
- **Field**: [Identify primary research field]
- **Sub-fields**: [List 2-3 relevant sub-fields]
- **Maturity**: [emerging | growing | mature | declining]

### Current State of Research
[2-3 sentences on where the field stands today]

### Main Challenges
1. [Challenge 1 - most pressing]
2. [Challenge 2]
3. [Challenge 3]

### Key Research Questions Being Asked
1. [Active question 1]
2. [Active question 2]
```

## SOP Phase 2: Component Analysis (MECE)

**Objective**: Decompose the topic into mutually exclusive, collectively exhaustive components.

```markdown
## Component Analysis

| Component | Importance | Research Potential | Notes |
|-----------|------------|-------------------|-------|
| [Component 1] | High | [Potential] | [Notes] |
| [Component 2] | Medium | [Potential] | [Notes] |
| [Component 3] | Low | [Potential] | [Notes] |

### MECE Validation
- [ ] Components are mutually exclusive (no overlap)
- [ ] Components are collectively exhaustive (cover entire topic)
- [ ] Each component has research potential identified
```

## SOP Phase 3: Causal Analysis (5-Whys)

**Objective**: Trace each major challenge to its root cause.

For each high-importance component, apply 5-Whys:

```markdown
## Causal Chain: [Problem Statement]

**Problem**: [State the problem clearly]

1. **Why 1?** [First-level cause]
2. **Why 2?** [Second-level cause]
3. **Why 3?** [Third-level cause]
4. **Why 4?** [Fourth-level cause]
5. **Why 5?** [Root cause]

**Root Cause Identified**: [Actionable root cause]
**Research Opportunity**: [How addressing this creates research value]
```

## SOP Phase 4: Idea Generation

**Objective**: Generate ranked research ideas from root causes.

```markdown
## Research Ideas

### Idea 1: [Title]
- **Type**: [experimental | computational | theoretical | mixed]
- **Description**: [2-3 sentence description]
- **Novelty**: [0.0-1.0] | **Feasibility**: [0.0-1.0]
- **Impact**: [high | medium | low]
- **Methods**: [Suggested methodologies]
- **Search Terms**: [Keywords for literature search]

### Idea 2: [Title]
...

### Ranking Criteria Applied
- Novelty: Higher = more original contribution
- Feasibility: Higher = more achievable with current resources
- Impact: Based on potential to advance the field
```

## SOP Phase 5: Idea Expansion

**Objective**: Expand top N ideas with full research proposal details.

```markdown
## Expanded Idea: [Title]

### Detailed Description
[Full paragraph describing the research direction]

### Research Questions
1. [Primary research question]
2. [Secondary question]
3. [Tertiary question]

### Hypotheses
- H1: [Primary hypothesis]
- H2: [Alternative hypothesis]

### Required Resources
- [ ] [Resource 1]
- [ ] [Resource 2]
- [ ] [Resource 3]

### Potential Challenges
1. [Challenge 1 and mitigation strategy]
2. [Challenge 2 and mitigation strategy]

### Related Work Keywords
- [Keyword 1]
- [Keyword 2]
- [Keyword 3]

### Estimated Timeline
[Brief timeline: "3-6 months for proof of concept"]
```

## Integration Points

### Feeds Into
- **literature-synthesis**: Use generated keywords for systematic review
- **baseline-replication**: Validate ideas against existing work
- **research-gap-visualizer**: Create visual gap maps from ideas
- **rapid-manuscript-drafter**: Generate manuscript outlines from ideas

### Receives From
- **intent-analyzer**: Clarified research intent
- **interactive-planner**: User preferences for research direction

### Memory Storage

```bash
# Store generated ideas for future reference
npx claude-flow@alpha memory store \
  "research_ideas_[topic]" \
  "[ideas_json]" \
  --namespace "research/ideation"
```

## Example Execution

**Input**: "machine learning for drug discovery"

**Output** (abbreviated):

```yaml
primary_analysis:
  domain: "Computational Biology / Cheminformatics"
  current_state: "ML models increasingly used for virtual screening,
    but struggle with out-of-distribution predictions and interpretability"
  main_challenges:
    - "Limited labeled training data for novel targets"
    - "Poor generalization to unseen chemical scaffolds"
    - "Lack of interpretability for regulatory approval"

component_analysis:
  components:
    - component: "Molecular Representation"
      importance: high
      research_potential: "New graph neural network architectures"
    - component: "Target Prediction"
      importance: high
      research_potential: "Transfer learning across targets"
    - component: "ADMET Prediction"
      importance: medium
      research_potential: "Multi-task learning approaches"

ideas:
  ranked_ideas:
    - id: 1
      title: "Few-Shot Learning for Novel Drug Targets"
      description: "Develop meta-learning approaches that can predict
        activity for new drug targets with minimal training examples"
      novelty_score: 0.85
      feasibility_score: 0.72
      impact_potential: high
      literature_pointers: ["meta-learning drug discovery",
        "few-shot molecular property prediction"]
```

## Feature Comparison

| Feature | Basic Tools | This Skill |
|---------|--------|------------|
| Speed | 2-3 min | 2-5 min |
| Transparency | Black box | Full reasoning shown |
| 5-Whys analysis | Yes | Yes (documented) |
| Component analysis | Yes | Yes (MECE validated) |
| Idea ranking | Basic | Scored (novelty, feasibility, impact) |
| Integration | Standalone | Feeds into literature-synthesis, manuscript-drafter |
| Memory | No history | Stored in memory-mcp |

## Success Criteria

- [ ] Generate 5+ ideas meeting novelty threshold
- [ ] All causal chains trace to actionable root causes
- [ ] MECE validation passes for component analysis
- [ ] Top 3 ideas have expanded details
- [ ] Literature pointers generate relevant search results
- [ ] Total execution time < 5 minutes (standard mode)

## Related Skills

- **literature-synthesis** - Deep dive into generated ideas
- **research-gap-visualizer** - Visualize gaps identified
- **rapid-manuscript-drafter** - Draft papers from ideas
- **intent-analyzer** - Clarify research intent
- **interactive-planner** - Gather preferences

---

**Version**: 1.0.0
**Category**: Research / Ideation
**Time**: 2-15 minutes depending on mode
**Design**: Evidence-based ideation with full transparency

## Core Principles

### 1. Systematic Causal Analysis Through 5-Whys
Research ideas must be grounded in root causes identified through systematic questioning, not superficial observations.

**In practice:**
- Apply 5-Whys methodology to each major challenge, drilling down from symptoms to root causes
- Validate that final "why" represents an actionable research opportunity, not an unsolvable constraint
- Document complete causal chains showing reasoning from problem to root cause to research idea
- Cross-validate root causes against existing literature to ensure genuine gaps exist

### 2. MECE Decomposition for Comprehensive Coverage
Topic decomposition must be mutually exclusive and collectively exhaustive to prevent gaps and overlaps in idea generation.

**In practice:**
- Break down topics into components that don't overlap (mutually exclusive)
- Ensure components cover the entire topic space (collectively exhaustive)
- Validate MECE criteria before proceeding to causal analysis
- Assign importance ratings to prioritize components with highest research potential

### 3. Transparent Reasoning Over Black-Box Generation
Research ideation must expose complete reasoning processes, enabling validation and learning, unlike opaque AI tools.

**In practice:**
- Document primary analysis showing domain assessment and current state
- Show component analysis with MECE validation and importance ratings
- Display causal chains with all five "why" levels and identified root causes
- Provide scoring rationale for novelty, feasibility, and impact assessments

## Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Surface-Level Ideation | Generating ideas from first impressions without root cause analysis leads to shallow, derivative research | Apply full 5-Whys methodology to each component, validate that ideas address root causes not symptoms |
| Novelty Claims Without Verification | Assuming ideas are novel without checking literature creates wasted effort replicating existing work | Include literature pointers with each idea, cross-check against related work keywords, flag for validation |
| Infeasibility Blindness | Proposing ambitious ideas without resource assessment leads to abandoned projects | Score feasibility explicitly (0-1 scale), estimate required resources, flag long-term vs quick-win ideas |
| Single-Domain Tunnel Vision | Restricting ideation to one field misses interdisciplinary opportunities and cross-pollination | Include adjacent fields in primary analysis, explore component interactions, suggest mixed methodologies |
| Vague Hypothesis Statements | Generating untestable research questions prevents experimental validation and publication | Formulate falsifiable hypotheses with clear success criteria and measurable outcomes for each idea |

## Conclusion

The Rapid Idea Generator skill transforms research ideation from ad-hoc brainstorming into systematic, evidence-based idea generation completed in under 5 minutes. By combining 5-Whys causal analysis with MECE decomposition and transparent scoring, this skill generates 5-10 actionable research ideas grounded in root causes rather than superficial observations. The structured workflow - primary analysis, component decomposition, causal chains, idea generation, and expansion - ensures comprehensive coverage while maintaining speed.

The integration with memory storage and downstream skills creates a complete research workflow. Generated ideas feed directly into literature synthesis for validation, baseline replication for experimental validation, and manuscript drafting for publication. Organizations implementing this skill report significant acceleration in research direction setting, higher quality initial hypotheses, and reduced wasted effort on derivative ideas. The novelty and feasibility scoring system enables prioritization between quick wins and long-term ambitious projects.

When compared to black-box idea generation tools, this skill provides unmatched transparency through documented reasoning at every step. Researchers can validate causal chains, challenge MECE decompositions, and adjust scoring criteria based on domain expertise. The expertise-aware workflow enables loading of domain-specific patterns and known research gaps, preventing regeneration of previously explored ideas. This systematic approach elevates research ideation from creative guesswork to rigorous, reproducible methodology that produces publication-ready research directions in minutes rather than weeks.