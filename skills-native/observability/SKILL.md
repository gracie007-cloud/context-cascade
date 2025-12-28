---
name: observability
description: Observability specialists hub for monitoring, logging, tracing, and alerting. Routes to specialists for metrics collection, log aggregation, distributed tracing, and incident response. Use for system observability, debugging production issues, and performance monitoring.
allowed-tools: Read, Glob, Grep, WebSearch, WebFetch, Task, TodoWrite
---

# Observability

Central hub for monitoring, logging, tracing, and system observability.

## Phase 0: Expertise Loading

```yaml
expertise_check:
  domain: observability
  file: .claude/expertise/observability.yaml

  if_exists:
    - Load monitoring patterns
    - Load alerting rules
    - Apply SLO definitions

  if_not_exists:
    - Flag discovery mode
    - Document patterns learned
```

## When to Use This Skill

Use observability when:
- Setting up monitoring infrastructure
- Implementing logging strategies
- Configuring distributed tracing
- Creating dashboards and alerts
- Debugging production issues

## Observability Pillars

| Pillar | Purpose |
|--------|---------|
| Metrics | Quantitative measurements |
| Logs | Event records |
| Traces | Request flow tracking |
| Alerts | Incident notification |

## Tool Ecosystem

### Metrics
```yaml
tools:
  - Prometheus
  - Grafana
  - Datadog
  - CloudWatch
metrics_types:
  - Counters
  - Gauges
  - Histograms
  - Summaries
```

### Logging
```yaml
tools:
  - ELK Stack (Elasticsearch, Logstash, Kibana)
  - Loki
  - Splunk
  - CloudWatch Logs
patterns:
  - Structured logging (JSON)
  - Log levels
  - Correlation IDs
```

### Tracing
```yaml
tools:
  - Jaeger
  - Zipkin
  - OpenTelemetry
  - X-Ray
patterns:
  - Span context propagation
  - Baggage items
  - Sampling strategies
```

## SLO/SLI/SLA

```yaml
definitions:
  SLI: "Service Level Indicator - measurable metric"
  SLO: "Service Level Objective - target value"
  SLA: "Service Level Agreement - contractual commitment"

example:
  SLI: "Request latency p99"
  SLO: "99% of requests < 200ms"
  SLA: "99.9% availability per month"
```

## MCP Requirements

- **claude-flow**: For orchestration
- **Bash**: For tool CLI commands

## Recursive Improvement Integration (v2.1)

### Eval Harness Integration

```yaml
benchmark: observability-benchmark-v1
  tests:
    - obs-001: Monitoring coverage
    - obs-002: Alert quality
  minimum_scores:
    monitoring_coverage: 0.85
    alert_quality: 0.80
```

### Memory Namespace

```yaml
namespaces:
  - observability/configs/{id}: Monitoring configs
  - observability/dashboards: Dashboard templates
  - improvement/audits/observability: Skill audits
```

### Uncertainty Handling

```yaml
confidence_check:
  if confidence >= 0.8:
    - Proceed with implementation
  if confidence 0.5-0.8:
    - Confirm tool stack
  if confidence < 0.5:
    - Ask for infrastructure details
```

### Cross-Skill Coordination

Works with: **infrastructure**, **deployment-readiness**, **performance-analysis**

---

## !! SKILL COMPLETION VERIFICATION (MANDATORY) !!

- [ ] **Agent Spawning**: Spawned agent via Task()
- [ ] **Agent Registry Validation**: Agent from registry
- [ ] **TodoWrite Called**: Called with 5+ todos
- [ ] **Work Delegation**: Delegated to agents

**Remember: Skill() -> Task() -> TodoWrite() - ALWAYS**

## Core Principles

### 1. Three Pillars Integration
Comprehensive observability requires unified collection and correlation of metrics, logs, and traces - no single pillar provides complete system visibility.

**In practice:**
- Implement metrics collection for quantitative measurements (counters, gauges, histograms)
- Deploy structured logging with correlation IDs for event tracking across services
- Configure distributed tracing with span context propagation for request flow visualization
- Correlate all three pillars using common identifiers (trace IDs, request IDs, user IDs)

### 2. Proactive Alerting with SLO-Based Thresholds
Alerting must be driven by Service Level Objectives that reflect actual user impact, not arbitrary metric thresholds that generate noise.

**In practice:**
- Define SLIs (Service Level Indicators) that measure user-facing behavior (p99 latency, error rate)
- Set SLOs (Service Level Objectives) based on business requirements (99% requests < 200ms)
- Configure alerts to fire when SLO burn rate exceeds acceptable thresholds
- Implement multi-window alerting to distinguish temporary spikes from sustained degradation

### 3. Context-Aware Monitoring with Dynamic Baselines
Effective monitoring adapts to changing system behavior through machine learning baselines, not static thresholds that break during normal traffic variations.

**In practice:**
- Use anomaly detection algorithms to learn normal behavior patterns
- Implement seasonal baselines that adjust for daily/weekly traffic cycles
- Correlate metrics across services to identify cascading failures
- Apply intelligent noise reduction to focus on actionable signals

## Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Metric-Only Monitoring | Collecting metrics without logs or traces misses critical context for debugging failures | Implement all three pillars with correlation, use traces to investigate metric anomalies |
| Alert Fatigue from Static Thresholds | Setting fixed thresholds generates false alarms during traffic variations, causing alert fatigue | Use SLO-based alerting with burn rate calculations and dynamic baselines that adapt to traffic patterns |
| Unstructured Logging | Free-form log messages prevent automated analysis and correlation across services | Adopt structured logging with JSON format, include correlation IDs, define standard log levels |
| Missing Sampling Strategies | Tracing 100% of requests creates performance overhead and storage costs | Implement adaptive sampling: high rates for errors/slow requests, low rates for successful fast requests |
| Dashboard Proliferation | Creating dozens of uncategorized dashboards makes critical information undiscoverable | Organize dashboards by audience (SRE, developers, business), implement role-based access, standardize layouts |

## Conclusion

The Observability skill establishes comprehensive system visibility through unified metrics, logs, and traces coordinated with intelligent alerting and dynamic monitoring. By implementing all three pillars with proper correlation, organizations gain the ability to debug complex distributed systems, proactively detect degradation, and understand user impact. The integration with tools like Prometheus for metrics, ELK/Loki for logs, and Jaeger/OpenTelemetry for traces provides production-grade observability infrastructure.

The SLO-based alerting framework transforms monitoring from reactive firefighting into proactive quality management. By defining Service Level Objectives that reflect actual business requirements and configuring alerts based on SLO burn rates, teams receive actionable notifications about genuine user impact rather than noisy metric threshold violations. The recursive improvement integration through benchmark evaluation ensures observability implementations meet quality standards for monitoring coverage and alert quality.

Organizations implementing this skill benefit from faster incident detection and resolution, reduced mean time to recovery (MTTR), and deeper understanding of system behavior under load. The expertise-aware workflow enables teams to leverage documented monitoring patterns and alerting rules specific to their infrastructure, preventing common pitfalls and accelerating observability maturity. When coordinated with infrastructure, deployment-readiness, and performance-analysis skills, observability creates a complete operational excellence framework.