# pre-coding-library-check.ps1
# Hook: PreToolUse on Task/Skill for coding-related operations
# Purpose: Display library check advisory before coding tasks
#
# CRITICAL: This hook is ADVISORY ONLY - never blocks execution
# Following safe-task-spawn guard pattern
# Always exits 0 regardless of findings

$ErrorActionPreference = "SilentlyContinue"

Write-Host @"

============================================================
!! LIBRARY CHECK: PRE-CODING ADVISORY !!
============================================================

Before implementing, CHECK for existing solutions:

TIER 1: LIBRARY CATALOG
  Location: .claude/library/catalog.json
  Components: 17+ indexed (auth, database, UI, testing)

  Quick Search:
    Select-String -Path ".claude\library\catalog.json" -Pattern "{keyword}"

  Categories: utilities, api, authentication, database, ui,
              integrations, testing

TIER 2: PATTERNS DOCUMENTATION
  Location: .claude/docs/inventories/LIBRARY-PATTERNS-GUIDE.md
  Patterns: 20+ documented (JWT, CRUD, middleware, testing)

  Quick Search:
    Select-String -Path ".claude\docs\inventories\LIBRARY-PATTERNS-GUIDE.md" -Pattern "{keyword}"

  Categories: authentication, api-design, database,
              quality-gates, resilience, content-pipeline, testing

TIER 3: PROJECT SCANNER
  Location: D:\Projects\*
  Projects: 10+ with reusable code

  Quick Search:
    Get-ChildItem -Path "D:\Projects" -Recurse -Include "*.ts","*.py" | Select-String "{keyword}"

------------------------------------------------------------
DECISION MATRIX
------------------------------------------------------------
| Match Quality    | Action       | Time Saved  |
|------------------|--------------|-------------|
| Library >90%     | REUSE        | 8+ hours    |
| Library 70-90%   | ADAPT        | 4-6 hours   |
| Pattern match    | FOLLOW       | 2-4 hours   |
| Project match    | EXTRACT      | 1-2 hours   |
| No matches       | BUILD NEW    | Proceed     |
------------------------------------------------------------

AFTER IMPLEMENTATION:
  If you built something new and valuable:
  1. Add to .claude/library/catalog.json
  2. Update .claude/docs/inventories/LIBRARY-CATALOG.md
  3. Log to Memory MCP: guards/library-check/{project}

============================================================
PROCEEDING: This check is advisory only
============================================================

"@

exit 0
