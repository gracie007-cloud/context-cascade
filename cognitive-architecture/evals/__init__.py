"""
VVV Recursive Improvement Evaluation Framework

This package provides evaluation infrastructure for the three foundry skills:
- prompt-architect (PA-001 to PA-050)
- agent-creator (AC-001 to AC-050)
- skill-forge (SF-001 to SF-050)

Total: 150 evaluation tasks

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
- Dogfooding capability

Usage:
    pytest evals/ -v  # Run all corpus validation tests
    pytest evals/test_prompt_architect.py -v  # Test PA corpus only
"""

__version__ = "1.0.0"
