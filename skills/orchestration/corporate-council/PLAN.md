# Corporate Advisor Council - Implementation Plan v1.0

## PLAN METADATA

```
PLAN_VERSION: 1.0
PLAN_STATUS: APPROVED
SPEC_VERSION: 0.4
AUTHOR: Claude Opus 4.5
DATE: 2026-01-08
METHODOLOGY: Sequential Thinking + Dependency Analysis
```

---

## 1. EXECUTIVE SUMMARY

This plan translates SPEC v0.4 into an actionable implementation roadmap for the Corporate Advisor Council (CAC). The system is a multi-model Byzantine consensus advisory board with 13 AI advisors that deliberate, debate, and synthesize strategic recommendations.

**Total Estimated Effort**: 120-160 hours across 6 phases
**Critical Path**: Database -> Core Engine -> API -> WebSocket -> Frontend -> Observability

---

## 2. ARCHITECTURE OVERVIEW

```
                                    +-------------------+
                                    |    "The Boardroom"|
                                    |    React 19 UI    |
                                    +--------+----------+
                                             |
                                    WebSocket + REST
                                             |
                                    +--------v----------+
                                    |   FastAPI Backend |
                                    |   (Orchestrator)  |
                                    +--------+----------+
                                             |
              +------------------------------+------------------------------+
              |                              |                              |
     +--------v--------+            +--------v--------+            +--------v--------+
     |  Multi-Model    |            |   Consensus     |            |   Memory MCP    |
     |  Router         |            |   Engine        |            |   Integration   |
     +--------+--------+            +-----------------+            +--------+--------+
              |                                                             |
    +---------+---------+---------+                               +---------v---------+
    |         |         |         |                               |   ChromaDB        |
+---v---+ +---v---+ +---v---+ +---v---+                           |   (Semantic)      |
|Claude | |Gemini | |OpenAI | |Fallback|                          +-------------------+
|API    | |API    | |API    | |Logic   |
+-------+ +-------+ +-------+ +--------+
```

---

## 3. TECH STACK DECISIONS

### 3.1 Backend

| Component | Technology | Rationale |
|-----------|------------|-----------|
| Framework | FastAPI 0.100+ | Async-native, OpenAPI auto-gen, WebSocket support |
| Python | 3.11+ | Match clause for state machines, performance |
| ORM | SQLAlchemy 2.0 + asyncpg | Async PostgreSQL, type safety |
| Validation | Pydantic v2 | SPEC schema -> Python models |
| Task Queue | None (asyncio) | Low latency required, no background jobs |
| WebSocket | fastapi-websocket | Built-in, Redis pub/sub for scaling |

### 3.2 Frontend

| Component | Technology | Rationale |
|-----------|------------|-----------|
| Framework | React 19 | Latest concurrent features |
| State | Zustand | Lightweight, WebSocket-friendly |
| UI Library | shadcn/ui | Accessible, customizable |
| Animation | Framer Motion | Advisor card animations |
| Charts | D3.js | Consensus gauge, analytics |
| Build | Vite | Fast HMR, optimized builds |
| Types | TypeScript 5.3+ | Full type safety |

### 3.3 Infrastructure

| Component | Technology | Rationale |
|-----------|------------|-----------|
| Database | PostgreSQL 15 | JSONB for flexible schema, mature |
| Vector DB | ChromaDB | Already in Memory MCP, semantic search |
| Cache/PubSub | Redis 7 | WebSocket scaling, rate limiting |
| Tracing | OpenTelemetry | Standard, Jaeger/Tempo export |
| Metrics | Prometheus | Grafana dashboards |
| Secrets | HashiCorp Vault | API key management (or env vars for v1) |

### 3.4 AI Model APIs

| Provider | SDK | Models |
|----------|-----|--------|
| Anthropic | anthropic-sdk | claude-opus-4-5, claude-sonnet-4 |
| Google | google-generativeai | gemini-2.5-pro, gemini-2.0-flash |
| OpenAI | openai | gpt-4-turbo, gpt-4o |

---

## 4. FILE STRUCTURE

### 4.1 Backend (Python)

