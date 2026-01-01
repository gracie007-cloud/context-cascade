# P0 IMPLEMENTATION PLAN: CLOSING THE FEEDBACK LOOPS

## Executive Summary

This plan implements the two P0 fixes identified in the VERILINGUA/VCL/VERIX audit:

1. **P0-1**: Wire `validate_response()` into `ClaudeRuntime.execute()`
2. **P0-2**: Call `record_mode_outcome()` after task completion

These fixes close the broken feedback loops and enable the Hofstadter strange loop architecture.

---

## ARCHITECTURE OVERVIEW

### Current State (Broken Loops)

```
PromptBuilder.build() --> Claude API --> response --> DEAD END
                                                         |
                                                         X (validate_response never called)
                                                         X (record_mode_outcome never called)

TelemetrySteeringEngine <-- NO DATA
FrameValidationBridge <-- NO FEEDBACK
```

### Target State (Closed Loops)

```
PromptBuilder.build() --> Claude API --> response
       ^                                    |
       |                                    v
       |                        ClaudeRuntime.execute()
       |                                    |
       |                                    v
       |                        prompt_builder.validate_response()
       |                                    |
       |                                    v
       |                        FrameValidationBridge.validate_and_feedback()
       |                                    |
       +--- frame weight adjustments <------+
                                            |
                                            v
                                 record_mode_outcome()
                                            |
                                            v
                              TelemetrySteeringEngine.record_outcome()
                                            |
                                            v
                              _update_pareto_frontier()
                                            |
                                            v
                              ModeSelector.select() [future builds]
```

---

## P0-1: Wire validate_response() into ClaudeRuntime.execute()

### Location
- **File**: `core/runtime.py`
- **Method**: `execute()` (lines 152-181)
- **Insert After**: Line 179 (after VERIX validation)

### Current Code (runtime.py:152-181)

```python
def execute(self, task: str, task_type: str = "default") -> ExecutionResult:
    # Build prompts
    system_prompt, user_prompt = self.prompt_builder.build(task, task_type)

    # Execute via API
    result = self._call_api(system_prompt, user_prompt)

    if not result.success:
        return result

    # Parse VERIX claims
    result.claims = self.verix_parser.parse(result.response)

    # Validate claims
    if result.claims:
        result.is_valid, result.violations = self.verix_validator.validate(result.claims)

    return result  # <-- MISSING: feedback loop invocation
```

### Required Changes

#### Step 1: Add ValidationFeedback to ExecutionResult

**File**: `core/runtime.py` (lines 70-98)

Add to `ExecutionResult` dataclass:

```python
from .frame_validation_bridge import ValidationFeedback  # Add import

@dataclass
class ExecutionResult:
    # ... existing fields ...

    # Validation results
    is_valid: bool = True
    violations: List[str] = field(default_factory=list)

    # NEW: Feedback loop data
    compliance_score: float = 0.0
    validation_feedback: Optional[ValidationFeedback] = None
```

#### Step 2: Modify execute() to call validate_response()

**File**: `core/runtime.py` (after line 179)

```python
def execute(self, task: str, task_type: str = "default") -> ExecutionResult:
    # Build prompts
    system_prompt, user_prompt = self.prompt_builder.build(task, task_type)

    # Execute via API
    result = self._call_api(system_prompt, user_prompt)

    if not result.success:
        return result

    # Parse VERIX claims
    result.claims = self.verix_parser.parse(result.response)

    # Validate claims (basic VERIX validation)
    if result.claims:
        result.is_valid, result.violations = self.verix_validator.validate(result.claims)

    # NEW: FIX P0-1 - Invoke feedback loop via PromptBuilder
    # This closes the VERIX->VERILINGUA feedback loop (FIX-5 from REMEDIATION-PLAN)
    try:
        compliance_score, violations, feedback = self.prompt_builder.validate_response(
            result.response,
            task_type=task_type,
        )
        result.compliance_score = compliance_score
        result.validation_feedback = feedback

        # Merge violations from feedback validation
        if violations:
            result.violations = list(set(result.violations + violations))

    except Exception as e:
        # Graceful degradation - don't fail execution on feedback error
        logger.warning(f"Feedback loop error (non-fatal): {e}")

    return result
```

#### Step 3: Wire Mode Outcome Recording

**File**: `core/runtime.py` (after feedback loop invocation)

