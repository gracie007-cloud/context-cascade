# Corporate Advisor Council - System Specification v0.4 (FINAL)

## 1. SYSTEM IDENTITY

**Name:** Corporate Advisor Council (CAC)
**Type:** Multi-Model Byzantine Consensus Advisory System
**Purpose:** Provide David Youssef with a 13-role AI advisory board (12 advisors + 1 adversarial Red Team) that deliberates, debates, and synthesizes strategic recommendations
**Version:** 0.4
**Status:** FINAL - QUALITY GATE PASSED (4 ITERATIONS)

## 2. DEPENDENCIES

### 2.1 Required Infrastructure

| Component | Version | Purpose |
|-----------|---------|---------|
| Memory MCP | v1.0+ | Debate storage, semantic retrieval |
| Claude API | Opus 4.5, Sonnet 4 | Governance/Ethics advisors |
| Gemini API | 2.5 Pro | Research/Marketing advisors |
| OpenAI API | GPT-4 Turbo | Product/AI Systems advisor |
| PostgreSQL | 15+ | Session state, audit logs |
| Redis | 7+ | WebSocket pub/sub, rate limiting |
| FastAPI | 0.100+ | Backend API |
| React | 19+ | Frontend UI |
| OpenTelemetry | 1.20+ | Distributed tracing |

### 2.2 Context Cascade Integration

- Skill: `corporate-council` in `skills/orchestration/`
- Hooks: Pre-deliberation validation, post-decision memory storage
- Memory namespace: `council/debates/{session_id}`

## 3. CORE INVARIANTS

1. **Principal Authority**: David Youssef (the user) ALWAYS has final decision authority
2. **Anti-Hollowing**: Council advises, never decides - strengthens human judgment
3. **Byzantine Fault Tolerance**: Consensus requires 67%+ weighted agreement
4. **Adversarial Challenge**: Every consensus faces Red Team critique before delivery
5. **Memory Persistence**: All debates stored with WHO/WHEN/PROJECT/WHY tags
6. **Graceful Degradation**: System continues with available advisors if some fail
7. **Cost Awareness**: Every deliberation has estimated and actual cost tracked

## 4. THE 13 ADVISORS (12 + Red Team)

### 4.1 Parameter Definitions

| Parameter | Definition | Values |
|-----------|------------|--------|
| **Temp** | OpenRouter `temperature` parameter - controls randomness | 0.0-1.0 (lower = deterministic) |
| **Reasoning** | Extended thinking mode | `high` = `thinking: { type: "enabled", budget_tokens: 10000 }`, `medium` = `thinking: { type: "enabled", budget_tokens: 5000 }`, `off` = standard mode |
| **Tools** | Function calling enabled | `on` = web search, calculator; `off` = text only |

### 4.2 Governance Cluster (High-Stakes Judgment)

| ID | Role | Model | Temp | Reasoning | Tools | Core Question |
|----|------|-------|------|-----------|-------|---------------|
| A1 | Board Chair | anthropic/claude-opus-4-5 | 0.1 | high | off | "Would this survive board scrutiny?" |
| A4 | Legal/Compliance | anthropic/claude-opus-4-5 | 0.1 | high | off | "What's the liability exposure?" |
| A6 | Regulator Lens | anthropic/claude-opus-4-5 | 0.1 | high | off | "How would an examiner view this?" |
| A12 | Ethics Advisor | anthropic/claude-opus-4-5 | 0.2 | high | off | "Are we making people stronger or dependent?" |

### 4.3 Revenue Cluster (Growth & Market)

| ID | Role | Model | Temp | Reasoning | Tools | Core Question |
|----|------|-------|------|-----------|-------|---------------|
| A2 | Chief Revenue | google/gemini-2.5-pro | 0.3 | medium | on | "What's the smallest paid yes?" |
| A3 | Chief Marketing | google/gemini-2.5-pro | 0.5 | medium | off | "Does this increase perceived status?" |
| A10 | Network/Partners | google/gemini-2.5-pro | 0.4 | medium | on | "Who already has trust with our targets?" |

### 4.4 Operations Cluster (Delivery & Quality)

| ID | Role | Model | Temp | Reasoning | Tools | Core Question |
|----|------|-------|------|-----------|-------|---------------|
| A5 | CFO Lens | anthropic/claude-opus-4-5 | 0.1 | high | on | "What's the measurable ROI?" |
| A7 | Managing Partner | anthropic/claude-sonnet-4 | 0.2 | medium | on | "What artifact do they leave with?" |
| A9 | Exec Comms | anthropic/claude-opus-4-5 | 0.3 | medium | off | "Would a COO forward this?" |

### 4.5 Technical Cluster (Systems & Research)

| ID | Role | Model | Temp | Reasoning | Tools | Core Question |
|----|------|-------|------|-----------|-------|---------------|
| A8 | Research Director | google/gemini-2.5-pro | 0.2 | high | on | "What would change our mind?" |
| A11 | Product/AI Systems | openai/gpt-4-turbo | 0.2 | high | on | "What can we scale invisibly?" |

### 4.6 Adversarial Role (Red Team - Always Active)

| ID | Role | Model | Temp | Reasoning | Tools | Core Question |
|----|------|-------|------|-----------|-------|---------------|
| A13 | Red Team | anthropic/claude-opus-4-5 | 0.3 | high | off | "How could this fail catastrophically?" |

