---
skill_name: when-tracking-financial-runway-use-dashboard
description: Daily financial tracking with burn rate calculation, runway projection, and alert thresholds
version: 1.0.0
tier: critical
category: financial-survival
auto_trigger:
  keywords:
    - "runway"
    - "burn rate"
    - "financial status"
    - "cash flow"
    - "how long can I operate"
created: 2025-01-06
agents:
  - analyst (FinTracker role)
coordinator: single-agent
topology: simple
memory_patterns:
  - life-os/runway/{YYYY-MM}/daily-snapshots
  - life-os/runway/projections
mcp_integration:
  - memory-mcp (WHO/WHEN/PROJECT/WHY tagging required)
  - claude-flow (hooks)
data_sources:
  - data/finances/accounts.yml
  - data/finances/expenses.yml
  - data/finances/revenue_streams.yml
outputs:
  - outputs/dashboards/runway_{YYYY-MM-DD}.md
cadence: daily
scheduled_trigger:
  days: [Monday, Tuesday, Wednesday, Thursday, Friday]
  time: "08:00"
  prompt_file: prompts/runway_update.txt
estimated_time: 5 min per run
---

# Runway Dashboard

Real-time financial tracking with burn rate analysis, runway projection, and critical alert thresholds. Know exactly how many weeks you can operate.

## Overview

Single-agent dashboard that calculates:
- **Current liquid assets** (checking, savings, available credit)
- **Monthly burn rate** (fixed + variable expenses)
- **Revenue streams** (Guild workshops, consulting, hackathons, grants)
- **Runway remaining** (weeks until zero)
- **Alert thresholds** (30-day warning, 60-day caution, 90-day safe)

**Critical for**: Survival planning, decision-making under financial pressure

## Assigned Agent

**analyst (FinTracker role)** - Daily financial snapshot and projection
- Expertise: Financial modeling, trend analysis, forecasting
- Tools: CSV processing, arithmetic, projection algorithms
- Output: Daily dashboard with runway visualization

## Data Flow

```
SKILL: runway-dashboard
  ↓
analyst (FinTracker) executes daily
  ↓
COMMANDS:
  - Read accounts.yml (current balances)
  - Read expenses.yml (monthly burn)
  - Read revenue_streams.yml (income)
  - Calculate runway = assets / (burn - revenue)
  - Generate markdown dashboard
  - Store snapshot in Memory MCP
  ↓
OUTPUT: Daily dashboard + 30/60/90-day projections
```

---

## Daily Execution Script

