---
name: when-profiling-performance-use-performance-profiler
description: Route performance profiling requests to the performance-profiler skill
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Direct profiling-heavy requests to the performance-profiler SOP to ensure structured data collection and analysis.

### Trigger Conditions
- **Positive:** Need CPU/heap/flame profiling; Request for profiling scripts or sessions; Desire to capture traces for hotspots
- **Negative:** Broader performance analysis (route to when-analyzing-performance-use-performance-analysis); Infrastructure build (route to infrastructure); Observability setup (route to opentelemetry-observability)

### Guardrails
- Structure-first: keep SKILL.md aligned with examples/, tests/, and any resources/references so downstream agents always have scaffolding.
- Adversarial validation is mandatory: cover boundary cases, failure paths, and rollback drills before declaring the SOP complete.
- Prompt hygiene: separate hard vs. soft vs. inferred constraints and confirm inferred constraints before acting.
- Explicit confidence ceilings: format as 'Confidence: X.XX (ceiling: TYPE Y.YY)' and never exceed the ceiling for the claim type.
- MCP traceability: tag sessions WHO=operations-{name}-{session_id}, WHY=skill-execution, and capture evidence links in outputs.
- Avoid anti-patterns: undocumented changes, missing rollback paths, skipped tests, or unbounded automation without approvals.

### Required Artifacts
- SKILL.md (routing SOP)
- PROCESS.md and README.md
- metadata.json
- supporting profiler configs

### Execution Phases
1. **Verify profiling need**
   - Confirm ask is profiling-focused
   - Redirect broader analysis to performance-analysis
   - List constraints (env, load, safety)

2. **Prepare profiling plan**
   - Select tools and sampling strategy
   - Gather reproduction steps and data sensitivity notes
   - Schedule runs with approvals and safety checks

3. **Coordinate execution**
   - Share profiling SOP, scripts, and expectations
   - Ensure observability and storage for traces
   - Align on confidence ceilings for findings

4. **Document results**
   - Capture collected artifacts and locations
   - Summarize preliminary observations
   - Record next actions or handoff back to performance-analysis

### Output Format
- Routing confirmation to performance-profiler
- Profiling plan with tools, scope, and approvals
- Artifact locations for traces/profiles
- Summary of observations and next steps

### Validation Checklist
- Request matches profiling scope
- Safety/approvals for profiling captured
- Artifacts stored with traceability
- Confidence ceiling communicated for observations
- MCP tags recorded

Confidence: 0.70 (ceiling: inference 0.70) - Routing SOP keeps profiling asks aligned to dedicated skill
