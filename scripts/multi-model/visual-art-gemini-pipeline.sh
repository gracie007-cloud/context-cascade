#!/bin/bash
# Visual Art Composition -> Gemini Media Pipeline
# Generates structured aesthetic prompts and creates images via Imagen/Veo

set -e

# ============================================================================
# CONFIGURATION
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MEMORY_DIR="${HOME}/.claude/memory-mcp-data"
STATE_DIR="${HOME}/.claude/visual-art-pipeline"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Defaults
SUBJECT=""
EMOTIONAL_CORE="composed"
TRADITIONS=""
DIMENSIONS=""
OUTPUT_PATH=""
IMAGE_TYPE="image"
RESOLUTION="1024x1024"
SAVE_PROMPT="true"

# ============================================================================
# DIMENSIONAL TAXONOMY (13 Dimensions)
# ============================================================================

# Pre-defined emotional presets
declare -A EMOTION_PRESETS
EMOTION_PRESETS["calm"]="ma_emptiness,deliberate_incomplete,wabi_melancholy,notan_two_value"
EMOTION_PRESETS["tense"]="horror_vacui,emotional_distortion,tenebrism_extreme,dynamic_diagonals"
EMOTION_PRESETS["energetic"]="motion_fragmented,dynamic_sequence,high_key_luminous,emotional_expressive"
EMOTION_PRESETS["awe"]="linear_perspective,sublime_awe,hierarchical_importance,polished_complete"
EMOTION_PRESETS["composed"]="itutu_cool,polished_complete,serene_detachment,focal_hierarchy"

# Tradition-to-dimension mappings
declare -A TRADITION_DIMENSIONS
TRADITION_DIMENSIONS["Japanese"]="ma_emptiness,notan_two_value,deliberate_incomplete,wabi_melancholy"
TRADITION_DIMENSIONS["Byzantine"]="reverse_perspective,hieratic_stylization,flat_unmodeled,symbolic_encoded"
TRADITION_DIMENSIONS["Yoruba"]="itutu_cool,polished_complete,generative_unfinished,form_has_agency"
TRADITION_DIMENSIONS["Futurism"]="motion_fragmented,dynamic_sequence,enveloping_immersion,dynamic_diagonals"
TRADITION_DIMENSIONS["Renaissance"]="linear_perspective,chiaroscuro_gradated,perfect_ideal,golden_proportion"
TRADITION_DIMENSIONS["Chinese"]="atmospheric_dissolve,qi_yun_resonance,calligraphic_gesture,deliberate_incomplete"
TRADITION_DIMENSIONS["Expressionism"]="emotional_distortion,passionate_expression,process_visible,emotional_expressive"
TRADITION_DIMENSIONS["Islamic"]="infinite_extension,horror_vacui,radial_mandala,symbolic_coded"

# ============================================================================
# USAGE
# ============================================================================

usage() {
    cat << EOF
Visual Art Composition -> Gemini Media Pipeline

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --subject <text>         Subject to depict (required)
    --emotional-core <type>  Emotional preset: calm, tense, energetic, awe, composed
    --traditions <list>      Comma-separated traditions: Japanese,Byzantine,Yoruba,...
    --dimensions <list>      Override dimensions: ma_emptiness,itutu_cool,...
    --output <path>          Output file path (default: auto-generated)
    --type <type>            Output type: image, video (default: image)
    --resolution <res>       Resolution: 1024x1024, 1920x1080 (default: 1024x1024)
    --no-save-prompt         Don't save prompt to Memory-MCP
    --help                   Show this help

EXAMPLES:
    # Simple usage with emotional preset
    $0 --subject "programmer at desk" --emotional-core composed

    # Cross-cultural synthesis
    $0 --subject "tech dashboard" --traditions "Japanese,Byzantine" --output docs/dashboard.png

    # Full control
    $0 --subject "portrait" \\
       --dimensions "ma_emptiness,itutu_cool,notan_two_value,reverse_perspective" \\
       --output docs/images/portrait.png

EMOTIONAL PRESETS:
    calm       : ma_emptiness, deliberate_incomplete, wabi_melancholy
    tense      : horror_vacui, emotional_distortion, tenebrism_extreme
    energetic  : motion_fragmented, dynamic_sequence, high_key_luminous
    awe        : linear_perspective, sublime_awe, hierarchical_importance
    composed   : itutu_cool, polished_complete, serene_detachment

TRADITIONS:
    Japanese, Byzantine, Yoruba, Futurism, Renaissance, Chinese, Expressionism, Islamic

EOF
    exit 0
}