```
corporate-council/
├── pyproject.toml                    # Poetry dependencies
├── alembic.ini                       # Database migrations
├── alembic/
│   └── versions/                     # Migration files
├── src/
│   └── council/
│       ├── __init__.py
│       ├── main.py                   # FastAPI app entry
│       ├── config.py                 # Settings (pydantic-settings)
│       │
│       ├── models/                   # SQLAlchemy + Pydantic
│       │   ├── __init__.py
│       │   ├── database.py           # DB connection, Base
│       │   ├── debate.py             # Debate, AdvisorOpinion, Consensus
│       │   ├── advisor.py            # AdvisorConfig, CircuitBreaker state
│       │   └── schemas.py            # Pydantic request/response models
│       │
│       ├── advisors/                 # Multi-model orchestration
│       │   ├── __init__.py
│       │   ├── base.py               # AdvisorBase ABC
│       │   ├── claude.py             # ClaudeAdvisor (Opus, Sonnet)
│       │   ├── gemini.py             # GeminiAdvisor (Pro, Flash)
│       │   ├── openai.py             # OpenAIAdvisor (GPT-4 Turbo)
│       │   ├── registry.py           # ADVISOR_REGISTRY (A1-A13 config)
│       │   ├── circuit_breaker.py    # AdvisorCircuitBreaker
│       │   └── fallback.py           # FallbackManager
│       │
│       ├── engine/                   # Deliberation engine
│       │   ├── __init__.py
│       │   ├── deliberation.py       # DeliberationEngine (5 phases)
│       │   ├── consensus.py          # calculate_consensus(), weights
│       │   ├── red_team.py           # RedTeamChallenger
│       │   ├── synthesizer.py        # SynthesisEngine (A1 final)
│       │   └── quorum.py             # QuorumValidator
│       │
│       ├── memory/                   # Memory MCP integration
│       │   ├── __init__.py
│       │   ├── client.py             # MemoryMCPClient
│       │   ├── storage.py            # DebateStorage (save/retrieve)
│       │   ├── precedents.py         # PrecedentFinder (semantic search)
│       │   └── learning.py           # CouncilLearning (future)
│       │
│       ├── api/                      # FastAPI routers
│       │   ├── __init__.py
│       │   ├── council.py            # /api/council/* endpoints
│       │   ├── analytics.py          # /api/council/analytics
│       │   └── websocket.py          # WebSocket handler
│       │
│       ├── services/                 # Business logic
│       │   ├── __init__.py
│       │   ├── deliberation_service.py  # Orchestrates full flow
│       │   ├── cost_service.py       # CostEstimator, CostGuard
│       │   └── duplicate_service.py  # DuplicateDetector
│       │
│       └── observability/            # Metrics, tracing
│           ├── __init__.py
│           ├── metrics.py            # Prometheus metrics
│           ├── tracing.py            # OpenTelemetry setup
│           └── logging.py            # Structured logging
│
├── tests/
│   ├── conftest.py                   # Fixtures
│   ├── unit/
│   │   ├── test_consensus.py
│   │   ├── test_circuit_breaker.py
│   │   ├── test_cost.py
│   │   └── test_quorum.py
│   ├── integration/
│   │   ├── test_deliberation.py
│   │   ├── test_api.py
│   │   └── test_websocket.py
│   └── load/
│       └── k6_load_test.js
│
└── docker/
    ├── Dockerfile
    ├── docker-compose.yml
    └── docker-compose.dev.yml
```

### 4.2 Frontend (React)