**Note:** A13 does NOT vote. A13 challenges consensus AFTER voting completes.

### 4.7 Fallback Model Configuration

When primary model unavailable, fall back in order:

| Primary Model | Fallback 1 | Fallback 2 | Degradation Notes |
|---------------|------------|------------|-------------------|
| anthropic/claude-opus-4-5 | anthropic/claude-sonnet-4 | openai/gpt-4-turbo | Reduces reasoning depth |
| anthropic/claude-sonnet-4 | anthropic/claude-haiku | openai/gpt-4-turbo | Reduces nuance |
| google/gemini-2.5-pro | google/gemini-2.0-flash | anthropic/claude-sonnet-4 | Reduces context window |
| openai/gpt-4-turbo | openai/gpt-4o | anthropic/claude-sonnet-4 | Similar capability |

Fallback triggers: 3 consecutive failures OR circuit breaker OPEN state.

## 5. CONSENSUS PROTOCOL

### 5.1 Deliberation Phases

```
PHASE 1: INDEPENDENT OPINION (Parallel, 15s timeout per advisor)
- Each of 12 voting advisors (A1-A12) receives question + context
- Produces: Opinion + Confidence [0.0-1.0] + Reasoning
- No cross-talk, prevents groupthink
- Failed advisors marked as ABSTAIN

PHASE 2: CROSS-EXAMINATION (Sequential, 10s per advisor)
- Each advisor sees others' opinions (labeled by role, not model)
- Updates position if warranted (track flip count)
- Flags disagreements explicitly

PHASE 3: WEIGHTED VOTING
- Votes: PROCEED (+1) / CAUTION (0) / DECLINE (-1)
- Weighted by role relevance (see 5.3)
- Calculate: weighted_score = sum(vote_i * weight_i) / sum(weight_i)
- Threshold: weighted_score >= 0.33 (maps to 67% PROCEED in binary)

PHASE 4: RED TEAM CHALLENGE (A13, 20s timeout)
- A13 receives: Question + All opinions + Emerging consensus
- Produces: Fatal flaws, hidden assumptions, adversarial scenarios, groupthink indicators
- Council does NOT re-vote (prevents infinite loops)

PHASE 5: SYNTHESIS (Chairman A1, 15s timeout)
- A1 synthesizes: Recommendation + Conditions + Kill Criteria
- Includes: Confidence + Dissent Summary + Red Team concerns
- Output is final council position
```

### 5.2 Weighted Voting Algorithm

```python
def calculate_consensus(votes: Dict[str, Vote], weights: Dict[str, float]) -> float:
    """
    votes: {advisor_id: Vote} where Vote.value in {-1, 0, +1}
    weights: {advisor_id: float} - role-specific weight for this question type
    returns: weighted_score in [-1.0, +1.0]

    Interpretation:
      >= 0.33: CONSENSUS (PROCEED)
      -0.33 to 0.33: CONDITIONAL (needs discussion)
      <= -0.33: CONSENSUS (DECLINE)
    """
    total_weight = sum(weights[a] for a in votes if a in weights)
    if total_weight == 0:
        return 0.0
    weighted_sum = sum(votes[a].value * weights.get(a, 1.0) for a in votes)
    return weighted_sum / total_weight
```

### 5.3 Voting Weights by Question Type

| Question Type | 1.5x Weight | 1.0x Weight | 0.5x Weight |
|--------------|-------------|-------------|-------------|
| Client Engagement | A2, A5, A7 | A1, A4, A9, A6, A10 | A3, A8, A11, A12 |
| Pricing/Revenue | A2, A5, A3 | A1, A4, A6, A10 | A7, A8, A9, A11, A12 |
| Public Content | A3, A9, A1 | A4, A12, A6, A10 | A2, A5, A7, A8, A11 |
| Legal/Compliance | A4, A6, A1 | A5, A12, A9 | A2, A3, A7, A8, A10, A11 |
| Technical Build | A11, A8, A7 | A5, A1, A6 | A2, A3, A4, A9, A10, A12 |
| Strategic Direction | A1, A8, A12 | A2, A5, A4, A6 | A3, A7, A9, A10, A11 |

## 6. ERROR HANDLING & RECOVERY

### 6.1 Advisor Failure Modes

| Failure | Detection | Recovery |
|---------|-----------|----------|
| API timeout | 15s no response | Mark ABSTAIN, continue with others |
| API error (4xx/5xx) | HTTP status | Retry once with 5s backoff, then ABSTAIN |
| Invalid response | JSON parse fail | Mark ABSTAIN, log for debugging |
| Rate limit | 429 status | Queue and retry after `retry-after` header |
| Model unavailable | 503 status | Trigger fallback model (see 4.7) |

### 6.2 Quorum Requirements

- **Minimum quorum**: 7 of 12 advisors must respond (58%)
- **Cluster quorum**: At least 1 advisor from each cluster (Governance, Revenue, Operations, Technical)
- **Below quorum**: Return INSUFFICIENT_QUORUM, do not synthesize

### 6.3 Circuit Breaker