# ============================================================================
# ARGUMENT PARSING
# ============================================================================

while [[ $# -gt 0 ]]; do
    case $1 in
        --subject)
            SUBJECT="$2"
            shift 2
            ;;
        --emotional-core)
            EMOTIONAL_CORE="$2"
            shift 2
            ;;
        --traditions)
            TRADITIONS="$2"
            shift 2
            ;;
        --dimensions)
            DIMENSIONS="$2"
            shift 2
            ;;
        --output)
            OUTPUT_PATH="$2"
            shift 2
            ;;
        --type)
            IMAGE_TYPE="$2"
            shift 2
            ;;
        --resolution)
            RESOLUTION="$2"
            shift 2
            ;;
        --no-save-prompt)
            SAVE_PROMPT="false"
            shift
            ;;
        --help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate required arguments
if [[ -z "$SUBJECT" ]]; then
    echo "ERROR: --subject is required"
    usage
fi

# ============================================================================
# PHASE 1: BUILD DIMENSION SET
# ============================================================================

echo "=============================================="
echo "VISUAL ART COMPOSITION -> GEMINI MEDIA PIPELINE"
echo "=============================================="
echo ""
echo "PHASE 1: Building Dimension Set"
echo "----------------------------------------------"

FINAL_DIMENSIONS=""

# Start with emotional preset
if [[ -n "${EMOTION_PRESETS[$EMOTIONAL_CORE]}" ]]; then
    FINAL_DIMENSIONS="${EMOTION_PRESETS[$EMOTIONAL_CORE]}"
    echo "  Emotional core: $EMOTIONAL_CORE"
    echo "  -> Dimensions: $FINAL_DIMENSIONS"
fi

# Add tradition-based dimensions
if [[ -n "$TRADITIONS" ]]; then
    IFS=',' read -ra TRADITION_ARRAY <<< "$TRADITIONS"
    for tradition in "${TRADITION_ARRAY[@]}"; do
        tradition=$(echo "$tradition" | xargs)  # trim whitespace
        if [[ -n "${TRADITION_DIMENSIONS[$tradition]}" ]]; then
            FINAL_DIMENSIONS="${FINAL_DIMENSIONS},${TRADITION_DIMENSIONS[$tradition]}"
            echo "  Tradition: $tradition"
            echo "  -> Added: ${TRADITION_DIMENSIONS[$tradition]}"
        fi
    done
fi

# Override with explicit dimensions if provided
if [[ -n "$DIMENSIONS" ]]; then
    FINAL_DIMENSIONS="$DIMENSIONS"
    echo "  Explicit dimensions override: $DIMENSIONS"
fi

# Remove duplicates
FINAL_DIMENSIONS=$(echo "$FINAL_DIMENSIONS" | tr ',' '\n' | sort -u | tr '\n' ',' | sed 's/,$//')
echo ""
echo "  Final dimensions: $FINAL_DIMENSIONS"

# ============================================================================
# PHASE 2: VALIDATE COMBINATIONS
# ============================================================================

echo ""
echo "PHASE 2: Validating Combinations"
echo "----------------------------------------------"

# Check for mutually exclusive pairs
VALIDATION_PASSED=true
TENSIONS=""

# linear_perspective vs reverse_perspective
if echo "$FINAL_DIMENSIONS" | grep -q "linear_perspective" && echo "$FINAL_DIMENSIONS" | grep -q "reverse_perspective"; then
    echo "  WARNING: linear_perspective + reverse_perspective are mutually exclusive"
    echo "  -> Keeping reverse_perspective (more novel)"
    FINAL_DIMENSIONS=$(echo "$FINAL_DIMENSIONS" | sed 's/linear_perspective,//g' | sed 's/,linear_perspective//g')
fi

# horror_vacui vs ma_emptiness (productive tension)
if echo "$FINAL_DIMENSIONS" | grep -q "horror_vacui" && echo "$FINAL_DIMENSIONS" | grep -q "ma_emptiness"; then
    echo "  TENSION: horror_vacui + ma_emptiness"
    echo "  -> Resolution: zone segregation (dense center, breathing edges)"
    TENSIONS="horror_vacui vs ma_emptiness resolved through zone segregation"
fi

