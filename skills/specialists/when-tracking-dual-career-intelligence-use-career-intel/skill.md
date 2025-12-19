---
skill_name: when-tracking-dual-career-intelligence-use-career-intel
description: Automated US/EU career opportunity tracking with policy monitoring, EV-based ranking, and tailored application materials
version: 1.0.0
tier: critical
category: career-orchestration
auto_trigger:
  keywords:
    - "job search"
    - "career opportunities"
    - "track positions"
    - "EU visa"
    - "policy changes"
    - "career intel"
created: 2025-01-06
agents:
  - researcher (Scout + RegWatch roles)
  - analyst (Ranker role)
  - coder (PitchPrep role)
coordinator: hierarchical-coordinator
topology: hierarchical
memory_patterns:
  - life-os/career/opportunities/{YYYY-WW}
  - life-os/career/policy-changes/{YYYY-WW}
  - life-os/career/pitches/{org}
mcp_integration:
  - memory-mcp (WHO/WHEN/PROJECT/WHY tagging required)
  - claude-flow (hooks + coordination)
data_sources:
  - data/sources/job_boards.yml
  - data/sources/biotech_watch.yml
  - data/profiles/cv_core.md
outputs:
  - outputs/reports/career_intel_{YYYY-WW}.md
  - outputs/briefs/career_pitch_{org}.md
cadence: 2x per week
estimated_time: 45 min per run
---

# Dual-Track Career Intelligence

Automated tracking of internal/external roles across US/EU markets with policy monitoring, visa leverage analysis, and tailored pitch generation.

## Overview

This skill orchestrates 3 specialist agents to:
1. **Scout** (researcher) - Crawl job boards and normalize opportunities
2. **RegWatch** (researcher) - Diff EU policy/regulatory pages for visa changes
3. **Ranker** (analyst) - Score opportunities by Fit, Option Value, Speed, Cred Stack
4. **PitchPrep** (coder) - Generate tailored bullets, Q&A, and anecdotes

**Critical differentiator**: Tracks visa leverage and immigration policy changes alongside traditional job factors.

## When to Use

- **Weekly/bi-weekly**: Systematic career opportunity scanning
- **Before major applications**: Generate tailored pitch materials
- **EU policy changes**: Understand immigration implications
- **Strategic planning**: Maintain optionality across geographies

## Assigned Agents

### Primary Agents

**researcher (Scout role)** - Phase 1: Web scraping, data normalization, source aggregation
- Expertise: API integration, data extraction, YAML processing
- Tools: curl, jq, yq, bash scripting
- Output: Raw CSV of opportunities with metadata

**researcher (RegWatch role)** - Phase 2: Policy diff analysis, regulatory monitoring
- Expertise: Document comparison, policy interpretation, change detection
- Tools: diff, git, web scraping
- Output: Policy change summary with action items

### Secondary Agents

**analyst (Ranker role)** - Phase 3: Multi-factor scoring, EV calculation
- Expertise: Scoring algorithms, decision analysis, prioritization
- Tools: Python/Node scoring scripts, statistical analysis
- Output: Ranked opportunities with justifications

**coder (PitchPrep role)** - Phase 4: Content generation, tailoring, formatting
- Expertise: Natural language generation, resume optimization, storytelling
- Tools: Template engines, GPT-assisted writing, markdown formatting
- Output: Tailored cover letters, Q&A prep, cred stack mapping

## Coordination Pattern

```
SKILL: dual-track-career-intelligence
  ↓
hierarchical-coordinator spawns 4 sequential phases
  ↓
Phase 1: Scout (researcher) → raw data
Phase 2: RegWatch (researcher) → policy deltas
Phase 3: Ranker (analyst) → scored opportunities
Phase 4: PitchPrep (coder) → tailored materials
  ↓
All phases coordinate via Memory MCP with WHO/WHEN/PROJECT/WHY tagging
```

---

## Phase 1: Scout (Data Collection)

**Agent**: `researcher` (Scout role)

### Inputs
- `data/sources/job_boards.yml` - Job board APIs and search parameters
- `data/profiles/cv_core.md` - Keywords and skills to match

### Commands Executed