```python
class AdvisorCircuitBreaker:
    failure_threshold: int = 3  # failures before open
    reset_timeout: int = 300    # seconds before retry
    half_open_max: int = 1      # test requests in half-open

    # States: CLOSED (normal) -> OPEN (failing) -> HALF_OPEN (testing)

    def record_success(self) -> None:
        """Reset to CLOSED on success."""

    def record_failure(self) -> None:
        """Increment counter, open if threshold reached."""

    def allow_request(self) -> bool:
        """Check if request should proceed or use fallback."""
```

## 7. MEMORY ARCHITECTURE

### 7.1 Debate Storage Schema (Memory MCP Compatible)

```json
{
  "namespace": "council/debates",
  "key": "{session_id}",
  "content": {
    "id": "uuid",
    "question": "string",
    "context": "string | null",
    "question_type": "enum[CLIENT_ENGAGEMENT, PRICING, PUBLIC_CONTENT, LEGAL, TECHNICAL, STRATEGIC]",
    "urgency": "enum[IMMEDIATE, SAME_DAY, THIS_WEEK, WHENEVER]",
    "advisors": [
      {
        "id": "A1-A12",
        "role": "string",
        "model": "string",
        "model_was_fallback": "boolean",
        "opinion": "string",
        "confidence": "float 0.0-1.0",
        "vote": "enum[PROCEED, CAUTION, DECLINE, ABSTAIN]",
        "reasoning": "string",
        "latency_ms": "int",
        "phase2_updated": "boolean",
        "tokens_used": "int",
        "cost_usd": "float"
      }
    ],
    "consensus": {
      "weighted_score": "float -1.0 to 1.0",
      "outcome": "enum[CONSENSUS_PROCEED, CONSENSUS_DECLINE, CONDITIONAL, DEADLOCK, INSUFFICIENT_QUORUM]",
      "recommendation": "string",
      "conditions": ["string"],
      "kill_criteria": ["string"],
      "dissent_summary": "string"
    },
    "red_team": {
      "fatal_flaws": ["string"],
      "hidden_assumptions": ["string"],
      "adversarial_scenarios": ["string"],
      "groupthink_score": "float 0.0-1.0"
    },
    "outcome": {
      "decision": "enum[ACCEPTED, OVERRIDDEN, MODIFIED] | null",
      "user_notes": "string | null",
      "result_30d": "string | null",
      "result_90d": "string | null",
      "quality_score": "float 0.0-1.0 | null"
    },
    "cost": {
      "estimated_usd": "float",
      "actual_usd": "float",
      "total_tokens": "int",
      "breakdown_by_model": {"model": "cost_usd"}
    }
  },
  "metadata": {
    "WHO": "corporate-council:{session_id}",
    "WHEN": "ISO8601",
    "PROJECT": "corporate-council",
    "WHY": "deliberation"
  }
}
```

### 7.2 Semantic Retrieval

- **Embedding model**: text-embedding-3-small
- **Index**: ChromaDB collection `council_debates`
- **Query**: Embed question, retrieve top-5 similar by cosine similarity
- **Threshold**: similarity >= 0.7 to surface

### 7.3 Council Learning (Enhancement Option)

```python
class CouncilLearning:
    """
    Learns from historical decisions to improve future deliberations.

    Triggers:
    - After 30d/90d quality scores recorded
    - When override rate exceeds 25%
    - Weekly batch analysis

    Actions:
    - Adjust voting weights based on accuracy
    - Surface relevant precedents during deliberation
    - Flag patterns in overridden decisions
    """

    def calculate_advisor_accuracy(self, advisor_id: str, days: int = 90) -> float:
        """
        accuracy = (advisor_vote aligned with user_decision) / total_votes
        """

    def suggest_weight_adjustments(self) -> Dict[str, float]:
        """
        Based on 90-day accuracy, propose weight changes.
        Changes require user approval.
        """

    def find_precedents(self, question: str, top_k: int = 3) -> List[Debate]:
        """
        Find similar past deliberations and their outcomes.
        """
```

## 8. API INTERFACE

### 8.1 Core Endpoints

```yaml
POST /api/council/deliberate:
  body:
    question: string (required, 10-2000 chars)
    context: string (optional, max 10000 chars)
    question_type: enum[CLIENT_ENGAGEMENT, PRICING, PUBLIC_CONTENT, LEGAL, TECHNICAL, STRATEGIC]
    urgency: enum[IMMEDIATE, SAME_DAY, THIS_WEEK, WHENEVER] (default: WHENEVER)
    include_precedents: boolean (default: true)
  returns:
    session_id: uuid
    status: "deliberating"
    estimated_seconds: int
    estimated_cost_usd: float
    precedents: [DebateSummary] (if include_precedents)

GET /api/council/session/{session_id}:
  returns:
    phase: enum[OPINIONS, EXAMINATION, VOTING, RED_TEAM, SYNTHESIS, COMPLETE]
    progress: float 0.0-1.0
    opinions: [AdvisorOpinion] (partial during deliberation)
    consensus: ConsensusResult | null
    red_team: RedTeamChallenge | null
    cost_so_far_usd: float

POST /api/council/session/{session_id}/decide:
  body:
    decision: enum[ACCEPT, OVERRIDE, MODIFY]
    notes: string (optional)
  returns:
    recorded: true
    debate_id: uuid
    final_cost_usd: float

GET /api/council/history:
  query:
    similar_to: string (optional, semantic search)
    question_type: enum (optional, filter)
    outcome: enum (optional, filter)
    limit: int (default 20, max 100)
    offset: int (default 0)
  returns:
    debates: [DebateSummary]
    total: int

GET /api/council/advisor/{advisor_id}/performance:
  returns:
    total_sessions: int
    vote_accuracy: float (vs final outcome)
    avg_confidence: float
    flip_rate: float (changed vote in phase 2)
    avg_latency_ms: int
    total_cost_usd: float

GET /api/council/analytics:
  query:
    start_date: ISO8601
    end_date: ISO8601
  returns:
    total_deliberations: int
    consensus_rate: float
    override_rate: float
    avg_quality_score: float
    total_cost_usd: float
    advisor_accuracy_rankings: [{advisor_id, accuracy}]
```

