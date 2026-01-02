---
name: when-verifying-quality-readme
description: Quick reference for routing verification tasks to Verification Quality.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality/routing
x-vcl-compliance: v3.1.1
---

## Overview
Use this router when the job is to verify outputs or claims. It hands the task to `verification-quality` and ensures constraints, evidence, and confidence ceilings are respected.

## Steps
1. Confirm the task is verification/grounding; otherwise choose another skill.
2. Check `verification-quality` artifacts (examples/tests) for expected reporting formats.
3. Supply scope, sources, and policy constraints to the downstream skill.
4. Close with `Confidence: X.XX (ceiling: TYPE Y.YY)`.

## Validation Checklist
- [ ] Verification scope confirmed.
- [ ] Evidence and constraint expectations restated.
- [ ] Downstream artifacts located.
- [ ] Confidence ceiling provided.

Confidence: 0.70 (ceiling: inference 0.70) – README rewritten with Prompt Architect confidence discipline and Skill Forge structure-first routing.
