# Performance Profiling Routing Process

Purpose: ensure profiling-focused requests are handled by the performance-profiler skill with clear constraints, safe execution, and explicit confidence ceilings.

## Fast Path Checklist
1. **Qualify the ask**: confirm goal is profiling/tracing (CPU/heap/flame/trace). If broader diagnosis is needed, route to performance-analysis.
2. **Scope and safety**: record environments, load levels, data sensitivity, and approvals; ensure profiling will not violate SLAs.
3. **Plan the session**: choose tools, sampling vs. instrumentation, and time windows; define storage locations for artifacts.
4. **Run with guardrails**: stage in lower environments when possible, add observability, and announce start/stop to stakeholders.
5. **Handoff**: summarize artifacts, initial observations, and next-step recommendations (often feeding back into performance-analysis).

## Evidence Packet Template
- Target services/endpoints and suspected hotspots
- Workload generator or reproduction steps
- Tooling selection (e.g., eBPF, flame graphs, heap/CPU profilers)
- Data handling notes (PII, retention) and approvals
- Expected outputs (profiles, traces, metrics) and storage paths

## Validation Gates
- Routing confirmed to performance-profiler; non-profiling asks rerouted appropriately.
- Safety checks completed (load impact, permissions, data handling).
- Artifact locations and owners documented.
- Confidence ceiling stated alongside observations and recommendations.

Confidence: 0.70 (ceiling: inference 0.70) - profiling routing follows skill-forge guardrails and prompt-architect clarity.
