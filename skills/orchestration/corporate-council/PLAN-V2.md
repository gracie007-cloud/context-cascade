# Corporate Advisor Council - Implementation Plan v2.0

## PLAN METADATA

```
PLAN_VERSION: 2.0
PLAN_STATUS: APPROVED
SPEC_VERSION: 0.4
AUTHOR: Claude Opus 4.5
DATE: 2026-01-08
METHODOLOGY: Sequential Thinking + Skill/Agent Mapping + Quality Gates
SKILL_COUNT: 237 skills analyzed
AGENT_COUNT: 217 agents analyzed
```

---

## 1. EXECUTIVE SUMMARY

Enhanced implementation plan that maps Context Cascade's 237 skills and 217 agents to each phase, with mandatory quality gates using theater detection, functionality audits, connascence analysis, and the 7-analyzer suite.

**Total Estimated Effort**: 120-160 hours across 6 phases
**Quality Gates**: 6 gates (one per phase)
**Critical Path**: Database -> Core Engine -> API -> WebSocket -> Frontend -> Observability

---

## 2. SKILL & AGENT MAPPING BY PHASE

### Phase 1: Foundation (20-25 hours)

#### Skills to Apply

| Skill | Purpose | When |
|-------|---------|------|
| `python-specialist` | SQLAlchemy models, Pydantic schemas | Model creation |
| `sop-api-development` | API contract design | Schema design |
| `dependencies` | Dependency management | pyproject.toml |
| `production-readiness` | DB migration strategy | Alembic setup |

#### Agents to Spawn

```javascript
// Database Models
Task("Create debate models", "Create SQLAlchemy models for Debate, AdvisorConfig, CostLog matching SPEC 7.1 schema", "python-expert")

// Pydantic Schemas
Task("Create API schemas", "Create Pydantic v2 schemas for all request/response types from SPEC 8.1", "python-expert")

// Configuration
Task("Create config system", "Create pydantic-settings config with API keys, thresholds, advisor registry", "python-expert")

// Database Migration
Task("Create initial migration", "Create Alembic migration for all tables with proper indexes", "db-architect")
```

#### Quality Gate 1: Foundation Gate

```yaml
gate_id: G1_FOUNDATION
trigger: After Phase 1 complete
skills:
  - theater-detection-audit:
      targets: [src/council/models/, src/council/config.py]
      blockers: [TODO, FIXME, placeholder, NotImplementedError]
      pass_criteria: zero_blockers

  - functionality-audit:
      targets: [tests/unit/test_models.py]
      execution: pytest --cov=src/council/models
      pass_criteria: coverage >= 80%, all_tests_pass

  - connascence-quality-gate:
      targets: [src/council/models/]
      forbidden: [CoE, CoT2, CoV, CoI]  # No dynamic connascence
      pass_criteria: only_static_connascence

pass_threshold: ALL gates must pass
on_fail: Block Phase 2, return to remediation
```

---

### Phase 2: Multi-Model Orchestration (25-30 hours)

#### Skills to Apply

| Skill | Purpose | When |
|-------|---------|------|
| `python-specialist` | Async model clients | Client implementation |
| `multi-model` | Multi-provider routing | Client abstraction |
| `smart-bug-fix` | API error handling | Error recovery |
| `testing-framework` | Mock API testing | Test harness |

#### Agents to Spawn

```javascript
// Advisor Base Class
Task("Create advisor base", "Create AdvisorBase ABC with get_opinion, update_opinion methods per SPEC", "python-expert")

// Claude Advisor (Parallel)
Task("Create Claude client", "Implement ClaudeAdvisor with extended thinking support, response parsing, error handling", "python-expert")

// Gemini Advisor (Parallel)
Task("Create Gemini client", "Implement GeminiAdvisor with Google Search grounding for tools=on", "python-expert")

// OpenAI Advisor (Parallel)
Task("Create OpenAI client", "Implement OpenAIAdvisor with function calling, response parsing", "python-expert")

// Circuit Breaker
Task("Create circuit breaker", "Implement AdvisorCircuitBreaker with Redis-backed state per SPEC 6.3", "python-expert")

// Fallback Manager
Task("Create fallback manager", "Implement FallbackManager with fallback chains per SPEC 4.7", "python-expert")
```

#### Quality Gate 2: Multi-Model Gate

