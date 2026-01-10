# five-phase-enforcer.ps1
# PURPOSE: Enforce 5-phase workflow on every non-trivial request
# HOOK TYPE: UserPromptSubmit (runs before Claude processes user message)

$ErrorActionPreference = "SilentlyContinue"

# Read the user's message from stdin
$inputJson = ""
try {
    $inputJson = [Console]::In.ReadToEnd()
} catch {
    $inputJson = "{}"
}

if (-not $inputJson) { $inputJson = "{}" }

# Extract the actual message text
$messageText = ""
try {
    $inputData = $inputJson | ConvertFrom-Json
    if ($inputData.message) {
        $messageText = $inputData.message
    }
} catch {
    $messageText = $inputJson
}

# Classification: Is this trivial or non-trivial?
$isTrivial = $false

# Trivial patterns (skip 5-phase)
$trivialPatterns = @(
    "^(hi|hello|hey|thanks|thank you|ok|okay|yes|no|bye)$",
    "^what (is|are|does|do) ",
    "^(can you|could you) explain",
    "^(help|/help|/clear|/status)",
    "^show me",
    "^list ",
    "^read ",
    "^(git status|git log|ls|pwd)"
)

foreach ($pattern in $trivialPatterns) {
    if ($messageText -match $pattern) {
        $isTrivial = $true
        break
    }
}

# Non-trivial patterns (REQUIRE 5-phase)
$nonTrivialPatterns = @(
    "(build|create|implement|develop|add|make)",
    "(fix|debug|repair|resolve|solve)",
    "(refactor|optimize|improve|enhance)",
    "(analyze|audit|review|check|validate)",
    "(deploy|release|ship|publish)",
    "(test|spec|coverage)",
    "(design|architect|plan|strategy)"
)

foreach ($pattern in $nonTrivialPatterns) {
    if ($messageText -match $pattern) {
        $isTrivial = $false
        break
    }
}

# Inject 5-phase requirement for non-trivial requests
if (-not $isTrivial) {
    Write-Host @"

!! 5-PHASE WORKFLOW ENFORCEMENT !!

This appears to be a NON-TRIVIAL request. You MUST execute the 5-phase workflow:

PHASE 1: INTENT ANALYSIS (MANDATORY)
  - Invoke: Skill("intent-analyzer")
  - Output: Understood intent + confidence score
  - If confidence < 80%: Ask clarifying questions FIRST

PHASE 2: PROMPT OPTIMIZATION (MANDATORY)
  - Invoke: Skill("prompt-architect")
  - Output: Optimized request + success criteria

PHASE 3: STRATEGIC PLANNING (MANDATORY)
  - Invoke: Skill("research-driven-planning") OR Skill("planner")
  - Output: Task breakdown + dependencies + parallelization strategy

PHASE 4: PLAYBOOK/SKILL ROUTING (MANDATORY)
  - Match tasks to playbooks from catalog
  - Output: Routing decisions for each task

PHASE 5: EXECUTION (MANDATORY)
  - Execute using routed playbooks/skills
  - Spawn agents via Task() - AGENTS FROM REGISTRY ONLY
  - Track progress via TodoWrite()
  - Golden Rule: 1 MESSAGE = ALL PARALLEL OPERATIONS

DOMAIN EXPERTISE (NEW - CHECK FIRST):
  - Does domain have expertise file? Check: .claude/expertise/{domain}.yaml
  - If YES: Load and validate before Phase 3
  - If NO: Generate expertise as side effect

DO NOT skip phases. DO NOT skip skill evaluation. DO NOT use generic agents.

"@
}

exit 0