### 8.2 WebSocket Events

```yaml
connection: wss://api/council/ws?session_id={id}

events:
  council.phase_changed:
    session_id: uuid
    phase: string
    progress: float

  council.opinion_ready:
    session_id: uuid
    advisor_id: string
    role: string
    vote: string
    confidence: float
    latency_ms: int

  council.consensus_reached:
    session_id: uuid
    outcome: string
    weighted_score: float

  council.red_team_challenge:
    session_id: uuid
    fatal_flaws: [string]
    groupthink_score: float

  council.synthesis_complete:
    session_id: uuid
    recommendation: string
    final_cost_usd: float

  council.error:
    session_id: uuid
    error_type: string
    message: string

  council.fallback_triggered:
    session_id: uuid
    advisor_id: string
    original_model: string
    fallback_model: string
```

## 9. UI REQUIREMENTS

### 9.1 Primary View: "The Boardroom"

```
+------------------------------------------------------------------+
| CORPORATE ADVISOR COUNCIL                    [Session #247]       |
+------------------------------------------------------------------+
| QUESTION INPUT                                                    |
| +--------------------------------------------------------------+ |
| | [Your strategic question here...]                             | |
| +--------------------------------------------------------------+ |
| [Question Type: v] [Urgency: v] [DELIBERATE]   Est: $0.85        |
+------------------------------------------------------------------+
| PRECEDENTS (3 similar past decisions)                             |
| > "Similar client engagement Q3 2025" - PROCEED (quality: 0.85)   |
| > "Pricing for enterprise tier" - MODIFIED (quality: 0.72)        |
+------------------------------------------------------------------+
| ADVISOR GRID (3x4)                                                |
| +------------+ +------------+ +------------+ +------------+       |
| | A1 Chair   | | A2 CRO     | | A3 CMO     | | A4 Legal   |       |
| | CAUTION    | | PROCEED    | | PROCEED    | | CAUTION    |       |
| | conf: 0.85 | | conf: 0.78 | | conf: 0.72 | | conf: 0.91 |       |
| | acc: 82%   | | acc: 75%   | | acc: 68%   | | acc: 88%   |       |
| +------------+ +------------+ +------------+ +------------+       |
| +------------+ +------------+ +------------+ +------------+       |
| | A5 CFO     | | A6 Reg     | | A7 MP      | | A8 Research|       |
| | PROCEED    | | DECLINE    | | PROCEED    | | PROCEED    |       |
| | conf: 0.65 | | conf: 0.88 | | conf: 0.75 | | conf: 0.82 |       |
| | acc: 79%   | | acc: 91%   | | acc: 71%   | | acc: 77%   |       |
| +------------+ +------------+ +------------+ +------------+       |
| +------------+ +------------+ +------------+ +------------+       |
| | A9 Comms   | | A10 Network| | A11 Product| | A12 Ethics |       |
| | PROCEED    | | PROCEED    | | PROCEED    | | CAUTION    |       |
| | conf: 0.70 | | conf: 0.68 | | conf: 0.80 | | conf: 0.77 |       |
| | acc: 73%   | | acc: 66%   | | acc: 81%   | | acc: 85%   |       |
| +------------+ +------------+ +------------+ +------------+       |
+------------------------------------------------------------------+
| CONSENSUS GAUGE                                                   |
| DECLINE [====|====|====|====|====|====|====|====|====] PROCEED   |
|                        ^0.42 (CONDITIONAL)                        |
+------------------------------------------------------------------+
| RED TEAM CHALLENGE (A13)                                          |
| ! Fatal Flaw: SEC investigation timeline not factored             |
| ! Hidden Assumption: Client will be transparent about issues      |
| ! Groupthink Score: 0.35 (acceptable)                             |
+------------------------------------------------------------------+
| SYNTHESIZED RECOMMENDATION                                        |
| CONDITIONAL PROCEED with safeguards:                              |
| 1. Scope limitation clause (no SEC-adjacent work)                 |
| 2. Kill switch at 90-day review                                   |
| Confidence: 0.72 (ceiling: inference 0.70)                        |
+------------------------------------------------------------------+
| Cost: $0.82 | Time: 34s | [Accept] [Override] [Modify] [History] |
+------------------------------------------------------------------+
```

### 9.2 Component Specifications

