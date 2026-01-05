"""
Update registry.json with all 203+ agents from the agents directory

Scans all category folders and builds a complete registry.
Run: python update_registry.py
"""

import json
import re
from pathlib import Path
from datetime import datetime

AGENTS_DIR = Path(__file__).parent.parent.parent
REGISTRY_PATH = Path(__file__).parent / "registry.json"

AGENT_CATEGORIES = [
    "delivery", "foundry", "operations", "orchestration",
    "platforms", "quality", "research", "security",
    "specialists", "tooling"
]

# Skip these files (not agents)
SKIP_PATTERNS = ["README", "INDEX", "SUMMARY", "MIGRATION", "BATCH", "INFRASTRUCTURE"]

# Category to type mapping
CATEGORY_TO_TYPE = {
    "delivery": "delivery",
    "foundry": "core-development",
    "operations": "operations",
    "orchestration": "orchestration",
    "platforms": "platforms",
    "quality": "quality",
    "research": "research",
    "security": "security",
    "specialists": "specialists",
    "tooling": "tooling",
}


def parse_yaml_frontmatter(content: str) -> dict:
    """Parse YAML frontmatter from markdown file."""
    if not content.startswith("---"):
        return {}

    parts = content.split("---", 2)
    if len(parts) < 3:
        return {}

    frontmatter = parts[1].strip()
    result = {}
    current_key = None
    current_list = None

    for line in frontmatter.split("\n"):
        if not line.strip():
            continue

        if line.strip().startswith("- "):
            if current_list is not None:
                item = line.strip()[2:].strip().strip('"\'')
                current_list.append(item)
            continue

        if ":" in line and not line.startswith(" ") and not line.startswith("\t"):
            if current_key and current_list is not None:
                result[current_key] = current_list
                current_list = None

            key, value = line.split(":", 1)
            key = key.strip()
            value = value.strip()

            if value == "" or value == "[]":
                current_key = key
                current_list = []
            elif value.startswith("[") and value.endswith("]"):
                items = value[1:-1].split(",")
                result[key] = [i.strip().strip('"\'') for i in items if i.strip()]
                current_key = None
            elif value.lower() in ["true", "false"]:
                result[key] = value.lower() == "true"
                current_key = None
            else:
                result[key] = value.strip('"\'')
                current_key = None

    if current_key and current_list is not None:
        result[current_key] = current_list

    return result


def extract_description(content: str, frontmatter: dict) -> str:
    """Extract agent description from frontmatter or content."""
    if frontmatter.get("description"):
        return frontmatter["description"]

    # Try to find description in markdown content
    lines = content.split("\n")
    for i, line in enumerate(lines):
        if line.startswith("# "):
            # Get first paragraph after title
            for j in range(i + 1, min(i + 10, len(lines))):
                if lines[j].strip() and not lines[j].startswith("#"):
                    return lines[j].strip()[:300]

    return ""


def extract_tools(content: str, frontmatter: dict) -> str:
    """Extract tools list from frontmatter."""
    tools = frontmatter.get("tools") or frontmatter.get("allowed-tools") or []

    if isinstance(tools, list):
        return ", ".join(tools)
    if isinstance(tools, str):
        return tools

    # Search in content
    match = re.search(r"tools:\s*\[([^\]]+)\]", content)
    if match:
        return match.group(1)

    return "Read, Write, Edit, Bash, Glob, Grep"


def extract_capabilities(content: str, frontmatter: dict) -> list:
    """Extract capabilities from frontmatter or content."""
    caps = frontmatter.get("capabilities") or frontmatter.get("x-capabilities") or []

    if caps:
        return caps[:10]

    # Search in content
    match = re.search(r"capabilities:\s*\n((?:\s*-\s*[^\n]+\n?)+)", content)
    if match:
        lines = match.group(1)
        caps = []
        for line in lines.split("\n"):
            if line.strip().startswith("-"):
                cap = line.strip()[1:].strip().strip('"\'')
                if cap:
                    caps.append(cap)
        return caps[:10]

    return []


def extract_skills(content: str, frontmatter: dict) -> list:
    """Extract related skills."""
    skills = frontmatter.get("skills") or frontmatter.get("x-skills") or []
    if skills:
        return skills[:5]
    return []


