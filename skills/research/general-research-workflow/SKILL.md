---
name: general-research-workflow
description: Systematic 6-phase research methodology for history, mythology, and literature implementing Red's (OSP) evidence-based approach. Use when researching topics outside academic ML scope that require primary/secondary source evaluation, credibility analysis, and evidence-based thesis formation. Sequential agent workflow (researcher, analyst, coordinator) over 6-10 hours with Quality Gates ensuring rigorous source validation and synthesis.
version: 3.0
agents: [researcher, analyst, coordinator]
duration: 6-10 hours
quality_gates: 7
---

# General Research Workflow

## Purpose

Execute systematic general-purpose research across history, mythology, literature, and non-ML domains using Red's (OSP) 6-phase evidence-based methodology with rigorous source evaluation and synthesis.

## When to Use This Skill

**Use this skill when:**
- ✅ Researching historical events, mythological topics, or literary analysis
- ✅ Need to evaluate primary vs secondary sources
- ✅ Building evidence-based arguments with citations
- ✅ Topic requires source credibility analysis
- ✅ Have 6+ hours for thorough research

**Do NOT use for:**
- ❌ Academic ML research (use `literature-synthesis` instead)
- ❌ Quick fact-checking (<30 min)
- ❌ Literature reviews for academic papers (use `deep-research-orchestrator`)

**Decision Tree**: See `references/decision-tree.md`

## Quick Reference

| Step | Agent | Deliverable | Duration | Quality Gate |
|------|-------|-------------|----------|--------------|
| 0 | researcher | Wikipedia verification OR fallback plan | 5-10 min | ≥1 viable starting source |
| 1 | researcher | 10+ citations from Wikipedia references | 15-30 min | ≥10 citations, ≥3 categories |
| 2 | researcher | 20+ sources with metadata + relevance scores | 1-2 hours | ≥20 sources, ≥50% accessible |
| 3 | analyst | Classified sources with credibility/bias/priority scores | 30-60 min | ≥5 primaries, ≥80% credibility ≥3 |
| 4 | researcher | Context profiles for 10+ sources, 3+ time periods | 1-2 hours | ≥10 contextualized, ≥3 periods |
| 5 | researcher | 50+ notes, 20+ quotes with pages, 5+ cross-links | 2-3 hours | All quotas met |
| 6 | coordinator | Evidence-based thesis + final report | 1-2 hours | ≥5 sources support thesis, validated |

## Agent Coordination Protocol

### Sequential Execution
Each step passes deliverables to the next step. Do NOT proceed if Quality Gate fails.

### Agent Roles
- **researcher**: Discovery, analysis, note-taking (Steps 0, 1, 2, 4, 5, Phase A-B of Step 6)
- **analyst**: Validation, classification, quality checks (Step 3, Phase C of Step 6)
- **coordinator**: Synthesis orchestration (Phase D of Step 6)

### Memory MCP Tags
ALL stored data must include: `WHO=[agent]`, `WHEN=[timestamp]`, `PROJECT=[research-topic]`, `WHY=[intent]`

## Glossary

See `references/glossary.md` for complete definitions:
- **Primary Source**: Original documents/eyewitness accounts from the time period
- **Secondary Source**: Analysis/interpretation created after the events
- **Credibility Score (1-5)**: Reliability based on expertise, venue, citations
- **Bias Risk Score (1-5)**: Likelihood of systematic distortion
- **WorldCat**: worldcat.org - Global library catalog
- **Google Scholar**: scholar.google.com - Academic publication search

---

## Step-by-Step Workflow

### STEP 0: Pre-Flight Check (Gate 0)
**Agent**: researcher
**Goal**: Verify Wikipedia article exists OR establish fallback plan

**Procedure**:
1. Search Wikipedia for research topic
2. **IF article exists**: ✅ Proceed to Step 1
3. **IF NO article**:
   - Try related/broader topics, alternative spellings
   - **FALLBACK**: Start with Google Scholar search instead
   - Extract ≥10 citations from Scholar results
   - Document: "No Wikipedia article, started with Google Scholar"
4. Check language accessibility:
   - Flag non-English sources for translation assessment
   - Document language limitation if proceeding without translations

**Deliverable**: Confirmation of viable starting point

**Quality Gate 0**: STOP if no viable sources. Escalate to user for topic clarification.

---

### STEP 1: Wikipedia Mining
**Agent**: researcher
**Goal**: Extract reference trail from Wikipedia

