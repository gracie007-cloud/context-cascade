---
name: researcher
description: Skill for researcher
allowed-tools: Read, Glob, Grep, WebSearch, WebFetch, Task, TodoWrite
---

name: researcher
description: Multi-level research with Gemini Search integration supporting 3 research
  depths. Use when gathering information, conducting systematic analysis, or synthesizing
  knowledge from multiple sources. Applies 90%+ credibility scoring and comprehensive
  source evaluation.
version: 1.0.0
category: research
tags:
- research
- analysis
- planning
author: ruv
---

# Researcher - Systematic Information Gathering

Systematic multi-level research with integrated Gemini Search for comprehensive knowledge synthesis.

## When to Use This Skill

Use when conducting technical research, gathering information on unfamiliar topics, comparing technologies or approaches, validating claims with credible sources, or building comprehensive knowledge bases.

## 3-Level Research Methodology

### Level 1: Basic Research (< 5 minutes)
- Quick factual queries
- Single-source validation
- Surface-level understanding
- Immediate answers needed

**Process**:
1. Query Gemini Search for primary information
2. Validate source credibility (>70%)
3. Extract key facts
4. Provide concise summary

### Level 2: Multi-Source Research (15-30 minutes)
- Cross-reference multiple sources
- Deeper analysis required
- Technical understanding needed
- Comprehensive overview desired

**Process**:
1. Query 3-5 authoritative sources
2. Compare and contrast findings
3. Identify consensus and disagreements
4. Synthesize into coherent analysis
5. Score sources for credibility (>85%)

### Level 3: Deep Dive Research (1+ hours)
- Extensive investigation
- Academic rigor required
- Complex topic with nuances
- Publication-ready research

**Process**:
1. Systematic literature review
2. Query 10+ diverse sources
3. Analyze methodology and evidence
4. Identify research gaps
5. Synthesize comprehensive report
6. Ensure 90%+ source credibility

## Source Evaluation Criteria

### Credibility Scoring (0-100%)
- **Authority** (30%): Expert author, institutional backing
- **Accuracy** (25%): Fact-checked, peer-reviewed, verifiable
- **Objectivity** (20%): Minimal bias, balanced perspective
- **Currency** (15%): Recent publication, up-to-date information
- **Coverage** (10%): Comprehensive treatment of topic

### Source Types by Reliability
1. **Tier 1 (90-100%)**: Peer-reviewed journals, official documentation
2. **Tier 2 (75-89%)**: Industry reports, credible news outlets
3. **Tier 3 (60-74%)**: Blog posts from experts, technical forums
4. **Tier 4 (<60%)**: Unverified sources, opinion pieces

## Gemini Search Integration

- Use `gemini-search` skill for web queries
- Enable grounded search for factual accuracy
- Leverage Google Search API for broad coverage
- Apply source verification automatically

## Output Formats

- **Summary**: Key findings in bullet points
- **Synthesis**: Coherent narrative combining sources
- **Bibliography**: Annotated source list with credibility scores
- **Analysis**: Detailed evaluation with evidence
## Core Principles

Researcher operates on 3 fundamental principles:

### Principle 1: Credibility-First Source Evaluation
Every source is scored using a multi-dimensional rubric (Authority, Accuracy, Objectivity, Currency, Coverage) before incorporation. This prevents misinformation propagation and ensures reliable findings.

In practice:
- Tier 1 sources (90-100%) prioritized for critical claims
- Cross-validation required when using Tier 3 sources (60-74%)
- Automatic rejection of sources scoring below 60% credibility

### Principle 2: Multi-Source Triangulation
Claims are validated through independent corroboration from 3+ sources at different tiers. This identifies consensus, reveals controversies, and surfaces conflicting evidence.

In practice:
- Key technical findings backed by peer-reviewed journals plus official documentation
- Contradictory evidence explicitly reported with analysis of disagreement sources
- Single-source claims flagged and marked as unverified

### Principle 3: Transparent Evidence Trail
All research outputs include full citations, access dates, credibility scores, and methodology notes. This enables verification and builds trust in findings.

In practice:
- APA/IEEE/ACM citations with DOIs and access timestamps
- Credibility breakdown visible for each source (Authority 28/30, Accuracy 23/25...)
- Search methodology documented (queries used, sources consulted, filters applied)

## Common Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Single-Source Research** | Relying on one source creates vulnerability to bias, errors, or outdated information | Use Level 2+ research with 3-5 sources for cross-validation |
| **Accepting Low Credibility** | Using sources below 70% without disclosure degrades finding quality and misleads users | Flag all <70% sources explicitly, require 3+ independent corroborations |
| **Skipping Currency Check** | Outdated sources in rapidly evolving fields provide obsolete information | Verify publication date against topic evolution, flag sources >2 years old for tech topics |

## Conclusion

Researcher provides systematic multi-level research with rigorous source evaluation, ensuring findings are credible, well-supported, and transparently documented. By applying academic research standards to everyday information gathering, this skill transforms web search into evidence-based knowledge synthesis.

Use this skill when technical accuracy matters, when building knowledge bases for unfamiliar domains, or when decisions depend on reliable information. The three-level approach scales from quick factual lookups (Level 1, under 5 minutes) to publication-ready research (Level 3, 1+ hours with 10+ sources). The credibility scoring system ensures you know exactly how much trust to place in each finding, with explicit documentation of evidence quality.