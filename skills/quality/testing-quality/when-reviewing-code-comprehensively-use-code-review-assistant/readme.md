---
name: when-reviewing-code-comprehensively-readme
description: Quick reference for routing comprehensive reviews to Code Review Assistant.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality/routing
x-vcl-compliance: v3.1.1
---

## Overview
Use this router when a full-spectrum code review is requested. It forwards the task to `code-review-assistant` and reinforces evidence and confidence rules.

## Steps
1. Confirm the request is comprehensive; otherwise select the correct skill.
2. Locate `code-review-assistant` artifacts (examples/tests) to align on format.
3. Pass PR details, priorities, and exclusions downstream.
4. Close with `Confidence: X.XX (ceiling: TYPE Y.YY)`.

## Validation Checklist
- [ ] Comprehensive review confirmed.
- [ ] Evidence expectations restated (file:line, severity, reference).
- [ ] Downstream artifacts located.
- [ ] Confidence ceiling provided.

Confidence: 0.70 (ceiling: inference 0.70) – README rewritten using Prompt Architect confidence discipline and Skill Forge structure-first routing.
