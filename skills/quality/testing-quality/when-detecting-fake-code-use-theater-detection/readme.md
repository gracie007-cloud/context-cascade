---
name: when-detecting-fake-code-readme
description: Quick reference for routing fake-code investigations to Theater Detection Audit.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality/routing
x-vcl-compliance: v3.1.1
---

## Overview
Use this router when the task is to uncover placeholders, stubs, or mock implementations. It hands off to `theater-detection-audit` and enforces evidence/confidence expectations.

## Steps
1. Confirm the goal is theater detection; reroute if not.
2. Check `theater-detection-audit` artifacts (examples/tests) for patterns and phrasing.
3. Provide scope, risky areas, and exclusions to the downstream skill.
4. Close with `Confidence: X.XX (ceiling: TYPE Y.YY)`.

## Validation Checklist
- [ ] Task qualified as theater detection.
- [ ] Evidence expectations restated (file:line + snippet + classification).
- [ ] Downstream artifacts located.
- [ ] Confidence ceiling provided.

Confidence: 0.70 (ceiling: inference 0.70) – README rewritten with Prompt Architect confidence discipline and Skill Forge structure-first routing.
