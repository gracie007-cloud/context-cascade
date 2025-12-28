---
name: when-finding-high-ev-hackathons-use-ev-optimizer
description: Expected value optimization for hackathons and bounties with judge analysis and MVS generation
allowed-tools: Read, Write, Edit, Bash, Task, TodoWrite, Glob, Grep
---

# Hackathon EV Optimizer

Expected Value (EV) calculator for hackathons and bounties. Optimizes for prize × p(win) − time_cost with judge fit analysis and past win pattern learning.

## Overview

This skill orchestrates 3 specialist agents to:
1. **Collector** (researcher) - Scrape hackathon/bounty listings, normalize metadata
2. **EVCalc** (analyst) - Calculate expected value: (prize × p_win) − time_cost
3. **TeamBuilder** (researcher) - Identify skill gaps, generate outreach drafts
4. **SubmissionKit** (coder) - Auto-generate README, demo script, form fills

**Critical differentiator**: Learns from your past project wins to estimate p(win) for new competitions.

## When to Use

- **Weekly**: Scan for new hackathons/bounties (Monday, Thursday)
- **Before commitment**: Calculate EV before dedicating 48 hours
- **Team formation**: Identify skill gaps and potential collaborators
- **Quick wins**: Find high-EV, low-time-cost opportunities

## Assigned Agents

### Primary Agents

**researcher (Collector role)** - Phase 1: Web scraping, metadata extraction, judge research
- Expertise: API integration, web crawling, YAML processing
- Tools: curl, puppeteer, jq, yq
- Output: Normalized hackathon CSV with prizes, themes, judges, deadlines

**analyst (EVCalc role)** - Phase 2: Probability estimation, EV calculation, risk analysis
- Expertise: Statistical modeling, decision analysis, pattern matching
- Tools: Python/Node scoring, similarity algorithms, historical analysis
- Output: Ranked opportunities with EV justifications

### Secondary Agents

**researcher (TeamBuilder role)** - Phase 3: Skill gap analysis, network mapping
- Expertise: Competency mapping, collaboration strategy
- Tools: LinkedIn API, GitHub analysis, outreach templates
- Output: Team composition recommendations + outreach emails

**coder (SubmissionKit role)** - Phase 4: Automation, template generation, form filling
- Expertise: Boilerplate generation, documentation, automation
- Tools: Template engines, README generators, form auto-fill scripts
- Output: MVS (Minimum Viable Submission) package

## Coordination Pattern

```
SKILL: hackathon-ev-optimizer
  ↓
hierarchical-coordinator spawns 4 sequential phases
  ↓
Phase 1: Collector (researcher) → raw hackathon data
Phase 2: EVCalc (analyst) → EV-ranked opportunities
Phase 3: TeamBuilder (researcher) → skill gaps + outreach
Phase 4: SubmissionKit (coder) → MVS packages for top 3
  ↓
All phases coordinate via Memory MCP with WHO/WHEN/PROJECT/WHY tagging
```

---

## Phase 1: Collector (Hackathon Scanning)

**Agent**: `researcher` (Collector role)

### Inputs
- `data/sources/hackathons.yml` - Hackathon aggregators, bounty platforms
- Web scraping targets (DevPost, Gitcoin, DoraHacks, etc.)

### Commands Executed