```bash
#!/bin/bash
# Phase 1: Job Board Scanning

# PRE-TASK HOOK
npx claude-flow@alpha hooks pre-task \
  --description "Career intel: job board scanning" \
  --agent "researcher" \
  --role "Scout" \
  --skill "dual-track-career-intelligence"

# SESSION RESTORE (if resuming)
npx claude-flow@alpha hooks session-restore \
  --session-id "career-intel-$(date +%Y-%W)"

# SETUP
WEEK=$(date +%Y-%W)
mkdir -p outputs/reports
mkdir -p raw_data

# READ CONFIG
BOARDS=$(yq eval '.boards[].url' data/sources/job_boards.yml)
KEYWORDS=$(yq eval '.search_keywords | join(",")' data/sources/job_boards.yml)
GEO=$(yq eval '.geo_filters | join(",")' data/sources/job_boards.yml)

# SCRAPE JOB BOARDS
echo "title,company,location,url,posted_date,visa_support,remote_ok,comp_signal" > raw_data/jobs_${WEEK}.csv

for BOARD in $BOARDS; do
  echo "[Scout] Scanning: $BOARD"

  # Example API call (adapt to actual board APIs)
  curl -s "${BOARD}/api/jobs?keywords=${KEYWORDS}&geo=${GEO}" \
    | jq -r '.results[] | [
        .title,
        .company,
        .location,
        .apply_url,
        .posted_date,
        .visa_sponsorship,
        .remote_allowed,
        (.salary.min // 0)
      ] | @csv' \
    >> raw_data/jobs_${WEEK}.csv

  sleep 2  # Rate limiting
done

JOB_COUNT=$(wc -l < raw_data/jobs_${WEEK}.csv)
echo "[Scout] Found $JOB_COUNT opportunities"

# MEMORY STORE (with WHO/WHEN/PROJECT/WHY tagging)
npx claude-flow@alpha memory store \
  --key "life-os/career/opportunities/${WEEK}/raw-data" \
  --value "$(cat raw_data/jobs_${WEEK}.csv)" \
  --metadata "{
    \"WHO\": {
      \"agent\": \"researcher\",
      \"role\": \"Scout\",
      \"category\": \"career-intelligence\",
      \"capabilities\": [\"web-scraping\", \"api-integration\", \"data-normalization\"]
    },
    \"WHEN\": {
      \"iso\": \"$(date -Iseconds)\",
      \"unix\": $(date +%s),
      \"readable\": \"$(date)\"
    },
    \"PROJECT\": \"life-os-career-tracking\",
    \"WHY\": {
      \"intent\": \"research\",
      \"task_type\": \"opportunity-scanning\",
      \"outcome_expected\": \"raw-job-list\",
      \"phase\": \"data-collection\"
    }
  }"

# POST-TASK HOOK
npx claude-flow@alpha hooks post-task \
  --task-id "career-intel-phase1-scout" \
  --metrics "jobs_found=${JOB_COUNT}"

echo "[Scout] Phase 1 complete: $JOB_COUNT opportunities stored"
```

### Outputs
- `raw_data/jobs_{YYYY-WW}.csv` - Normalized job data
- Memory: `life-os/career/opportunities/{YYYY-WW}/raw-data`

---

## Phase 2: RegWatch (Policy Monitoring)

**Agent**: `researcher` (RegWatch role)

### Inputs
- `data/sources/biotech_watch.yml` - EU policy/regulatory URLs
- Previous week's policy snapshot (from memory)

### Commands Executed

