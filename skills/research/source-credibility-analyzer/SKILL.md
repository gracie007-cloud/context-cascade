---
name: source-credibility-analyzer
description: Standalone tool for automated source evaluation using program-of-thought scoring rubrics. Outputs credibility (1-5), bias (1-5), and priority (1-5) scores with transparent explanations. Use when evaluating research sources, automating general-research-workflow Step 3, or scoring large batches consistently. Single analyst agent workflow (5-15 min per source).
version: 2.0
agents: [analyst]
duration: 5-15 minutes per source
quality_gates: 5
---

# Source Credibility Analyzer

## Purpose

Automate evaluation of research sources using transparent program-of-thought rubrics. Outputs structured JSON with credibility, bias, and priority scores (1-5) plus explanations showing calculation logic. Can be used as standalone tool OR integrated into general-research-workflow Step 3.

## When to Use This Tool

**Use this tool when:**
- ✅ Evaluating research sources for academic projects
- ✅ Automating source classification (general-research-workflow Step 3)
- ✅ Scoring large batches of sources consistently
- ✅ Getting objective second opinion on source quality

**Do NOT use for:**
- ❌ Entertainment content (movies, novels) - not designed for this
- ❌ Source quality already obvious (Nature paper = high, random blog = low)
- ❌ Unique/irreplaceable source (only source on obscure topic) - read anyway

**Decision Tree**: If manual source evaluation takes >10 min → use this tool (saves 15-45 min per source)

## Quick Reference

| Step | Objective | Deliverable | Duration | Quality Gate |
|------|-----------|-------------|----------|--------------|
| 0 | Validate inputs | Confirmed metadata | 30 sec | Required fields present |
| 0.5 | Classify source type | Source category | 1 min | Type assigned |
| 1 | Calculate credibility | Score 1-5 + explanation | 2-5 min | Score justified |
| 2 | Calculate bias | Score 1-5 + explanation | 2-5 min | Score justified |
| 3 | Calculate priority | Score 1-5 + explanation | 1-3 min | Score justified |
| 4 | Resolve conflicts | Final recommendation | 1 min | Logic correct |
| 5 | Generate output | JSON + storage | 1 min | Complete + stored |

---

## Agent Coordination Protocol

### Single Agent Execution
- **Agent**: analyst
- **Role**: Evaluate source using program-of-thought rubrics
- **Workflow**: Sequential steps 0 → 0.5 → 1 → 2 → 3 → 4 → 5

### Input Format
```json
{
  "title": "[Required]",
  "author": "[Required]",
  "year": [Required, 1500-2025],
  "venue": "[Required]",
  "type": "[Required]",
  "citations": [Optional],
  "doi": "[Optional]",
  "url": "[Optional]",
  "institution": "[Optional]",
  "credentials": "[Optional]"
}
```

### Output Format
```json
{
  "source": { ... },
  "scores": {
    "credibility": {"score": [1-5], "explanation": "..."},
    "bias": {"score": [1-5], "explanation": "..."},
    "priority": {"score": [1-5], "explanation": "..."}
  },
  "recommendation": {
    "action": "[READ_FIRST | READ_LATER | VERIFY_CLAIMS | SKIP]",
    "reason": "...",
    "conflicts": "..."
  },
  "metadata": { ... }
}
```

### Memory MCP Tags
Store with: `WHO=analyst`, `WHEN=[timestamp]`, `PROJECT=[topic]`, `WHY=source-scoring`, `CREDIBILITY=[score]`, `BIAS=[score]`, `PRIORITY=[score]`, `RECOMMENDATION=[action]`

---

## Step-by-Step Workflow

### STEP 0: Validate Input Metadata
**Agent**: analyst
**Objective**: Ensure required metadata is present and valid

**Procedure**:
1. Check for ✅ **required** fields:
   - `title` (string, non-empty)
   - `author` (string, non-empty)
   - `year` (integer, 1500-2025)
   - `venue` (string, non-empty)
   - `type` (string, non-empty)

2. Note ⚠️ **optional** fields if present:
   - `citations` (improves credibility scoring)
   - `doi` (improves credibility scoring)
   - `institution` (improves credibility scoring)
   - `credentials` (improves credibility scoring)
   - `url` (for reference)

3. Validate data types and ranges:
   - Year must be integer 1500-2025
   - All required strings non-empty

4. If validation fails → Return error with missing/invalid field name

**Deliverable**: Validated metadata object

**Quality Gate 0**:
- **GO**: All required fields present, year valid (1500-2025)
- **NO-GO**: Missing/invalid field → Return error to user

---

