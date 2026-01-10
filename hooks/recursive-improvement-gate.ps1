# recursive-improvement-gate.ps1
# PURPOSE: Gate all self-improvement changes through eval harness
# HOOK TYPE: PreToolUse (runs before Write/Edit on improvement targets)

$ErrorActionPreference = "SilentlyContinue"

# Read tool input from stdin
$inputJson = ""
try {
    $inputJson = [Console]::In.ReadToEnd()
} catch {
    $inputJson = "{}"
}

if (-not $inputJson) { $inputJson = "{}" }

# Extract file path
$filePath = ""
try {
    $inputData = $inputJson | ConvertFrom-Json
    if ($inputData.tool_input.file_path) {
        $filePath = $inputData.tool_input.file_path
    } elseif ($inputData.tool_input.path) {
        $filePath = $inputData.tool_input.path
    }
} catch {}

# Check if this is a recursive improvement target
$improvementTargets = @(
    "prompt-forge",
    "skill-forge",
    "agent-creator",
    "eval-harness",
    "bootstrap-loop",
    "improvement-pipeline",
    "prompt-auditor",
    "skill-auditor",
    "expertise-auditor",
    "output-auditor"
)

$isImprovementTarget = $false

foreach ($target in $improvementTargets) {
    if ($filePath -match $target) {
        $isImprovementTarget = $true
        break
    }
}

# If modifying an improvement target, warn about eval gate
if ($isImprovementTarget) {
    Write-Host @"

================================================================
!! RECURSIVE IMPROVEMENT GATE !!
================================================================

You are modifying a META-SKILL that powers the recursive improvement system.

TARGET DETECTED: This file is part of the self-improvement loop.

MANDATORY REQUIREMENTS:

1. EVAL HARNESS GATE
   - ALL changes to meta-skills MUST pass eval-harness
   - Run: Skill("eval-harness") after changes
   - Benchmarks + Regressions must pass

2. ARCHIVE BEFORE MODIFY
   - Current version MUST be archived first
   - Path: .archive/SKILL-v{current}.md
   - Enables rollback if regression detected

3. FORBIDDEN CHANGES
   - NEVER remove safeguards
   - NEVER bypass eval harness
   - NEVER modify frozen benchmarks
   - NEVER weaken contract requirements

4. SPECIAL RULES FOR EVAL-HARNESS
   - eval-harness does NOT self-improve
   - Changes to eval-harness require MANUAL human approval
   - Only expansion allowed (never reduction)

5. SELF-REBUILD SAFETY
   - skill-forge rebuilding itself uses PREVIOUS version
   - Never use current version to rebuild current version

PROCEED ONLY IF:
  [ ] Change improves the system (not just different)
  [ ] Eval harness will be run after
  [ ] Archive exists for rollback
  [ ] No forbidden changes included

================================================================

"@
}

exit 0