```bash
#!/bin/bash
# Phase 2: EU Policy Change Detection

# PRE-TASK HOOK
npx claude-flow@alpha hooks pre-task \
  --description "Career intel: EU policy monitoring" \
  --agent "researcher" \
  --role "RegWatch" \
  --skill "dual-track-career-intelligence"

# SETUP
WEEK=$(date +%Y-%W)
mkdir -p raw_data/policy_snapshots

# READ POLICY SOURCES
POLICY_URLS=$(yq eval '.policy_sources[].url' data/sources/biotech_watch.yml)

# FETCH CURRENT SNAPSHOTS
for URL in $POLICY_URLS; do
  SOURCE_NAME=$(echo $URL | sed 's/[^a-zA-Z0-9]/_/g')

  echo "[RegWatch] Fetching: $URL"
  curl -s "$URL" > "raw_data/policy_snapshots/${SOURCE_NAME}_${WEEK}.html"
done

# RETRIEVE LAST WEEK'S SNAPSHOTS
LAST_WEEK=$(date -d '7 days ago' +%Y-%W)
PREV_SNAPSHOTS=$(npx claude-flow@alpha memory retrieve \
  --key "life-os/career/policy-changes/${LAST_WEEK}/snapshots" \
  2>/dev/null || echo "")

# DIFF DETECTION
echo "# EU Policy Changes - Week $WEEK" > outputs/reports/policy_changes_${WEEK}.md
echo "" >> outputs/reports/policy_changes_${WEEK}.md
echo "## Summary" >> outputs/reports/policy_changes_${WEEK}.md
echo "" >> outputs/reports/policy_changes_${WEEK}.md

CHANGES_DETECTED=0

for SNAPSHOT in raw_data/policy_snapshots/*_${WEEK}.html; do
  BASENAME=$(basename "$SNAPSHOT" _${WEEK}.html)
  PREV_SNAPSHOT="raw_data/policy_snapshots/${BASENAME}_${LAST_WEEK}.html"

  if [[ -f "$PREV_SNAPSHOT" ]]; then
    DIFF_OUTPUT=$(diff -u "$PREV_SNAPSHOT" "$SNAPSHOT" | grep -E '^\+|^-' | grep -v '^+++\|^---')

    if [[ -n "$DIFF_OUTPUT" ]]; then
      CHANGES_DETECTED=$((CHANGES_DETECTED + 1))

      echo "### ${BASENAME}" >> outputs/reports/policy_changes_${WEEK}.md
      echo "" >> outputs/reports/policy_changes_${WEEK}.md
      echo "**Changes detected**: Yes" >> outputs/reports/policy_changes_${WEEK}.md
      echo "" >> outputs/reports/policy_changes_${WEEK}.md
      echo "\`\`\`diff" >> outputs/reports/policy_changes_${WEEK}.md
      echo "$DIFF_OUTPUT" | head -n 20 >> outputs/reports/policy_changes_${WEEK}.md
      echo "\`\`\`" >> outputs/reports/policy_changes_${WEEK}.md
      echo "" >> outputs/reports/policy_changes_${WEEK}.md
      echo "**Action**: Review for visa/immigration impact" >> outputs/reports/policy_changes_${WEEK}.md
      echo "" >> outputs/reports/policy_changes_${WEEK}.md
    fi
  else
    echo "[RegWatch] No baseline for $BASENAME, skipping diff"
  fi
done

echo "[RegWatch] Detected $CHANGES_DETECTED policy changes"

# MEMORY STORE
npx claude-flow@alpha memory store \
  --key "life-os/career/policy-changes/${WEEK}/snapshots" \
  --value "$(ls raw_data/policy_snapshots/*_${WEEK}.html)" \
  --metadata "{
    \"WHO\": {
      \"agent\": \"researcher\",
      \"role\": \"RegWatch\",
      \"capabilities\": [\"policy-monitoring\", \"diff-analysis\", \"regulatory-tracking\"]
    },
    \"WHEN\": {\"iso\": \"$(date -Iseconds)\", \"unix\": $(date +%s)},
    \"PROJECT\": \"life-os-career-tracking\",
    \"WHY\": {
      \"intent\": \"research\",
      \"task_type\": \"policy-change-detection\",
      \"outcome_expected\": \"policy-delta-report\",
      \"phase\": \"regulatory-monitoring\"
    }
  }"

npx claude-flow@alpha memory store \
  --key "life-os/career/policy-changes/${WEEK}/report" \
  --value "$(cat outputs/reports/policy_changes_${WEEK}.md)" \
  --metadata "{\"WHO\": {\"agent\": \"researcher\", \"role\": \"RegWatch\"}, \"WHEN\": {\"iso\": \"$(date -Iseconds)\"}, \"PROJECT\": \"life-os-career-tracking\", \"WHY\": {\"intent\": \"analysis\", \"phase\": \"policy-diffing\"}}"

# POST-TASK HOOK
npx claude-flow@alpha hooks post-task \
  --task-id "career-intel-phase2-regwatch" \
  --metrics "changes_detected=${CHANGES_DETECTED}"

echo "[RegWatch] Phase 2 complete: $CHANGES_DETECTED changes documented"
```

### Outputs
- `outputs/reports/policy_changes_{YYYY-WW}.md` - Policy diff report
- Memory: `life-os/career/policy-changes/{YYYY-WW}/snapshots` + `/report`

---

## Phase 3: Ranker (Opportunity Scoring)

**Agent**: `analyst` (Ranker role)

### Inputs
- Memory: `life-os/career/opportunities/{YYYY-WW}/raw-data`
- `data/profiles/cv_core.md` - Skills for fit scoring

### Commands Executed