# perfect_ideal vs noble_imperfection (productive tension)
if echo "$FINAL_DIMENSIONS" | grep -q "perfect_ideal" && echo "$FINAL_DIMENSIONS" | grep -q "noble_imperfection"; then
    echo "  TENSION: perfect_ideal + noble_imperfection"
    echo "  -> Resolution: kintsugi principle (ideal form with visible repair)"
    TENSIONS="${TENSIONS}; perfect_ideal vs noble_imperfection resolved through kintsugi"
fi

echo "  Validation: PASSED"
echo "  Tensions: ${TENSIONS:-none}"

# ============================================================================
# PHASE 3: GENERATE STRUCTURED PROMPT
# ============================================================================

echo ""
echo "PHASE 3: Generating Structured Prompt"
echo "----------------------------------------------"

# Build the structured prompt
STRUCTURED_PROMPT="[SUBJECT] $SUBJECT

"

# Add dimensional specifications
IFS=',' read -ra DIM_ARRAY <<< "$FINAL_DIMENSIONS"
for dim in "${DIM_ARRAY[@]}"; do
    dim=$(echo "$dim" | xargs)
    case $dim in
        ma_emptiness)
            STRUCTURED_PROMPT+="SPACE: ma_emptiness - 40-70% negative space as presence, breathing room around subject
"
            ;;
        itutu_cool)
            STRUCTURED_PROMPT+="EMOTION: itutu_cool (Yoruba) - composed, serene face, power contained within cool exterior
"
            ;;
        notan_two_value)
            STRUCTURED_PROMPT+="VALUE: notan - strong two-value structure, balance of dark and light shapes
"
            ;;
        reverse_perspective)
            STRUCTURED_PROMPT+="SPATIAL: reverse_perspective (Byzantine) - space opens toward viewer, forms widen as they approach
"
            ;;
        linear_perspective)
            STRUCTURED_PROMPT+="SPATIAL: linear_perspective - vanishing point, mathematically correct depth
"
            ;;
        motion_fragmented)
            STRUCTURED_PROMPT+="SPATIAL: motion_fragmented (Futurism) - chronophotographic effect, multiple exposure, lines of force
"
            ;;
        horror_vacui)
            STRUCTURED_PROMPT+="SPACE: horror_vacui - no empty space, ornament fills all surfaces
"
            ;;
        deliberate_incomplete)
            STRUCTURED_PROMPT+="COMPLETION: deliberate_incomplete - edges fade, suggestions not statements
"
            ;;
        polished_complete)
            STRUCTURED_PROMPT+="COMPLETION: polished_complete - every inch resolved to highest craft
"
            ;;
        qi_yun_resonance)
            STRUCTURED_PROMPT+="EMOTION: qi_yun_resonance (Chinese) - spirit resonance, forms breathe, energy moves through composition
"
            ;;
        sublime_awe)
            STRUCTURED_PROMPT+="EMOTION: sublime_awe (Romantic) - vast scale dwarfing subject, dramatic natural forces
"
            ;;
        wabi_melancholy)
            STRUCTURED_PROMPT+="EMOTION: wabi_melancholy - quiet contemplation, gentle sadness, beauty in transience
"
            ;;
        hieratic_stylization)
            STRUCTURED_PROMPT+="IDEALIZATION: hieratic_stylization (Byzantine) - elongated proportions, frontal presentation
"
            ;;
        emotional_distortion)
            STRUCTURED_PROMPT+="IDEALIZATION: emotional_distortion (Expressionism) - warped proportions to match feeling
"
            ;;
        flat_unmodeled)
            STRUCTURED_PROMPT+="VALUE: flat_unmodeled - no light source, even illumination, pure color areas
"
            ;;
        tenebrism_extreme)
            STRUCTURED_PROMPT+="VALUE: tenebrism_extreme (Caravaggio) - most of canvas near-black, spotlight effect
"
            ;;
        high_key_luminous)
            STRUCTURED_PROMPT+="VALUE: high_key_luminous - minimal darks, radiant brightness throughout
"
            ;;
        calligraphic_gesture)
            STRUCTURED_PROMPT+="SURFACE: calligraphic_gesture - visible energetic marks, speed and pressure visible
"
            ;;
        symbolic_coded)
            STRUCTURED_PROMPT+="MEANING: symbolic_coded - colors and objects encode specific meanings
"
            ;;
        *)
            STRUCTURED_PROMPT+="DIMENSION: $dim
"
            ;;
    esac
done

