"""
Image Auditor - Automated quality validation for generated images.
Uses vision model to evaluate against a rubric based on visual-art-composition framework.

Integrates with Ralph Loop for iterative refinement until quality threshold met.

PRODUCTION STANDARD: 95% threshold required for all images.
Claude Code inspects images directly using Read tool and follows this rubric.
"""

import os
import base64
import json
from pathlib import Path
from typing import Optional, Dict, List, Tuple
from dataclasses import dataclass, field
from enum import Enum

# Try to import anthropic for Claude vision

# ============================================================
# LIBRARY-FIRST PROTOCOL
# ============================================================
# Before generating code, check:
#   1. .claude/library/catalog.json
#   2. .claude/docs/inventories/LIBRARY-PATTERNS-GUIDE.md
#   3. D:\Projects\* for existing implementations
#
# Decision: REUSE (>90%) | ADAPT (70-90%) | FOLLOW pattern | BUILD new
# ============================================================

try:
    import anthropic
    CLAUDE_AVAILABLE = True
except ImportError:
    CLAUDE_AVAILABLE = False


class AuditSeverity(Enum):
    """Severity levels for audit findings."""
    PASS = "pass"
    WARNING = "warning"
    FAIL = "fail"
    CRITICAL = "critical"


@dataclass
class AuditFinding:
    """Single audit finding."""
    category: str
    severity: AuditSeverity
    message: str
    suggestion: Optional[str] = None


@dataclass
class AuditResult:
    """Complete audit result for an image."""
    passed: bool
    score: float
    findings: List[AuditFinding] = field(default_factory=list)
    prompt_feedback: Optional[str] = None
    regenerate_prompt: Optional[str] = None

    def to_dict(self) -> Dict:
        return {
            "passed": self.passed,
            "score": self.score,
            "findings": [
                {
                    "category": f.category,
                    "severity": f.severity.value,
                    "message": f.message,
                    "suggestion": f.suggestion
                }
                for f in self.findings
            ],
            "prompt_feedback": self.prompt_feedback,
            "regenerate_prompt": self.regenerate_prompt
        }


AUDIT_RUBRIC = """
# Image Quality Audit Rubric (95% THRESHOLD REQUIRED)

Evaluate the image against these criteria. For each, provide a score (0-10) and specific feedback.

## 1. TEXT ARTIFACTS (Critical - Auto-Fail if present)
- Are there ANY visible text, letters, numbers, or symbols that look like text?
- Score 0 if ANY text artifacts present, 10 if completely clean

## 2. CONCEPT ALIGNMENT (Weight: 30%)
- Does the image communicate the intended concept/message?
- Is the visual metaphor clear and appropriate?

## 3. PROFESSIONAL QUALITY (Weight: 25%)
- Is this suitable for a professional LinkedIn banner?
- Are there any obvious AI artifacts?

## 4. COLOR PALETTE (Weight: 15%)
- Does the color scheme match the intended palette?
- Are colors harmonious and professional?

## 5. AESTHETIC COHERENCE (Weight: 15%)
- Do all elements work together as a unified composition?
- Is there a clear focal point?

## 6. TECHNICAL QUALITY (Weight: 15%)
- Is the resolution appropriate?
- Are edges clean?

## 7. FORBIDDEN ELEMENTS (Critical - Auto-Fail if present)
- Does the image contain ANY elements from the NOT list?
- Faces, people, hands - if forbidden, must be absent

## Output Format (JSON):
{
  "text_artifacts": {"score": 0-10, "found": true/false, "details": "..."},
  "concept_alignment": {"score": 0-10, "feedback": "..."},
  "professional_quality": {"score": 0-10, "feedback": "..."},
  "color_palette": {"score": 0-10, "feedback": "..."},
  "aesthetic_coherence": {"score": 0-10, "feedback": "..."},
  "technical_quality": {"score": 0-10, "feedback": "..."},
  "forbidden_elements": {"score": 0-10, "found": true/false, "details": "..."},
  "overall_pass": true/false,
  "overall_score": 0-100,
  "regeneration_suggestions": "Specific prompt changes if score < 95"
}
"""