```bash
#!/bin/bash
# Phase 3: Multi-Factor Opportunity Ranking

# PRE-TASK HOOK
npx claude-flow@alpha hooks pre-task \
  --description "Career intel: opportunity ranking" \
  --agent "analyst" \
  --role "Ranker" \
  --skill "dual-track-career-intelligence"

# SETUP
WEEK=$(date +%Y-%W)

# RETRIEVE RAW DATA
npx claude-flow@alpha memory retrieve \
  --key "life-os/career/opportunities/${WEEK}/raw-data" \
  > raw_data/jobs_${WEEK}.csv

# READ SKILLS PROFILE
MY_SKILLS=$(grep -A 100 '## Skills' data/profiles/cv_core.md | grep '- ' | sed 's/- //' | tr '\n' ',' | sed 's/,$//')

# SCORING SCRIPT (Node.js for simplicity)
cat > raw_data/score_opportunities.js <<'SCORER'
const fs = require('fs');
const csv = require('csv-parser'); // npm install csv-parser

const mySkills = process.argv[2].toLowerCase().split(',');
const results = [];

fs.createReadStream('raw_data/jobs_' + process.argv[3] + '.csv')
  .pipe(csv())
  .on('data', (row) => {
    // Fit Score (0-100): keyword match in title/company
    const titleLower = row.title.toLowerCase();
    const fitMatches = mySkills.filter(skill => titleLower.includes(skill)).length;
    const fitScore = Math.min(100, (fitMatches / mySkills.length) * 100);

    // Option Value (0-100): visa support + EU location
    let optionValue = 0;
    if (row.visa_support === 'true' || row.visa_support === '1') optionValue += 50;
    if (row.location.includes('EU') || row.location.includes('Netherlands') || row.location.includes('Switzerland')) optionValue += 50;

    // Speed to Apply (0-100): inverse of days since posted
    const daysOld = Math.floor((Date.now() - new Date(row.posted_date).getTime()) / (1000 * 60 * 60 * 24));
    const speedScore = Math.max(0, 100 - (daysOld * 5));

    // Cred Stack (0-100): comp signal proxy
    const compSignal = parseInt(row.comp_signal) || 0;
    const credScore = Math.min(100, (compSignal / 150000) * 100);

    // Weighted Total
    const totalScore = (fitScore * 0.4) + (optionValue * 0.3) + (speedScore * 0.2) + (credScore * 0.1);

    results.push({
      ...row,
      fit_score: fitScore.toFixed(1),
      option_value: optionValue.toFixed(1),
      speed_score: speedScore.toFixed(1),
      cred_score: credScore.toFixed(1),
      total_score: totalScore.toFixed(1)
    });
  })
  .on('end', () => {
    // Sort by total score descending
    results.sort((a, b) => parseFloat(b.total_score) - parseFloat(a.total_score));

    // Output top 15
    console.log(JSON.stringify(results.slice(0, 15), null, 2));
  });
SCORER

# RUN SCORER
node raw_data/score_opportunities.js "$MY_SKILLS" "$WEEK" > raw_data/scored_opportunities_${WEEK}.json

TOP_COUNT=$(jq length raw_data/scored_opportunities_${WEEK}.json)
echo "[Ranker] Scored and ranked $TOP_COUNT opportunities"

# GENERATE MARKDOWN REPORT
cat > outputs/reports/career_intel_${WEEK}.md <<REPORT_HEADER
# Career Intelligence Report - Week $WEEK

**Generated**: $(date)
**Source**: Automated dual-track scanning (US/EU)
**Opportunities Scanned**: $(wc -l < raw_data/jobs_${WEEK}.csv)
**Top Opportunities**: $TOP_COUNT

---

## Top 15 Opportunities

| Rank | Title | Company | Location | Fit | Option | Speed | Cred | Total | Action Deadline | Link |
|------|-------|---------|----------|-----|--------|-------|------|-------|-----------------|------|
REPORT_HEADER

jq -r '.[] | [
  (. | keys | map(select(. == "total_score")) | .[0]),
  .title,
  .company,
  .location,
  .fit_score,
  .option_value,
  .speed_score,
  .cred_score,
  .total_score,
  (. | if .speed_score < 50 then "URGENT" else "Normal" end),
  .url
] | @tsv' raw_data/scored_opportunities_${WEEK}.json \
  | awk 'BEGIN{OFS="|"; rank=1} {print rank++, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11}' \
  >> outputs/reports/career_intel_${WEEK}.md

# APPEND POLICY CHANGES SECTION
echo "" >> outputs/reports/career_intel_${WEEK}.md
echo "---" >> outputs/reports/career_intel_${WEEK}.md
echo "" >> outputs/reports/career_intel_${WEEK}.md
echo "## EU Policy & Regulatory Changes" >> outputs/reports/career_intel_${WEEK}.md
echo "" >> outputs/reports/career_intel_${WEEK}.md

if [[ -f outputs/reports/policy_changes_${WEEK}.md ]]; then
  tail -n +5 outputs/reports/policy_changes_${WEEK}.md >> outputs/reports/career_intel_${WEEK}.md
else
  echo "*No policy changes detected this week*" >> outputs/reports/career_intel_${WEEK}.md
fi

# APPEND FAST PLAYS SECTION
echo "" >> outputs/reports/career_intel_${WEEK}.md
echo "---" >> outputs/reports/career_intel_${WEEK}.md
echo "" >> outputs/reports/career_intel_${WEEK}.md
echo "## 3 Fast Plays (This Week)" >> outputs/reports/career_intel_${WEEK}.md
echo "" >> outputs/reports/career_intel_${WEEK}.md

jq -r '.[0:3] | .[] | "1. **\(.title)** at \(.company) - Score: \(.total_score)\n   - **Why**: Fit=\(.fit_score), Visa=\(.option_value), Urgency=\(.speed_score)\n   - **Action**: [Apply](\(.url)) by " + (if .speed_score < 50 then "**THIS WEEK**" else "end of week" end) + "\n"' \
  raw_data/scored_opportunities_${WEEK}.json \
  >> outputs/reports/career_intel_${WEEK}.md

# MEMORY STORE
npx claude-flow@alpha memory store \
  --key "life-os/career/opportunities/${WEEK}/ranked" \
  --value "$(cat raw_data/scored_opportunities_${WEEK}.json)" \
  --metadata "{
    \"WHO\": {\"agent\": \"analyst\", \"role\": \"Ranker\", \"capabilities\": [\"scoring\", \"prioritization\", \"decision-analysis\"]},
    \"WHEN\": {\"iso\": \"$(date -Iseconds)\", \"unix\": $(date +%s)},
    \"PROJECT\": \"life-os-career-tracking\",
    \"WHY\": {\"intent\": \"analysis\", \"task_type\": \"opportunity-ranking\", \"outcome\": \"prioritized-list\", \"phase\": \"scoring\"}
  }"

# POST-TASK HOOK
npx claude-flow@alpha hooks post-task \
  --task-id "career-intel-phase3-ranker" \
  --metrics "opportunities_ranked=${TOP_COUNT}"

echo "[Ranker] Phase 3 complete: Top $TOP_COUNT opportunities ranked"
```