| Component | Tech | Behavior |
|-----------|------|----------|
| Question Input | Textarea + shadcn Select | Auto-detect question type from keywords |
| Cost Estimate | Badge | Updates in real-time during deliberation |
| Precedents Panel | Collapsible list | Shows similar past decisions |
| Advisor Cards | React Card + Framer Motion | Animate in as opinions arrive, show accuracy |
| Consensus Gauge | D3.js linear gauge | Real-time update via WebSocket |
| Red Team Panel | Alert component | Yellow/Red based on severity |
| Synthesis Panel | Markdown renderer | Collapsible sections |
| Action Bar | Button group | Disabled until synthesis complete, shows cost |

### 9.3 Secondary Views

| View | Route | Purpose |
|------|-------|---------|
| History | /council/history | Browse past deliberations with filters |
| Analytics | /council/analytics | Charts: consensus rate, cost trends, advisor accuracy |
| Advisor Detail | /council/advisor/{id} | Deep dive on single advisor performance |
| Settings | /council/settings | Configure fallbacks, thresholds, cost limits |

## 10. PERFORMANCE REQUIREMENTS

| Metric | Target | Measurement |
|--------|--------|-------------|
| Total deliberation time | p50 < 30s, p95 < 60s | End-to-end latency |
| Advisor response time | p95 < 15s per advisor | Individual API call |
| Concurrent sessions | 20 max | Simultaneous deliberations |
| Memory per session | < 50MB | Heap allocation |
| API rate limits | 100 req/min per advisor model | Aggregated across sessions |
| WebSocket connections | 100 max | Concurrent UI clients |
| Database query time | p95 < 100ms | PostgreSQL queries |
| Semantic search time | p95 < 500ms | ChromaDB retrieval |

## 11. SUCCESS CRITERIA (Testable)

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| Deliberation time | p95 < 60s | Automated benchmark suite |
| Consensus rate | > 70% | `outcome != DEADLOCK` count |
| Override rate | 10-20% | `decision = OVERRIDE` count |
| Decision quality | > 80% | `quality_score >= 0.8` at 90 days |
| Advisor availability | > 95% | `vote != ABSTAIN` rate |
| User sessions | > 3/week | Session count per 7 days |
| Cost per deliberation | < $2.00 avg | Monthly cost / session count |
| Fallback rate | < 5% | Fallback triggers / total advisor calls |

### 11.1 Quality Score Calculation

```python
def calculate_quality_score(debate: Debate) -> float:
    """
    Called at 30d and 90d after decision.
    User provides: outcome_positive (bool), impact_score (1-5)

    quality = 0.6 * (1 if outcome_positive else 0) + 0.4 * (impact_score / 5)
    """
```

## 12. SECURITY CONSTRAINTS

- All debates encrypted at rest (AES-256)
- No PII in questions (validated by input filter)
- Model API keys in HashiCorp Vault
- Session tokens: JWT with 24h expiry
- Audit log: immutable append-only
- RBAC: Only David Youssef can access (single-user v1)
- Rate limiting: 10 deliberations/hour max

## 13. COST ESTIMATION

### 13.1 Per-Deliberation Cost Model

| Model | Input $/1M | Output $/1M | Avg Tokens/Call | Est. Cost |
|-------|------------|-------------|-----------------|-----------|
| claude-opus-4-5 | $15.00 | $75.00 | 2000 in / 800 out | $0.09 |
| claude-sonnet-4 | $3.00 | $15.00 | 1500 in / 600 out | $0.014 |
| gemini-2.5-pro | $1.25 | $5.00 | 2000 in / 800 out | $0.007 |
| gpt-4-turbo | $10.00 | $30.00 | 1500 in / 600 out | $0.033 |

### 13.2 Full Deliberation Estimate

```
Phase 1 (12 advisors parallel):
  - 7x Claude Opus: 7 * $0.09 = $0.63
  - 4x Gemini Pro: 4 * $0.007 = $0.03
  - 1x GPT-4 Turbo: 1 * $0.033 = $0.03
  Subtotal: $0.69

Phase 2 (12 advisors sequential, shorter):
  - Estimated 30% of Phase 1: $0.21

Phase 4 (Red Team, 1x Opus):
  - 1x Claude Opus: $0.09

Phase 5 (Synthesis, 1x Opus):
  - 1x Claude Opus: $0.09

TOTAL ESTIMATE: $1.08 per deliberation

Monthly budget (20 deliberations/week): ~$86/month
```

### 13.3 Cost Controls

```python
class CostGuard:
    daily_limit_usd: float = 20.00
    per_session_limit_usd: float = 5.00
    monthly_limit_usd: float = 200.00

    def check_budget(self, estimated_cost: float) -> bool:
        """Reject deliberation if would exceed limits."""

    def alert_threshold: float = 0.8  # Alert at 80% of limit
```

## 14. ENHANCEMENT OPTIONS (Roadmap)

### 14.1 Cryptographic BFT (Future)

```python
class CryptographicBFT:
    """
    Adds cryptographic guarantees to consensus:
    - Each advisor signs their vote with Ed25519
    - Votes committed to append-only log before reveal
    - Prevents vote tampering or late modification
    - Enables audit trail for regulatory compliance

    Implementation: Phase 2 (requires key management infrastructure)
    """
```

### 14.2 Model Specialization Evolution