```yaml
gate_id: G2_MULTIMODEL
trigger: After Phase 2 complete
skills:
  - theater-detection-audit:
      targets: [src/council/advisors/]
      blockers: [mock_response, fake_api, hardcoded_return]
      pass_criteria: zero_blockers

  - functionality-audit:
      targets: [tests/unit/test_advisors.py, tests/integration/test_model_calls.py]
      execution: |
        pytest tests/unit/test_advisors.py -v
        pytest tests/integration/test_model_calls.py -v --timeout=30
      pass_criteria: all_tests_pass

  - connascence-quality-gate:
      targets: [src/council/advisors/]
      check_types:
        - CoN: WARN  # Name coupling acceptable
        - CoT: WARN  # Type coupling acceptable
        - CoA: BLOCK # Algorithm coupling forbidden (each model independent)
      pass_criteria: no_CoA_violations

  - security-audit:
      targets: [src/council/advisors/]
      checks: [no_hardcoded_keys, env_var_usage, secret_masking_in_logs]
      pass_criteria: zero_security_issues

pass_threshold: ALL gates must pass
on_fail: Block Phase 3
```

---

### Phase 3: Deliberation Engine (25-30 hours)

#### Skills to Apply

| Skill | Purpose | When |
|-------|---------|------|
| `python-specialist` | Engine implementation | Core logic |
| `cascade-orchestrator` | 5-phase orchestration | Phase flow |
| `testing-framework` | Consensus testing | Algorithm validation |
| `functionality-audit` | Verify consensus correct | Integration tests |

#### Agents to Spawn

```javascript
// Phase 1: Independent Opinions
Task("Build phase 1 engine", "Implement parallel opinion gathering with 15s timeout, ABSTAIN handling", "python-expert")

// Phase 2: Cross-Examination
Task("Build phase 2 engine", "Implement sequential cross-exam with flip tracking, 10s timeout", "python-expert")

// Phase 3: Consensus
Task("Build consensus calculator", "Implement calculate_consensus with voting weights per SPEC 5.2-5.3", "python-expert")

// Phase 4: Red Team
Task("Build red team challenger", "Implement RedTeamChallenger with fatal_flaws, groupthink_score", "python-expert")

// Phase 5: Synthesis
Task("Build synthesizer", "Implement SynthesisEngine for A1 final recommendation with conditions", "python-expert")

// Quorum Validation
Task("Build quorum validator", "Implement QuorumValidator with 7/12 minimum, cluster requirements", "python-expert")

// Integration
Task("Integrate deliberation engine", "Wire all 5 phases into DeliberationEngine with state machine", "python-expert")
```

#### Quality Gate 3: Engine Gate

```yaml
gate_id: G3_ENGINE
trigger: After Phase 3 complete
skills:
  - theater-detection-audit:
      targets: [src/council/engine/]
      blockers: [return 0.5, fake_consensus, stub_phase]
      pass_criteria: zero_blockers

  - functionality-audit:
      targets: [tests/unit/test_consensus.py, tests/unit/test_quorum.py, tests/integration/test_deliberation.py]
      execution: |
        pytest tests/unit/test_consensus.py -v
        pytest tests/unit/test_quorum.py -v
        pytest tests/integration/test_deliberation.py -v --timeout=120
      test_scenarios:
        - happy_path: All 12 advisors respond, consensus reached
        - partial_failure: 3 advisors timeout, quorum maintained
        - below_quorum: 6 fail, should abort
        - deadlock: 50/50 split, returns CONDITIONAL
      pass_criteria: all_scenarios_pass

  - connascence-quality-gate:
      targets: [src/council/engine/]
      check_types:
        - CoE: BLOCK  # Execution order must be explicit (phases 1-5)
        - CoT2: BLOCK # Timing coupling forbidden
        - CoP: WARN   # Position coupling in vote arrays acceptable
      pass_criteria: no_CoE_CoT2_violations

  - style-audit:
      targets: [src/council/engine/]
      rules: [typing_complete, docstrings_present, max_function_length_50]
      pass_criteria: zero_style_violations

pass_threshold: ALL gates must pass
on_fail: Block Phase 4
```

---

### Phase 4: API & WebSocket (20-25 hours)

#### Skills to Apply

| Skill | Purpose | When |
|-------|---------|------|
| `sop-api-development` | REST endpoint design | API implementation |
| `python-specialist` | FastAPI routers | Endpoint code |
| `testing-framework` | API testing | Route tests |
| `production-readiness` | WebSocket scaling | Redis pub/sub |

#### Agents to Spawn