### Outputs
- `outputs/reports/career_intel_{YYYY-WW}.md` - Comprehensive ranked report
- Memory: `life-os/career/opportunities/{YYYY-WW}/ranked`

---

## Phase 4: PitchPrep (Tailored Messaging)

**Agent**: `coder` (PitchPrep role)

### Inputs
- Memory: `life-os/career/opportunities/{YYYY-WW}/ranked` (top 5)
- `data/profiles/cv_core.md` - Anecdotes and achievements

### Commands Executed

```bash
#!/bin/bash
# Phase 4: Generate Tailored Pitch Materials

# PRE-TASK HOOK
npx claude-flow@alpha hooks pre-task \
  --description "Career intel: tailored pitch generation" \
  --agent "coder" \
  --role "PitchPrep" \
  --skill "dual-track-career-intelligence"

# SETUP
WEEK=$(date +%Y-%W)
mkdir -p outputs/briefs

# RETRIEVE TOP 5 OPPORTUNITIES
npx claude-flow@alpha memory retrieve \
  --key "life-os/career/opportunities/${WEEK}/ranked" \
  | jq '.[0:5]' > raw_data/top5_${WEEK}.json

# READ CV ANECDOTES
CV_ANECDOTES=$(grep -A 200 '## Achievements' data/profiles/cv_core.md)

# GENERATE PITCH FOR EACH TOP OPPORTUNITY
jq -c '.[]' raw_data/top5_${WEEK}.json | while read -r opportunity; do
  ORG=$(echo "$opportunity" | jq -r '.company' | sed 's/[^a-zA-Z0-9]/_/g')
  TITLE=$(echo "$opportunity" | jq -r '.title')
  URL=$(echo "$opportunity" | jq -r '.url')
  FIT=$(echo "$opportunity" | jq -r '.fit_score')

  echo "[PitchPrep] Generating pitch for: $ORG - $TITLE"

  # CREATE PITCH BRIEF
  cat > outputs/briefs/career_pitch_${ORG}.md <<PITCH_TEMPLATE
# Application Pitch: $TITLE at $ORG

**Position**: $TITLE
**Company**: $ORG
**Fit Score**: $FIT/100
**Application URL**: $URL
**Generated**: $(date)

---

## Positioning Statement

**Core Thesis**: [Your unique value proposition for this role]

*Example*: "As someone who bridges AI implementation, systems thinking, and education design, I bring a rare combination that aligns perfectly with $ORG's mission to [inferred mission from job description]."

---

## Tailored Bullets (Top 5)

Use these in cover letter and resume customization:

1. **[Relevant achievement from CV]**
   - *Why it matters*: Demonstrates [required skill from JD]
   - *Proof*: [Link to publication, GitHub, portfolio]

2. **[Cross-domain expertise example]**
   - *Why it matters*: Shows ability to [job requirement]
   - *Proof*: [Concrete evidence]

3. **[Technical credential]**
   - *Why it matters*: Directly applicable to [job responsibility]
   - *Proof*: [Demo, code sample, case study]

4. **[Soft skill / leadership example]**
   - *Why it matters*: Critical for [team/culture fit aspect]
   - *Proof*: [Testimonial, outcome metric]

5. **[Unique differentiator]**
   - *Why it matters*: Sets you apart from typical candidates
   - *Proof*: [Evidence of novelty]

---

## Likely Interview Questions (Top 5)

### Question 1: "Tell me about yourself"
**Recommended approach**:
- Start with polymath framing (AI + biology + education)
- Emphasize cross-domain pattern recognition
- Connect to company's specific challenges

**Practice response**: [Draft 2-minute answer]

---

### Question 2: "Why this role/company?"
**Recommended approach**:
- Reference specific company initiatives (research their recent work)
- Show genuine intellectual alignment, not just job-seeking
- Mention EU/US optionality if relevant

**Practice response**: [Draft answer with company-specific details]

---

### Question 3: "Describe a technical challenge you solved"
**Recommended approach**:
- Pick achievement from CV that matches role requirements
- Use STAR method (Situation, Task, Action, Result)
- Emphasize learning and iteration

**Practice response**: [Draft using specific example]

---

### Question 4: "How do you handle [domain-specific scenario]?"
**Recommended approach**:
- Show systematic thinking (SPARC methodology reference?)
- Demonstrate awareness of trade-offs
- Mention collaborative approach if team role

**Practice response**: [Draft scenario-based answer]

---

### Question 5: "Where do you see yourself in 3-5 years?"
**Recommended approach**:
- Align with company growth trajectory
- Show ambition but not overreach
- Mention continuous learning and impact focus

**Practice response**: [Draft forward-looking answer]

---

## Cred Stack Mapping (3 Anecdotes)

### Anecdote 1: [Title from CV]
**Full story**:
$CV_ANECDOTES

**When to deploy**:
- Behavioral question about [specific skill]
- Technical deep-dive on [domain]
- Cultural fit discussion about [value]

**Impact framing**: "This experience taught me [lesson] which directly applies to [job responsibility]"

---

### Anecdote 2: [Cross-domain example]
**Full story**: [Extract from CV]

**When to deploy**:
- Questions about innovation or creativity
- Discussions of unique perspective
- Why you vs. traditional candidates

**Impact framing**: "My unusual background in [domains] gives me the ability to [unique capability]"

---

### Anecdote 3: [Recent achievement]
**Full story**: [Extract from CV]

**When to deploy**:
- "What have you done recently?"
- Proof of continuous growth
- Demonstration of self-direction

**Impact framing**: "Even outside traditional employment, I've been [actively developing/researching/building]"

---

## Application Checklist

- [ ] Customize resume with top 5 bullets above
- [ ] Write cover letter using positioning statement
- [ ] Prepare 2-minute "tell me about yourself" answer
- [ ] Research company's recent news/publications
- [ ] Identify 2-3 employees to connect with on LinkedIn
- [ ] Prepare 3 questions to ask interviewer
- [ ] Set up Google Alert for company name
- [ ] Document application in tracking system
- [ ] Follow up in 1 week if no response

---

## Unique Angle

**What makes you different for THIS role**:

*[AI-generated suggestion based on CV + job description analysis]*

Example: "Most candidates will come from pure biotech OR pure AI backgrounds. You're one of the few who has published research in both domains (microbiology paper + AI cultural bias work) AND has practical implementation experience (commercial AI courses, workshop delivery). This positions you as a bridge-builder, which is exactly what interdisciplinary teams need."

---

**Next Steps**:
1. Refine bullets based on actual job description deep-read
2. Practice interview questions out loud (record yourself)
3. Apply within [deadline from ranking phase]

**Last updated**: $(date)
**Source**: Dual-track career intelligence skill v1.0.0
PITCH_TEMPLATE

  echo "[PitchPrep] Created: outputs/briefs/career_pitch_${ORG}.md"
done

PITCH_COUNT=$(ls outputs/briefs/career_pitch_*.md 2>/dev/null | wc -l)

# MEMORY STORE
npx claude-flow@alpha memory store \
  --key "life-os/career/pitches/${WEEK}/generated" \
  --value "$(ls outputs/briefs/career_pitch_*.md | xargs -I {} basename {})" \
  --metadata "{
    \"WHO\": {\"agent\": \"coder\", \"role\": \"PitchPrep\", \"capabilities\": [\"content-generation\", \"tailoring\", \"storytelling\"]},
    \"WHEN\": {\"iso\": \"$(date -Iseconds)\", \"unix\": $(date +%s)},
    \"PROJECT\": \"life-os-career-tracking\",
    \"WHY\": {\"intent\": \"implementation\", \"task_type\": \"pitch-generation\", \"outcome\": \"tailored-materials\", \"phase\": \"content-creation\"}
  }"

# POST-TASK HOOK
npx claude-flow@alpha hooks post-task \
  --task-id "career-intel-phase4-pitchprep" \
  --metrics "pitches_generated=${PITCH_COUNT}"

# POST-EDIT HOOK (for each generated file)
for PITCH in outputs/briefs/career_pitch_*.md; do
  npx claude-flow@alpha hooks post-edit \
    --file "$PITCH" \
    --memory-key "life-os/career/pitches/${WEEK}/$(basename $PITCH)"
done

echo "[PitchPrep] Phase 4 complete: $PITCH_COUNT pitch briefs generated"
```

