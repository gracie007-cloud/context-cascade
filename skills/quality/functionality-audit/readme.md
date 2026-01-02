---
name: functionality-audit-readme
description: Quick start and artifact map for the Functionality Audit skill.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality/functionality-audit
x-vcl-compliance: v3.1.1
---

## Overview
Functionality Audit proves that code behaves as intended by executing targeted tests, capturing traces, and recommending fixes. Use this README to navigate the artifacts and launch an audit quickly.

## Artifact Map
- `SKILL.md` – SOP with triggers, phases, guardrails, and confidence ceiling rules.
- `examples/` – sample execution plans and result summaries.
- `tests/` – prompts or harnesses to rehearse the audit flow.
- `references/` – debugging heuristics, command snippets, and repro templates.
- `resources/` – helper scripts, fixtures, or environment notes.
- `graphviz/` – process diagrams for the audit loop.

## Quick Start
1. Read `SKILL.md` to align on scope, evidence, and confidence ceilings.
2. Select an `examples/` scenario similar to your target component.
3. Prepare the environment using `resources/` instructions; run `tests/` as a smoke check.
4. Execute the audit, logging commands and outputs; store artifacts under the project namespace.
5. Close with a confidence statement and links to evidence.

## Validation Checklist
- [ ] Required artifacts present; missing items queued.
- [ ] Execution evidence captured (commands, inputs, outputs).
- [ ] Negative/boundary cases exercised.
- [ ] Confidence ceiling stated in English-only output.

Confidence: 0.70 (ceiling: inference 0.70) – README updated with Skill Forge structure-first cues and Prompt Architect confidence discipline.
