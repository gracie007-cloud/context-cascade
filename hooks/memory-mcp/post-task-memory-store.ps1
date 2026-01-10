# Post-Task Hook: Memory MCP Triple-Tier Store Reminder
# Fires after Task() to remind agents to store results
# Updated: 2026-01-09 for triple-tier with WHO/WHEN/PROJECT/WHY + confidence

$ErrorActionPreference = "SilentlyContinue"

Write-Host @"
!! MEMORY-MCP: POST-TASK STORE !!

AFTER completing task, STORE with WHO/WHEN/PROJECT/WHY + confidence:

REQUIRED METADATA:
  WHO: "{agent-type}:{session-id}"
  WHEN: "ISO8601 timestamp"
  PROJECT: "{project-name}"
  WHY: "implementation|bugfix|refactor|testing|documentation|planning|research"
  confidence: 0.5-0.95

IF task found issues (confidence: 0.8):
  Store finding with severity, affected files, reproduction steps

IF task applied fixes (confidence: 0.85):
  Store fix with pattern used, files changed, verification status
  HippoRAG will auto-extract entities for graph

IF task made decisions (confidence: 0.9):
  Store decision rationale, alternatives rejected, implications

IF task learned pattern (confidence: 0.9, retention: long):
  Store pattern with context, implementation guidance, examples

CONFIDENCE GUIDELINES:
  0.5-0.6: Uncertain, needs verification
  0.7-0.8: Reasonable confidence, tested locally
  0.85-0.95: High confidence, verified in production

TRIPLE-TIER OPTIMIZATION:
  - Include related concepts for HippoRAG entity extraction
  - Set confidence for Bayesian tier ranking
  - Use descriptive text for Vector RAG embedding

ALWAYS: Tag with WHO/WHEN/PROJECT/WHY!

"@

exit 0