```javascript
// REST Endpoints (Parallel)
Task("Create council router", "Implement /api/council/deliberate, session, decide, history endpoints per SPEC 8.1", "python-expert")
Task("Create analytics router", "Implement /api/council/analytics endpoint per SPEC 8.1", "python-expert")
Task("Create advisor router", "Implement /api/council/advisor/{id}/performance endpoint", "python-expert")

// WebSocket Handler
Task("Create WebSocket handler", "Implement WebSocket with Redis pub/sub for all events per SPEC 8.2", "python-expert")

// Memory MCP Integration
Task("Create Memory MCP client", "Implement MemoryMCPClient, DebateStorage, PrecedentFinder per SPEC 7", "python-expert")

// Middleware
Task("Create API middleware", "Implement rate limiting, cost guard, JWT auth per SPEC 12", "python-expert")
```

#### Quality Gate 4: API Gate

```yaml
gate_id: G4_API
trigger: After Phase 4 complete
skills:
  - theater-detection-audit:
      targets: [src/council/api/]
      blockers: [return {"status": "ok"}, mock_data, placeholder_response]
      pass_criteria: zero_blockers

  - functionality-audit:
      targets: [tests/integration/test_api.py, tests/integration/test_websocket.py]
      execution: |
        pytest tests/integration/test_api.py -v
        pytest tests/integration/test_websocket.py -v --timeout=60
      test_scenarios:
        - deliberate_endpoint: POST creates session, returns estimated_cost
        - session_endpoint: GET returns progress, opinions
        - decide_endpoint: POST records decision
        - websocket_events: All 7 event types emit correctly
        - rate_limiting: 429 on excess requests
      pass_criteria: all_scenarios_pass

  - security-audit:
      targets: [src/council/api/]
      checks:
        - input_validation: All Pydantic models validate
        - auth: JWT required on all endpoints
        - cors: Restricted origins
        - rate_limit: 10 deliberations/hour
      pass_criteria: zero_security_issues

  - connascence-quality-gate:
      targets: [src/council/api/, src/council/services/]
      check_types:
        - CoI: WARN  # Identity coupling via session_id acceptable
        - CoV: BLOCK # Value coupling between services forbidden
      pass_criteria: no_CoV_violations

pass_threshold: ALL gates must pass
on_fail: Block Phase 5
```

---

### Phase 5: Frontend (30-35 hours)

#### Skills to Apply

| Skill | Purpose | When |
|-------|---------|------|
| `typescript-specialist` | TypeScript/React code | Component implementation |
| `frontend-specialists` | React 19 patterns | Modern React |
| `ui-ux-excellence` | Design system | shadcn/Framer Motion |
| `testing-framework` | E2E testing | Playwright |

#### Agents to Spawn

```javascript
// Project Setup
Task("Setup React project", "Initialize Vite + React 19 + TypeScript + Tailwind + shadcn/ui", "typescript-expert")

// Stores
Task("Create Zustand stores", "Create deliberation, history, settings stores with WebSocket integration", "typescript-expert")

// Boardroom Components (Parallel)
Task("Create QuestionInput", "Build textarea with question type auto-detection per SPEC 9.1", "frontend-specialist")
Task("Create AdvisorGrid", "Build 3x4 grid with Framer Motion animations per SPEC 9.1", "frontend-specialist")
Task("Create ConsensusGauge", "Build D3.js linear gauge with real-time WebSocket updates", "frontend-specialist")
Task("Create RedTeamPanel", "Build alert panel with severity colors per SPEC 9.1", "frontend-specialist")

// Secondary Pages (Parallel)
Task("Create HistoryPage", "Build list view with filters, semantic search", "frontend-specialist")
Task("Create AnalyticsPage", "Build charts: consensus rate, cost trends, accuracy rankings", "frontend-specialist")
Task("Create SettingsPage", "Build config UI for limits, fallbacks, thresholds", "frontend-specialist")

// Accessibility
Task("Add accessibility", "Add ARIA labels, keyboard nav, focus management per SPEC 20", "frontend-specialist")
```

#### Quality Gate 5: Frontend Gate