def determine_model(frontmatter: dict) -> str:
    """Determine the model for the agent."""
    model = frontmatter.get("model", "sonnet")
    if model in ["sonnet", "opus", "haiku", "auto"]:
        return model
    return "sonnet"


def get_subpath(file_path: Path, category: str) -> str:
    """Get the subpath after the category folder."""
    parts = file_path.parts
    try:
        idx = parts.index(category)
        return "/".join(parts[idx + 1:])
    except ValueError:
        return file_path.name


def process_agent_file(file_path: Path, category: str) -> tuple:
    """Process a single agent .md file and return (name, agent_data)."""
    try:
        content = file_path.read_text(encoding="utf-8")
    except Exception as e:
        print(f"  Error reading {file_path}: {e}")
        return None, None

    frontmatter = parse_yaml_frontmatter(content)

    # Get agent name
    name = frontmatter.get("name", file_path.stem)

    # Skip non-agent files
    if any(pat in name.upper() for pat in SKIP_PATTERNS):
        return None, None

    # Build agent data in Anthropic-compliant format
    agent_data = {
        "name": name,
        "description": extract_description(content, frontmatter),
        "tools": extract_tools(content, frontmatter),
        "model": determine_model(frontmatter),
        "x-type": CATEGORY_TO_TYPE.get(category, category),
        "x-path": get_subpath(file_path, category),
        "x-capabilities": extract_capabilities(content, frontmatter),
        "x-skills": extract_skills(content, frontmatter),
    }

    # Add prompting techniques if present
    techniques = frontmatter.get("prompting_techniques") or frontmatter.get("x-prompting_techniques")
    if techniques:
        agent_data["x-prompting_techniques"] = techniques

    return name, agent_data


def scan_all_agents() -> dict:
    """Scan all agent directories and build registry."""
    agents = {}

    for category in AGENT_CATEGORIES:
        category_path = AGENTS_DIR / category
        if not category_path.exists():
            print(f"Category not found: {category}")
            continue

        print(f"\nScanning {category}...")
        category_count = 0

        for md_file in category_path.rglob("*.md"):
            name, agent_data = process_agent_file(md_file, category)
            if name and agent_data:
                agents[name] = agent_data
                category_count += 1

        print(f"  Found {category_count} agents in {category}")

    return agents


def main():
    print("=" * 60)
    print("CONTEXT CASCADE REGISTRY UPDATER")
    print("=" * 60)
    print(f"Agents directory: {AGENTS_DIR}")
    print(f"Output: {REGISTRY_PATH}")

    # Scan all agents
    agents = scan_all_agents()

    print(f"\n{'='*60}")
    print(f"Total agents found: {len(agents)}")

    # Build registry
    registry = {
        "version": "3.1.0",
        "description": f"Complete {len(agents)}+ AI agent registry for Context Cascade - auto-generated",
        "format": "anthropic-compliant",
        "generated_at": datetime.now().isoformat(),
        "anthropic_field_mappings": {
            "description": "This registry uses Anthropic official fields with x- prefixed custom extensions",
            "official_fields": ["name", "description", "tools", "model"],
            "custom_extensions": {
                "type": "x-type (agent category type)",
                "path": "x-path (file path relative to category)",
                "capabilities": "x-capabilities",
                "skills": "x-skills",
                "prompting_techniques": "x-prompting_techniques"
            }
        },
        "agents": agents
    }

    # Backup existing registry
    if REGISTRY_PATH.exists():
        backup_path = REGISTRY_PATH.with_suffix(".json.bak")
        REGISTRY_PATH.rename(backup_path)
        print(f"Backed up existing registry to: {backup_path}")

    # Write new registry
    with open(REGISTRY_PATH, "w", encoding="utf-8") as f:
        json.dump(registry, f, indent=2, ensure_ascii=False)

    print(f"Written new registry with {len(agents)} agents")

    # Print category breakdown
    print("\nCategory breakdown:")
    categories = {}
    for name, data in agents.items():
        cat = data.get("x-type", "unknown")
        categories[cat] = categories.get(cat, 0) + 1

    for cat, count in sorted(categories.items()):
        print(f"  {cat}: {count}")


if __name__ == "__main__":
    main()