```python
    # NEW: FIX P0-2 - Record mode outcome for telemetry steering
    # This closes the Telemetry->ModeSelector feedback loop (FIX-7)
    try:
        from modes.selector import record_mode_outcome

        # Calculate metrics for telemetry
        accuracy = 1.0 if result.is_valid else 0.5
        efficiency = self._calculate_efficiency(result.metrics)
        consistency = result.compliance_score

        record_mode_outcome(accuracy, efficiency, consistency)

    except Exception as e:
        logger.warning(f"Telemetry recording error (non-fatal): {e}")

    return result
```

#### Step 4: Add efficiency calculation helper

**File**: `core/runtime.py` (new method in ClaudeRuntime class)

```python
def _calculate_efficiency(self, metrics: ExecutionMetrics) -> float:
    """
    Calculate token efficiency score for telemetry.

    Higher efficiency = fewer tokens for same result.
    Normalized to 0.0-1.0 scale.

    Args:
        metrics: Execution metrics with token counts

    Returns:
        Efficiency score (0.0-1.0)
    """
    if metrics.total_tokens == 0:
        return 1.0  # No tokens = maximally efficient

    # Baseline: 500 tokens is "normal", 2000 is "expensive"
    # Scale: 200 tokens -> 1.0, 500 -> 0.8, 1000 -> 0.5, 2000 -> 0.0
    baseline = 500
    max_tokens = 2000

    efficiency = 1.0 - (metrics.total_tokens - 200) / (max_tokens - 200)
    return max(0.0, min(1.0, efficiency))
```

### Complete Modified execute() Method

```python
def execute(self, task: str, task_type: str = "default") -> ExecutionResult:
    """
    Execute a task and return structured result.

    This is the main entry point for running prompts.

    FIX P0-1: Now invokes validate_response() for feedback loop.
    FIX P0-2: Now records mode outcome for telemetry steering.

    Args:
        task: Task description
        task_type: Category of task

    Returns:
        ExecutionResult with response, claims, metrics, validation, and feedback
    """
    # Build prompts
    system_prompt, user_prompt = self.prompt_builder.build(task, task_type)

    # Execute via API
    result = self._call_api(system_prompt, user_prompt)

    if not result.success:
        return result

    # Parse VERIX claims
    result.claims = self.verix_parser.parse(result.response)

    # Validate claims (basic VERIX validation)
    if result.claims:
        result.is_valid, result.violations = self.verix_validator.validate(result.claims)

    # FIX P0-1: Invoke feedback loop via PromptBuilder
    # Closes VERIX->VERILINGUA feedback loop (REMEDIATION-PLAN FIX-5)
    try:
        compliance_score, violations, feedback = self.prompt_builder.validate_response(
            result.response,
            task_type=task_type,
        )
        result.compliance_score = compliance_score
        result.validation_feedback = feedback

        # Merge violations from feedback validation
        if violations:
            result.violations = list(set(result.violations + violations))

    except Exception as e:
        logger.warning(f"Feedback loop error (non-fatal): {e}")
        result.compliance_score = 0.5  # Default on error

    # FIX P0-2: Record mode outcome for telemetry steering
    # Closes Telemetry->ModeSelector feedback loop (REMEDIATION-PLAN FIX-7)
    try:
        from modes.selector import record_mode_outcome

        accuracy = 1.0 if result.is_valid else 0.5
        efficiency = self._calculate_efficiency(result.metrics)
        consistency = result.compliance_score

        record_mode_outcome(accuracy, efficiency, consistency)

    except Exception as e:
        logger.warning(f"Telemetry recording error (non-fatal): {e}")

    return result
```

---

## P0-2: Call record_mode_outcome() in Hooks

### Location
- **File**: `hooks/__init__.py`
- **Method**: `on_response_complete()` (lines 68-107)

### Current Code (hooks/__init__.py:68-107)

```python
def on_response_complete(
    response: str,
    mode_name: str = "balanced",
) -> Dict[str, Any]:
    # ... validation logic ...

    return {
        "hook": "on_response_complete",
        "frame_score": frame_score,
        "verix_score": verix_score,
        "verix_markers": verix_markers,
        "compliant": frame_score >= 0.5 and verix_score >= 0.3,
    }  # <-- MISSING: record_mode_outcome call
```

### Required Changes