```bash
#!/bin/bash
# Phase 1: Hackathon Data Collection

# PRE-TASK HOOK
npx claude-flow@alpha hooks pre-task \
  --description "Hackathon EV: opportunity scanning" \
  --agent "researcher" \
  --role "Collector" \
  --skill "hackathon-ev-optimizer"

# SESSION RESTORE
npx claude-flow@alpha hooks session-restore \
  --session-id "hackathon-ev-$(date +%Y-%W)"

# SETUP
WEEK=$(date +%Y-%W)
mkdir -p outputs/reports outputs/briefs raw_data/hackathons

# READ SOURCES
PLATFORMS=$(yq eval '.platforms[].url' data/sources/hackathons.yml)

echo "slug,name,theme,prize_pool,top_prize,deadline,location,judges,deliverables,url,posted_date" > raw_data/hackathons/events_${WEEK}.csv

# SCRAPE PLATFORMS
for PLATFORM in $PLATFORMS; do
  echo "[Collector] Scanning: $PLATFORM"

  # Example: DevPost API (adapt to actual endpoints)
  if [[ $PLATFORM == *"devpost"* ]]; then
    curl -s "https://devpost.com/api/hackathons?status[]=upcoming&status[]=open" \
      | jq -r '.hackathons[] | [
          .slug,
          .title,
          .themes[0].name,
          (.prizes | map(.amount) | add // 0),
          (.prizes | max_by(.amount).amount // 0),
          .submission_period_ends,
          .location,
          (.judges | map(.name) | join(";")),
          .requirements,
          .url,
          .published_at
        ] | @csv' \
      >> raw_data/hackathons/events_${WEEK}.csv
  fi

  # Example: Gitcoin Bounties
  if [[ $PLATFORM == *"gitcoin"* ]]; then
    curl -s "https://gitcoin.co/api/v0.1/bounties/?is_open=True" \
      | jq -r '.[] | [
          .id,
          .title,
          .keywords[0],
          .value_in_usdt,
          .value_in_usdt,
          .expires_date,
          "Remote",
          "",
          .issue_description,
          .url,
          .created_on
        ] | @csv' \
      >> raw_data/hackathons/events_${WEEK}.csv
  fi

  # Example: DoraHacks
  if [[ $PLATFORM == *"dorahacks"* ]]; then
    curl -s "https://dorahacks.io/api/buidl/grants?status=active" \
      | jq -r '.data[] | [
          .id,
          .name,
          .category,
          .total_amount,
          .max_award,
          .end_time,
          "Hybrid",
          "",
          .description,
          ("https://dorahacks.io/buidl/" + .id),
          .start_time
        ] | @csv' \
      >> raw_data/hackathons/events_${WEEK}.csv
  fi

  sleep 3  # Rate limiting
done

EVENT_COUNT=$(tail -n +2 raw_data/hackathons/events_${WEEK}.csv | wc -l)
echo "[Collector] Found $EVENT_COUNT hackathons/bounties"

# JUDGE RESEARCH (for top 20 by prize)
echo "[Collector] Researching judges for top opportunities..."

tail -n +2 raw_data/hackathons/events_${WEEK}.csv \
  | sort -t',' -k4 -nr \
  | head -n 20 \
  | while IFS=',' read -r slug name theme prize top deadline location judges deliverables url posted; do
      if [[ -n "$judges" ]]; then
        echo "[Collector] Judges for $slug: $judges"

        # Store judge profiles for similarity matching
        echo "$judges" | tr ';' '\n' | while read -r judge; do
          # Placeholder: In production, scrape LinkedIn/Twitter for judge expertise
          echo "$slug,$judge,AI|biotech|systems" >> raw_data/hackathons/judge_profiles_${WEEK}.csv
        done
      fi
    done

# MEMORY STORE
npx claude-flow@alpha memory store \
  --key "life-os/hackathons/${WEEK}/opportunities" \
  --value "$(cat raw_data/hackathons/events_${WEEK}.csv)" \
  --metadata "{
    \"WHO\": {
      \"agent\": \"researcher\",
      \"role\": \"Collector\",
      \"category\": \"revenue-generation\",
      \"capabilities\": [\"web-scraping\", \"api-integration\", \"judge-research\"]
    },
    \"WHEN\": {
      \"iso\": \"$(date -Iseconds)\",
      \"unix\": $(date +%s),
      \"readable\": \"$(date)\"
    },
    \"PROJECT\": \"life-os-hackathon-optimization\",
    \"WHY\": {
      \"intent\": \"research\",
      \"task_type\": \"opportunity-scanning\",
      \"outcome_expected\": \"raw-hackathon-list\",
      \"phase\": \"data-collection\"
    }
  }"

# POST-TASK HOOK
npx claude-flow@alpha hooks post-task \
  --task-id "hackathon-ev-phase1-collector" \
  --metrics "events_found=${EVENT_COUNT}"

echo "[Collector] Phase 1 complete: $EVENT_COUNT events stored"
```

### Outputs
- `raw_data/hackathons/events_{YYYY-WW}.csv` - Normalized event data
- `raw_data/hackathons/judge_profiles_{YYYY-WW}.csv` - Judge expertise tags
- Memory: `life-os/hackathons/{YYYY-WW}/opportunities`

---

## Phase 2: EVCalc (Expected Value Calculation)

**Agent**: `analyst` (EVCalc role)

### Inputs
- Memory: `life-os/hackathons/{YYYY-WW}/opportunities`
- `data/profiles/case_studies.md` - Past project wins for similarity matching

### Commands Executed