```bash
#!/bin/bash
# Runway Dashboard - Daily Financial Snapshot

# PRE-TASK HOOK
npx claude-flow@alpha hooks pre-task \
  --description "Runway: daily financial snapshot" \
  --agent "analyst" \
  --role "FinTracker" \
  --skill "runway-dashboard"

# SETUP
TODAY=$(date +%Y-%m-%d)
MONTH=$(date +%Y-%m)
mkdir -p outputs/dashboards raw_data/runway

# READ FINANCIAL DATA
CHECKING=$(yq eval '.accounts.checking.balance' data/finances/accounts.yml)
SAVINGS=$(yq eval '.accounts.savings.balance' data/finances/accounts.yml)
CREDIT_AVAIL=$(yq eval '.accounts.credit.available' data/finances/accounts.yml)

FIXED_EXPENSES=$(yq eval '.monthly.fixed | to_entries | map(.value) | add' data/finances/expenses.yml)
VARIABLE_EXPENSES=$(yq eval '.monthly.variable | to_entries | map(.value) | add' data/finances/expenses.yml)

GUILD_REVENUE=$(yq eval '.streams.guild.monthly_avg' data/finances/revenue_streams.yml)
CONSULTING_REVENUE=$(yq eval '.streams.consulting.monthly_avg' data/finances/revenue_streams.yml)
OTHER_REVENUE=$(yq eval '.streams.other.monthly_avg' data/finances/revenue_streams.yml)

# CALCULATIONS
TOTAL_ASSETS=$(echo "$CHECKING + $SAVINGS" | bc)
MONTHLY_BURN=$(echo "$FIXED_EXPENSES + $VARIABLE_EXPENSES" | bc)
MONTHLY_REVENUE=$(echo "$GUILD_REVENUE + $CONSULTING_REVENUE + $OTHER_REVENUE" | bc)
NET_BURN=$(echo "$MONTHLY_BURN - $MONTHLY_REVENUE" | bc)

# Runway in weeks (handle negative net burn = infinite runway)
if (( $(echo "$NET_BURN <= 0" | bc -l) )); then
  RUNWAY_WEEKS="∞ (revenue > expenses)"
else
  RUNWAY_WEEKS=$(echo "scale=1; ($TOTAL_ASSETS / $NET_BURN) * 4.33" | bc)
fi

# Alert status
if (( $(echo "$RUNWAY_WEEKS < 4" | bc -l) )); then
  ALERT_STATUS="🔴 CRITICAL (< 4 weeks)"
  ALERT_ACTION="IMMEDIATE ACTION REQUIRED"
elif (( $(echo "$RUNWAY_WEEKS < 8" | bc -l) )); then
  ALERT_STATUS="🟠 WARNING (< 8 weeks)"
  ALERT_ACTION="Accelerate revenue generation"
elif (( $(echo "$RUNWAY_WEEKS < 13" | bc -l) )); then
  ALERT_STATUS="🟡 CAUTION (< 13 weeks)"
  ALERT_ACTION="Monitor closely, prepare backup plans"
else
  ALERT_STATUS="🟢 SAFE (> 13 weeks)"
  ALERT_ACTION="Normal operations"
fi

# GENERATE DASHBOARD
cat > outputs/dashboards/runway_${TODAY}.md <<DASHBOARD
# Financial Runway Dashboard - $TODAY

$ALERT_STATUS

---

## Current Status

| Metric | Value |
|--------|-------|
| **Liquid Assets** | \$$(printf "%.2f" $TOTAL_ASSETS) |
| **Monthly Burn** | \$$(printf "%.2f" $MONTHLY_BURN) |
| **Monthly Revenue** | \$$(printf "%.2f" $MONTHLY_REVENUE) |
| **Net Burn** | \$$(printf "%.2f" $NET_BURN) |
| **Runway Remaining** | **$RUNWAY_WEEKS weeks** |
| **Alert Status** | $ALERT_STATUS |

---

## Asset Breakdown

| Account | Balance |
|---------|---------|
| Checking | \$$(printf "%.2f" $CHECKING) |
| Savings | \$$(printf "%.2f" $SAVINGS) |
| Credit Available | \$$(printf "%.2f" $CREDIT_AVAIL) (emergency only) |
| **Total Liquid** | **\$$(printf "%.2f" $TOTAL_ASSETS)** |

---

## Monthly Burn Rate

### Fixed Expenses (\$$(printf "%.2f" $FIXED_EXPENSES)/mo)
$(yq eval '.monthly.fixed | to_entries | .[] | "- \(.key): $\(.value)"' data/finances/expenses.yml)

### Variable Expenses (\$$(printf "%.2f" $VARIABLE_EXPENSES)/mo)
$(yq eval '.monthly.variable | to_entries | .[] | "- \(.key): $\(.value)"' data/finances/expenses.yml)

**Total Burn**: \$$(printf "%.2f" $MONTHLY_BURN)/month

---

## Revenue Streams

| Source | Monthly Avg |
|--------|-------------|
| Guild Workshops | \$$(printf "%.2f" $GUILD_REVENUE) |
| Consulting | \$$(printf "%.2f" $CONSULTING_REVENUE) |
| Other (hackathons, grants) | \$$(printf "%.2f" $OTHER_REVENUE) |
| **Total Revenue** | **\$$(printf "%.2f" $MONTHLY_REVENUE)/month** |

---

## Runway Projection

| Scenario | Weeks Remaining |
|----------|-----------------|
| Current trajectory | **$RUNWAY_WEEKS** |
| If revenue stops | $(echo "scale=1; ($TOTAL_ASSETS / $MONTHLY_BURN) * 4.33" | bc) weeks |
| If double Guild revenue | $(echo "scale=1; ($TOTAL_ASSETS / ($MONTHLY_BURN - $GUILD_REVENUE * 2)) * 4.33" | bc) weeks |
| If land 1 consulting gig (+\$5k/mo) | $(echo "scale=1; ($TOTAL_ASSETS / ($MONTHLY_BURN - 5000)) * 4.33" | bc) weeks |

---

## Action Plan

**Current Status**: $ALERT_ACTION

$(if (( $(echo "$RUNWAY_WEEKS < 8" | bc -l) )); then
cat <<URGENT

### URGENT ACTIONS (This Week)
- [ ] Apply to 5+ high-probability roles (use /career_intel)
- [ ] Submit 2+ hackathon/bounty entries (use /hackathon_ev)
- [ ] Reach out to 10 past clients for consulting opportunities
- [ ] Price cut Guild workshops 20% to accelerate sales
- [ ] Consider selling non-essential assets

### Medium-Term (This Month)
- [ ] Activate unemployment benefits if eligible
- [ ] Negotiate payment plans for non-critical expenses
- [ ] Explore short-term contract work (Upwork, Toptal)
- [ ] Monetize existing content (courses, workshops)

URGENT
else
cat <<NORMAL

### Priority Actions
- [ ] Continue weekly career intel scans
- [ ] Maintain 2 hackathon entries/month
- [ ] Grow Guild workshop pipeline
- [ ] Document IP for future monetization

NORMAL
fi)

---

## 30/60/90-Day Forecast

**Assumptions**:
- Fixed expenses remain constant
- Revenue continues at current average
- No major windfalls or emergencies

| Date | Projected Balance | Status |
|------|-------------------|--------|
| $(date -d '+30 days' +%Y-%m-%d) | \$$(echo "$TOTAL_ASSETS - $NET_BURN" | bc) | $(if (( $(echo "($TOTAL_ASSETS - $NET_BURN) < ($NET_BURN * 2)" | bc -l) )); then echo "🟠 Warning zone"; else echo "🟢 Safe"; fi) |
| $(date -d '+60 days' +%Y-%m-%d) | \$$(echo "$TOTAL_ASSETS - ($NET_BURN * 2)" | bc) | $(if (( $(echo "($TOTAL_ASSETS - $NET_BURN * 2) < ($NET_BURN * 2)" | bc -l) )); then echo "🔴 Critical"; else echo "🟡 Caution"; fi) |
| $(date -d '+90 days' +%Y-%m-%d) | \$$(echo "$TOTAL_ASSETS - ($NET_BURN * 3)" | bc) | $(if (( $(echo "($TOTAL_ASSETS - $NET_BURN * 3) < 0" | bc -l) )); then echo "🔴 Zero"; else echo "🟠 Low"; fi) |

---

## Historical Trend (Last 7 Days)

$(if [[ -f raw_data/runway/history.csv ]]; then
  tail -n 7 raw_data/runway/history.csv | awk -F',' '{printf "| %s | $%.2f | $%.2f | %.1f weeks |\n", $1, $2, $3, $4}'
else
  echo "*(No historical data yet - run daily for 7 days to build trend)*"
fi)

---

**Last updated**: $(date)
**Next update**: $(date -d '+1 day' +%Y-%m-%d) 08:00 AM (automated)

**Data sources**:
- data/finances/accounts.yml (manual update required)
- data/finances/expenses.yml (reviewed monthly)
- data/finances/revenue_streams.yml (updated as income received)
DASHBOARD

# SAVE HISTORICAL SNAPSHOT
echo "$TODAY,$TOTAL_ASSETS,$NET_BURN,$RUNWAY_WEEKS" >> raw_data/runway/history.csv

# MEMORY STORE
npx claude-flow@alpha memory store \
  --key "life-os/runway/${MONTH}/daily-snapshots/${TODAY}" \
  --value "$(cat outputs/dashboards/runway_${TODAY}.md)" \
  --metadata "{
    \"WHO\": {\"agent\": \"analyst\", \"role\": \"FinTracker\", \"capabilities\": [\"financial-modeling\", \"forecasting\"]},
    \"WHEN\": {\"iso\": \"$(date -Iseconds)\", \"unix\": $(date +%s)},
    \"PROJECT\": \"life-os-financial-tracking\",
    \"WHY\": {\"intent\": \"analysis\", \"task_type\": \"runway-calculation\", \"outcome\": \"survival-metrics\", \"phase\": \"daily-snapshot\"}
  }"

# POST-TASK HOOK
npx claude-flow@alpha hooks post-task \
  --task-id "runway-dashboard-${TODAY}" \
  --metrics "runway_weeks=${RUNWAY_WEEKS},alert_status=${ALERT_STATUS}"

echo "✓ Runway Dashboard Updated: outputs/dashboards/runway_${TODAY}.md"
echo "  Status: $ALERT_STATUS"
echo "  Runway: $RUNWAY_WEEKS weeks"
```

