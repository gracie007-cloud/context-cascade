---
name: when-analyzing-performance-use-performance-analysis
description: Route performance analysis requests to the dedicated performance-analysis skill
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Ensure performance analysis work follows the performance-analysis SOP with evidence-driven investigation and validation.

### Trigger Conditions
- **Positive:** Any request to analyze or debug performance; Need recommendations for latency/throughput; Desire for performance experiments or benchmarks
- **Negative:** Profiling-only sessions (route to when-profiling-performance-use-performance-profiler); Pure observability setup (route to opentelemetry-observability); Incident recovery (route to cicd-intelligent-recovery)

### Guardrails
- Structure-first: keep SKILL.md aligned with examples/, tests/, and any resources/references so downstream agents always have scaffolding.
- Adversarial validation is mandatory: cover boundary cases, failure paths, and rollback drills before declaring the SOP complete.
- Prompt hygiene: separate hard vs. soft vs. inferred constraints and confirm inferred constraints before acting.
- Explicit confidence ceilings: format as 'Confidence: X.XX (ceiling: TYPE Y.YY)' and never exceed the ceiling for the claim type.
- MCP traceability: tag sessions WHO=operations-{name}-{session_id}, WHY=skill-execution, and capture evidence links in outputs.
- Avoid anti-patterns: undocumented changes, missing rollback paths, skipped tests, or unbounded automation without approvals.

### Required Artifacts
- SKILL.md (routing SOP)
- PROCESS.md and README.md for quick alignment
- metadata.json

### Execution Phases
1. **Confirm routing**
   - Verify the ask is performance analysis, not deployment or infra
   - Point to performance-analysis SKILL and artifacts
   - Record constraints and success criteria

2. **Prepare handoff**
   - Assemble baseline metrics/logs/traces
   - Capture reproduction steps and environment
   - Highlight risks or deadlines

3. **Align execution**
   - Ensure performance-analysis guardrails are acknowledged
   - Clarify confidence ceiling expectations
   - Schedule checkpoints and outputs

4. **Track and validate**
   - Monitor progress and evidence collection
   - Route findings back to requesters
   - Document completion and remaining risks

### Output Format
- Routing note confirming performance-analysis ownership
- Context packet with metrics, traces, and reproduction steps
- Checkpoint plan with decision owners
- Completion summary with confidence ceiling

### Validation Checklist
- Routing confirmed not better served elsewhere
- Baseline evidence attached for analysis
- Checkpoints and owners defined
- Confidence ceiling restated for conclusions
- MCP tags applied for traceability

Confidence: 0.70 (ceiling: inference 0.70) - Routing SOP aligns to prompt-architect clarity and skill-forge guardrails