**Procedure**:
1. Read Wikipedia article for overview
2. Navigate to "References" section
3. Extract ALL citations with metadata:
   - ✅ Author(s) [REQUIRED]
   - ✅ Title [REQUIRED]
   - ✅ Year [REQUIRED]
   - ⚠️ ISBN/DOI [OPTIONAL]
4. Extract "Further Reading" citations
5. Categorize by type: Books, Papers, News, Websites
6. Store with Memory MCP tags

**Example**: See `examples/wikipedia-citation-example.json`

**Deliverable**: JSON array of 10+ citations

**Quality Gate 1**: STOP if <10 citations. Expand to related Wikipedia articles.

---

### STEP 2: Source Discovery
**Agent**: researcher
**Goal**: Locate actual sources, expand beyond Wikipedia

**Procedure**:
1. For EACH citation from Step 1:
   - Search WorldCat (worldcat.org)
   - Search Google Books
   - Classify as primary/secondary
   - Note accessibility: full text, preview, physical, unavailable
   - Note language
2. Expand using:
   - Google Scholar "Cited by"
   - "Related articles" suggestions
   - Author's other works
3. For each source record:
   - ✅ Title, author, year, type [REQUIRED]
   - ✅ Accessibility + language [REQUIRED]
   - ✅ Relevance note: "Addresses [question] via [primary evidence/analysis/context]" [REQUIRED]
   - ✅ Relevance score 1-5 [REQUIRED]

**Deliverable**: Source inventory with 20+ sources

**Quality Gate 2**: STOP if <20 sources OR <50% accessible. Continue discovery.

**Exception**: If obscure topic, proceed with ≥10 high-credibility sources, document limitation.

---

### STEP 3: Source Classification
**Agent**: analyst (with researcher support)
**Goal**: Classify sources using systematic rubrics

**Procedure**:

**A. Primary vs Secondary**:
- **Primary**: Original documents, eyewitness accounts, contemporary records, original data
- **Secondary**: Analysis of primaries, textbooks, biographies (written after)

**B. Credibility Score (1-5) - Program-of-Thought**:
```
Start: 3 (neutral)

ADD +1 for EACH:
✅ Peer-reviewed (academic journal, university press)
✅ Author has PhD/recognized expertise
✅ Cites primary sources, provides references
✅ Reputable institution

SUBTRACT -1 for EACH:
❌ Self-published or vanity press
❌ No author credentials
❌ No citations/references
❌ Known conflicts of interest

Final: 1-5 (capped)
```

**C. Bias Risk Score (1-5)**:
```
Start: 2 (low bias)

ADD +1 for EACH:
⚠️ Advocacy organization affiliation
⚠️ Funding from interested party
⚠️ Strong ideological language
⚠️ Cherry-picked/one-sided presentation

Final: 1-5
(1=minimal, 3=moderate, 5=high bias)
```

**D. Reading Priority (1-5)**:
```
Formula:
Priority = (Relevance × 0.4) + (Credibility × 0.3) +
           (Primary=+2, Secondary=0) + (Accessible=+1, Not=-1)

Bands:
5 = Read IMMEDIATELY
4 = Read soon
3 = Read if time
2 = Defer to end
1 = Skip unless critical
```

**Flag sources**:
- 💡 Priority 4-5: Immediate queue
- ⏸️ Priority 1-3: Defer
- ⚠️ Conflicting: Cross-check
- 🚨 Bias ≥4: Extra scrutiny

**Example**: See `examples/source-classification-example.md`

**Deliverable**: Classified inventory with scores

**Quality Gate 3**: STOP if <5 primaries OR <80% credibility ≥3.

**Exception**: If NO primaries available (ancient topics), proceed with ≥10 credibility ≥4 secondaries, document.

---

### STEP 4: Contextual Analysis
**Agent**: researcher (with analyst verification)
**Goal**: Understand sources in historical/cultural/scholarly context

**Procedure**:
Start with priority 4-5 sources. For EACH:

**A. Temporal Context**:
- ✅ Publication date [REQUIRED]
- ✅ Major events at that time [REQUIRED]
- 💡 Time period's influence on perspective [ANALYSIS]

**B. Cultural Context**:
- ✅ Author's cultural/national background [REQUIRED]
- ✅ Intended audience [REQUIRED]
- 💡 Embedded cultural assumptions [ANALYSIS]