```
council-ui/
├── package.json
├── vite.config.ts
├── tsconfig.json
├── tailwind.config.js
│
├── src/
│   ├── main.tsx                      # Entry point
│   ├── App.tsx                       # Router setup
│   │
│   ├── api/                          # API client
│   │   ├── client.ts                 # Axios/fetch wrapper
│   │   ├── council.ts                # Council API calls
│   │   └── websocket.ts              # WebSocket manager
│   │
│   ├── stores/                       # Zustand stores
│   │   ├── deliberation.ts           # Current deliberation state
│   │   ├── history.ts                # Past deliberations
│   │   └── settings.ts               # User preferences
│   │
│   ├── components/
│   │   ├── ui/                       # shadcn components
│   │   │   ├── button.tsx
│   │   │   ├── card.tsx
│   │   │   ├── select.tsx
│   │   │   └── ...
│   │   │
│   │   ├── boardroom/                # Main deliberation UI
│   │   │   ├── QuestionInput.tsx
│   │   │   ├── PrecedentsPanel.tsx
│   │   │   ├── AdvisorGrid.tsx
│   │   │   ├── AdvisorCard.tsx
│   │   │   ├── ConsensusGauge.tsx
│   │   │   ├── RedTeamPanel.tsx
│   │   │   ├── SynthesisPanel.tsx
│   │   │   └── ActionBar.tsx
│   │   │
│   │   ├── history/                  # History view
│   │   │   ├── HistoryList.tsx
│   │   │   ├── DebateDetail.tsx
│   │   │   └── SearchFilters.tsx
│   │   │
│   │   ├── analytics/                # Analytics view
│   │   │   ├── OverviewCards.tsx
│   │   │   ├── ConsensusChart.tsx
│   │   │   ├── CostChart.tsx
│   │   │   └── AdvisorRankings.tsx
│   │   │
│   │   └── settings/                 # Settings view
│   │       ├── CostLimits.tsx
│   │       ├── FallbackConfig.tsx
│   │       └── ThresholdConfig.tsx
│   │
│   ├── pages/
│   │   ├── BoardroomPage.tsx         # Main deliberation
│   │   ├── HistoryPage.tsx           # Past deliberations
│   │   ├── AnalyticsPage.tsx         # Analytics dashboard
│   │   ├── AdvisorPage.tsx           # Single advisor detail
│   │   └── SettingsPage.tsx          # Configuration
│   │
│   ├── hooks/
│   │   ├── useDeliberation.ts        # Deliberation state + WS
│   │   ├── useWebSocket.ts           # WebSocket connection
│   │   └── usePrecedents.ts          # Precedent fetching
│   │
│   ├── lib/
│   │   ├── utils.ts                  # Utility functions
│   │   └── constants.ts              # Advisor IDs, colors, etc.
│   │
│   └── types/
│       ├── api.ts                    # API response types
│       ├── advisor.ts                # Advisor types
│       └── debate.ts                 # Debate types
│
├── public/
│   └── assets/
│       └── advisor-icons/            # A1-A13 icons
│
└── tests/
    ├── components/
    └── e2e/
        └── deliberation.spec.ts      # Playwright E2E
```

---

## 5. IMPLEMENTATION PHASES

### Phase 1: Foundation (20-25 hours)

**Goal**: Database schema, project scaffolding, basic models

#### 1.1 Project Setup (4h)
```
- [ ] Create corporate-council/ directory structure
- [ ] Initialize pyproject.toml with dependencies
- [ ] Configure alembic for migrations
- [ ] Set up pytest, coverage, pre-commit hooks
- [ ] Create .env.example with required vars
```

#### 1.2 Database Models (8h)
```
- [ ] Create SQLAlchemy Base, async engine
- [ ] Debate model (matches SPEC 7.1 schema)
- [ ] AdvisorConfig model (13 advisors)
- [ ] CircuitBreakerState model
- [ ] CostLog model
- [ ] Initial Alembic migration
```

#### 1.3 Pydantic Schemas (6h)
```
- [ ] DeliberateRequest, DeliberateResponse
- [ ] SessionStatus, AdvisorOpinion
- [ ] ConsensusResult, RedTeamChallenge
- [ ] DecideRequest, DebateSummary
- [ ] AnalyticsResponse
```

#### 1.4 Configuration (4h)
```
- [ ] Settings class (API keys, thresholds)
- [ ] AdvisorRegistry (A1-A13 with all params)
- [ ] VotingWeights (6 question types)
- [ ] CostConfig (per-model pricing)
```

**Deliverables**:
- Database schema applied
- All Pydantic models validated against SPEC
- Config loading from env vars

---

### Phase 2: Multi-Model Orchestration (25-30 hours)

**Goal**: Working advisor clients with fallback and circuit breakers