### Outputs
- `outputs/briefs/career_pitch_{org}.md` (one per top 5 opportunity)
- Memory: `life-os/career/pitches/{YYYY-WW}/generated`

---

## Complete Workflow Orchestration

**Master command**: Runs all 4 phases sequentially

```bash
#!/bin/bash
# Master Orchestration: Dual-Track Career Intelligence

set -e  # Exit on error

WEEK=$(date +%Y-%W)

echo "=========================================="
echo "Career Intelligence - Week $WEEK"
echo "=========================================="
echo ""

# OPTIONAL: Initialize swarm coordination
echo "[Coordinator] Initializing hierarchical swarm..."
npx claude-flow@alpha swarm init \
  --topology hierarchical \
  --max-agents 4 \
  --strategy specialized

# SESSION START
npx claude-flow@alpha hooks session-start \
  --session-id "career-intel-${WEEK}"

echo ""
echo "[Phase 1/4] Scout - Job board scanning..."
bash phases/phase1_scout.sh

echo ""
echo "[Phase 2/4] RegWatch - Policy monitoring..."
bash phases/phase2_regwatch.sh

echo ""
echo "[Phase 3/4] Ranker - Opportunity scoring..."
bash phases/phase3_ranker.sh

echo ""
echo "[Phase 4/4] PitchPrep - Tailored pitch generation..."
bash phases/phase4_pitchprep.sh

# SESSION END
npx claude-flow@alpha hooks session-end \
  --session-id "career-intel-${WEEK}" \
  --export-metrics true

echo ""
echo "=========================================="
echo "✓ Career Intelligence Complete"
echo "=========================================="
echo ""
echo "📊 Generated Reports:"
echo "  - outputs/reports/career_intel_${WEEK}.md"
echo "  - outputs/reports/policy_changes_${WEEK}.md"
echo ""
echo "📝 Tailored Pitches:"
ls outputs/briefs/career_pitch_*.md 2>/dev/null | sed 's/^/  - /'
echo ""
echo "🎯 Next Actions:"
jq -r '.[0:3] | .[] | "  - Apply to \(.title) at \(.company) (Score: \(.total_score))"' \
  raw_data/scored_opportunities_${WEEK}.json
echo ""
echo "🔗 Full Report: outputs/reports/career_intel_${WEEK}.md"
```