```bash
#!/bin/bash
# Phase 2: Expected Value Calculation

# PRE-TASK HOOK
npx claude-flow@alpha hooks pre-task \
  --description "Hackathon EV: probability estimation" \
  --agent "analyst" \
  --role "EVCalc" \
  --skill "hackathon-ev-optimizer"

# SETUP
WEEK=$(date +%Y-%W)

# RETRIEVE HACKATHON DATA
npx claude-flow@alpha memory retrieve \
  --key "life-os/hackathons/${WEEK}/opportunities" \
  > raw_data/hackathons/events_${WEEK}.csv

# READ CASE STUDIES (past wins)
CASE_STUDIES=$(grep -A 500 '## Past Projects' data/profiles/case_studies.md)

# EV CALCULATION SCRIPT
cat > raw_data/hackathons/calculate_ev.js <<'EVCALC'
const fs = require('fs');
const csv = require('csv-parser');

// Read case studies (simplified - in production, parse markdown properly)
const caseStudies = process.argv[2].split('\n')
  .filter(line => line.includes('###'))
  .map(line => {
    const match = line.match(/###\s+(.+)/);
    return match ? match[1].toLowerCase() : '';
  })
  .filter(Boolean);

console.error('[EVCalc] Past projects:', caseStudies.join(', '));

const results = [];

fs.createReadStream('raw_data/hackathons/events_' + process.argv[3] + '.csv')
  .pipe(csv())
  .on('data', (row) => {
    const theme = row.theme.toLowerCase();
    const topPrize = parseFloat(row.top_prize) || 0;
    const deadline = new Date(row.deadline);
    const daysUntil = Math.floor((deadline - Date.now()) / (1000 * 60 * 60 * 24));

    // PROBABILITY ESTIMATION
    // p(win) = similarity to past wins × judge alignment × skill coverage

    // Similarity score (0-1): keyword overlap with case studies
    const themeWords = theme.split(/\s+/);
    const similarityMatches = themeWords.filter(word =>
      caseStudies.some(project => project.includes(word))
    ).length;
    const similarityScore = Math.min(1, similarityMatches / Math.max(1, themeWords.length));

    // Judge alignment (0-1): placeholder - in production, match judge expertise to your profile
    const judgeAlignment = 0.5; // Default 50%

    // Skill coverage (0-1): deliverables match your capabilities
    const deliverables = row.deliverables.toLowerCase();
    const hasRequiredSkills =
      (deliverables.includes('ai') || deliverables.includes('ml')) &&
      (deliverables.includes('demo') || deliverables.includes('prototype'));
    const skillCoverage = hasRequiredSkills ? 0.8 : 0.4;

    // Combined probability (conservative)
    const p_win = (similarityScore * 0.4) + (judgeAlignment * 0.3) + (skillCoverage * 0.3);

    // TIME COST ESTIMATION
    // Base: 48 hours for hackathon, 20 hours for bounty
    const isHackathon = row.location !== 'Remote' || row.name.toLowerCase().includes('hackathon');
    const timeHours = isHackathon ? 48 : 20;
    const hourlyValue = 75; // Your opportunity cost ($/hour)
    const timeCost = timeHours * hourlyValue;

    // EXPECTED VALUE
    const EV = (topPrize * p_win) - timeCost;

    // RISK FLAGS
    const riskFlags = [];
    if (daysUntil < 7) riskFlags.push('SHORT_NOTICE');
    if (topPrize < 5000) riskFlags.push('LOW_PRIZE');
    if (p_win < 0.2) riskFlags.push('LOW_WIN_PROB');
    if (timeHours > 40) riskFlags.push('HIGH_TIME_COST');

    results.push({
      ...row,
      p_win: p_win.toFixed(3),
      time_hours: timeHours,
      time_cost: timeCost,
      ev: EV.toFixed(2),
      ev_per_hour: (EV / timeHours).toFixed(2),
      days_until: daysUntil,
      risk_flags: riskFlags.join('|'),
      rationale: `Similarity=${(similarityScore*100).toFixed(0)}%, Judge=${(judgeAlignment*100).toFixed(0)}%, Skills=${(skillCoverage*100).toFixed(0)}%`
    });
  })
  .on('end', () => {
    // Sort by EV descending
    results.sort((a, b) => parseFloat(b.ev) - parseFloat(a.ev));

    // Output top 20
    console.log(JSON.stringify(results.slice(0, 20), null, 2));
  });
EVCALC

# RUN EV CALCULATOR
node raw_data/hackathons/calculate_ev.js "$CASE_STUDIES" "$WEEK" \
  > raw_data/hackathons/ev_ranked_${WEEK}.json

RANKED_COUNT=$(jq length raw_data/hackathons/ev_ranked_${WEEK}.json)
echo "[EVCalc] Ranked $RANKED_COUNT opportunities by EV"

# GENERATE MARKDOWN REPORT
cat > outputs/reports/hackathons_${WEEK}.md <<REPORT_HEADER
# Hackathon EV Report - Week $WEEK

**Generated**: $(date)
**Source**: Automated multi-platform scanning
**Total Scanned**: $(tail -n +2 raw_data/hackathons/events_${WEEK}.csv | wc -l)
**High-EV Opportunities**: $RANKED_COUNT

---

## Top 20 by Expected Value

| Rank | Event | Theme | Prize | p(win) | Time | EV | EV/hr | Deadline | Risks | Link |
|------|-------|-------|-------|--------|------|----|----|----------|-------|------|
REPORT_HEADER

jq -r '.[] | [
  .name,
  .theme,
  "$" + .top_prize,
  (.p_win | tonumber * 100 | tostring + "%"),
  .time_hours + "h",
  "$" + .ev,
  "$" + .ev_per_hour,
  .days_until + "d",
  .risk_flags,
  .url
] | @tsv' raw_data/hackathons/ev_ranked_${WEEK}.json \
  | awk 'BEGIN{OFS="|"; rank=1} {print rank++, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10}' \
  >> outputs/reports/hackathons_${WEEK}.md

# APPEND EV METHODOLOGY
cat >> outputs/reports/hackathons_${WEEK}.md <<'METHODOLOGY'

---

## EV Calculation Methodology

**Formula**: EV = (Prize × p(win)) − Time Cost

**p(win) estimation**:
- 40%: Similarity to past projects (keyword overlap)
- 30%: Judge alignment (expertise match)
- 30%: Skill coverage (deliverables feasibility)

**Time cost**:
- Hackathons: 48 hours @ $75/hr = $3,600
- Bounties: 20 hours @ $75/hr = $1,500

**Risk flags**:
- SHORT_NOTICE: <7 days to deadline
- LOW_PRIZE: <$5,000 top prize
- LOW_WIN_PROB: <20% estimated win probability
- HIGH_TIME_COST: >40 hours required

---

## Recommended Action

### Immediate Priorities (EV > $1,000)
METHODOLOGY

jq -r '.[] | select(.ev | tonumber > 1000) | "- **\(.name)** (EV: $\(.ev), Deadline: \(.days_until)d)\n  - **Rationale**: \(.rationale)\n  - **Action**: Review deliverables, form team if needed\n"' \
  raw_data/hackathons/ev_ranked_${WEEK}.json \
  >> outputs/reports/hackathons_${WEEK}.md

cat >> outputs/reports/hackathons_${WEEK}.md <<'FOOTER'

### Watch List (EV $500-$1,000)
Consider if time allows or theme strongly aligns.

### Skip (EV < $500)
Opportunity cost too high - focus on higher-EV options or direct client work.

---

**Next Steps**:
1. Review top 3 deliverables in detail
2. Assess skill gaps and team needs
3. Generate MVS (Minimum Viable Submission) plan
4. Commit or skip decision by EOD

**Last updated**: FOOTER
echo "$(date)" >> outputs/reports/hackathons_${WEEK}.md

# MEMORY STORE
npx claude-flow@alpha memory store \
  --key "life-os/hackathons/${WEEK}/ev-ranked" \
  --value "$(cat raw_data/hackathons/ev_ranked_${WEEK}.json)" \
  --metadata "{
    \"WHO\": {\"agent\": \"analyst\", \"role\": \"EVCalc\", \"capabilities\": [\"probability-estimation\", \"ev-calculation\", \"risk-analysis\"]},
    \"WHEN\": {\"iso\": \"$(date -Iseconds)\", \"unix\": $(date +%s)},
    \"PROJECT\": \"life-os-hackathon-optimization\",
    \"WHY\": {\"intent\": \"analysis\", \"task_type\": \"ev-ranking\", \"outcome\": \"prioritized-opportunities\", \"phase\": \"scoring\"}
  }"

# POST-TASK HOOK
npx claude-flow@alpha hooks post-task \
  --task-id "hackathon-ev-phase2-evcalc" \
  --metrics "high_ev_count=$(jq '[.[] | select(.ev | tonumber > 1000)] | length' raw_data/hackathons/ev_ranked_${WEEK}.json)"

echo "[EVCalc] Phase 2 complete: $RANKED_COUNT opportunities ranked"
```

