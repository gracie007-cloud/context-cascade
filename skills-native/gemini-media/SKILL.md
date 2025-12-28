---
name: gemini-media
description: Image generation using modular provider system - local SDXL Lightning or cloud APIs
allowed-tools: Read, Write, Edit, Bash, Task, TodoWrite, Glob, Grep
---

# Image Generation Skill (Modular)

> **DEPRECATED**: This skill now redirects to the modular `image-gen` skill.
> Use `image-gen` directly for better provider flexibility.

## Purpose

Generate images using the best available provider. This skill wraps the modular image generation system that supports:

- **Local SDXL Lightning** - Free, private, ~7GB disk, 8GB VRAM
- **OpenAI DALL-E 3** - Paid API, highest quality
- **Replicate** - Paid API, fast and cheap
- **Custom providers** - Plug in your own

## Quick Start

```bash
# Check available providers
python scripts/multi-model/image-gen/cli.py --list

# Setup local SDXL Lightning (recommended)
python scripts/multi-model/image-gen/cli.py --setup local

# Generate image
python scripts/multi-model/image-gen/cli.py "A sunset" output.png
```

## When to Use

### Perfect For:
- Blog banners and social media images
- Documentation diagrams
- UI mockups and wireframes
- Concept visualization
- Any image generation need

### Provider Selection:
- **Privacy required?** -> Local SDXL
- **No GPU?** -> OpenAI or Replicate API
- **Batch generation?** -> Local (no API costs)
- **Highest quality?** -> DALL-E 3 or SDXL Lightning

## Usage

### Basic Image Generation
```bash
# Auto-selects best provider
python scripts/multi-model/image-gen/cli.py "Create a flowchart" output.png

# LinkedIn banner (1200x630)
python scripts/multi-model/image-gen/cli.py "Tech dashboard" banner.png --width 1200 --height 630

# Force specific provider
python scripts/multi-model/image-gen/cli.py "A cat" cat.png --provider openai
```

### With Visual Art Composition

For professional-quality images, use with `visual-art-composition`:

```bash
# 1. Get structured prompt
/visual-art-composition "tech dashboard for productivity app"

# 2. Generate with structured prompt
python scripts/multi-model/image-gen/cli.py \
  "Dashboard with linear_perspective depth, composed blues and golds,
   focal_hierarchy, notan two-value contrast. Modern aesthetic." \
  dashboard.png --width 1200 --height 630
```

## Provider Setup

### Local SDXL Lightning (Free, Recommended)
```bash
python scripts/multi-model/image-gen/cli.py --setup local
# Downloads ~7GB to D:/AI-Models/sdxl-lightning
```

### OpenAI DALL-E 3 (~$0.04/image)
```bash
export OPENAI_API_KEY="sk-..."
```

### Replicate (~$0.01/image)
```bash
export REPLICATE_API_TOKEN="r8_..."
```

## Related Skills

- **`image-gen`**: The modular system this skill wraps (use directly)
- **`visual-art-composition`**: 13-dimension aesthetic framework for structured prompts
- **`pptx-generation`**: Uses generated images in presentations

## Video Generation

> **REMOVED**: Video generation via Veo has been removed from this skill.
> Veo requires specific API access not available in standard Gemini CLI.
> For video needs, consider:
> - Runway ML API
> - Pika Labs
> - Manual generation via Google AI Studio

## Files

- Main skill: `skills-native/image-gen/SKILL.md`
- CLI: `scripts/multi-model/image-gen/cli.py`
- Providers: `scripts/multi-model/image-gen/`
