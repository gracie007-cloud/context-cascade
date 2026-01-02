---
name: when-auditing-code-style-readme
description: Quick reference for routing style audits to the Style Audit SOP.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality/routing
x-vcl-compliance: v3.1.1
---

## Overview
Use this router when the task is primarily about style, readability, naming, or documentation. It hands off to `style-audit` and reminds reviewers of evidence and confidence expectations.

## Steps
1. Confirm the request is style-focused; if not, reroute to the appropriate skill.
2. Reference `style-audit` artifacts (examples/tests) for phrasing and evidence formats.
3. Forward scope, priorities, and exclusions to `style-audit`.
4. Close with `Confidence: X.XX (ceiling: TYPE Y.YY)`.

## Validation Checklist
- [ ] Task confirmed as style review.
- [ ] Evidence expectations restated (file:line, rule, fix).
- [ ] Downstream artifacts located.
- [ ] Confidence ceiling provided.

Confidence: 0.70 (ceiling: inference 0.70) – README rewritten to match Prompt Architect confidence and Skill Forge structure-first routing.