### Outputs
- `outputs/reports/hackathons_{YYYY-WW}.md` - EV-ranked report
- Memory: `life-os/hackathons/{YYYY-WW}/ev-ranked`

---

## Phase 3: TeamBuilder (Skill Gap Analysis)

**Agent**: `researcher` (TeamBuilder role)

### Inputs
- Memory: `life-os/hackathons/{YYYY-WW}/ev-ranked` (top 3)
- `data/profiles/cv_core.md` - Your skills inventory

### Commands Executed

```bash
#!/bin/bash
# Phase 3: Team Formation & Skill Gap Analysis

# PRE-TASK HOOK
npx claude-flow@alpha hooks pre-task \
  --description "Hackathon EV: team building" \
  --agent "researcher" \
  --role "TeamBuilder" \
  --skill "hackathon-ev-optimizer"

# SETUP
WEEK=$(date +%Y-%W)
mkdir -p outputs/briefs/teams

# RETRIEVE TOP 3 OPPORTUNITIES
npx claude-flow@alpha memory retrieve \
  --key "life-os/hackathons/${WEEK}/ev-ranked" \
  | jq '.[0:3]' > raw_data/hackathons/top3_${WEEK}.json

# READ YOUR SKILLS
MY_SKILLS=$(grep -A 100 '## Skills' data/profiles/cv_core.md | grep '- ' | sed 's/- //')

# ANALYZE EACH OPPORTUNITY
jq -c '.[]' raw_data/hackathons/top3_${WEEK}.json | while read -r event; do
  SLUG=$(echo "$event" | jq -r '.slug')
  NAME=$(echo "$event" | jq -r '.name')
  DELIVERABLES=$(echo "$event" | jq -r '.deliverables')

  echo "[TeamBuilder] Analyzing: $SLUG"

  # SKILL GAP DETECTION (simple keyword matching)
  cat > outputs/briefs/teams/${SLUG}_team_analysis.md <<TEAM_HEADER
# Team Analysis: $NAME

**Event**: $NAME
**Slug**: $SLUG
**EV**: \$$(echo "$event" | jq -r '.ev')
**Deadline**: $(echo "$event" | jq -r '.days_until') days

---

## Required Skills (from deliverables)

TEAM_HEADER

  # Extract skill requirements
  echo "$DELIVERABLES" | tr ',' '\n' | while read -r req; do
    echo "- $req" >> outputs/briefs/teams/${SLUG}_team_analysis.md
  done

  cat >> outputs/briefs/teams/${SLUG}_team_analysis.md <<'GAPS'

---

## Your Skills Coverage

GAPS

  # Check which skills you have
  echo "$MY_SKILLS" | while read -r skill; do
    if echo "$DELIVERABLES" | grep -qi "$skill"; then
      echo "- ✓ **$skill** (covered)" >> outputs/briefs/teams/${SLUG}_team_analysis.md
    else
      echo "- $skill" >> outputs/briefs/teams/${SLUG}_team_analysis.md
    fi
  done

  cat >> outputs/briefs/teams/${SLUG}_team_analysis.md <<'RECOMMENDATIONS'

---

## Skill Gaps & Team Needs

**Analysis**: Based on deliverables vs. your profile

RECOMMENDATIONS

  # Identify gaps (placeholder - in production, use more sophisticated analysis)
  if echo "$DELIVERABLES" | grep -qi "frontend"; then
    echo "- **Gap**: Frontend development (React/Vue)" >> outputs/briefs/teams/${SLUG}_team_analysis.md
    echo "  - **Recommendation**: Find UI/UX specialist" >> outputs/briefs/teams/${SLUG}_team_analysis.md
    echo "  - **Outreach channels**: LinkedIn, Discord, Twitter" >> outputs/briefs/teams/${SLUG}_team_analysis.md
  fi

  if echo "$DELIVERABLES" | grep -qi "blockchain"; then
    echo "- **Gap**: Smart contract development" >> outputs/briefs/teams/${SLUG}_team_analysis.md
    echo "  - **Recommendation**: Find Web3 developer" >> outputs/briefs/teams/${SLUG}_team_analysis.md
    echo "  - **Outreach channels**: ETHGlobal Discord, BuildSpace" >> outputs/briefs/teams/${SLUG}_team_analysis.md
  fi

  if echo "$DELIVERABLES" | grep -qi "mobile"; then
    echo "- **Gap**: Mobile development (iOS/Android)" >> outputs/briefs/teams/${SLUG}_team_analysis.md
    echo "  - **Recommendation**: Find mobile engineer" >> outputs/briefs/teams/${SLUG}_team_analysis.md
    echo "  - **Outreach channels**: React Native community, Flutter Discord" >> outputs/briefs/teams/${SLUG}_team_analysis.md
  fi

  cat >> outputs/briefs/teams/${SLUG}_team_analysis.md <<OUTREACH_TEMPLATE
---

## Outreach Email Template

**Subject**: Hackathon Team Formation - $NAME

---

Hi [Name],

I'm assembling a team for **$NAME** (deadline: $(echo "$event" | jq -r '.days_until') days) and saw your work on [specific project].

**The opportunity**:
- Theme: $(echo "$event" | jq -r '.theme')
- Prize: \$$(echo "$event" | jq -r '.top_prize')
- My EV estimate: \$$(echo "$event" | jq -r '.ev') ($(echo "$event" | jq -r '.p_win | tonumber * 100')% win probability)

**Your role**: [Specific skill gap you'd fill]

**My contribution**: AI/ML implementation, systems design, research-backed approach

**Time commitment**: ~$(echo "$event" | jq -r '.time_hours') hours over [timeframe]

Interested in collaborating? Happy to jump on a quick call to discuss.

Best,
David Youssef
dnyoussef.com

---

OUTREACH_TEMPLATE

  echo "[TeamBuilder] Created: outputs/briefs/teams/${SLUG}_team_analysis.md"
done

TEAM_ANALYSIS_COUNT=$(ls outputs/briefs/teams/*_team_analysis.md 2>/dev/null | wc -l)

# POST-TASK HOOK
npx claude-flow@alpha hooks post-task \
  --task-id "hackathon-ev-phase3-teambuilder" \
  --metrics "team_analyses=${TEAM_ANALYSIS_COUNT}"

echo "[TeamBuilder] Phase 3 complete: $TEAM_ANALYSIS_COUNT team analyses created"
```