#### 2.1 Advisor Base Class (4h)
```python
# advisors/base.py
class AdvisorBase(ABC):
    @abstractmethod
    async def get_opinion(
        self,
        question: str,
        context: str,
        role_prompt: str,
        temperature: float,
        reasoning_budget: int
    ) -> AdvisorOpinion:
        """Generate opinion for deliberation phase 1."""

    @abstractmethod
    async def update_opinion(
        self,
        question: str,
        own_opinion: str,
        other_opinions: List[OpinionSummary]
    ) -> AdvisorOpinion:
        """Update opinion after seeing others (phase 2)."""
```

#### 2.2 Claude Advisor (6h)
```
- [ ] ClaudeAdvisor implementing AdvisorBase
- [ ] Extended thinking support (budget_tokens)
- [ ] Response parsing (opinion, confidence, vote)
- [ ] Error handling (timeout, rate limit)
- [ ] Unit tests with mocked API
```

#### 2.3 Gemini Advisor (6h)
```
- [ ] GeminiAdvisor implementing AdvisorBase
- [ ] Google Search grounding for tools=on
- [ ] Response parsing
- [ ] Error handling
- [ ] Unit tests
```

#### 2.4 OpenAI Advisor (4h)
```
- [ ] OpenAIAdvisor implementing AdvisorBase
- [ ] Function calling for tools=on
- [ ] Response parsing
- [ ] Error handling
- [ ] Unit tests
```

#### 2.5 Circuit Breaker (4h)
```
- [ ] AdvisorCircuitBreaker class
- [ ] States: CLOSED -> OPEN -> HALF_OPEN
- [ ] Redis-backed state for distributed
- [ ] Metrics emission on state change
- [ ] Unit tests
```

#### 2.6 Fallback Manager (4h)
```
- [ ] FallbackManager class
- [ ] Fallback chain per primary model
- [ ] Integration with circuit breaker
- [ ] Logging of fallback events
- [ ] Unit tests
```

**Deliverables**:
- All 3 model clients working
- Circuit breaker with Redis state
- Fallback working for 503/timeout

---

### Phase 3: Deliberation Engine (25-30 hours)

**Goal**: Complete 5-phase deliberation with consensus

#### 3.1 Phase 1: Independent Opinions (6h)
```
- [ ] Parallel execution of 12 advisors
- [ ] 15s timeout per advisor
- [ ] ABSTAIN on failure
- [ ] Cost tracking per call
- [ ] Progress tracking
```

#### 3.2 Phase 2: Cross-Examination (6h)
```
- [ ] Sequential execution
- [ ] Build opinion summary (role, not model)
- [ ] Track flip count
- [ ] 10s timeout per advisor
- [ ] Update opinions in DB
```

#### 3.3 Phase 3: Consensus Calculator (4h)
```python
# engine/consensus.py
def calculate_consensus(
    votes: Dict[str, Vote],
    question_type: QuestionType
) -> ConsensusResult:
    """
    Apply weights from SPEC 5.3.
    Return outcome: PROCEED/DECLINE/CONDITIONAL/DEADLOCK
    """
```

#### 3.4 Phase 4: Red Team Challenge (4h)
```
- [ ] A13 receives full context
- [ ] Parse fatal_flaws, hidden_assumptions
- [ ] Calculate groupthink_score
- [ ] 20s timeout
```

#### 3.5 Phase 5: Synthesis (4h)
```
- [ ] A1 synthesizes recommendation
- [ ] Include conditions, kill_criteria
- [ ] Dissent summary
- [ ] 15s timeout
```

#### 3.6 Quorum Validation (4h)
```
- [ ] QuorumValidator class
- [ ] 7 of 12 minimum
- [ ] 1 per cluster requirement
- [ ] INSUFFICIENT_QUORUM outcome
```

**Deliverables**:
- Full deliberation flow working
- Consensus calculation correct
- Quorum enforcement active

---

### Phase 4: API & WebSocket (20-25 hours)

**Goal**: Complete REST API and real-time updates

#### 4.1 Core Endpoints (8h)
```
- [ ] POST /api/council/deliberate
- [ ] GET /api/council/session/{id}
- [ ] POST /api/council/session/{id}/decide
- [ ] GET /api/council/history
- [ ] GET /api/council/advisor/{id}/performance
- [ ] GET /api/council/analytics
```