---

## Setup (One-Time)

```bash
# Create directories
mkdir -p data/finances outputs/dashboards raw_data/runway prompts

# Create accounts config
cat > data/finances/accounts.yml <<ACCOUNTS
accounts:
  checking:
    balance: 5000.00  # Update manually or via bank API
    institution: Chase
  savings:
    balance: 8000.00
    institution: Ally
  credit:
    limit: 15000.00
    used: 2000.00
    available: 13000.00  # Emergency only
ACCOUNTS

# Create expenses config
cat > data/finances/expenses.yml <<EXPENSES
monthly:
  fixed:
    rent: 1500.00
    utilities: 200.00
    insurance: 150.00
    subscriptions: 100.00
    internet: 80.00
  variable:
    food: 400.00
    transportation: 150.00
    healthcare: 200.00
    misc: 200.00
EXPENSES

# Create revenue streams config
cat > data/finances/revenue_streams.yml <<REVENUE
streams:
  guild:
    monthly_avg: 800.00  # Update as workshops booked
    last_month: 1200.00
    trend: stable
  consulting:
    monthly_avg: 0.00  # Update when contracts signed
    last_month: 0.00
    trend: seeking
  other:
    monthly_avg: 0.00  # Hackathons, grants, etc.
    last_month: 0.00
    trend: opportunistic
REVENUE

# Create prompt for scheduled execution
cat > prompts/runway_update.txt <<PROMPT
Run the runway-dashboard skill for today.

Read the latest financial data from data/finances/ and generate:
1. Current runway calculation
2. Alert status (critical/warning/caution/safe)
3. 30/60/90-day forecast
4. Action plan based on runway

Show me the alert status and weeks of runway remaining.
If status is CRITICAL or WARNING, also show the urgent actions list.
PROMPT

echo "✓ Setup complete! Run: bash runway_dashboard.sh"
```