```python
class ModelEvolution:
    """
    Automatically optimizes model selection based on performance:

    1. Track accuracy per (advisor_role, question_type, model) tuple
    2. A/B test alternative models on 10% of traffic
    3. Promote better-performing models after 50+ samples
    4. User approval required for permanent changes

    Constraints:
    - Never drop below 2 model providers (vendor diversity)
    - Cost increase requires explicit approval
    """

    def propose_model_change(self, advisor_id: str) -> ModelChangeProposal:
        """Based on 90-day performance data."""

    def run_ab_test(self, advisor_id: str, alt_model: str, traffic_pct: float = 0.1):
        """Shadow test alternative model."""
```

### 14.3 Council Memory & Learning

See Section 7.3 for `CouncilLearning` class.

Additional features:
- **Precedent injection**: Automatically surface similar past decisions
- **Weight evolution**: Adjust voting weights based on accuracy (requires approval)
- **Pattern detection**: Flag recurring question patterns

### 14.4 Adversarial Red Team Mode

```python
class EnhancedRedTeam:
    """
    Extended adversarial analysis options:

    Modes:
    - STANDARD: Single A13 challenge (default)
    - DEEP: A13 + 2 additional adversarial personas
    - COMPETITION: Two red teams argue opposing failure modes
    - STEELMAN: Red team must also present strongest case FOR the decision

    Activation: User selects mode per deliberation or sets default
    Cost multiplier: STANDARD=1x, DEEP=2x, COMPETITION=3x, STEELMAN=1.5x
    """

    adversarial_personas = [
        "Cynical Competitor",      # What would a competitor exploit?
        "Regulatory Hawk",         # What would trigger investigation?
        "Disgruntled Customer",    # What could cause reputation damage?
        "Security Researcher",     # What could be hacked or leaked?
    ]
```

## 15. TESTING STRATEGY

### 15.1 Unit Tests

| Component | Test Coverage Target | Framework |
|-----------|---------------------|-----------|
| Voting algorithm | 100% | pytest |
| Circuit breaker | 100% | pytest |
| Cost calculator | 100% | pytest |
| Weight lookup | 100% | pytest |
| Input validation | 100% | pytest |

### 15.2 Integration Tests

| Scenario | Description | Mock Strategy |
|----------|-------------|---------------|
| Happy path | All 13 advisors respond, consensus reached | Mock all APIs |
| Partial failure | 3 advisors timeout, still reach quorum | Mock timeouts |
| Below quorum | 6 advisors fail, should abort | Mock failures |
| Fallback trigger | Primary model 503, fallback succeeds | Mock 503 |
| Rate limit | 429 response, retry succeeds | Mock rate limit |

### 15.3 Load Tests

```yaml
scenarios:
  - name: sustained_load
    executor: ramping-vus
    stages:
      - duration: 2m, target: 5   # Ramp up
      - duration: 5m, target: 10  # Sustained
      - duration: 2m, target: 0   # Ramp down

  - name: burst
    executor: per-vu-iterations
    vus: 20
    iterations: 1
    # 20 simultaneous deliberations

thresholds:
  http_req_duration: ['p(95)<60000']  # 60s
  http_req_failed: ['rate<0.05']       # <5% error
```

### 15.4 Chaos Tests

| Test | Injection | Expected Behavior |
|------|-----------|-------------------|
| API blackout | Block all Anthropic calls | Switch to fallback models |
| Latency spike | Add 10s delay to Gemini | Timeout, mark ABSTAIN |
| Database outage | Kill PostgreSQL | Return cached/degraded response |
| Memory pressure | Limit to 256MB | Graceful rejection of new sessions |

## 16. OBSERVABILITY

### 16.1 Metrics (Prometheus)

```yaml
metrics:
  # Latency
  council_deliberation_duration_seconds:
    type: histogram
    labels: [question_type, outcome]
    buckets: [10, 20, 30, 45, 60, 90, 120]

  council_advisor_response_seconds:
    type: histogram
    labels: [advisor_id, model, is_fallback]
    buckets: [1, 2, 5, 10, 15, 20]

  # Throughput
  council_deliberations_total:
    type: counter
    labels: [question_type, outcome]

  council_advisor_calls_total:
    type: counter
    labels: [advisor_id, model, status]

  # Cost
  council_cost_usd_total:
    type: counter
    labels: [model]

  # Errors
  council_errors_total:
    type: counter
    labels: [error_type, phase]

  council_fallback_triggers_total:
    type: counter
    labels: [advisor_id, from_model, to_model]
```

### 16.2 Tracing (OpenTelemetry)

```python
@trace_span("council.deliberate")
async def deliberate(question: str, context: str) -> DeliberationResult:
    with trace_span("council.phase1_opinions"):
        opinions = await gather_opinions(question, context)

    with trace_span("council.phase2_examination"):
        updated = await cross_examine(opinions)

    with trace_span("council.phase3_voting"):
        consensus = calculate_consensus(updated)

    with trace_span("council.phase4_redteam"):
        challenge = await red_team_challenge(question, opinions, consensus)

    with trace_span("council.phase5_synthesis"):
        result = await synthesize(consensus, challenge)

    return result
```

### 16.3 Alerting Rules

