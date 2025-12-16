---
<!-- META-LOOP v2.1 INTEGRATION -->## Phase 0: Expertise Loadingexpertise_check:  domain: platforms  file: .claude/expertise/platforms.yaml  fallback: discovery_mode## Recursive Improvement Integration (v2.1)benchmark: gemini-media-benchmark-v1  tests:    - command_execution_success    - domain_validation  success_threshold: 0.9namespace: "commands/platforms/multi-model-commands/gemini-media/{project}/{timestamp}"uncertainty_threshold: 0.85coordination:  related_skills: [flow-nexus-platform]  related_agents: [multi-model-orchestrator]## COMMAND COMPLETION VERIFICATIONsuccess_metrics:  execution_success: ">95%"<!-- END META-LOOP -->
name: gemini-media
binding: multi-model:gemini-media
category: multi-model
version: 1.0.0
---

# /gemini-media

Generate images (Imagen 3/4) and videos (Veo 2/3.1) for visualizations.

## Usage
```bash
/gemini-media "<description>" [options]
```

## Parameters
- `description` - Detailed description of image/video to generate (required)
- `--type` - Media type: image|video (default: image)
- `--output` - Output file path (required)
- `--style` - Style: realistic|artistic|diagram|technical (default: realistic)

## Examples
```bash
# Generate architecture diagram
/gemini-media "System architecture diagram showing microservices with API gateway" \
  --type image --output docs/architecture.png --style diagram

# Create UI mockup
/gemini-media "Modern dashboard UI with dark mode and analytics charts" \
  --output mockups/dashboard.png

# Generate demo video
/gemini-media "Demo video showing user signup flow" \
  --type video --output demos/signup-flow.mp4
```

## When to Use
- ✅ Architecture diagrams
- ✅ UI mockups and wireframes
- ✅ Documentation visuals
- ✅ Demo videos
- ✅ Marketing materials

## Capabilities
- **Images**: Imagen 3/4 (high quality)
- **Videos**: Veo 2/3.1 (up to 60 seconds)
- **Model**: Gemini 2.0 Flash

## Implementation
```bash
# Executed via Gemini CLI with media generation
gemini "Generate: <description>" --output <file>
```

## Chains with
```bash
# Design → generate → document
/agent-architect "Design authentication system" | \
/gemini-media "Architecture diagram for designed system" --output docs/auth-arch.png | \
/generate-docs docs/architecture.md
```

## See also
- `/gemini-extensions` - Figma integration for design
- `/agent-architect` - System architecture design
- `/generate-docs` - Documentation generation
