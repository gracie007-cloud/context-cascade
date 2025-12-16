---

<!-- META-LOOP v2.1 INTEGRATION -->
## Phase 0: Expertise Loading
expertise_check:
  domain: deployment
  file: .claude/expertise/deployment.yaml
  fallback: discovery_mode

## Recursive Improvement Integration (v2.1)
benchmark: profiler-start-benchmark-v1
  tests:
    - memory_operations_success
    - monitoring_validation
  success_threshold: 0.9
namespace: "commands/operations/optimization/profiler-start/{project}/{timestamp}"
uncertainty_threshold: 0.85
coordination:
  related_skills: [agentdb-memory-patterns, performance-analysis]
  related_agents: [prometheus-monitoring-specialist, grafana-visualization-agent]

## COMMAND COMPLETION VERIFICATION
success_metrics:
  execution_success: ">95%"
<!-- END META-LOOP -->