### Outputs
- `outputs/briefs/teams/{slug}_team_analysis.md` - Skill gaps + outreach templates

---

## Phase 4: SubmissionKit (MVS Generation)

**Agent**: `coder` (SubmissionKit role)

### Inputs
- Memory: `life-os/hackathons/{YYYY-WW}/ev-ranked` (top 3)

### Commands Executed

```bash
#!/bin/bash
# Phase 4: Minimum Viable Submission (MVS) Package Generation

# PRE-TASK HOOK
npx claude-flow@alpha hooks pre-task \
  --description "Hackathon EV: MVS generation" \
  --agent "coder" \
  --role "SubmissionKit" \
  --skill "hackathon-ev-optimizer"

# SETUP
WEEK=$(date +%Y-%W)
mkdir -p outputs/briefs/mvs

# RETRIEVE TOP 3
npx claude-flow@alpha memory retrieve \
  --key "life-os/hackathons/${WEEK}/ev-ranked" \
  | jq '.[0:3]' > raw_data/hackathons/top3_${WEEK}.json

# GENERATE MVS FOR EACH
jq -c '.[]' raw_data/hackathons/top3_${WEEK}.json | while read -r event; do
  SLUG=$(echo "$event" | jq -r '.slug')
  NAME=$(echo "$event" | jq -r '.name')
  THEME=$(echo "$event" | jq -r '.theme')
  DEADLINE=$(echo "$event" | jq -r '.deadline')

  echo "[SubmissionKit] Generating MVS for: $SLUG"

  # CREATE MVS BRIEF
  cat > outputs/briefs/mvs/h_${SLUG}_MVS.md <<MVS_HEADER
# Minimum Viable Submission: $NAME

**Event**: $NAME
**Theme**: $THEME
**Deadline**: $DEADLINE
**EV**: \$$(echo "$event" | jq -r '.ev')
**Generated**: $(date)

---

## 24-Hour Plan

### Hour 0-4: Research & Planning
- [ ] Deep-read hackathon requirements and judging criteria
- [ ] Review past winning submissions (DevPost/GitHub)
- [ ] Finalize tech stack (bias toward what you know)
- [ ] Create project skeleton (README, repo structure)
- [ ] Set up dev environment and dependencies

### Hour 4-12: Core Implementation
- [ ] Implement MVP feature set (focus on demo-ability)
- [ ] Build proof-of-concept for most impressive feature
- [ ] Integrate AI/ML component if theme-relevant
- [ ] Create basic UI/dashboard (even if CLI)
- [ ] Commit progress regularly (backup strategy)

### Hour 12-18: Polish & Demo Prep
- [ ] Add error handling and edge case coverage
- [ ] Create demo dataset/examples
- [ ] Record demo video (2-3 minutes, script it)
- [ ] Write compelling README with screenshots
- [ ] Prepare judging criteria mapping document

### Hour 18-24: Submission & Presentation
- [ ] Final testing and bug fixes
- [ ] Deploy to public URL (Vercel/Netlify/Replit)
- [ ] Complete submission form (auto-fill where possible)
- [ ] Submit 2 hours before deadline (buffer for issues)
- [ ] Tweet/post about submission (social proof)

---

## Repository Skeleton Checklist

\`\`\`
${SLUG}/
├── README.md                 # ✓ Compelling overview, demo video, screenshots
├── JUDGING_CRITERIA.md       # ✓ Map features to scoring rubric
├── docs/
│   ├── ARCHITECTURE.md       # ✓ System design (impress technical judges)
│   ├── DEMO_SCRIPT.md        # ✓ Walkthrough for video recording
│   └── API.md                # ✓ If applicable
├── src/
│   ├── main.*                # ✓ Entry point
│   ├── core/                 # ✓ Business logic
│   └── utils/                # ✓ Helpers
├── tests/                    # ✓ At least smoke tests
├── .env.example              # ✓ Configuration template
├── package.json / requirements.txt
└── LICENSE                   # ✓ Open source (if allowed)
\`\`\`

---

## Judging Criteria Mapping

$(echo "$event" | jq -r '.deliverables' | tr ',' '\n' | while read -r criterion; do
  echo "### $criterion"
  echo ""
  echo "**Your approach**:"
  echo "- [How you'll address this criterion]"
  echo "- [Specific feature/demo that proves it]"
  echo "- [Evidence/metrics to show success]"
  echo ""
done)

---

## Demo Storyboard (2-3 min video)

**0:00-0:15 - Hook**
- "Imagine you're a [target user] facing [problem]..."
- Show the pain point visually
- Tease the solution

**0:15-0:45 - Solution Overview**
- "We built [project name] to solve this using [key innovation]"
- Quick architecture diagram or visual
- Highlight unique angle (AI, systems thinking, cross-domain)

**0:45-2:00 - Core Demo**
- Walkthrough of main workflow (3-5 steps max)
- Show most impressive feature in action
- Real data/example that resonates with judges

**2:00-2:30 - Technical Depth**
- Brief architecture explanation (if technical judges)
- Mention tech stack and why (show thought process)
- Highlight scalability or innovation

**2:30-3:00 - Impact & Vision**
- Quantify impact (time saved, cost reduced, users helped)
- Future roadmap (if we had more time...)
- Call to action (try it, star repo, connect)

---

## Submission Form Auto-Fill

**Project Name**: [Catchy name related to theme]

**Tagline** (1 sentence): "We [verb] [problem] for [audience] using [innovation]"

**Description** (3 paragraphs):
1. **Problem**: What pain point does this solve? Who faces it?
2. **Solution**: How does your project address it? What's unique?
3. **Impact**: What's the potential? Why does it matter?

**Tech Stack**:
- Frontend: [e.g., React, Next.js]
- Backend: [e.g., Node.js, Python/FastAPI]
- AI/ML: [e.g., OpenAI API, Hugging Face, custom models]
- Database: [e.g., PostgreSQL, MongoDB]
- Deployment: [e.g., Vercel, AWS, Replit]

**Challenges**:
- [Specific technical hurdle you overcame]
- [How you learned something new during the hackathon]
- [Trade-off decision you made and why]

**Accomplishments**:
- [Quantified achievement, e.g., "Processed 10k records in <2s"]
- [Novel integration or approach]
- [Working MVP in 24 hours]

**What we learned**:
- [Technical learning]
- [Domain learning]
- [Team collaboration learning if applicable]

**What's next**:
- [Feature roadmap]
- [Scaling plan]
- [Potential users or customers]

---

## Risk Mitigation

**If behind schedule**:
- Cut scope ruthlessly (demo > features)
- Focus on one killer feature vs. many mediocre ones
- Pre-record demo early (can edit later)
- Submit SOMETHING even if incomplete

**If technical blockers**:
- Switch to simpler tech stack you know
- Use third-party APIs instead of building from scratch
- Mock/hardcode data if integration fails
- Document the intended approach in README

**If team coordination issues**:
- Establish clear ownership early
- Use feature branches and PRs
- Over-communicate via Discord/Slack
- Have backup plan for solo completion

---

## Post-Submission Actions

- [ ] Tweet about submission with demo link
- [ ] Post in hackathon Discord/Slack
- [ ] Star and watch competitor projects (networking)
- [ ] Prepare 1-min pitch for potential sponsor calls
- [ ] Document lessons learned for next time
- [ ] Update case_studies.md with project (win or lose)

---

**Next Steps**:
1. Review this MVS plan and adjust based on your strengths
2. Decide GO/NO-GO based on EV, time availability, team formation
3. If GO: Block calendar, inform stakeholders, commit fully
4. If NO-GO: Keep on watch list, wait for better opportunity

**Last updated**: $(date)
**Source**: Hackathon EV Optimizer v1.0.0
MVS_HEADER

  echo "[SubmissionKit] Created: outputs/briefs/mvs/h_${SLUG}_MVS.md"
done

MVS_COUNT=$(ls outputs/briefs/mvs/h_*_MVS.md 2>/dev/null | wc -l)

# MEMORY STORE
npx claude-flow@alpha memory store \
  --key "life-os/hackathons/mvs/${WEEK}/generated" \
  --value "$(ls outputs/briefs/mvs/h_*_MVS.md | xargs -I {} basename {})" \
  --metadata "{
    \"WHO\": {\"agent\": \"coder\", \"role\": \"SubmissionKit\", \"capabilities\": [\"template-generation\", \"automation\", \"documentation\"]},
    \"WHEN\": {\"iso\": \"$(date -Iseconds)\", \"unix\": $(date +%s)},
    \"PROJECT\": \"life-os-hackathon-optimization\",
    \"WHY\": {\"intent\": \"implementation\", \"task_type\": \"mvs-generation\", \"outcome\": \"submission-packages\", \"phase\": \"automation\"}
  }"

# POST-TASK HOOK
npx claude-flow@alpha hooks post-task \
  --task-id "hackathon-ev-phase4-submissionkit" \
  --metrics "mvs_generated=${MVS_COUNT}"

# POST-EDIT HOOKS
for MVS in outputs/briefs/mvs/h_*_MVS.md; do
  npx claude-flow@alpha hooks post-edit \
    --file "$MVS" \
    --memory-key "life-os/hackathons/mvs/$(basename $MVS)"
done

echo "[SubmissionKit] Phase 4 complete: $MVS_COUNT MVS packages created"
```