#### 4.2 WebSocket Handler (8h)
```
- [ ] Connection manager (per session_id)
- [ ] Redis pub/sub for scaling
- [ ] Event emission:
    - council.phase_changed
    - council.opinion_ready
    - council.consensus_reached
    - council.red_team_challenge
    - council.synthesis_complete
    - council.error
    - council.fallback_triggered
- [ ] Heartbeat/reconnection
```

#### 4.3 Memory MCP Integration (6h)
```
- [ ] MemoryMCPClient wrapper
- [ ] DebateStorage (save/retrieve)
- [ ] PrecedentFinder (semantic search)
- [ ] WHO/WHEN/PROJECT/WHY metadata
```

**Deliverables**:
- All API endpoints working
- WebSocket real-time updates
- Memory MCP storing debates

---

### Phase 5: Frontend (30-35 hours)

**Goal**: Complete "The Boardroom" UI

#### 5.1 Project Setup (4h)
```
- [ ] Vite + React 19 + TypeScript
- [ ] Tailwind + shadcn/ui setup
- [ ] Zustand stores
- [ ] API client setup
- [ ] WebSocket hook
```

#### 5.2 Boardroom Components (16h)
```
- [ ] QuestionInput (auto-detect type)
- [ ] PrecedentsPanel (collapsible)
- [ ] AdvisorGrid (3x4 layout)
- [ ] AdvisorCard (Framer Motion animations)
- [ ] ConsensusGauge (D3.js)
- [ ] RedTeamPanel (severity colors)
- [ ] SynthesisPanel (markdown)
- [ ] ActionBar (Accept/Override/Modify)
```

#### 5.3 Secondary Pages (8h)
```
- [ ] HistoryPage (list + filters)
- [ ] AnalyticsPage (charts)
- [ ] AdvisorPage (performance detail)
- [ ] SettingsPage (config)
```

#### 5.4 Accessibility (4h)
```
- [ ] ARIA labels per SPEC 20.2
- [ ] Keyboard navigation
- [ ] Focus management
- [ ] prefers-reduced-motion
```

**Deliverables**:
- Full UI matching SPEC mockup
- Real-time WebSocket updates
- WCAG 2.1 AA compliant

---

### Phase 6: Observability & Testing (15-20 hours)

**Goal**: Production-ready monitoring and test coverage

#### 6.1 Metrics (4h)
```
- [ ] Prometheus metrics per SPEC 16.1
- [ ] council_deliberation_duration_seconds
- [ ] council_advisor_response_seconds
- [ ] council_cost_usd_total
- [ ] council_errors_total
- [ ] council_fallback_triggers_total
```

#### 6.2 Tracing (4h)
```
- [ ] OpenTelemetry setup
- [ ] Span per deliberation phase
- [ ] Trace propagation to model APIs
- [ ] Jaeger/Tempo export
```

#### 6.3 Alerting (3h)
```
- [ ] HighDeliberationLatency alert
- [ ] AdvisorUnavailable alert
- [ ] HighFallbackRate alert
- [ ] DailyBudgetExceeded alert
```

#### 6.4 Integration Tests (6h)
```
- [ ] Happy path (full deliberation)
- [ ] Partial failure (quorum maintained)
- [ ] Below quorum (abort)
- [ ] Fallback trigger
- [ ] Rate limit handling
```

**Deliverables**:
- Grafana dashboard
- Alerting rules active
- >80% test coverage

---

## 6. DEPENDENCY GRAPH

```
Phase 1 (Foundation)
    |
    v
Phase 2 (Multi-Model) ----+
    |                      |
    v                      |
Phase 3 (Engine) ---------+
    |                      |
    v                      |
Phase 4 (API/WS) ---------+
    |                      |
    +----------+-----------+
               |
               v
         Phase 5 (Frontend)
               |
               v
         Phase 6 (Observability)
```

**Critical Dependencies**:
1. Phase 2 depends on Phase 1 (models, config)
2. Phase 3 depends on Phase 2 (advisors)
3. Phase 4 depends on Phase 3 (engine)
4. Phase 5 depends on Phase 4 (API)
5. Phase 6 can start after Phase 4

