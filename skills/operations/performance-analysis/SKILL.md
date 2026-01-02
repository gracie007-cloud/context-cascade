---
name: performance-analysis
description: Analyze and remediate performance bottlenecks with evidence-driven plans
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Investigate performance regressions or capacity risks, quantify impact, and propose validated fixes with experiments.

### Trigger Conditions
- **Positive:** Performance regression or latency spike; Capacity planning or throughput tuning; Evidence-based performance review
- **Negative:** Need profiling session only (route to when-profiling-performance-use-performance-profiler); Infra build or rollout (route to infrastructure/cloud-platforms); Pure observability setup (route to opentelemetry-observability)

### Guardrails
- Structure-first: keep SKILL.md aligned with examples/, tests/, and any resources/references so downstream agents always have scaffolding.
- Adversarial validation is mandatory: cover boundary cases, failure paths, and rollback drills before declaring the SOP complete.
- Prompt hygiene: separate hard vs. soft vs. inferred constraints and confirm inferred constraints before acting.
- Explicit confidence ceilings: format as 'Confidence: X.XX (ceiling: TYPE Y.YY)' and never exceed the ceiling for the claim type.
- MCP traceability: tag sessions WHO=operations-{name}-{session_id}, WHY=skill-execution, and capture evidence links in outputs.
- Avoid anti-patterns: undocumented changes, missing rollback paths, skipped tests, or unbounded automation without approvals.

### Required Artifacts
- SKILL.md (this SOP)
- examples/ for analysis patterns
- tests/ or scripts in _shared/ for validation
- resources/ for dashboards

### Execution Phases
1. **Frame the hypothesis**
   - Capture symptoms, SLO/SLA impact, and success criteria
   - List signals to collect and separate hard/soft constraints
   - Establish baseline and target thresholds

2. **Collect evidence**
   - Gather traces/profiles/metrics and reproduction steps
   - Correlate load, errors, and resource usage
   - Identify hotspots and suspect components

3. **Analyze and propose fixes**
   - Validate findings across layers (app, DB, network)
   - Draft options with impact, risk, and effort
   - Plan experiments or benchmarks to confirm

4. **Validate improvements**
   - Run experiments and compare to baseline
   - Update dashboards/alerts to lock in gains
   - Document recommendations and next steps

### Output Format
- Performance findings summary with quantified impact
- Hotspot list with evidence links
- Remediation options with impact/risk/effort trade-offs
- Experiment or benchmark plan and results
- Recommendations with owners and timeline

### Validation Checklist
- Baseline and target metrics defined and measured
- Reproduction steps or datasets captured
- Experiments show measurable deltas with evidence
- Risks and rollbacks identified for proposed changes
- Confidence ceiling stated for conclusions

Confidence: 0.70 (ceiling: inference 0.70) - Performance analysis SOP centers evidence and explicit ceilings