# Add tensions if any
if [[ -n "$TENSIONS" ]]; then
    STRUCTURED_PROMPT+="
Productive tensions: $TENSIONS
"
fi

# Add technical specs
STRUCTURED_PROMPT+="
Technical: $RESOLUTION resolution, high quality rendering"

echo "$STRUCTURED_PROMPT"

# ============================================================================
# PHASE 4: INVOKE GEMINI MEDIA
# ============================================================================

echo ""
echo "PHASE 4: Invoking Gemini Media (Imagen)"
echo "----------------------------------------------"

# Generate output path if not specified
if [[ -z "$OUTPUT_PATH" ]]; then
    mkdir -p "${HOME}/generated-images"
    OUTPUT_PATH="${HOME}/generated-images/visual-art-${TIMESTAMP}.png"
fi

# Ensure output directory exists
OUTPUT_DIR=$(dirname "$OUTPUT_PATH")
mkdir -p "$OUTPUT_DIR"

echo "  Output path: $OUTPUT_PATH"
echo "  Type: $IMAGE_TYPE"
echo "  Resolution: $RESOLUTION"

# Check if gemini CLI is available
if ! command -v gemini &> /dev/null; then
    echo ""
    echo "  WARNING: gemini CLI not found"
    echo "  To install: npm install -g @anthropic/claude-code-gemini"
    echo ""
    echo "  PROMPT GENERATED (save for manual use):"
    echo "  ----------------------------------------"
    echo "$STRUCTURED_PROMPT"

    # Save prompt to file
    PROMPT_FILE="${STATE_DIR}/prompts/${TIMESTAMP}-prompt.txt"
    mkdir -p "$(dirname "$PROMPT_FILE")"
    echo "$STRUCTURED_PROMPT" > "$PROMPT_FILE"
    echo ""
    echo "  Prompt saved to: $PROMPT_FILE"
else
    # Invoke Gemini CLI
    echo "  Invoking Gemini CLI..."

    if [[ "$IMAGE_TYPE" == "video" ]]; then
        gemini "Generate a video: $STRUCTURED_PROMPT. Duration: 10 seconds. Save to $OUTPUT_PATH" 2>&1
    else
        gemini "Generate an image: $STRUCTURED_PROMPT. Save to $OUTPUT_PATH" 2>&1
    fi

    if [[ -f "$OUTPUT_PATH" ]]; then
        echo "  SUCCESS: Image generated at $OUTPUT_PATH"
    else
        echo "  Image generation requested. Check Gemini output."
    fi
fi

# ============================================================================
# PHASE 5: STORE TO MEMORY-MCP
# ============================================================================

if [[ "$SAVE_PROMPT" == "true" ]]; then
    echo ""
    echo "PHASE 5: Storing to Memory-MCP"
    echo "----------------------------------------------"

    # Create memory entry
    MEMORY_KEY="visual-art-composition/${TIMESTAMP}"
    MEMORY_DATA=$(cat << EOF
{
  "key": "$MEMORY_KEY",
  "subject": "$SUBJECT",
  "emotional_core": "$EMOTIONAL_CORE",
  "traditions": "$TRADITIONS",
  "dimensions": "$FINAL_DIMENSIONS",
  "tensions": "$TENSIONS",
  "output_path": "$OUTPUT_PATH",
  "structured_prompt": $(echo "$STRUCTURED_PROMPT" | jq -Rs .),
  "timestamp": "$TIMESTAMP",
  "WHO": "visual-art-gemini-pipeline",
  "WHEN": "$(date -Iseconds)",
  "PROJECT": "multi-model",
  "WHY": "image-generation"
}
EOF
)

    # Save to state directory for retrieval
    mkdir -p "${STATE_DIR}/memory"
    echo "$MEMORY_DATA" > "${STATE_DIR}/memory/${TIMESTAMP}.json"
    echo "  Saved to: ${STATE_DIR}/memory/${TIMESTAMP}.json"
fi

# ============================================================================
# SUMMARY
# ============================================================================

echo ""
echo "=============================================="
echo "PIPELINE COMPLETE"
echo "=============================================="
echo "  Subject: $SUBJECT"
echo "  Dimensions: $FINAL_DIMENSIONS"
echo "  Tensions: ${TENSIONS:-none}"
echo "  Output: $OUTPUT_PATH"
echo ""
echo "To regenerate with variations:"
echo "  $0 --subject \"$SUBJECT\" --emotional-core <different-emotion>"
echo ""