### STEP 0.5: Classify Source Type (Edge Case Handling)
**Agent**: analyst
**Objective**: Assign source to appropriate category for rubric baseline

**Edge Case Decision Tree**:

```
Is source peer-reviewed? (Check venue: journal, academic press, conference proceedings)
├─ ✅ Yes → ACADEMIC
│   Examples: Nature, Cambridge University Press, ICML proceedings
│
├─ ❌ No → Is source from recognized institution?
    ├─ ✅ Yes → INSTITUTIONAL
    │   Examples: US Census Bureau, Brookings Institution, university press (non-peer-reviewed)
    │
    └─ ❌ No → Is source verifiable/documented?
        ├─ ✅ Yes → GENERAL
        │   Examples: Wikipedia, NYT, expert blogs (Gwern, SSC)
        │
        ├─ ⚠️ Preprint? → PREPRINTS
        │   Examples: arXiv, bioRxiv, SSRN
        │
        └─ ❌ No → UNVERIFIED
            Examples: Personal blogs, social media, unknown sites
```

**Category Baseline Scores**:

| Category | Credibility Baseline | Notes | Examples |
|----------|---------------------|-------|----------|
| **ACADEMIC** | 4 | Peer-reviewed, standard rubric | Journals, academic books, conference papers |
| **INSTITUTIONAL** | 3 | Check funding source | Government reports, white papers |
| **GENERAL** | 3 | Verify against other sources | Wikipedia, reputable news, expert blogs |
| **PREPRINTS** | 3 | Not yet peer-reviewed, verify claims | arXiv, bioRxiv, SSRN |
| **UNVERIFIED** | 2 | Use with extreme caution | Personal blogs, social media |

**Special Cases**:

1. **Wikipedia**:
   - Credibility: 3 (verifiable, crowd-sourced)
   - Bias: 4 (NPOV policy)
   - Priority: 2 (background only, not citable in academic work)
   - Action: READ_LATER (gateway to primary sources)

2. **Preprints** (arXiv, bioRxiv):
   - Credibility: 3 (not peer-reviewed but often high-quality)
   - Bias: 4 (assume good faith)
   - Priority: Depends on recency and relevance
   - Action: VERIFY_CLAIMS (read but cross-check against peer-reviewed sources)

3. **Gray Literature** (government reports, NGO papers):
   - Credibility: 3-4 (depends on institution reputation)
   - Bias: Check funding source carefully
   - Priority: Depends on topic match