### Outputs
- `outputs/briefs/mvs/h_{slug}_MVS.md` - Complete 24-hour execution plan

---

## Master Orchestration + Scheduling

```bash
#!/bin/bash
# Master: Hackathon EV Optimizer with Scheduled Execution

set -e

WEEK=$(date +%Y-%W)
DAY=$(date +%A)

echo "=========================================="
echo "Hackathon EV Optimizer - Week $WEEK ($DAY)"
echo "=========================================="
echo ""

# Check if scheduled run (Monday or Thursday)
if [[ "$DAY" != "Monday" && "$DAY" != "Thursday" && "$1" != "--force" ]]; then
  echo "⏭️  Skipping: Scheduled for Monday/Thursday only"
  echo "   Use --force to run manually"
  exit 0
fi

# SESSION START
npx claude-flow@alpha hooks session-start \
  --session-id "hackathon-ev-${WEEK}"

echo ""
echo "[Phase 1/4] Collector - Scanning hackathon platforms..."
bash phases/phase1_collector.sh

echo ""
echo "[Phase 2/4] EVCalc - Calculating expected values..."
bash phases/phase2_evcalc.sh

echo ""
echo "[Phase 3/4] TeamBuilder - Analyzing skill gaps..."
bash phases/phase3_teambuilder.sh

echo ""
echo "[Phase 4/4] SubmissionKit - Generating MVS packages..."
bash phases/phase4_submissionkit.sh

# SESSION END
npx claude-flow@alpha hooks session-end \
  --session-id "hackathon-ev-${WEEK}" \
  --export-metrics true

echo ""
echo "=========================================="
echo "✓ Hackathon EV Optimization Complete"
echo "=========================================="
echo ""
echo "📊 Report: outputs/reports/hackathons_${WEEK}.md"
echo ""
echo "🎯 High-EV Opportunities:"
jq -r '.[0:3] | .[] | "  - \(.name) (EV: $\(.ev), Deadline: \(.days_until)d)"' \
  raw_data/hackathons/ev_ranked_${WEEK}.json
echo ""
echo "📦 MVS Packages:"
ls outputs/briefs/mvs/h_*_MVS.md 2>/dev/null | sed 's/^/  - /' || echo "  (none generated)"
```

