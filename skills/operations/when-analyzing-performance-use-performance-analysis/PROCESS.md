# Performance Analysis Routing Process

Purpose: route performance analysis requests into the performance-analysis skill with the same structure-first, adversarial validation, and confidence-ceiling guardrails used by skill-forge and prompt-architect.

## Fast Path Checklist
1. **Qualify the request**: confirm it is analysis/diagnosis (not profiling-only, infra build, or observability setup).
2. **Select the right skill**: point to `skills/operations/performance-analysis` and confirm the requestor accepts its SOP.
3. **Surface constraints**: capture hard/soft/inferred requirements (SLOs, deadlines, risk tolerance) and restate them for confirmation.
4. **Assemble evidence**: baseline metrics, traces/logs, repro steps, environment details, and recent changes.
5. **Set cadence**: agree on checkpoints, owners, and expected outputs (findings, options, experiments, recommendations).

## Evidence Packet Template
- **Context**: service/endpoint, environments, recent deploys, suspected areas.
- **Signals**: metrics (latency/throughput/errors), traces/profiles if available, logs for the affected window.
- **Reproduction**: steps, datasets/fixtures, load patterns.
- **Constraints**: success criteria, deadlines, budget for experiments, change windows.
- **Risks**: customer impact, compliance considerations, data sensitivity.

## Validation Gates
- Routing confirmed to performance-analysis; mismatches rerouted (profiling-only → performance-profiler; observability setup → opentelemetry-observability).
- Evidence packet attached or explicit gap noted with owner to fill it.
- Checkpoints defined with owners and communication channels.
- Confidence ceiling agreed and restated in all summaries.

Confidence: 0.70 (ceiling: inference 0.70) - routing process mirrors performance-analysis SOP with prompt-architect clarity.