4. **Expert Blogs** (Gwern, LessWrong, Scott Alexander):
   - Credibility: 3 (no formal peer review)
   - Bias: 3-4 (depends on author's agenda)
   - Priority: Depends on expertise match with topic

**💡 Tip**: When category is ambiguous → Default to GENERAL and note uncertainty in output

**Deliverable**: Source category (ACADEMIC | INSTITUTIONAL | GENERAL | PREPRINTS | UNVERIFIED)

**Quality Gate 0.5**:
- **GO**: Category assigned based on decision tree
- **NO-GO**: Unable to classify → Default to GENERAL, flag uncertainty

---

### STEP 1: Calculate Credibility Score (1-5)
**Agent**: analyst
**Objective**: Assess source trustworthiness using program-of-thought rubric

**Program-of-Thought Rubric**:

**Baseline Score** (from Step 0.5):
- ACADEMIC: Start at 4
- INSTITUTIONAL / GENERAL / PREPRINTS: Start at 3
- UNVERIFIED: Start at 2

**Add +1 for EACH** (max +3):
- ✅ Peer-reviewed publication (journal, academic press)
- ✅ Author has PhD or recognized expertise
- ✅ Cites primary sources + extensive references (≥20 citations)
- ✅ Published by top-tier institution (Ivy League, top publisher)
- ✅ High citation count (≥100 for papers, ≥500 for books)
- ✅ Has DOI or persistent identifier

**Subtract -1 for EACH** (max -3):
- ❌ Self-published or vanity press
- ❌ No author credentials or anonymous
- ❌ No citations/references provided
- ❌ Known conflicts of interest (industry-funded study on own product)
- ❌ Published on unmoderated platform (personal blog, social media)
- ❌ Retracted or corrected after publication

**🚨 Borderline Score Policy**:
- If final score = 2.5 or 3.5 → **Round DOWN** (conservative for credibility)
- Example: 2.5 → 2, 3.5 → 3

**Final Credibility Score**: [1-5, capped at boundaries]

**Calculation Procedure**:
1. Determine baseline from Step 0.5
2. Apply each applicable rule (+1 or -1)
3. Sum: Baseline + Adjustments
4. Apply borderline rounding if score ends in .5
5. Cap at 1 (minimum) and 5 (maximum)
6. Generate explanation: "Baseline [X], [list rules applied] = [sum] → [final]"

**Example**:
```
Source: "Machine Learning: A Probabilistic Perspective" by Kevin Murphy (MIT Press, 2012)
Category: ACADEMIC

Calculation:
Baseline: 4 (Academic source)
+1 (Published by MIT Press - top-tier university press)
+1 (Author: PhD, Google Research - recognized expertise)
+1 (15,000 citations - highly influential)
= 7 → capped at 5

Final Credibility: 5/5
Explanation: "Academic baseline 4, +1 MIT Press top-tier, +1 PhD author expertise, +1 15k citations = 7 capped at 5. Authoritative textbook."
```

**Deliverable**: Credibility score (1-5) + explanation showing baseline + rules + final

**Quality Gate 1**:
- **GO**: Score 1-5, explanation lists baseline and applied rules
- **NO-GO**: Score outside 1-5 or no explanation → Recalculate

---

### STEP 2: Calculate Bias Score (1-5)
**Agent**: analyst
**Objective**: Assess source objectivity and potential bias

**Program-of-Thought Rubric**:

**Baseline Score**:
- Standard: Start at 3 (Neutral)
- **Special Baselines**:
  - Primary sources (historical documents, datasets): Start at 5 (factual records)
  - Opinion pieces (editorials, op-eds): Start at 2 (explicitly opinionated)

**Add +1 for EACH** (max +3):
- ✅ Academic/scholarly source with peer review
- ✅ Presents multiple perspectives or counterarguments
- ✅ Clearly distinguishes facts from opinions
- ✅ Transparent about methodology and limitations
- ✅ No financial conflicts of interest
- ✅ Published by neutral/academic institution (not advocacy group)

**Subtract -1 for EACH** (max -3):
- ❌ Advocacy organization or political think tank
- ❌ Funded by interested party with conflicts (Exxon-funded climate study)
- ❌ One-sided presentation (no counterarguments/limitations)
- ❌ Opinion piece or editorial without labeling
- ❌ Sensationalist language or clickbait title
- ❌ Known partisan publication (Breitbart, Jacobin)

**🚨 Borderline Score Policy**:
- If final score = 2.5 or 3.5 → **Round UP** (benefit of doubt for bias)
- Example: 2.5 → 3, 3.5 → 4

**Final Bias Score**: [1-5, where 5 = least biased, 1 = most biased]

**Calculation Procedure**:
1. Determine baseline (3, or special baseline)
2. Apply each applicable rule (+1 or -1)
3. Sum: Baseline + Adjustments
4. Apply borderline rounding if score ends in .5
5. Cap at 1 (minimum) and 5 (maximum)
6. Generate explanation

**Example**:
```
Source: "Climate Change Impacts Study" by Heartland Institute (2021)
Category: INSTITUTIONAL

Calculation:
Baseline: 3
-1 (Heartland Institute - known climate denial advocacy group)
-1 (Funded by fossil fuel industry - conflicts of interest)
-1 (One-sided - dismisses consensus without balanced counterarguments)
= 0 → capped at 1

Final Bias: 1/5 (highly biased)
Explanation: "Institutional baseline 3, -1 advocacy org, -1 industry funding, -1 one-sided = 0 capped at 1. Strong bias, verify all claims independently."
```

**Deliverable**: Bias score (1-5) + explanation showing baseline + rules + final

**Quality Gate 2**:
- **GO**: Score 1-5, explanation lists baseline and applied rules
- **NO-GO**: Score outside 1-5 or no explanation → Recalculate

---

### STEP 3: Calculate Priority Score (1-5)
**Agent**: analyst
**Objective**: Assess reading priority for research project

**Program-of-Thought Rubric**:

**Baseline Score**:
- Start at 3 (Neutral)

**Add +1 for EACH** (max +3):
- ✅ **Recent** publication (≤5 years for empirical, ≤10 years for historical)
- ✅ **Directly relevant** to research question (core topic)
- ✅ **Highly cited** (≥50 for papers, ≥100 for books)
- ✅ **Primary source** or seminal work (foundational to field)
- ✅ **Recommended** by expert or cited in key papers
- ✅ **Comprehensive** coverage (textbook, review, meta-analysis)

**Subtract -1 for EACH** (max -3):
- ❌ **Outdated** (>20 years for empirical, unless seminal)
- ❌ **Tangentially relevant** (mentions topic in passing only)
- ❌ **Low credibility** (<3 from Step 1)
- ❌ **High bias** (<3 from Step 2)
- ❌ **Redundant** (duplicates already-read source)
- ❌ **Too narrow** (hyper-specialized, not useful for overview)

**💡 Special Considerations**:
- **Classic works**: Even if old (>50 years), retain high priority if seminal (e.g., Darwin's *Origin* for evolution)
- **Breadth vs depth**: Intros = lower priority than specialized deep dives (unless building foundation)

**🚨 Borderline Score Policy**:
- If final score = 2.5 or 3.5 → **Round UP** (favor reading when uncertain)
- Example: 2.5 → 3, 3.5 → 4

**Calculation Procedure**:
1. Start at 3
2. Apply each applicable rule (+1 or -1)
3. **Auto-check**: If Credibility <3 OR Bias <3 → Subtract -1
4. Sum: Baseline + Adjustments
5. Apply borderline rounding if score ends in .5
6. Cap at 1 (minimum) and 5 (maximum)
7. Generate explanation (must reference credibility/bias from Steps 1-2)

**Example**:
```
Source: "Byzantium and the Renaissance" by N.G. Wilson (Cambridge, 1992)
Category: ACADEMIC
Research: Byzantine influence on Renaissance

Calculation:
Baseline: 3
-1 (Published 33 years ago - outdated BUT historical analysis, offset)
+1 (Directly addresses research question)
+1 (250+ citations - highly influential)
+1 (Primary scholarship - seminal work)
= 5

Final Priority: 5/5 (read first)
Explanation: "Baseline 3, -1 age (offset by seminal status), +1 directly relevant, +1 highly cited, +1 primary scholarship = 5. Essential reading despite age."
```

**Deliverable**: Priority score (1-5) + explanation showing baseline + rules + credibility/bias check + final

**Quality Gate 3**:
- **GO**: Score 1-5, explanation references credibility/bias from Steps 1-2
- **NO-GO**: Score ignores credibility/bias → Recalculate with penalty

---

### STEP 4: Resolve Conflicting Scores
**Agent**: analyst
**Objective**: Handle edge cases where credibility/bias/priority conflict

**Conflict Resolution Matrix**:

| Credibility | Bias | Priority | Recommendation | Reasoning |
|-------------|------|----------|----------------|-----------|
| ≥4 | ≥3 | ≥4 | **READ_FIRST** | Ideal source: credible + unbiased + relevant |
| ≥3 | ≥3 | ≥3 | **READ_LATER** | Solid source: good quality, moderate priority |
| ≥4 | ≤2 | ANY | **VERIFY_CLAIMS** | Credible but biased: useful but verify |
| ≤2 | ANY | ANY | **SKIP** | Not credible: find better alternative |
| ANY | ≤2 | ≥4 | **VERIFY_CLAIMS** | Needed but biased: read critically |
| ≥4 | ≥3 | ≤2 | **READ_LATER** | Quality background material |

**Conflict Type Handlers**:

**Type 1: High Credibility + High Bias**
- Example: Peer-reviewed paper in advocacy journal (Credibility 4, Bias 2)
- Resolution: VERIFY_CLAIMS
- Reason: "Credible source but biased presentation. Read critically, verify against independent sources."

**Type 2: Low Credibility + Low Bias**
- Example: Anonymous blog with balanced presentation (Credibility 2, Bias 4)
- Resolution: SKIP
- Reason: "Unbiased but not credible. Find authoritative alternative."

**Type 3: High Priority + Low Credibility**
- Example: Only source on obscure topic (Priority 5, Credibility 2)
- Resolution: READ_LATER (with warning)
- Reason: "Relevant but low credibility. Read as last resort, verify everything."

**Type 4: High Credibility + Low Priority**
- Example: Tangential textbook (Credibility 5, Priority 2)
- Resolution: READ_LATER
- Reason: "Authoritative but not directly relevant. Read for context if time permits."

**Deliverable**: Final recommendation (READ_FIRST | READ_LATER | VERIFY_CLAIMS | SKIP) + reasoning + conflict explanation if applicable

**Quality Gate 4**:
- **GO**: Recommendation matches matrix, conflicts explained
- **NO-GO**: Recommendation doesn't match scores → Reapply matrix logic

---

### STEP 5: Generate Structured Output
**Agent**: analyst
**Objective**: Create complete scoring report in standardized JSON + store in Memory MCP

**Output JSON Template**:

```json
{
  "source": {
    "title": "[Title]",
    "author": "[Author]",
    "year": [YYYY],
    "venue": "[Venue]",
    "type": "[Type]",
    "category": "[ACADEMIC | INSTITUTIONAL | GENERAL | PREPRINTS | UNVERIFIED]",
    "doi": "[DOI if available]",
    "url": "[URL if available]"
  },
  "scores": {
    "credibility": {
      "score": [1-5],
      "explanation": "[Baseline + rules + final]"
    },
    "bias": {
      "score": [1-5],
      "explanation": "[Baseline + rules + final]"
    },
    "priority": {
      "score": [1-5],
      "explanation": "[Baseline + rules + credibility/bias check + final]"
    }
  },
  "recommendation": {
    "action": "[READ_FIRST | READ_LATER | VERIFY_CLAIMS | SKIP]",
    "reason": "[1-2 sentences justifying based on scores]",
    "conflicts": "[If conflicts exist, explain resolution]"
  },
  "metadata": {
    "analyzed_by": "source-credibility-analyzer",
    "timestamp": "[ISO8601]",
    "version": "2.0"
  }
}
```

**Storage in Memory MCP**:

```bash
npx claude-flow@alpha memory store \
  --key "source-analysis/[project]/[source-id]" \
  --value "[JSON output]" \
  --tags "WHO=analyst,WHEN=[timestamp],PROJECT=[topic],WHY=source-scoring,CREDIBILITY=[score],BIAS=[score],PRIORITY=[score],RECOMMENDATION=[action]"
```

**Deliverable**: Complete JSON report + Memory MCP storage confirmation

**Quality Gate 5**:
- **GO**: All scores present (1-5), explanations complete, recommendation matches matrix, stored successfully
- **NO-GO**: Missing field or storage failed → Regenerate JSON and retry storage (max 3 attempts)

---

## Success Metrics

### Quantitative
- ✅ All 3 scores calculated (credibility, bias, priority)
- ✅ All scores valid range (1-5)
- ✅ Explanations show calculations
- ✅ Recommendation matches decision matrix
- ✅ Execution time 5-15 min per source
- ✅ Output stored in Memory MCP

### Qualitative
- ✅ Scores match manual scoring within ±1 point
- ✅ Explanations clearly justify scores with explicit rules
- ✅ Recommendation is actionable
- ✅ Edge cases handled (Wikipedia, preprints, gray literature)
- ✅ Conflicts resolved transparently

---

## Error Handling

| Failure Mode | Gate | Resolution |
|--------------|------|------------|
| **Missing required metadata** | 0 | Return error with field name |
| **Invalid year** | 0 | Reject, request correction |
| **Score outside 1-5** | 1-3 | Recalculate with capping |
| **No explanation** | 1-3 | Regenerate with explicit rules |
| **Borderline score (X.5)** | 1-3 | Apply rounding policy |
| **Ambiguous source type** | 0.5 | Default to GENERAL, flag uncertainty |
| **Conflicting scores** | 4 | Apply conflict resolution matrix |
| **Recommendation mismatch** | 4 | Reapply matrix, document conflict |
| **Memory MCP storage fails** | 5 | Retry 3x, fallback to local JSON |

---

## Integration

**Standalone Usage**:
```bash
Skill("source-credibility-analyzer") + {
  "title": "...",
  "author": "...",
  "year": 2020,
  "venue": "...",
  "type": "journal article"
}
```

**Within general-research-workflow**:
- Called during Step 3 (Source Classification)
- Automates manual scoring
- Reduces time: 30-60 min → 5-15 min per source
- Outputs feed into Step 4 (Reading Plan)

**Output Feeds To**:
- general-research-workflow Step 4 (reading prioritization)
- academic-reading-workflow (decide which sources to annotate deeply)
- Memory MCP (persistent scoring for future reference)

---

## Process Visualization

See `source-credibility-analyzer-process.dot` for complete workflow diagram showing all steps, gates, and decision points.

---

## Complete Examples

See `examples/scoring-examples.md` for 5 complete end-to-end examples:
1. ✅ Academic paper (Credibility 5, Bias 5, Priority 4) → READ_FIRST
2. ✅ Think tank report (Credibility 3, Bias 1, Priority 3) → VERIFY_CLAIMS
3. ⚠️ Preprint (Credibility 3, Bias 4, Priority 5) → READ_FIRST (verify)
4. ⚠️ Wikipedia (Credibility 3, Bias 4, Priority 2) → READ_LATER (background)
5. ❌ Blog post (Credibility 2, Bias 2, Priority 1) → SKIP

Each example: Input → Calculations → Output JSON → Explanation

---

**Program-of-Thought Principle**: "Make scoring transparent, auditable, and reproducible through explicit calculations"