---

## 7. MILESTONES

| Milestone | Phase | Definition of Done |
|-----------|-------|-------------------|
| M1: Schema Ready | 1 | Database migrated, models validated |
| M2: Advisors Working | 2 | All 3 model types responding |
| M3: Deliberation Complete | 3 | Full 5-phase flow, consensus correct |
| M4: API Live | 4 | All endpoints working, WS streaming |
| M5: UI Complete | 5 | Boardroom matches mockup |
| M6: Production Ready | 6 | Metrics, alerts, >80% coverage |

---

## 8. RISK MITIGATION

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Model API rate limits | HIGH | MEDIUM | Circuit breakers, fallbacks, request queuing |
| WebSocket scaling | MEDIUM | HIGH | Redis pub/sub from day 1 |
| Cost overruns | MEDIUM | MEDIUM | CostGuard with daily limits |
| Consensus deadlocks | LOW | LOW | CONDITIONAL outcome, user tie-break |
| Memory MCP integration | MEDIUM | MEDIUM | Abstract behind interface, mock for testing |

---

## 9. DEVELOPMENT ORDER (Sequential)

```
Week 1: Phase 1 (Foundation)
  Day 1-2: Project setup, database models
  Day 3-4: Pydantic schemas
  Day 5: Configuration, advisor registry

Week 2: Phase 2 (Multi-Model)
  Day 1-2: Advisor base class, Claude
  Day 3: Gemini
  Day 4: OpenAI
  Day 5: Circuit breaker, fallback

Week 3: Phase 3 (Engine)
  Day 1-2: Phase 1 & 2 deliberation
  Day 3: Consensus calculator
  Day 4: Red team, synthesis
  Day 5: Quorum validation, integration

Week 4: Phase 4 (API/WS)
  Day 1-2: Core REST endpoints
  Day 3-4: WebSocket handler
  Day 5: Memory MCP integration

Week 5: Phase 5 (Frontend)
  Day 1: Project setup, stores
  Day 2-3: Boardroom components
  Day 4: Secondary pages
  Day 5: Accessibility, polish

Week 6: Phase 6 (Observability)
  Day 1-2: Metrics, tracing
  Day 3: Alerting
  Day 4-5: Integration tests, coverage
```

---

## 10. CONTEXT CASCADE INTEGRATION

### 10.1 Skill Registration

Create `skills/orchestration/corporate-council/skill.yaml`:

```yaml
name: corporate-council
description: 13-role AI advisory board with Byzantine consensus
version: 1.0.0
triggers:
  - "/council"
  - "deliberate"
  - "advisory board"
  - "consensus"
agents:
  - council-orchestrator
  - red-team-challenger
hooks:
  pre_deliberation:
    - validate_question_length
    - check_cost_budget
  post_decision:
    - store_to_memory_mcp
    - emit_metrics
```

### 10.2 Memory Namespace

```
council/
  debates/{session_id}     # Full debate records
  precedents/              # Semantic index
  analytics/               # Aggregated stats
  learning/                # Weight adjustments (future)
```

---

## 11. TESTING STRATEGY SUMMARY

| Test Type | Framework | Coverage Target | Runs |
|-----------|-----------|-----------------|------|
| Unit | pytest | 90% | Every commit |
| Integration | pytest + testcontainers | 80% | Every PR |
| Load | k6 | p95 < 60s | Weekly |
| E2E | Playwright | Critical paths | Before release |
| Chaos | Custom | Fallback works | Monthly |

---

## 12. SUCCESS CRITERIA

| Metric | Target | Phase |
|--------|--------|-------|
| All models responding | 100% | M2 |
| Deliberation completes | p95 < 60s | M3 |
| API endpoints passing | 100% | M4 |
| UI matches mockup | 100% | M5 |
| Test coverage | >80% | M6 |
| Cost per deliberation | <$2 avg | M6 |

---

PLAN_VERSION: 1.0
PLAN_STATUS: APPROVED
PLAN_AUTHOR: Claude Opus 4.5
PLAN_DATE: 2026-01-08
PLAN_CONFIDENCE: 0.92 (ceiling: inference 0.70)
