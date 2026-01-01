"""
DeepEval Configuration for VVV Recursive Improvement Loop

This module sets up the evaluation framework for the three foundry skills:
- prompt-architect (PA-001 to PA-050)
- agent-creator (AC-001 to AC-050)
- skill-forge (SF-001 to SF-050)

Evaluation Dimensions:
- Intent extraction accuracy
- Constraint identification
- Optimization quality
- VERIX grounding ratio
- L2 output purity
- Registry compliance
- VCL 7-slot coverage
- Adversarial resistance
- COV validation pass
"""

import json
import os
from pathlib import Path
from typing import Any

import pytest

# Corpus directory
CORPUS_DIR = Path(__file__).parent / "corpus"


def load_corpus(skill_name: str) -> dict[str, Any]:
    """Load task corpus for a specific skill."""
    corpus_file = CORPUS_DIR / f"{skill_name}-corpus.json"
    if not corpus_file.exists():
        raise FileNotFoundError(f"Corpus not found: {corpus_file}")
    with open(corpus_file, "r", encoding="utf-8") as f:
        return json.load(f)


@pytest.fixture
def prompt_architect_corpus():
    """Load prompt-architect evaluation corpus."""
    return load_corpus("prompt-architect")


@pytest.fixture
def agent_creator_corpus():
    """Load agent-creator evaluation corpus."""
    return load_corpus("agent-creator")


@pytest.fixture
def skill_forge_corpus():
    """Load skill-forge evaluation corpus."""
    return load_corpus("skill-forge")


@pytest.fixture
def all_corpora():
    """Load all three corpora."""
    return {
        "prompt-architect": load_corpus("prompt-architect"),
        "agent-creator": load_corpus("agent-creator"),
        "skill-forge": load_corpus("skill-forge"),
    }


# DeepEval metric configurations
EVAL_METRICS = {
    "intent_extraction": {
        "threshold": 0.85,
        "weight": 0.2,
    },
    "constraint_identification": {
        "threshold": 0.80,
        "weight": 0.15,
    },
    "verix_grounding": {
        "threshold": 0.95,
        "weight": 0.25,
    },
    "l2_output_purity": {
        "threshold": 0.99,
        "weight": 0.15,
    },
    "vcl_7slot_coverage": {
        "threshold": 1.0,
        "weight": 0.15,
    },
    "adversarial_resistance": {
        "threshold": 0.90,
        "weight": 0.10,
    },
}


# Confidence ceilings by evidence type (from VCL v3.1.1)
CONFIDENCE_CEILINGS = {
    "definition": 0.95,
    "policy": 0.90,
    "observation": 0.95,
    "research": 0.85,
    "report": 0.70,
    "inference": 0.70,
}


def check_confidence_ceiling(claim_type: str, claimed_confidence: float) -> bool:
    """Verify confidence doesn't exceed evidence ceiling."""
    ceiling = CONFIDENCE_CEILINGS.get(claim_type, 0.70)
    return claimed_confidence <= ceiling


def check_verix_format(statement: str) -> bool:
    """Check if statement follows VERIX notation format."""
    # [illocution|affect] content [ground:source] [conf:X.XX] [state:status]
    required_markers = ["[ground:", "[conf:", "[state:"]
    return all(marker in statement for marker in required_markers)


def check_l2_purity(output: str) -> bool:
    """Check if output contains no VCL markers (L2 compliance)."""
    vcl_markers = [
        "[ground:",
        "[conf:",
        "[state:",
        "[assert|",
        "[define|",
        "[direct|",
        "[[HON:",
        "[[MOR:",
        "[[COM:",
        "[[CLS:",
        "[[EVD:",
        "[[ASP:",
        "[[SPC:",
    ]
    return not any(marker in output for marker in vcl_markers)