---

## Usage

### One-Time Setup

```bash
# Create directory structure
mkdir -p data/sources data/profiles outputs/reports outputs/briefs raw_data phases

# Create data source configs
cat > data/sources/job_boards.yml <<SOURCES
boards:
  - name: Indeed
    url: https://api.indeed.com/v1
    type: api
  - name: LinkedIn
    url: https://www.linkedin.com/jobs/search
    type: scrape
  - name: BioSpace
    url: https://www.biospace.com/jobs
    type: scrape

search_keywords:
  - AI
  - biotech
  - systems biology
  - computational biology
  - machine learning
  - education technology

geo_filters:
  - United States
  - Netherlands
  - Switzerland
  - Germany
  - EU

visa_priority: true
remote_ok: true
SOURCES

cat > data/sources/biotech_watch.yml <<WATCH
policy_sources:
  - name: EMA Regulatory
    url: https://www.ema.europa.eu/en/news
    type: regulatory
  - name: FDA Updates
    url: https://www.fda.gov/news-events
    type: regulatory
  - name: Dutch Immigration
    url: https://ind.nl/en/news
    type: visa
  - name: Swiss Work Permits
    url: https://www.sem.admin.ch/sem/en/home.html
    type: visa

update_frequency: weekly
WATCH

# Create CV profile (populate with your actual content)
cat > data/profiles/cv_core.md <<CV
# Core CV Profile

## Skills
- Artificial Intelligence & Machine Learning
- Prompt Engineering & LLM Integration
- Systems Biology & Computational Biology
- Workshop Design & Facilitation
- Research & Technical Writing
- Python, Node.js, Bash scripting

## Achievements

### AI Cultural Bias Research
Published paper co-written with GPT-4 on cultural archetypes in AI language models.
**Impact**: Novel methodology combining AI assistance with academic rigor.
**Proof**: [Link to publication]

### Guild of the Rose
Founded educational workshop business covering AI integration, personal development, and systems thinking.
**Impact**: Successfully delivered 20+ workshops to diverse audiences.
**Proof**: dnyoussef.com/guild

### Microbiology Research
Published work on insect wing nanostructure antibacterial properties.
**Impact**: Contributed to biomimicry and materials science.
**Proof**: [Link to publication]

### Oasis of Rest Podcast
Co-host of podcast promoting deep thinking and systems awareness.
**Impact**: Growing audience seeking intellectual depth.
**Proof**: Spotify, podcast platforms

## Keywords for Matching
AI, machine learning, biotech, computational biology, education, workshops, research, systems thinking, prompt engineering, Python, data science
CV

echo "✓ Setup complete!"
echo "Next: Run ./career_intel_master.sh"
```