---

## Scheduled Automation Setup

### Prompt File for Windows Task Scheduler

Create: `prompts/hackathon_scan.txt`

```
Run the hackathon-ev-optimizer skill for this week.

Execute all 4 phases:
1. Scan hackathon platforms (DevPost, Gitcoin, DoraHacks)
2. Calculate expected values for all opportunities
3. Analyze skill gaps for top 3 opportunities
4. Generate MVS packages for top 3

Save all outputs to outputs/reports/ and outputs/briefs/.

After completion, show me:
- Top 3 high-EV opportunities with deadlines
- Any opportunities with EV > $2,000 that need immediate action
- Summary of time saved vs manual searching
```

### Windows Task Scheduler Script

Create: `scheduled_tasks/hackathon_scan_scheduled.ps1`

```powershell
# Scheduled Hackathon EV Scan
# Runs: Monday & Thursday at 9:00 AM

$PROJECT_PATH = "C:\Users\17175"
$PROMPT_FILE = "$PROJECT_PATH\prompts\hackathon_scan.txt"

# Change to project directory
cd $PROJECT_PATH

# Run hackathon EV optimizer via Claude Code
Get-Content $PROMPT_FILE | claude --project $PROJECT_PATH

# Optional: Send notification when complete
# (requires notification setup)
```