**C. Historiographical Context**:
- ✅ Position in scholarly debate [REQUIRED]
- ⚠️ Mainstream or controversial? [IF APPLICABLE]
- ⚠️ School of thought [IF APPLICABLE]

**D. Translation Issues** (if applicable):
- ⚠️ Translation reputation
- ⚠️ Known issues
- ⚠️ Multiple translations compared?

Create context profile (3-5 sentences per type)

**Deliverable**: Profiles for 10+ sources, 3+ time periods

**Quality Gate 4**: STOP if <10 contextualized OR <3 periods. Continue.

---

### STEP 5: Comprehensive Note-Taking
**Agent**: researcher
**Goal**: Extract claims, evidence, quotes with page numbers

**Procedure**:
Read sources in priority order. For EACH source use template:

```markdown
## SOURCE: [Title] - [Author] ([Year])
TYPE: [Primary/Secondary] | CREDIBILITY: [Score] | BIAS: [Score]

### ✅ KEY CLAIMS [REQUIRED - Min 2]
- Claim 1 (page X): "[quote or paraphrase]"
- Claim 2 (page Y): "[quote or paraphrase]"

### ✅ SUPPORTING EVIDENCE [REQUIRED]
- For Claim 1 (pages X-Y): [How supported? Data/sources/reasoning?]
- For Claim 2 (pages Y-Z): [How supported?]

### ✅ QUOTABLE PASSAGES [REQUIRED - Min 2 with pages]
- "Notable quote 1" (page X)
- "Notable quote 2" (page Y)

### ⚠️ CONTRADICTIONS [OPTIONAL - If detected]
- Conflicts with [Source B] on [point] (page X vs page Y)

### ⚠️ BIAS/AGENDA [OPTIONAL - If bias score ≥3]
- Observable patterns: [Examples]

### ⚠️ CROSS-REFERENCES [OPTIONAL - If relevant]
- Links to [Source C] on [topic]
- Supports/refutes [Source D]
```

Tag with: `#primary-source` or `#secondary-source`, `#key-claim`, `#needs-verification`, `#high-confidence`/`#uncertain`, `#[topic-keywords]`

**Template**: See `examples/note-template.md`

**Deliverable**: 50+ notes, 20+ quotes with pages, 5+ cross-links

**Quality Gate 5**: STOP if quotas not met. Re-read sources.

---

### STEP 6: Synthesis & Dot Connecting
**Agent**: coordinator (with researcher + analyst support)
**Goal**: Synthesize evidence into thesis and final report

**Phase A - Pattern Recognition** (researcher):
1. Review ALL Step 5 notes
2. Identify recurring themes (≥3 sources)
3. Find agreements (multiple sources, similar claims)
4. Find disagreements/contradictions
5. Map evidence chains: "Source A (p.42) → Source B (p.15) → Claim X"
6. Identify gaps (insufficient evidence)

**Phase B - Thesis Formation** (researcher):
1. **CRITICAL**: Let thesis EMERGE from evidence (NOT imposed)
2. Draft 1-2 sentence thesis that:
   - ✅ Makes clear argument
   - ✅ Supported by source evidence
   - ✅ Acknowledges scope/limitations
3. List supporting evidence (≥5 sources)
4. List counter-evidence
5. Identify limitations

**SPECIAL CASE - Inconclusive**:
IF evidence too contradictory/insufficient:
- ✅ State "INCONCLUSIVE"
- 💡 Explain WHY
- 📋 Summarize competing interpretations
- 🚨 Document what sources would resolve ambiguity

**Phase C - Validation** (analyst):
1. Check for fallacies:
   - ❌ Circular reasoning
   - ❌ Confirmation bias
   - ❌ Unsupported leaps
2. Verify EVERY claim has citation + PAGE NUMBER
3. Flag unsupported assertions → return to researcher
4. Confirm ≥2 primaries cited (if available)
5. Assess strength:
   - ✅ STRONG: ≥5 sources, ≥2 primaries, logical
   - ⚠️ MODERATE: 3-4 sources OR 1 primary, minor gaps
   - ❌ WEAK: <3 sources OR no primaries → return

**Phase D - Final Report** (coordinator):
Compile report using template:

```markdown
# RESEARCH REPORT: [Topic]

## THESIS
[1-2 sentence evidence-based thesis]
OR [INCONCLUSIVE: Explanation]

## SUPPORTING EVIDENCE
1. [Claim 1]
   - **Source 1**: [Author, Year, p.X-Y] - [Quote/paraphrase]
   - **Source 2**: [Author, Year, p.Z] - [Quote/paraphrase]

## LIMITATIONS & CAVEATS
- **Limitation 1**: [Description]
- **Limitation 2**: [Description]

## COUNTER-EVIDENCE OR ALTERNATIVES
- **Alternative 1**: [Description] - [Source, Year, p.X]

## PRIMARY SOURCES REFERENCED [N total]
1. [Title] - [Author], [Year] - [1-sentence significance]

## SECONDARY SOURCES REFERENCED [N total]
1. [Title] - [Author], [Year] - [1-sentence contribution]

## METHODOLOGY NOTES
- Total sources: [N]
- Primaries: [N] | Secondaries: [N]
- Time periods: [List]
- Perspectives: [Regions/cultures]
- Research duration: [X hours]

## RECOMMENDATIONS FOR FURTHER RESEARCH
- [Additional sources needed?]
- [Unanswered questions?]
```

**Example**: See `examples/final-report-example.md`

**Deliverable**: Complete research report

**Quality Gate 6 (FINAL)**:
**GO**:
- ✅ Thesis supported by ≥5 sources OR "INCONCLUSIVE" explained
- ✅ ≥2 primaries cited (OR exception documented)
- ✅ NO unsupported claims
- ✅ ≥1 limitation acknowledged
- ✅ Analyst validation passed

**NO-GO** (return to Phase B):
- ❌ Unsupported claims
- ❌ Logical fallacies
- ❌ <5 sources for thesis
- ❌ No limitations (overconfident)

---

## Red's Research Principles

This workflow embeds Red's (OSP) methodology:

| Principle | Implementation |
|-----------|---------------|
| **"Trust No One"** | Step 3: Systematic credibility + bias scoring |
| **"Context is Everything"** | Step 4: Temporal/cultural/historiographical analysis |
| **"Thesis from Evidence"** | Step 6: Thesis EMERGES, not imposed. "INCONCLUSIVE" option |
| **"Wikipedia is a Gateway"** | Step 1: Mine references, not final authority. Gate 0 fallback |
| **"Primary Sources Matter"** | Step 3: ≥2 primaries required (or exception) |
| **"Page Numbers Save Lives"** | Step 5: All quotes/claims MUST have page refs |

See `references/red-methodology.md` for full explanation.

---

## Success Metrics

### Quantitative
- ✅ ≥20 sources in inventory
- ✅ ≥5 primary sources (OR exception documented)
- ✅ ≥80% sources credibility ≥3
- ✅ ≥50 notes captured
- ✅ ≥20 quotes with page numbers
- ✅ ≥5 cross-source links
- ✅ Thesis supported by ≥5 sources (OR "INCONCLUSIVE")
- ✅ ≥2 primaries cited (OR exception)
- ✅ 6-10 hours duration

### Qualitative
- ✅ Context explained for ≥10 sources
- ✅ Biases identified in ≥3 sources
- ✅ Thesis emerges from evidence
- ✅ All claims have citations + pages
- ✅ ≥1 limitation acknowledged
- ✅ Alternatives acknowledged
- ✅ NO logical fallacies

---

## Error Handling

| Failure | Gate | Resolution |
|---------|------|------------|
| No Wikipedia article | 0 | Google Scholar fallback |
| <10 citations | 1 | Related articles, alt terms |
| <20 sources | 2 | Different discovery methods |
| <50% accessible | 2 | Prioritize accessible, document |
| <5 primaries | 3 | Continue OR document exception |
| <80% credibility ≥3 | 3 | Return to Step 2 |
| Non-English sources | 0, 2 | Flag for translation OR document |
| Contradictory evidence | 6B | "INCONCLUSIVE" option |
| Logical fallacies | 6C | Return to Phase B |
| Unsupported claims | 6C | Add sources OR remove claims |

---

## Integration

**Before**: Use `intent-analyzer` if research question vague
**During**: Can parallel `literature-synthesis` for ML components
**After**: Use `academic-reading-workflow` for deep reading

---

## Process Visualization

See `general-research-process.dot` for complete workflow diagram showing all steps, gates, and decision points.

---

**Red's Research Principles**: "Trust No One, Context is Everything, Thesis from Evidence, Wikipedia is a Gateway, Primary Sources Matter, Page Numbers Save Lives"
