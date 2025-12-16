---
<!-- META-LOOP v2.1 INTEGRATION -->## Phase 0: Expertise Loadingexpertise_check:  domain: platforms  file: .claude/expertise/platforms.yaml  fallback: discovery_mode## Recursive Improvement Integration (v2.1)benchmark: gemini-search-benchmark-v1  tests:    - command_execution_success    - domain_validation  success_threshold: 0.9namespace: "commands/platforms/multi-model-commands/gemini-search/{project}/{timestamp}"uncertainty_threshold: 0.85coordination:  related_skills: [flow-nexus-platform]  related_agents: [multi-model-orchestrator]## COMMAND COMPLETION VERIFICATIONsuccess_metrics:  execution_success: ">95%"<!-- END META-LOOP -->
name: gemini-search
binding: multi-model:gemini-search
category: multi-model
version: 1.0.0
---

# /gemini-search

Get real-time web information via Google Search grounding (bypasses Claude Code knowledge cutoff).

## Usage
```bash
/gemini-search "<query>" [options]
```

## Parameters
- `query` - Search query (required)
- `--output` - Output file for results (default: stdout)
- `--format` - Output format: markdown|json|text (default: markdown)

## Examples
```bash
# Latest framework info
/gemini-search "What are breaking changes in React 19?"

# Current best practices
/gemini-search "Best practices for Next.js 15 app router 2025"

# Library compatibility
/gemini-search "Is Tailwind v4 compatible with React 19?"

# Generate report
/gemini-search "Latest security vulnerabilities in npm packages" --output security-news.md
```

## When to Use
- ✅ Need current information (post-Claude's cutoff)
- ✅ Latest framework updates
- ✅ Current best practices
- ✅ Recent CVEs or security news
- ✅ Library compatibility checks

## Capabilities
- **Grounding**: Google Search with real-time results
- **Model**: Gemini 2.0 Flash
- **Free tier**: 60 requests/min

## Implementation
```bash
# Executed via Gemini CLI with Google Search grounding
gemini "<query>" --grounding google-search
```

## Chains with
```bash
# Research → prototype with latest info
/gemini-search "Latest React 19 best practices" | \
/codex-auto "Implement using these best practices"

# Security check → audit
/gemini-search "Known vulnerabilities in dependencies" | \
/security-scan src/ --known-cves
```

## See also
- `/gemini-megacontext` - Large context analysis
- `/codex-auto` - Rapid prototyping
- `/agent-rca` - Root cause analysis