class ImageAuditor:
    """Audit generated images against quality rubric. Production threshold is 95%."""

    def __init__(self, vision_provider: str = "claude"):
        self.provider = "claude"
        self._claude_client = None

        if not CLAUDE_AVAILABLE:
            raise ValueError("anthropic package not available")
        if not os.environ.get("ANTHROPIC_API_KEY"):
            raise ValueError("ANTHROPIC_API_KEY not set")

    def _get_claude_client(self):
        if self._claude_client is None:
            self._claude_client = anthropic.Anthropic()
        return self._claude_client

    def _encode_image(self, image_path: Path) -> Tuple[str, str]:
        suffix = image_path.suffix.lower()
        media_type = {
            ".png": "image/png",
            ".jpg": "image/jpeg",
            ".jpeg": "image/jpeg",
            ".gif": "image/gif",
            ".webp": "image/webp"
        }.get(suffix, "image/png")
        with open(image_path, "rb") as f:
            data = base64.standard_b64encode(f.read()).decode("utf-8")
        return data, media_type

    def _build_audit_prompt(self, original_prompt: str, intended_concept: str) -> str:
        return f"""You are an expert image quality auditor.

## Original Generation Prompt:
{original_prompt}

## Intended Concept:
{intended_concept}

{AUDIT_RUBRIC}

Be STRICT - production threshold is 95%."""

    def audit(self, image_path: Path, original_prompt: str, intended_concept: str, pass_threshold: float = 0.95) -> AuditResult:
        image_path = Path(image_path)
        if not image_path.exists():
            return AuditResult(passed=False, score=0.0, findings=[AuditFinding(category="file", severity=AuditSeverity.CRITICAL, message=f"Image not found: {image_path}")])

        image_data, media_type = self._encode_image(image_path)
        audit_prompt = self._build_audit_prompt(original_prompt, intended_concept)
        response = self._audit_with_claude(image_data, media_type, audit_prompt)
        return self._parse_audit_response(response, pass_threshold, original_prompt)

    def _audit_with_claude(self, image_data: str, media_type: str, prompt: str) -> str:
        client = self._get_claude_client()
        message = client.messages.create(
            model="claude-sonnet-4-20250514",
            max_tokens=2000,
            messages=[{"role": "user", "content": [{"type": "image", "source": {"type": "base64", "media_type": media_type, "data": image_data}}, {"type": "text", "text": prompt}]}]
        )
        return message.content[0].text

    def _parse_audit_response(self, response: str, pass_threshold: float, original_prompt: str) -> AuditResult:
        findings = []
        try:
            json_start = response.find("{")
            json_end = response.rfind("}") + 1
            if json_start >= 0 and json_end > json_start:
                data = json.loads(response[json_start:json_end])
            else:
                raise ValueError("No JSON found")
        except (json.JSONDecodeError, ValueError) as e:
            return AuditResult(passed=False, score=0.5, findings=[AuditFinding(category="parse_error", severity=AuditSeverity.WARNING, message=str(e))], prompt_feedback=response[:500])

        text_data = data.get("text_artifacts", {})
        if text_data.get("found", False) or text_data.get("score", 10) < 5:
            findings.append(AuditFinding(category="text_artifacts", severity=AuditSeverity.CRITICAL, message=text_data.get("details", "Text artifacts detected")))

        forbidden_data = data.get("forbidden_elements", {})
        if forbidden_data.get("found", False) or forbidden_data.get("score", 10) < 5:
            findings.append(AuditFinding(category="forbidden_elements", severity=AuditSeverity.CRITICAL, message=forbidden_data.get("details", "Forbidden elements detected")))

        categories = [("concept_alignment", 0.30), ("professional_quality", 0.25), ("color_palette", 0.15), ("aesthetic_coherence", 0.15), ("technical_quality", 0.15)]
        weighted_score = 0.0
        for category, weight in categories:
            cat_data = data.get(category, {})
            score = cat_data.get("score", 5) / 10.0
            weighted_score += score * weight
            if score < 0.9:
                severity = AuditSeverity.FAIL if score < 0.7 else AuditSeverity.WARNING
                findings.append(AuditFinding(category=category, severity=severity, message=cat_data.get("feedback", f"Low score in {category}")))

        has_critical = text_data.get("found", False) or forbidden_data.get("found", False)
        if has_critical:
            weighted_score = min(weighted_score, 0.3)

        overall_score = data.get("overall_score", weighted_score * 100) / 100.0
        passed = overall_score >= pass_threshold and not has_critical

        regenerate_prompt = None
        if not passed:
            suggestions = data.get("regeneration_suggestions", "")
            if suggestions:
                regenerate_prompt = f"{original_prompt}\n\nIMPROVEMENTS: {suggestions}\n\nCRITICAL: NO TEXT, NO FACES, NO PEOPLE, NO HANDS. ABSTRACT ONLY."

        return AuditResult(passed=passed, score=overall_score, findings=findings, prompt_feedback=data.get("regeneration_suggestions"), regenerate_prompt=regenerate_prompt)