```yaml
gate_id: G5_FRONTEND
trigger: After Phase 5 complete
skills:
  - theater-detection-audit:
      targets: [council-ui/src/]
      blockers: [TODO, console.log, placeholder, mock_data]
      pass_criteria: zero_blockers

  - functionality-audit:
      targets: [council-ui/tests/e2e/]
      execution: |
        npx playwright test
      test_scenarios:
        - full_deliberation: Submit question -> watch advisors populate -> see consensus
        - history_navigation: Browse history, filter by type
        - settings_update: Change cost limit, verify applied
        - accessibility: Tab navigation works, screen reader compatible
      pass_criteria: all_e2e_pass

  - style-audit:
      targets: [council-ui/src/]
      rules:
        - eslint: zero_errors
        - prettier: formatted
        - typescript: strict_mode
        - tailwind: no_arbitrary_values
      pass_criteria: zero_style_violations

  - connascence-quality-gate:
      targets: [council-ui/src/]
      check_types:
        - CoN: WARN  # Name coupling acceptable
        - CoT: WARN  # Type coupling acceptable (TypeScript)
        - CoP: BLOCK # Position coupling in props forbidden (use named props)
      pass_criteria: no_CoP_violations

pass_threshold: ALL gates must pass
on_fail: Block Phase 6
```

---

### Phase 6: Observability & Testing (15-20 hours)

#### Skills to Apply

| Skill | Purpose | When |
|-------|---------|------|
| `opentelemetry-observability` | Tracing setup | Distributed tracing |
| `observability` | Metrics design | Prometheus metrics |
| `testing-framework` | Load testing | k6 tests |
| `production-readiness` | Alerting rules | Grafana alerts |

#### Agents to Spawn

```javascript
// Metrics
Task("Create Prometheus metrics", "Implement all metrics from SPEC 16.1 with correct labels and buckets", "python-expert")

// Tracing
Task("Create OpenTelemetry setup", "Implement distributed tracing with spans per deliberation phase", "python-expert")

// Alerting
Task("Create alerting rules", "Implement alerting rules from SPEC 16.3 for Grafana", "devops-specialist")

// Dashboard
Task("Create Grafana dashboard", "Build dashboard with panels from SPEC 16.4", "devops-specialist")

// Load Tests
Task("Create k6 load tests", "Implement sustained_load and burst scenarios per SPEC 15.3", "tester")

// Integration Tests
Task("Create integration test suite", "Implement all scenarios from SPEC 15.2", "tester")
```

#### Quality Gate 6: Production Gate (FINAL)

```yaml
gate_id: G6_PRODUCTION
trigger: After Phase 6 complete
skills:
  - audit-pipeline:
      description: Full 3-stage audit pipeline
      stages:
        1_theater: theater-detection-audit on entire codebase
        2_functionality: functionality-audit with full test suite
        3_style: style-audit on all Python and TypeScript

  - connascence-quality-gate:
      targets: [src/, council-ui/src/]
      full_scan: true
      report_format: SARIF
      check_all_9_types: true
      severity_map:
        CoN: note
        CoT: note
        CoM: warning
        CoP: warning
        CoA: warning
        CoE: error
        CoT2: error
        CoV: error
        CoI: error
      pass_criteria: zero_errors, warnings < 10

  - functionality-audit:
      execution: |
        # Backend
        pytest --cov=src/council --cov-report=xml
        # Frontend
        cd council-ui && npm test -- --coverage
        # E2E
        cd council-ui && npx playwright test
        # Load
        k6 run tests/load/k6_load_test.js
      coverage_threshold: 80%
      load_test_threshold: p95 < 60s
      pass_criteria: coverage >= 80%, p95 < 60s, all_tests_pass

  - security-audit:
      tools: [bandit, safety, npm_audit]
      execution: |
        bandit -r src/council -f json
        safety check --json
        cd council-ui && npm audit --json
      pass_criteria: zero_high_vulnerabilities

  - holistic-evaluation:
      checklist:
        - [ ] All API endpoints documented (OpenAPI)
        - [ ] All WebSocket events tested
        - [ ] Metrics emitting to Prometheus
        - [ ] Tracing spans visible in Jaeger
        - [ ] Alerting rules firing correctly
        - [ ] Cost tracking accurate
        - [ ] Memory MCP integration verified
      pass_criteria: all_checks_complete

pass_threshold: ALL gates must pass
on_fail: Return to remediation, do NOT deploy
```

---

## 3. COMPLETE SKILL/AGENT MAPPING TABLE

### Skills by Phase

| Phase | Skills Used | Count |
|-------|-------------|-------|
| 1: Foundation | python-specialist, sop-api-development, dependencies, production-readiness | 4 |
| 2: Multi-Model | python-specialist, multi-model, smart-bug-fix, testing-framework | 4 |
| 3: Engine | python-specialist, cascade-orchestrator, testing-framework, functionality-audit | 4 |
| 4: API | sop-api-development, python-specialist, testing-framework, production-readiness | 4 |
| 5: Frontend | typescript-specialist, frontend-specialists, ui-ux-excellence, testing-framework | 4 |
| 6: Observability | opentelemetry-observability, observability, testing-framework, production-readiness | 4 |