---

## Usage

### One-Time Setup

```bash
# Create directories
mkdir -p data/sources data/profiles outputs/reports outputs/briefs/mvs outputs/briefs/teams raw_data/hackathons phases prompts scheduled_tasks

# Create hackathon sources config
cat > data/sources/hackathons.yml <<SOURCES
platforms:
  - name: DevPost
    url: https://devpost.com/api/hackathons
    type: api
  - name: Gitcoin
    url: https://gitcoin.co/api/v0.1/bounties
    type: api
  - name: DoraHacks
    url: https://dorahacks.io/api/buidl/grants
    type: api
  - name: ETHGlobal
    url: https://ethglobal.com/events
    type: scrape

prize_threshold: 1000
time_max_hours: 60
SOURCES

# Create case studies profile
cat > data/profiles/case_studies.md <<CASES
# Past Projects & Wins

## Past Projects

### AI Cultural Bias Research
Published paper using GPT-4 collaboration. Novel methodology.
**Themes**: AI, NLP, cultural studies, research
**Outcome**: Publication, academic credibility

### Guild of the Rose Workshops
Educational business covering AI integration, systems thinking.
**Themes**: Education, AI, workshops, facilitation
**Outcome**: Revenue generation, audience building

### Microbiology Nanostructure Research
Published work on antibacterial properties.
**Themes**: Biology, materials science, biomimicry
**Outcome**: Scientific publication

## Skills Inventory
- AI/ML implementation
- Systems thinking and analysis
- Workshop design and delivery
- Research methodology
- Python, Node.js development
- Data visualization
CASES

echo "✓ Setup complete! Run: ./hackathon_ev_master.sh"
```

### Running

```bash
# Manual execution
./hackathon_ev_master.sh --force

# Scheduled execution (automated via Task Scheduler)
# Runs Monday & Thursday at 9:00 AM automatically
```

---

## Expected Outcomes

### Week 1
- **10-20 hackathons/bounties** scanned
- **Top 5 by EV** with rationale
- **3 MVS packages** ready to execute
- **Team formation plans** for skill gaps
- **Time saved**: 8-10 hours vs manual

### Ongoing
- **Weekly scans** (Mon/Thu) keep pipeline full
- **EV learning** improves over time (actual wins train model)
- **Quick decisions** (GO/NO-GO in <10 min)
- **Higher win rate** (focus on high-probability opportunities)

---

## Success Metrics

- **Opportunities scanned**: 10-20/week
- **High-EV identified**: 2-5 with EV >$1,000
- **MVS packages generated**: 3/week
- **Actual entries**: 1-2/month
- **Win rate**: Track and improve (goal: >15%)
- **ROI**: (Prizes won) / (Time invested)

---

**Last updated**: 2025-01-06
**Version**: 1.0.0
**Scheduled**: Monday & Thursday, 9:00 AM
**Maintainer**: David Youssef