def audit_and_regenerate_loop(generator, auditor: ImageAuditor, prompt: str, intended_concept: str, output_path: Path, config=None, max_iterations: int = 5, pass_threshold: float = 0.95) -> Tuple[Path, AuditResult]:
    current_prompt = prompt
    output_path = Path(output_path)

    for iteration in range(max_iterations):
        iteration_path = output_path.with_stem(f"{output_path.stem}_iter{iteration+1}")
        print(f"\n[Iteration {iteration+1}/{max_iterations}] Generating image...")

        try:
            result = generator.generate(current_prompt, iteration_path, config)
            print(f"  Generated: {result.path} ({result.generation_time_seconds:.2f}s)")
        except Exception as e:
            print(f"  Generation failed: {e}")
            continue

        print(f"  Auditing image (95% threshold)...")
        audit_result = auditor.audit(iteration_path, current_prompt, intended_concept, pass_threshold)
        print(f"  Score: {audit_result.score:.1%} | Passed: {audit_result.passed}")

        if audit_result.passed:
            if iteration_path != output_path:
                iteration_path.rename(output_path)
            print(f"  SUCCESS: Image passed 95% audit!")
            return output_path, audit_result

        for finding in audit_result.findings:
            print(f"  [{finding.severity.value.upper()}] {finding.category}: {finding.message}")

        if audit_result.regenerate_prompt:
            current_prompt = audit_result.regenerate_prompt
            print(f"  Updating prompt for next iteration...")

        if iteration_path.exists() and iteration_path != output_path:
            iteration_path.unlink()

    print(f"\n  FAILED: Max iterations reached without passing 95% audit.")
    return output_path, audit_result


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Audit generated images (95% threshold)")
    parser.add_argument("image", help="Path to image")
    parser.add_argument("--prompt", "-p", required=True, help="Original prompt")
    parser.add_argument("--concept", "-c", required=True, help="Intended concept")
    parser.add_argument("--threshold", "-t", type=float, default=0.95, help="Pass threshold")
    parser.add_argument("--json", action="store_true", help="Output JSON")
    args = parser.parse_args()

    auditor = ImageAuditor()
    result = auditor.audit(Path(args.image), args.prompt, args.concept, args.threshold)

    if args.json:
        print(json.dumps(result.to_dict(), indent=2))
    else:
        status = "PASSED" if result.passed else "FAILED"
        print(f"\nAUDIT: {status} | Score: {result.score:.1%}")
        for f in result.findings:
            print(f"  [{f.severity.value.upper()}] {f.category}: {f.message}")
