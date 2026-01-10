# model-router-pretool.ps1 - Automatic model routing based on task characteristics
# Integrates: Gemini (megacontext, search, media, extensions) + Codex (yolo, sandbox, audit)
# Part of Context Cascade Multi-Model Integration

param(
    [string]$ToolName = "",
    [string]$ToolInput = ""
)

$ErrorActionPreference = "SilentlyContinue"

$STATE_FILE = "$env:USERPROFILE\.claude\runtime\model-routing-state.json"
$stateDir = Split-Path $STATE_FILE -Parent
if (-not (Test-Path $stateDir)) {
    New-Item -ItemType Directory -Path $stateDir -Force | Out-Null
}

function Detect-TaskType {
    param([string]$Input)

    $inputLower = $Input.ToLower()

    # GEMINI MEGACONTEXT triggers (1M token analysis)
    if ($inputLower -match "entire codebase|full project|all files|architecture overview|whole system|30k|large codebase|complete analysis") {
        return "gemini-megacontext"
    }

    # GEMINI SEARCH triggers (real-time web info)
    if ($inputLower -match "latest|current|2025|search|find online|real-time|breaking changes|cve|vulnerability|documentation|best practices") {
        return "gemini-search"
    }

    # GEMINI MEDIA triggers (image/video generation)
    if ($inputLower -match "generate image|create diagram|flowchart|mockup|wireframe|architecture diagram|video|visualization|imagen|veo") {
        return "gemini-media"
    }

    # GEMINI EXTENSIONS triggers (third-party integrations)
    if ($inputLower -match "figma|stripe|postman|shopify|dynatrace|elastic|snyk|harness|extension") {
        return "gemini-extensions"
    }

    # CODEX YOLO/FULL-AUTO triggers (autonomous execution)
    if ($inputLower -match "autonomous|overnight|unattended|full auto|yolo|fire and forget|weekend|batch") {
        return "codex-yolo"
    }

    # CODEX SANDBOX triggers (isolated execution)
    if ($inputLower -match "sandbox|isolated|safe|experimental|risky|untrusted|prototype quickly") {
        return "codex-sandbox"
    }

    # CODEX AUDIT triggers (test-fix loops)
    if ($inputLower -match "fix all tests|debug|audit|test failures|auto-fix|iterate until") {
        return "codex-audit"
    }

    # CODEX REASONING triggers (second opinion)
    if ($inputLower -match "alternative approach|second opinion|different perspective|gpt-5|codex reasoning") {
        return "codex-reasoning"
    }

    # LLM COUNCIL triggers (consensus needed)
    if ($inputLower -match "consensus|critical decision|high stakes|multiple perspectives|council|vote") {
        return "llm-council"
    }

    # Default: Claude
    return "claude"
}

function Get-RoutingCommand {
    param(
        [string]$TaskType,
        [string]$Query
    )

    switch ($TaskType) {
        "gemini-megacontext" { return "gemini --all-files `"$Query`"" }
        "gemini-search" { return "gemini `"@search $Query`"" }
        "gemini-media" { return "gemini `"Generate: $Query`"" }
        "gemini-extensions" { return "gemini -e auto `"$Query`"" }
        "codex-yolo" { return "codex --yolo `"$Query`"" }
        "codex-sandbox" { return "codex --full-auto --sandbox true `"$Query`"" }
        "codex-audit" { return "codex --full-auto --max-iterations 10 `"$Query`"" }
        "codex-reasoning" { return "codex `"$Query`"" }
        "llm-council" { return "bash scripts/multi-model/llm-council.sh `"$Query`"" }
        default { return "claude" }
    }
}

# Only process Task tool calls
if ($ToolName -ne "Task") {
    exit 0
}

# Extract task description from input
$taskDesc = ""
try {
    $inputData = $ToolInput | ConvertFrom-Json
    if ($inputData.prompt) {
        $taskDesc = $inputData.prompt
    } elseif ($inputData.description) {
        $taskDesc = $inputData.description
    }
} catch {}

if (-not $taskDesc) {
    exit 0
}

# Detect optimal model
$taskType = Detect-TaskType $taskDesc

# If not Claude, suggest routing
if ($taskType -ne "claude") {
    $routingCmd = Get-RoutingCommand $taskType $taskDesc

    # Log routing decision
    $logEntry = @{
        timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ss")
        task_type = $taskType
        routing_command = $routingCmd
        original_task = $taskDesc
    }
    $logEntry | ConvertTo-Json | Add-Content -Path $STATE_FILE

    # Output suggestion
    Write-Host ""
    Write-Host "================================================================================"
    Write-Host "!! MULTI-MODEL ROUTING SUGGESTION !!"
    Write-Host "================================================================================"
    Write-Host ""
    Write-Host "Detected task type: $taskType"
    Write-Host ""
    Write-Host "This task may benefit from external model routing:"
    Write-Host ""
    Write-Host "  $routingCmd"
    Write-Host ""
    Write-Host "Rationale:"

    switch ($taskType) {
        "gemini-megacontext" { Write-Host "  - Task requires analyzing large codebase (Gemini has 1M token context)" }
        "gemini-search" { Write-Host "  - Task needs real-time web information (Gemini has Google Search grounding)" }
        "gemini-media" { Write-Host "  - Task requires image/video generation (Gemini has Imagen/Veo)" }
        "gemini-extensions" { Write-Host "  - Task involves third-party integration (Gemini has 70+ extensions)" }
        "codex-yolo" { Write-Host "  - Task can run autonomously overnight (Codex --yolo mode)" }
        "codex-sandbox" { Write-Host "  - Task needs isolated execution (Codex sandbox with network disabled)" }
        "codex-audit" { Write-Host "  - Task involves test-fix-retest loops (Codex auto-iteration)" }
        "codex-reasoning" { Write-Host "  - Task benefits from alternative perspective (GPT-5-Codex reasoning)" }
        "llm-council" { Write-Host "  - Critical decision benefits from multi-model consensus" }
    }

    Write-Host ""
    Write-Host "================================================================================"
    Write-Host "Proceeding with Claude agent (override with suggested command if preferred)"
    Write-Host "================================================================================"
    Write-Host ""
}

exit 0