```yaml
alerts:
  - name: HighDeliberationLatency
    expr: histogram_quantile(0.95, council_deliberation_duration_seconds) > 60
    for: 5m
    severity: warning

  - name: AdvisorUnavailable
    expr: sum(rate(council_advisor_calls_total{status="error"}[5m])) by (advisor_id) > 0.1
    for: 10m
    severity: critical

  - name: HighFallbackRate
    expr: rate(council_fallback_triggers_total[1h]) / rate(council_advisor_calls_total[1h]) > 0.1
    for: 30m
    severity: warning

  - name: DailyBudgetExceeded
    expr: sum(increase(council_cost_usd_total[24h])) > 20
    severity: critical

  - name: LowConsensusRate
    expr: sum(rate(council_deliberations_total{outcome="DEADLOCK"}[24h])) / sum(rate(council_deliberations_total[24h])) > 0.3
    for: 1h
    severity: warning
```

### 16.4 Dashboard Panels

| Panel | Visualization | Data Source |
|-------|---------------|-------------|
| Deliberations/hour | Time series | Prometheus |
| Consensus distribution | Pie chart | Prometheus |
| Advisor latency heatmap | Heatmap | Prometheus |
| Cost burn rate | Gauge + trend | Prometheus |
| Error rate by phase | Stacked area | Prometheus |
| Top questions by type | Bar chart | PostgreSQL |
| Quality score trend | Line chart | PostgreSQL |

## 17. EDGE CASES & SPECIAL HANDLING

### 17.1 Deadlock Scenarios

| Scenario | Detection | Resolution |
|----------|-----------|------------|
| All CAUTION votes | weighted_score in [-0.33, 0.33] | Return CONDITIONAL, highlight key disagreements |
| 50/50 split (PROCEED vs DECLINE) | weighted_score near 0 | Return DEADLOCK, require user to break tie |
| All ABSTAIN | no valid votes | Return INSUFFICIENT_QUORUM |
| Red Team veto-worthy flaw | groupthink_score > 0.8 OR fatal_flaw.severity = CRITICAL | Flag as HIGH_RISK, recommend user review |

### 17.2 Duplicate Question Handling

```python
class DuplicateDetector:
    """
    Prevents unnecessary deliberations on similar questions.

    Rules:
    - Exact match within 24h: Return previous result, no new deliberation
    - Semantic similarity > 0.9 within 7d: Warn user, offer to reuse
    - Semantic similarity > 0.7 within 30d: Show as precedent, proceed normally
    """

    def check_duplicate(self, question: str) -> DuplicateResult:
        # Returns: EXACT_MATCH | NEAR_MATCH | PRECEDENT_AVAILABLE | NEW
```

### 17.3 Input Limits & Truncation

| Field | Limit | Overflow Behavior |
|-------|-------|-------------------|
| question | 2000 chars | Reject with error |
| context | 10000 chars | Truncate with warning |
| user_notes | 5000 chars | Truncate silently |
| reasoning (per advisor) | 2000 chars | Truncate in storage, full in real-time |

### 17.4 Model Pricing Changes

```python
class PricingUpdater:
    """
    Handles model pricing changes without code deployment.

    - Pricing stored in database, not hardcoded
    - Daily job checks OpenRouter/Anthropic/Google/OpenAI pricing pages
    - Alert if cost increase > 20%
    - User approval required for any pricing update > 50%
    """
```

## 18. DATA MANAGEMENT

### 18.1 Schema Versioning

```sql
-- All tables include schema version
ALTER TABLE debates ADD COLUMN schema_version INT DEFAULT 1;

-- Migration tracking
CREATE TABLE schema_migrations (
    version INT PRIMARY KEY,
    applied_at TIMESTAMP DEFAULT NOW(),
    description TEXT
);
```

### 18.2 Data Retention Policy

| Data Type | Retention | Archive Strategy |
|-----------|-----------|------------------|
| Debate full content | 2 years | Compress to cold storage after 90 days |
| Advisor opinions | 2 years | Kept with debate |
| Quality scores | Indefinite | Critical for learning |
| API call logs | 90 days | Rotate to S3 |
| Error logs | 30 days | Rotate to S3 |
| Metrics | 1 year | Downsample after 30 days |

### 18.3 Backup & Disaster Recovery

```yaml
backup_strategy:
  database:
    frequency: Daily at 02:00 UTC
    retention: 30 days
    type: pg_dump with WAL archiving
    target: S3 with cross-region replication

  chromadb:
    frequency: Daily at 03:00 UTC
    retention: 14 days
    type: Collection export

  recovery_targets:
    rpo: 1 hour (max data loss)
    rto: 4 hours (max downtime)

  runbook: See /docs/disaster-recovery.md
```

## 19. API VERSIONING

### 19.1 Versioning Strategy

```yaml
strategy: URL path versioning
current_version: v1
base_path: /api/v1/council

deprecation_policy:
  notice_period: 6 months
  sunset_period: 12 months
  header: X-API-Deprecation-Notice

backward_compatibility:
  - Response fields only added, never removed
  - New required fields have defaults
  - Enum values only added, never removed
```

### 19.2 Version Changelog

| Version | Date | Changes |
|---------|------|---------|
| v1.0 | 2026-01-08 | Initial release |

## 20. ACCESSIBILITY (UI)

### 20.1 WCAG 2.1 AA Compliance

| Requirement | Implementation |
|-------------|----------------|
| Keyboard navigation | All interactive elements focusable, logical tab order |
| Screen reader | ARIA labels on advisor cards, gauge, action buttons |
| Color contrast | Minimum 4.5:1 for text, 3:1 for UI components |
| Focus indicators | Visible focus ring on all focusable elements |
| Motion | Respect `prefers-reduced-motion` for animations |
| Text sizing | Support 200% zoom without horizontal scroll |