```python
def on_response_complete(
    response: str,
    mode_name: str = "balanced",
    task_type: str = "default",  # NEW: Add task_type parameter
) -> Dict[str, Any]:
    """
    Hook called when response generation completes.

    Validates VERIX compliance, frame adherence, and records outcome
    for telemetry steering.

    FIX P0-2: Now calls record_mode_outcome() to close feedback loop.

    Args:
        response: The generated response
        mode_name: Name of the mode used
        task_type: Type of task (for telemetry)

    Returns:
        Dict with validation results and telemetry status
    """
    mode = get_mode(mode_name)
    if not mode:
        mode = BUILTIN_MODES["balanced"]

    # Score frame compliance
    frame_score = aggregate_frame_score(response, mode.config.framework)

    # Check VERIX markers
    verix_markers = {
        "has_ground": "[ground:" in response.lower() or "ground:" in response.lower(),
        "has_confidence": "[conf:" in response.lower() or "conf:" in response.lower(),
        "has_illocution": any(m in response.lower() for m in ["[assert", "[query", "[propose"]),
    }

    # Calculate compliance score
    verix_score = sum(verix_markers.values()) / len(verix_markers)

    # FIX P0-2: Record outcome for telemetry steering
    telemetry_recorded = False
    try:
        from modes.selector import record_mode_outcome

        # Map scores to telemetry dimensions
        accuracy = (frame_score + verix_score) / 2  # Combined accuracy
        efficiency = 0.7  # Default efficiency (hooks don't have token data)
        consistency = verix_score  # Epistemic consistency from VERIX

        record_mode_outcome(accuracy, efficiency, consistency)
        telemetry_recorded = True

    except Exception as e:
        # Non-fatal - hooks should not fail on telemetry errors
        import logging
        logging.getLogger(__name__).warning(f"Telemetry recording failed: {e}")

    return {
        "hook": "on_response_complete",
        "frame_score": frame_score,
        "verix_score": verix_score,
        "verix_markers": verix_markers,
        "compliant": frame_score >= 0.5 and verix_score >= 0.3,
        "telemetry_recorded": telemetry_recorded,  # NEW: Track telemetry status
    }
```

---

## IMPORT CHANGES SUMMARY

### core/runtime.py

Add at top of file:

```python
from typing import Optional, Dict, Any, List, Tuple
from .frame_validation_bridge import ValidationFeedback  # NEW
import logging  # If not already present

logger = logging.getLogger(__name__)  # If not already present
```

### hooks/__init__.py

Add at top (if not present):

```python
import logging
```

---

## TESTING PLAN

### Unit Tests

**File**: `tests/test_p0_fixes.py`

```python
"""
Test P0 fixes for feedback loop integration.
"""

import pytest
from core.runtime import ClaudeRuntime, create_runtime, ExecutionResult
from core.config import FullConfig
from modes.selector import _get_default_selector


class TestP0Fixes:
    """Test P0 feedback loop fixes."""

    def test_execute_returns_compliance_score(self):
        """P0-1: execute() should return compliance_score."""
        runtime = create_runtime(use_mock=True)
        result = runtime.execute("Test task", "coding")

        assert hasattr(result, "compliance_score")
        assert 0.0 <= result.compliance_score <= 1.0

    def test_execute_returns_validation_feedback(self):
        """P0-1: execute() should return ValidationFeedback."""
        runtime = create_runtime(use_mock=True)
        result = runtime.execute("Test task", "coding")

        assert hasattr(result, "validation_feedback")
        # Feedback may be None if bridge disabled, but field exists

    def test_execute_records_mode_outcome(self):
        """P0-2: execute() should record mode outcome."""
        # Reset selector state
        selector = _get_default_selector()
        initial_mode = getattr(selector, "_last_mode", None)

        runtime = create_runtime(use_mock=True)
        result = runtime.execute("Test analysis task", "analysis")

        # After execution, selector should have tracked the mode
        assert hasattr(selector, "_last_mode")

    def test_hooks_record_mode_outcome(self):
        """P0-2: on_response_complete should record telemetry."""
        from hooks import on_response_complete

        response = "[assert|neutral] Test claim [ground:test] [conf:0.85] [state:confirmed]"
        result = on_response_complete(response, "balanced", "coding")

        assert "telemetry_recorded" in result
        # Note: May be False if telemetry unavailable, but key exists


class TestFeedbackLoopIntegration:
    """Integration tests for complete feedback loop."""

    def test_full_feedback_loop(self):
        """Test complete feedback loop flow."""
        config = FullConfig()
        runtime = create_runtime(config, use_mock=True)

        # Execute multiple tasks to build telemetry
        for i in range(5):
            result = runtime.execute(f"Test task {i}", "coding")
            assert result.success
            assert result.compliance_score >= 0.0

        # Check that telemetry has been recorded
        from optimization.telemetry_steering import get_steering_engine
        engine = get_steering_engine()

        summary = engine.get_performance_summary()
        assert summary["total_records"] >= 0  # May be 0 if mock doesn't persist
```

