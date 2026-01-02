---
name: docker-containerization
description: Package applications into secure, portable Docker images with validated pipelines
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: operations
x-vcl-compliance: v3.1.1
x-cognitive-frames: [HON, MOR, COM, CLS, EVD, ASP, SPC]
---

## STANDARD OPERATING PROCEDURE

### Purpose
Define and deliver containerization patterns, pipelines, and runtime guidance with security and performance guardrails.

### Trigger Conditions
- **Positive:** Containerize an application; Harden Docker images and pipelines; Establish container runtime standards
- **Negative:** Cluster orchestration (route to kubernetes-specialist); General infra build (route to infrastructure); Performance debugging (route to performance-analysis)

### Guardrails
- Structure-first: keep SKILL.md aligned with examples/, tests/, and any resources/references so downstream agents always have scaffolding.
- Adversarial validation is mandatory: cover boundary cases, failure paths, and rollback drills before declaring the SOP complete.
- Prompt hygiene: separate hard vs. soft vs. inferred constraints and confirm inferred constraints before acting.
- Explicit confidence ceilings: format as 'Confidence: X.XX (ceiling: TYPE Y.YY)' and never exceed the ceiling for the claim type.
- MCP traceability: tag sessions WHO=operations-{name}-{session_id}, WHY=skill-execution, and capture evidence links in outputs.
- Avoid anti-patterns: undocumented changes, missing rollback paths, skipped tests, or unbounded automation without approvals.

### Required Artifacts
- SKILL.md (this SOP)
- metadata.json
- examples/ for Dockerfiles and pipelines

### Execution Phases
1. **Assess application requirements**
   - Capture language/runtime needs and system dependencies
   - Identify security constraints and data paths
   - Clarify performance and footprint expectations

2. **Design containerization approach**
   - Select base images and layering strategy
   - Plan build/publish pipelines with caching and SBOM/scanning
   - Define runtime configs (env vars, secrets, resource limits)

3. **Build and test**
   - Author Dockerfile with reproducible builds
   - Run unit/integration and image security scans
   - Validate runtime behavior locally and in staging

4. **Ship and document**
   - Publish images to registries with provenance
   - Document run/rollback steps and operational limits
   - Record resource profiles and monitoring hooks

### Output Format
- Containerization plan and Dockerfile references
- Build/test matrix with security scan results
- Registry publishing steps with provenance/attestations
- Runtime checklist (limits, health checks, configs)
- Runbook updates for operations and rollback

### Validation Checklist
- Images scanned and pinned with SBOMs where possible
- Resource usage profiled with limits/requests documented
- Builds reproducible across environments
- Runtime configs validated and secrets not baked in
- Confidence ceiling stated for promoting images

Confidence: 0.70 (ceiling: inference 0.70) - Container SOP aligns to security and validation guardrails