### Agents by Phase

| Phase | Agents Used | Count |
|-------|-------------|-------|
| 1: Foundation | python-expert, db-architect | 2 |
| 2: Multi-Model | python-expert (x6) | 6 |
| 3: Engine | python-expert (x7) | 7 |
| 4: API | python-expert (x5) | 5 |
| 5: Frontend | typescript-expert, frontend-specialist (x8) | 9 |
| 6: Observability | python-expert (x2), devops-specialist (x2), tester (x2) | 6 |

### Quality Gate Skills

| Gate | Skills Applied | Pass Criteria |
|------|----------------|---------------|
| G1 | theater-detection-audit, functionality-audit, connascence-quality-gate | zero_blockers, coverage >= 80%, only_static_connascence |
| G2 | theater-detection-audit, functionality-audit, connascence-quality-gate, security-audit | zero_blockers, all_tests_pass, no_CoA, zero_security_issues |
| G3 | theater-detection-audit, functionality-audit, connascence-quality-gate, style-audit | zero_blockers, all_scenarios_pass, no_CoE_CoT2, zero_style_violations |
| G4 | theater-detection-audit, functionality-audit, security-audit, connascence-quality-gate | zero_blockers, all_scenarios_pass, zero_security, no_CoV |
| G5 | theater-detection-audit, functionality-audit, style-audit, connascence-quality-gate | zero_blockers, all_e2e_pass, zero_style, no_CoP |
| G6 | audit-pipeline, connascence-quality-gate, functionality-audit, security-audit, holistic-evaluation | ALL must pass |

---

## 4. CONNASCENCE ANALYSIS DETAIL

### 9 Connascence Types (Weakest to Strongest)

| Type | Name | Allowed | Forbidden | Rationale |
|------|------|---------|-----------|-----------|
| CoN | Connascence of Name | ALL | - | Naming is necessary |
| CoT | Connascence of Type | ALL | - | Type safety is good |
| CoM | Connascence of Meaning | API boundaries | Internal | Magic values documented at edges |
| CoP | Connascence of Position | Arrays, tuples | Function params | Use named params |
| CoA | Connascence of Algorithm | Crypto, hashing | Business logic | Each advisor independent |
| CoE | Connascence of Execution | Deliberation phases | Services | Explicit phase state machine |
| CoT2 | Connascence of Timing | NONE | ALL | No timing dependencies |
| CoV | Connascence of Value | Config | Services | Values flow through config |
| CoI | Connascence of Identity | Session ID | Components | Minimize shared references |

### Per-Module Connascence Rules

```yaml
src/council/models/:
  allowed: [CoN, CoT]
  forbidden: [CoE, CoT2, CoV, CoI]
  rationale: Models are pure data, no behavior coupling

src/council/advisors/:
  allowed: [CoN, CoT, CoM]
  forbidden: [CoA, CoE, CoT2]
  rationale: Each advisor must be independent

src/council/engine/:
  allowed: [CoN, CoT, CoE]  # CoE allowed for phase ordering
  forbidden: [CoT2, CoV, CoI]
  rationale: Explicit phase execution, no timing/value coupling

src/council/api/:
  allowed: [CoN, CoT, CoI]  # CoI for session_id
  forbidden: [CoV, CoE, CoT2]
  rationale: Stateless endpoints, identity via session

council-ui/src/:
  allowed: [CoN, CoT]
  forbidden: [CoP, CoE, CoV]
  rationale: Named props, no position or value coupling
```

---

## 5. QUALITY GATE WORKFLOW

```
                    Phase N Complete
                           |
                           v
            +-----------------------------+
            |   Gate N: Theater Detection  |
            |   Skill: theater-detection   |
            +-----------------------------+
                           |
                      PASS | FAIL -> Remediate
                           v
            +-----------------------------+
            |  Gate N: Functionality Audit |
            |   Skill: functionality-audit |
            +-----------------------------+
                           |
                      PASS | FAIL -> Remediate
                           v
            +-----------------------------+
            |  Gate N: Connascence Scan    |
            |   Skill: connascence-quality |
            +-----------------------------+
                           |
                      PASS | FAIL -> Remediate
                           v
            +-----------------------------+
            |  Gate N: Security/Style      |
            |   Skills: security/style     |
            +-----------------------------+
                           |
                      PASS | FAIL -> Remediate
                           v
                    Phase N+1 Unlocked
```