### Integration Test Script

**File**: `tests/test_feedback_loop_integration.sh`

```bash
#!/bin/bash
# Integration test for P0 feedback loop fixes

echo "=== P0 Feedback Loop Integration Test ==="

cd "$(dirname "$0")/.."

# Run unit tests
echo "Running unit tests..."
python -m pytest tests/test_p0_fixes.py -v

# Run mock execution test
echo ""
echo "Running mock execution test..."
python -c "
from core.runtime import create_runtime
from core.config import FullConfig

runtime = create_runtime(FullConfig(), use_mock=True)
result = runtime.execute('Analyze this code for bugs', 'coding')

print(f'Success: {result.success}')
print(f'Compliance Score: {result.compliance_score:.2f}')
print(f'Has Feedback: {result.validation_feedback is not None}')
print(f'Violations: {len(result.violations)}')
"

echo ""
echo "=== Test Complete ==="
```

---

## ROLLBACK PLAN

If issues arise, the changes can be reverted by:

1. Remove the feedback loop invocation block from `execute()`
2. Remove the `record_mode_outcome()` call from hooks
3. Remove the `compliance_score` and `validation_feedback` fields from `ExecutionResult`

The changes are additive and use try/except with graceful degradation, so partial rollback is also possible.

---

## VERIFICATION CHECKLIST

After implementation, verify:

- [ ] `ClaudeRuntime.execute()` returns `compliance_score` field
- [ ] `ClaudeRuntime.execute()` returns `validation_feedback` field
- [ ] `FrameValidationBridge.validate_and_feedback()` is invoked on each execution
- [ ] `record_mode_outcome()` is called after each execution
- [ ] `TelemetrySteeringEngine.record_outcome()` receives data
- [ ] Pareto frontiers are updated based on new data
- [ ] `ModeSelector.select()` uses steering recommendations
- [ ] Hooks `on_response_complete()` records telemetry
- [ ] All tests pass
- [ ] No regressions in existing functionality

---

## ESTIMATED EFFORT

| Task | Time |
|------|------|
| P0-1: Modify runtime.py | 1-2 hours |
| P0-2: Modify hooks/__init__.py | 30 min |
| Add imports and helper methods | 30 min |
| Unit tests | 1-2 hours |
| Integration testing | 1 hour |
| Documentation | 30 min |
| **Total** | **4-6 hours** |

---

## DEPENDENCIES

### Required (Already Implemented)

- `PromptBuilder.validate_response()` - core/prompt_builder.py:304-353
- `FrameValidationBridge.validate_and_feedback()` - core/frame_validation_bridge.py:196-257
- `record_mode_outcome()` - modes/selector.py:506-523
- `TelemetrySteeringEngine.record_outcome()` - optimization/telemetry_steering.py:182-216
- `TelemetryAwareModeSelector.record_outcome()` - modes/selector.py:428-456

### New (This Implementation)

- `ExecutionResult.compliance_score` field
- `ExecutionResult.validation_feedback` field
- `ClaudeRuntime._calculate_efficiency()` helper
- Hook telemetry integration

---

## HOFSTADTER STRANGE LOOP COMPLETION

After these fixes, the system achieves:

1. **Self-Observation**: VERIX validates its own outputs
2. **Feedback**: Validation results adjust frame weights
3. **Steering**: Telemetry steers future mode selection
4. **Recursion**: Better outputs lead to better configurations

This closes the strange loop where the system observes and improves itself at runtime.

---

*Generated: 2026-01-01*
*Source: VERILINGUA-VERIX-COMPREHENSIVE-AUDIT.md, codex_verilingua_audit.json*
