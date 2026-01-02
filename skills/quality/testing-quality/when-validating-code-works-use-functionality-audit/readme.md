---
name: when-validating-code-works-readme
description: Quick reference for routing correctness checks to Functionality Audit.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality/routing
x-vcl-compliance: v3.1.1
---

## Overview
Use this router when the task is to confirm that code works. It forwards context to `functionality-audit` and enforces reproducibility and confidence rules.

## Steps
1. Verify the request is functionality validation; otherwise choose a different skill.
2. Pull `functionality-audit` artifacts (examples/tests) for expected output structure.
3. Provide reproduction steps, environments, and known issues to the downstream skill.
4. Close with `Confidence: X.XX (ceiling: TYPE Y.YY)`.

## Validation Checklist
- [ ] Functionality validation confirmed.
- [ ] Evidence expectations restated (commands, inputs/outputs, file:line).
- [ ] Downstream artifacts located.
- [ ] Confidence ceiling provided.

Confidence: 0.70 (ceiling: inference 0.70) – README rewritten using Prompt Architect confidence discipline and Skill Forge structure-first routing.