---

## 6. RALPH WIGGUM QUALITY LOOPS

Each gate supports Ralph Wiggum infinite refinement:

```python
class QualityGateRunner:
    """
    Ralph Wiggum pattern for quality gates.
    Iterates until pass or max_iterations reached.
    """

    def run_gate(self, gate_id: str, max_iterations: int = 10) -> GateResult:
        for iteration in range(max_iterations):
            # Run all gate skills
            theater = await self.run_skill("theater-detection-audit", gate_id)
            if theater.blockers > 0:
                await self.remediate(theater.findings)
                continue

            functionality = await self.run_skill("functionality-audit", gate_id)
            if not functionality.all_pass:
                await self.remediate(functionality.failures)
                continue

            connascence = await self.run_skill("connascence-quality-gate", gate_id)
            if connascence.violations > 0:
                await self.remediate(connascence.findings)
                continue

            # All passed
            return GateResult(passed=True, iterations=iteration + 1)

        return GateResult(passed=False, reason="max_iterations_exceeded")
```

---

## 7. FULL 7-ANALYZER SUITE (Final Gate)

The Production Gate (G6) runs the full 7-analyzer suite from claude-dev-cli:

| Analyzer | What It Checks | Pass Criteria |
|----------|----------------|---------------|
| **Connascence** | 9 coupling types | Zero CoE/CoT2/CoV/CoI errors |
| **NASA Safety** | Power of 10 rules | >95% compliance |
| **MECE** | Code duplication | >80% uniqueness |
| **Clarity Linter** | Cognitive complexity | Score > 7/10 |
| **Six Sigma** | DPMO quality | DPMO < 6210 |
| **Theater Detection** | Fake code | Zero blockers |
| **Safety Violations** | God objects, bombs | Zero critical |

```bash
# Run full 7-analyzer suite
claude-dev quality analyze src/ council-ui/src/ --profile strict

# Run quality gate (pass/fail)
claude-dev quality gate src/ council-ui/src/ --strict

# Generate Six Sigma report
claude-dev quality sigma src/
```

---

## 8. DEPLOYMENT PREREQUISITES

Before deploying to production, ALL must be true:

```yaml
prerequisites:
  quality:
    - [ ] G6_PRODUCTION gate passed
    - [ ] Test coverage >= 80%
    - [ ] p95 latency < 60s confirmed
    - [ ] Zero high-severity vulnerabilities

  documentation:
    - [ ] OpenAPI spec generated and reviewed
    - [ ] SPEC.md up to date
    - [ ] PLAN.md reflects actual implementation

  infrastructure:
    - [ ] PostgreSQL 15 provisioned
    - [ ] Redis 7 provisioned
    - [ ] ChromaDB collection created
    - [ ] API keys in Vault/env

  observability:
    - [ ] Prometheus scraping metrics
    - [ ] Jaeger receiving traces
    - [ ] Grafana dashboards deployed
    - [ ] Alerting rules active

  runbook:
    - [ ] Disaster recovery documented
    - [ ] Rollback procedure tested
    - [ ] On-call rotation defined
```

---

## 9. SUMMARY

### Skills Used: 24 unique skills

```
delivery: sop-api-development, testing-framework
quality: theater-detection-audit, functionality-audit, connascence-quality-gate, style-audit, security-audit, audit-pipeline, holistic-evaluation
operations: opentelemetry-observability, production-readiness
specialists: python-specialist, typescript-specialist, frontend-specialists
tooling: dependencies, ui-ux-excellence
orchestration: cascade-orchestrator, multi-model
```

### Agents Used: 35 agent invocations

```
python-expert: 20x
frontend-specialist: 8x
typescript-expert: 2x
db-architect: 1x
devops-specialist: 2x
tester: 2x
```

### Quality Gates: 6 mandatory gates

```
G1_FOUNDATION -> G2_MULTIMODEL -> G3_ENGINE -> G4_API -> G5_FRONTEND -> G6_PRODUCTION
```

### Analyzers: 7-analyzer suite at final gate

```
connascence + nasa + mece + clarity + sixsigma + theater + safety
```

---

PLAN_VERSION: 2.0
PLAN_STATUS: APPROVED
PLAN_AUTHOR: Claude Opus 4.5
PLAN_DATE: 2026-01-08
PLAN_CONFIDENCE: 0.94 (ceiling: inference 0.70)