---

## Scheduled Automation

**Frequency**: Daily at 8:00 AM (Monday-Friday)

**Windows Task Scheduler**:
```powershell
# scheduled_tasks/runway_update_scheduled.ps1
$PROJECT_PATH = "C:\Users\17175"
cd $PROJECT_PATH
Get-Content prompts\runway_update.txt | claude --project $PROJECT_PATH
```

**Manual execution**:
```bash
bash runway_dashboard.sh
```

---

## Expected Outcomes

### Daily
- **5-minute check**: Know exact runway status
- **Alert awareness**: Critical thresholds flagged
- **Trend tracking**: 7-day historical comparison
- **Action clarity**: What to do based on status

### Weekly
- **Financial discipline**: Regular monitoring prevents surprises
- **Decision data**: Runway informs job search urgency
- **Stress reduction**: Numbers replace anxiety
- **Plan adjustment**: Adapt strategy to reality

---

## Success Metrics

- **Zero surprises**: Always know runway status
- **Alert response**: <24 hours to act on critical alerts
- **Forecast accuracy**: ±10% on 30-day projections
- **Peace of mind**: Quantified vs. emotional stress

---

## Troubleshooting

**"Runway calculation seems wrong"**:
- Verify accounts.yml has current balances
- Check expenses.yml includes all monthly costs
- Update revenue_streams.yml with actual income
- Review raw_data/runway/history.csv for anomalies

**"How do I update data sources?"**:
- Edit YAML files manually (accounts, expenses, revenue)
- Run skill again to refresh dashboard
- Or integrate with bank APIs (advanced)

---

**Last updated**: 2025-01-06
**Version**: 1.0.0
**Scheduled**: Daily, 8:00 AM (Mon-Fri)
**Maintainer**: David Youssef