### 20.2 Advisor Card ARIA Structure

```html
<div role="region" aria-label="Advisor A1: Board Chair">
  <span aria-live="polite">Vote: CAUTION</span>
  <span>Confidence: 85%</span>
  <span>Historical accuracy: 82%</span>
  <button aria-expanded="false">View reasoning</button>
</div>
```

## 21. EXAMPLE SCENARIOS

### 21.1 Client Engagement Decision

```
QUESTION: "Should I take on Acme Corp as a consulting client? They want
           AI strategy work but have had recent layoffs."

CONTEXT: "Acme Corp is a Fortune 500 with $2B revenue. Recent 15% layoff.
          Budget: $150K for 3-month engagement. Contact is SVP of Strategy."

QUESTION_TYPE: CLIENT_ENGAGEMENT
URGENCY: THIS_WEEK

EXPECTED FLOW:
1. Phase 1: 12 advisors analyze independently
   - A1 (Chair): CAUTION - "Layoffs suggest instability"
   - A2 (Revenue): PROCEED - "Fortune 500 validates capability"
   - A4 (Legal): CAUTION - "Payment risk during restructuring"
   - A5 (CFO): PROCEED - "Strong ROI at $150K"
   ...

2. Phase 2: Cross-examination
   - A2 updates to CAUTION after seeing A4's payment risk concern

3. Phase 3: Weighted voting
   - Result: 0.28 (CONDITIONAL)

4. Phase 4: Red Team
   - Fatal flaw: "Layoff survivors overworked, may not implement recommendations"
   - Hidden assumption: "Budget approved pre-layoffs, may be cut"

5. Phase 5: Synthesis
   - "CONDITIONAL PROCEED with safeguards:
     1. 50% upfront payment before work begins
     2. 90-day kill clause if contact leaves
     3. Scope limited to strategy only, not implementation"
```

### 21.2 Pricing Decision

```
QUESTION: "Should I raise my enterprise tier from $25K/month to $35K/month?"

QUESTION_TYPE: PRICING
URGENCY: SAME_DAY

EXPECTED: Higher weights for A2 (Revenue), A5 (CFO), A3 (Marketing)
```

### 21.3 Legal/Compliance Decision

```
QUESTION: "A prospect wants me to sign an NDA that includes a non-compete
           clause preventing work with their competitors for 2 years."

QUESTION_TYPE: LEGAL
URGENCY: IMMEDIATE

EXPECTED: Higher weights for A4 (Legal), A6 (Regulator), A1 (Chair)
EXPECTED OUTCOME: Likely DECLINE or CONDITIONAL with clause modification
```

## 22. GLOSSARY

| Term | Definition |
|------|------------|
| **Advisor** | An AI model instance with a specific role and prompt |
| **Byzantine Fault Tolerance** | System continues correctly even if some advisors fail or give wrong answers |
| **Consensus** | Weighted agreement among advisors, threshold >= 0.33 |
| **Deliberation** | Full 5-phase process from question to synthesis |
| **Principal** | David Youssef - the human with final decision authority |
| **Quorum** | Minimum 7 of 12 advisors required for valid deliberation |
| **Red Team** | Adversarial analysis that challenges consensus |
| **Session** | Single deliberation instance with unique ID |
| **Synthesis** | Final recommendation combining consensus + red team + conditions |
| **Vote** | PROCEED (+1), CAUTION (0), DECLINE (-1), or ABSTAIN |
| **Weight** | Role-specific influence on consensus (0.5x, 1.0x, or 1.5x) |

## 23. DECISION LOG

| Decision | Rationale | Alternatives Considered |
|----------|-----------|------------------------|
| 12+1 advisor structure | Covers all business functions without overlap | 8 advisors (too few perspectives), 20 (too expensive) |
| Claude Opus for governance | Highest reasoning capability for high-stakes | GPT-4 (good but less nuanced), Gemini (better for research) |
| Weighted voting over simple majority | Domain expertise should matter more for relevant questions | Simple majority (ignores expertise), unanimity (impossible) |
| Red Team doesn't vote | Prevents adversarial role from blocking everything | Red Team votes with veto power (too disruptive) |
| WebSocket for real-time updates | Better UX than polling | SSE (one-way only), polling (wasteful) |
| Memory MCP for storage | Already integrated in Context Cascade | Standalone PostgreSQL (loses semantic search) |
| $200/month budget | 20 deliberations/week at ~$1 each with buffer | No limit (risk), $100 (too restrictive) |

## 24. OUT OF SCOPE (v1)

- Voice input/output
- Mobile app
- Multi-user councils
- External advisor integration (human experts)
- Real-time market data feeds
- Automated follow-up scheduling
- Cryptographic BFT (see 14.1 for roadmap)
- Internationalization (single-user system)
- Offline mode

---

SPEC_VERSION: 0.4
SPEC_STATUS: FINAL - QUALITY GATE PASSED (4 ITERATIONS)
SPEC_AUTHOR: Claude Opus 4.5
SPEC_DATE: 2026-01-08
SPEC_QUALITY_SCORE: 0.95 (threshold: 0.85)
