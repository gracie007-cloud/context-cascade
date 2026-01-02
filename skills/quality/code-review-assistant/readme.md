---
name: code-review-assistant-readme
description: Quick start and structure notes for the Code Review Assistant quality skill.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality
x-vcl-compliance: v3.1.1
---

## Overview
Code Review Assistant delivers evidence-rich PR reviews by coordinating multiple lenses (security, performance, correctness, style, docs, and tests). This README provides a fast orientation to the artifacts and how to use them.

## Directory Structure (Skill Forge pattern)
- `SKILL.md` – primary SOP with triggers, phases, guardrails, and confidence rules.
- `examples/` – sample review outputs; add one example per major lens.
- `tests/` – validation prompts or harnesses to exercise the review checklist.
- `references/` – style guides, security/performance budgets, and checklists.
- `resources/` – diagrams, templates, or helper scripts for running the review.
- `graphviz/` – process diagrams if needed.

## Quick Start
1. Read `SKILL.md` for the SOP and evidence requirements.
2. Review `examples/` to mirror severity language and confidence ceilings.
3. Use `tests/` to dry-run the workflow against sample diffs.
4. Capture findings with file:line references and cite the matching `references/` entry.
5. Close with `Confidence: X.XX (ceiling: TYPE Y.YY)` per Prompt Architect.

## Validation Checklist
- [ ] Required artifacts present (SKILL, examples, tests); missing pieces logged for follow-up.
- [ ] Output kept in English; no VCL markers in user-facing content.
- [ ] Evidence includes file:line, evidence type, and supporting reference.
- [ ] Confidence ceiling explicitly stated.

Confidence: 0.70 (ceiling: inference 0.70) – README rewritten to align with Skill Forge structure-first guidance and Prompt Architect confidence discipline.
