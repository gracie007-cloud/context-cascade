---
name: when-testing-code-readme
description: Quick start for using the testing framework routing skill.
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite]
model: sonnet
x-version: 3.2.0
x-category: quality/testing
x-vcl-compliance: v3.1.1
---

## Overview
This README guides you through running the testing framework when validating code changes. It pairs with `process.md`, helper scripts, and subagent guidance.

## Artifacts
- `SKILL.md` – SOP with guardrails, phases, and confidence rules.
- `process.md` – step-by-step command flow.
- `slash-command-test-run.sh` / `slash-command-test-generate.sh` – helper scripts.
- `subagent-testing-framework.md` – notes for subagents invoking the framework.
- `mcp-testing-framework.json` – MCP integration details.

## Quick Start
1. Review `SKILL.md` for triggers and guardrails.
2. Follow `process.md` to prepare the environment and run suites.
3. Use helper scripts to generate or execute tests; capture logs.
4. Report results with `Confidence: X.XX (ceiling: TYPE Y.YY)` and link evidence.

## Validation Checklist
- [ ] Environment prepared per subagent notes.
- [ ] Appropriate suites selected/generated.
- [ ] Evidence captured (commands, logs, failing cases).
- [ ] Confidence ceiling stated in English-only output.

Confidence: 0.70 (ceiling: inference 0.70) – README rewritten with Prompt Architect confidence discipline and Skill Forge structure-first testing guidance.