### Running the Skill

```bash
# Weekly execution (recommended: Monday AM, Thursday PM)
./career_intel_master.sh

# Or run phases individually
bash phases/phase1_scout.sh
bash phases/phase2_regwatch.sh
bash phases/phase3_ranker.sh
bash phases/phase4_pitchprep.sh
```

---

## Integration Points

### Memory MCP

All agents use WHO/WHEN/PROJECT/WHY tagging:
- **WHO**: Agent name, role, category, capabilities
- **WHEN**: ISO timestamp, Unix timestamp, readable format
- **PROJECT**: `life-os-career-tracking`
- **WHY**: Intent (research/analysis/implementation), task type, expected outcome, phase

### Connascence Analyzer

When `coder` agent generates scoring scripts:
- Auto-invoke connascence analysis
- Flag God Objects, Parameter Bombs
- Ensure NASA compliance (max 6 params, 4-level nesting)

### Hooks Automation

- **Pre-task**: Agent assignment, resource prep, context load
- **Post-task**: Metrics export, session persistence
- **Post-edit**: File tracking, memory updates, neural training

---

## Expected Outcomes

### Week 1 Baseline
- **15-20 opportunities** scanned and ranked
- **1-3 policy changes** detected and analyzed
- **5 tailored pitches** generated
- **Time saved**: 12-15 hours vs. manual search

### Ongoing Performance
- **2 applications/week** with tailored materials
- **90% reduction** in manual job board scanning
- **Early detection** of EU policy changes affecting visa options
- **Improved application quality** through systematic tailoring

### Success Metrics
- **Applications sent**: 2+ per week
- **Interview conversion**: Track ratio (aim for >10%)
- **Time per application**: <30 min with pre-generated pitch
- **EU option awareness**: Zero missed policy deadlines

---

## Troubleshooting

### No jobs found
- Check `data/sources/job_boards.yml` for valid URLs
- Verify API access / rate limits
- Adjust keywords to be less restrictive

### Policy diff errors
- Ensure previous week's snapshots exist
- Check network connectivity to policy sources
- Review diff output for formatting issues

### Low fit scores
- Update `data/profiles/cv_core.md` with more keywords
- Adjust scoring weights in phase3 script
- Expand search keywords in job_boards.yml

### Pitch generation incomplete
- Verify CV anecdotes section exists and is populated
- Check jq syntax for JSON parsing
- Review top 5 opportunities for completeness

---

## Future Enhancements

1. **ML-based scoring**: Train model on past application outcomes
2. **Automated applications**: One-click apply for pre-vetted roles
3. **Network analysis**: LinkedIn connection recommendations
4. **Salary negotiation**: Historical data + market analysis
5. **Interview scheduling**: Calendar integration
6. **Follow-up automation**: Reminder system for unanswered applications

---

**Last updated**: 2025-01-06
**Version**: 1.0.0
**Maintainer**: David Youssef
**License**: Personal use (Life-OS IP)
