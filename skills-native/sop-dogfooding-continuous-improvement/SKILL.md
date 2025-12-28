---
name: sop-dogfooding-continuous-improvement
description: 3-part dogfooding workflow Phase 3 - Full cycle orchestration combining Quality Detection + Pattern Retrieval + Application with automated metrics tracking. 60-120 seconds execution time.
allowed-tools: Read, Glob, Grep, Task, TodoWrite
---

## When to Use This Skill

Use this skill when:
- Code quality issues are detected (violations, smells, anti-patterns)
- Audit requirements mandate systematic review (compliance, release gates)
- Review needs arise (pre-merge, production hardening, refactoring preparation)
- Quality metrics indicate degradation (test coverage drop, complexity increase)
- Theater detection is needed (mock data, stubs, incomplete implementations)

## When NOT to Use This Skill

Do NOT use this skill for:
- Simple formatting fixes (use linter/prettier directly)
- Non-code files (documentation, configuration without logic)
- Trivial changes (typo fixes, comment updates)
- Generated code (build artifacts, vendor dependencies)
- Third-party libraries (focus on application code)

## Success Criteria

This skill succeeds when:
- **Violations Detected**: All quality issues found with ZERO false negatives
- **False Positive Rate**: <5% (95%+ findings are genuine issues)
- **Actionable Feedback**: Every finding includes file path, line number, and fix guidance
- **Root Cause Identified**: Issues traced to underlying causes, not just symptoms
- **Fix Verification**: Proposed fixes validated against codebase constraints

## Edge Cases and Limitations

Handle these edge cases carefully:
- **Empty Files**: May trigger false positives - verify intent (stub vs intentional)
- **Generated Code**: Skip or flag as low priority (auto-generated files)
- **Third-Party Libraries**: Exclude from analysis (vendor/, node_modules/)
- **Domain-Specific Patterns**: What looks like violation may be intentional (DSLs)
- **Legacy Code**: Balance ideal standards with pragmatic technical debt management

## Quality Analysis Guardrails

CRITICAL RULES - ALWAYS FOLLOW:
- **NEVER approve code without evidence**: Require actual execution, not assumptions
- **ALWAYS provide line numbers**: Every finding MUST include file:line reference
- **VALIDATE findings against multiple perspectives**: Cross-check with complementary tools
- **DISTINGUISH symptoms from root causes**: Report underlying issues, not just manifestations
- **AVOID false confidence**: Flag uncertain findings as "needs manual review"
- **PRESERVE context**: Show surrounding code (5 lines before/after minimum)
- **TRACK false positives**: Learn from mistakes to improve detection accuracy

## Evidence-Based Validation

Use multiple validation perspectives:
1. **Static Analysis**: Code structure, patterns, metrics (connascence, complexity)
2. **Dynamic Analysis**: Execution behavior, test results, runtime characteristics
3. **Historical Analysis**: Git history, past bug patterns, change frequency
4. **Peer Review**: Cross-validation with other quality skills (functionality-audit, theater-detection)
5. **Domain Expertise**: Leverage .claude/expertise/{domain}.yaml if available

**Validation Threshold**: Findings require 2+ confirming signals before flagging as violations.

## Integration with Quality Pipeline

This skill integrates with:
- **Pre-Phase**: Load domain expertise (.claude/expertise/{domain}.yaml)
- **Parallel Skills**: functionality-audit, theater-detection-audit, style-audit
- **Post-Phase**: Store findings in Memory MCP with WHO/WHEN/PROJECT/WHY tags
- **Feedback Loop**: Learnings feed dogfooding-system for continuous improvement


# SOP: Dogfooding Continuous Improvement

**Loop 3 of 3-Part System**: Full Cycle Orchestration

**Purpose**: Automated continuous improvement cycle combining all phases with safety checks and metrics tracking

**Timeline**: 60-120 seconds per cycle

---

## When to Use This Skill

Use this skill when:
- Code quality issues are detected (violations, smells, anti-patterns)
- Audit requirements mandate systematic review (compliance, release gates)
- Review needs arise (pre-merge, production hardening, refactoring preparation)
- Quality metrics indicate degradation (test coverage drop, complexity increase)
- Theater detection is needed (mock data, stubs, incomplete implementations)

## When NOT to Use This Skill

Do NOT use this skill for:
- Simple formatting fixes (use linter/prettier directly)
- Non-code files (documentation, configuration without logic)
- Trivial changes (typo fixes, comment updates)
- Generated code (build artifacts, vendor dependencies)
- Third-party libraries (focus on application code)

## Success Criteria

This skill succeeds when:
- **Violations Detected**: All quality issues found with ZERO false negatives
- **False Positive Rate**: <5% (95%+ findings are genuine issues)
- **Actionable Feedback**: Every finding includes file path, line number, and fix guidance
- **Root Cause Identified**: Issues traced to underlying causes, not just symptoms
- **Fix Verification**: Proposed fixes validated against codebase constraints

## Edge Cases and Limitations

Handle these edge cases carefully:
- **Empty Files**: May trigger false positives - verify intent (stub vs intentional)
- **Generated Code**: Skip or flag as low priority (auto-generated files)
- **Third-Party Libraries**: Exclude from analysis (vendor/, node_modules/)
- **Domain-Specific Patterns**: What looks like violation may be intentional (DSLs)
- **Legacy Code**: Balance ideal standards with pragmatic technical debt management

## Quality Analysis Guardrails

CRITICAL RULES - ALWAYS FOLLOW:
- **NEVER approve code without evidence**: Require actual execution, not assumptions
- **ALWAYS provide line numbers**: Every finding MUST include file:line reference
- **VALIDATE findings against multiple perspectives**: Cross-check with complementary tools
- **DISTINGUISH symptoms from root causes**: Report underlying issues, not just manifestations
- **AVOID false confidence**: Flag uncertain findings as "needs manual review"
- **PRESERVE context**: Show surrounding code (5 lines before/after minimum)
- **TRACK false positives**: Learn from mistakes to improve detection accuracy

## Evidence-Based Validation

Use multiple validation perspectives:
1. **Static Analysis**: Code structure, patterns, metrics (connascence, complexity)
2. **Dynamic Analysis**: Execution behavior, test results, runtime characteristics
3. **Historical Analysis**: Git history, past bug patterns, change frequency
4. **Peer Review**: Cross-validation with other quality skills (functionality-audit, theater-detection)
5. **Domain Expertise**: Leverage .claude/expertise/{domain}.yaml if available

**Validation Threshold**: Findings require 2+ confirming signals before flagging as violations.

## Integration with Quality Pipeline

This skill integrates with:
- **Pre-Phase**: Load domain expertise (.claude/expertise/{domain}.yaml)
- **Parallel Skills**: functionality-audit, theater-detection-audit, style-audit
- **Post-Phase**: Store findings in Memory MCP with WHO/WHEN/PROJECT/WHY tags
- **Feedback Loop**: Learnings feed dogfooding-system for continuous improvement


## System Architecture

```
[Cycle Start]
    ↓
[Phase 1: Quality Detection] (30-60s)
    ↓ (violations found)
[Phase 2: Pattern Retrieval] (10-30s)
    ↓ (patterns ranked)
[Phase 3: Safe Application] (20-40s)
    ↓ (sandbox testing)
[Phase 4: Metrics & Summary] (10-20s)
    ↓
[Cycle Complete] → Store Results → Trigger Next Cycle
```

---

## When to Use This Skill

Use this skill when:
- Code quality issues are detected (violations, smells, anti-patterns)
- Audit requirements mandate systematic review (compliance, release gates)
- Review needs arise (pre-merge, production hardening, refactoring preparation)
- Quality metrics indicate degradation (test coverage drop, complexity increase)
- Theater detection is needed (mock data, stubs, incomplete implementations)

## When NOT to Use This Skill

Do NOT use this skill for:
- Simple formatting fixes (use linter/prettier directly)
- Non-code files (documentation, configuration without logic)
- Trivial changes (typo fixes, comment updates)
- Generated code (build artifacts, vendor dependencies)
- Third-party libraries (focus on application code)

## Success Criteria

This skill succeeds when:
- **Violations Detected**: All quality issues found with ZERO false negatives
- **False Positive Rate**: <5% (95%+ findings are genuine issues)
- **Actionable Feedback**: Every finding includes file path, line number, and fix guidance
- **Root Cause Identified**: Issues traced to underlying causes, not just symptoms
- **Fix Verification**: Proposed fixes validated against codebase constraints

## Edge Cases and Limitations

Handle these edge cases carefully:
- **Empty Files**: May trigger false positives - verify intent (stub vs intentional)
- **Generated Code**: Skip or flag as low priority (auto-generated files)
- **Third-Party Libraries**: Exclude from analysis (vendor/, node_modules/)
- **Domain-Specific Patterns**: What looks like violation may be intentional (DSLs)
- **Legacy Code**: Balance ideal standards with pragmatic technical debt management

## Quality Analysis Guardrails

CRITICAL RULES - ALWAYS FOLLOW:
- **NEVER approve code without evidence**: Require actual execution, not assumptions
- **ALWAYS provide line numbers**: Every finding MUST include file:line reference
- **VALIDATE findings against multiple perspectives**: Cross-check with complementary tools
- **DISTINGUISH symptoms from root causes**: Report underlying issues, not just manifestations
- **AVOID false confidence**: Flag uncertain findings as "needs manual review"
- **PRESERVE context**: Show surrounding code (5 lines before/after minimum)
- **TRACK false positives**: Learn from mistakes to improve detection accuracy

## Evidence-Based Validation

Use multiple validation perspectives:
1. **Static Analysis**: Code structure, patterns, metrics (connascence, complexity)
2. **Dynamic Analysis**: Execution behavior, test results, runtime characteristics
3. **Historical Analysis**: Git history, past bug patterns, change frequency
4. **Peer Review**: Cross-validation with other quality skills (functionality-audit, theater-detection)
5. **Domain Expertise**: Leverage .claude/expertise/{domain}.yaml if available

**Validation Threshold**: Findings require 2+ confirming signals before flagging as violations.

## Integration with Quality Pipeline

This skill integrates with:
- **Pre-Phase**: Load domain expertise (.claude/expertise/{domain}.yaml)
- **Parallel Skills**: functionality-audit, theater-detection-audit, style-audit
- **Post-Phase**: Store findings in Memory MCP with WHO/WHEN/PROJECT/WHY tags
- **Feedback Loop**: Learnings feed dogfooding-system for continuous improvement


## Phase 1: Initialize Cycle (5 sec)

**Agent**: `hierarchical-coordinator`

**Prompt**:
```javascript
await Task("Cycle Coordinator", `
Initialize continuous improvement cycle.

Pre-Flight Checks:
1. Verify all 3 systems operational
   - Claude Code: Check .claude/ directory exists
   - Connascence Analyzer: Health check
   - Memory-MCP: ChromaDB accessible

2. Select target project for this cycle
   Options:
   - memory-mcp-triple-system (C:\\Users\\17175\\Desktop\\memory-mcp-triple-system)
   - connascence (C:\\Users\\17175\\Desktop\\connascence)
   - claude-flow (project root)

   Strategy: Round-robin or priority-based (NASA violations first)

3. Check last cycle timestamp
   Query Memory-MCP: vector_search("dogfooding cycle summary", limit=1)
   If <24 hours since last cycle → skip same project
   If ≥24 hours → proceed

4. Initialize cycle metadata
   Metadata:
   {
     cycle_id: "cycle-<timestamp>",
     target_project: "<project-name>",
     started_at: "<ISO-8601>",
     coordinator: "hierarchical-coordinator",
     project: "dogfooding-system",
     intent: "continuous-improvement"
   }

Store cycle start in Memory-MCP:
"# Dogfooding Cycle Started
Cycle ID: <cycle_id>
Target: <target_project>
Timestamp: <ISO>
Status: RUNNING"
`, "hierarchical-coordinator");
```

**MCP Tools Used**:
- `mcp__connascence-analyzer__health_check`
- `mcp__memory-mcp__vector_search`
- `mcp__memory-mcp__memory_store`

**Success Criteria**:
- All systems healthy
- Target project selected
- Cycle metadata stored
- Coordinator ready

---

## When to Use This Skill

Use this skill when:
- Code quality issues are detected (violations, smells, anti-patterns)
- Audit requirements mandate systematic review (compliance, release gates)
- Review needs arise (pre-merge, production hardening, refactoring preparation)
- Quality metrics indicate degradation (test coverage drop, complexity increase)
- Theater detection is needed (mock data, stubs, incomplete implementations)

## When NOT to Use This Skill

Do NOT use this skill for:
- Simple formatting fixes (use linter/prettier directly)
- Non-code files (documentation, configuration without logic)
- Trivial changes (typo fixes, comment updates)
- Generated code (build artifacts, vendor dependencies)
- Third-party libraries (focus on application code)

## Success Criteria

This skill succeeds when:
- **Violations Detected**: All quality issues found with ZERO false negatives
- **False Positive Rate**: <5% (95%+ findings are genuine issues)
- **Actionable Feedback**: Every finding includes file path, line number, and fix guidance
- **Root Cause Identified**: Issues traced to underlying causes, not just symptoms
- **Fix Verification**: Proposed fixes validated against codebase constraints

## Edge Cases and Limitations

Handle these edge cases carefully:
- **Empty Files**: May trigger false positives - verify intent (stub vs intentional)
- **Generated Code**: Skip or flag as low priority (auto-generated files)
- **Third-Party Libraries**: Exclude from analysis (vendor/, node_modules/)
- **Domain-Specific Patterns**: What looks like violation may be intentional (DSLs)
- **Legacy Code**: Balance ideal standards with pragmatic technical debt management

## Quality Analysis Guardrails

CRITICAL RULES - ALWAYS FOLLOW:
- **NEVER approve code without evidence**: Require actual execution, not assumptions
- **ALWAYS provide line numbers**: Every finding MUST include file:line reference
- **VALIDATE findings against multiple perspectives**: Cross-check with complementary tools
- **DISTINGUISH symptoms from root causes**: Report underlying issues, not just manifestations
- **AVOID false confidence**: Flag uncertain findings as "needs manual review"
- **PRESERVE context**: Show surrounding code (5 lines before/after minimum)
- **TRACK false positives**: Learn from mistakes to improve detection accuracy

## Evidence-Based Validation

Use multiple validation perspectives:
1. **Static Analysis**: Code structure, patterns, metrics (connascence, complexity)
2. **Dynamic Analysis**: Execution behavior, test results, runtime characteristics
3. **Historical Analysis**: Git history, past bug patterns, change frequency
4. **Peer Review**: Cross-validation with other quality skills (functionality-audit, theater-detection)
5. **Domain Expertise**: Leverage .claude/expertise/{domain}.yaml if available

**Validation Threshold**: Findings require 2+ confirming signals before flagging as violations.

## Integration with Quality Pipeline

This skill integrates with:
- **Pre-Phase**: Load domain expertise (.claude/expertise/{domain}.yaml)
- **Parallel Skills**: functionality-audit, theater-detection-audit, style-audit
- **Post-Phase**: Store findings in Memory MCP with WHO/WHEN/PROJECT/WHY tags
- **Feedback Loop**: Learnings feed dogfooding-system for continuous improvement


## Phase 2: Execute Quality Detection (30-60 sec)

**Agent**: `code-analyzer`

**Prompt**:
```javascript
await Task("Quality Detection Executor", `
Run Phase 1 (Quality Detection) on target project.

DELEGATE TO: sop-dogfooding-quality-detection skill

Target: <target_project>
Command: C:\\Users\\17175\\scripts\\dogfood-quality-check.bat <target_project>

Expected Outputs:
1. JSON: C:\\Users\\17175\\metrics\\dogfooding\\<project>_<timestamp>.json
2. Summary: C:\\Users\\17175\\metrics\\dogfooding\\summary_<timestamp>.txt
3. Memory-MCP storage confirmation
4. Dashboard update

Wait for completion, capture results:
- Total violations: <count>
- Critical violations: <count> (NASA compliance)
- High violations: <count>
- Medium violations: <count>

If violations found:
  Proceed to Phase 3 (Pattern Retrieval)
Else:
  Skip to Phase 6 (Summary) - no work needed

Store Phase 2 status:
cycle_status: "quality-detection-complete"
violations_found: <count>
`, "code-analyzer");
```

**Script**: `C:\\Users\\17175\\scripts\\dogfood-quality-check.bat`

**MCP Tools Used**:
- `mcp__connascence-analyzer__analyze_workspace`
- `mcp__memory-mcp__memory_store`

**Success Criteria**:
- Analysis completed
- Violations categorized
- Results stored in memory
- Phase 1 output files generated

---

## When to Use This Skill

Use this skill when:
- Code quality issues are detected (violations, smells, anti-patterns)
- Audit requirements mandate systematic review (compliance, release gates)
- Review needs arise (pre-merge, production hardening, refactoring preparation)
- Quality metrics indicate degradation (test coverage drop, complexity increase)
- Theater detection is needed (mock data, stubs, incomplete implementations)

## When NOT to Use This Skill

Do NOT use this skill for:
- Simple formatting fixes (use linter/prettier directly)
- Non-code files (documentation, configuration without logic)
- Trivial changes (typo fixes, comment updates)
- Generated code (build artifacts, vendor dependencies)
- Third-party libraries (focus on application code)

## Success Criteria

This skill succeeds when:
- **Violations Detected**: All quality issues found with ZERO false negatives
- **False Positive Rate**: <5% (95%+ findings are genuine issues)
- **Actionable Feedback**: Every finding includes file path, line number, and fix guidance
- **Root Cause Identified**: Issues traced to underlying causes, not just symptoms
- **Fix Verification**: Proposed fixes validated against codebase constraints

## Edge Cases and Limitations

Handle these edge cases carefully:
- **Empty Files**: May trigger false positives - verify intent (stub vs intentional)
- **Generated Code**: Skip or flag as low priority (auto-generated files)
- **Third-Party Libraries**: Exclude from analysis (vendor/, node_modules/)
- **Domain-Specific Patterns**: What looks like violation may be intentional (DSLs)
- **Legacy Code**: Balance ideal standards with pragmatic technical debt management

## Quality Analysis Guardrails

CRITICAL RULES - ALWAYS FOLLOW:
- **NEVER approve code without evidence**: Require actual execution, not assumptions
- **ALWAYS provide line numbers**: Every finding MUST include file:line reference
- **VALIDATE findings against multiple perspectives**: Cross-check with complementary tools
- **DISTINGUISH symptoms from root causes**: Report underlying issues, not just manifestations
- **AVOID false confidence**: Flag uncertain findings as "needs manual review"
- **PRESERVE context**: Show surrounding code (5 lines before/after minimum)
- **TRACK false positives**: Learn from mistakes to improve detection accuracy

## Evidence-Based Validation

Use multiple validation perspectives:
1. **Static Analysis**: Code structure, patterns, metrics (connascence, complexity)
2. **Dynamic Analysis**: Execution behavior, test results, runtime characteristics
3. **Historical Analysis**: Git history, past bug patterns, change frequency
4. **Peer Review**: Cross-validation with other quality skills (functionality-audit, theater-detection)
5. **Domain Expertise**: Leverage .claude/expertise/{domain}.yaml if available

**Validation Threshold**: Findings require 2+ confirming signals before flagging as violations.

## Integration with Quality Pipeline

This skill integrates with:
- **Pre-Phase**: Load domain expertise (.claude/expertise/{domain}.yaml)
- **Parallel Skills**: functionality-audit, theater-detection-audit, style-audit
- **Post-Phase**: Store findings in Memory MCP with WHO/WHEN/PROJECT/WHY tags
- **Feedback Loop**: Learnings feed dogfooding-system for continuous improvement


## Phase 3: Execute Pattern Retrieval (10-30 sec)

**Agent**: `code-analyzer`

**Prompt**:
```javascript
await Task("Pattern Retrieval Executor", `
Run Phase 2 (Pattern Retrieval) for each violation found.

DELEGATE TO: sop-dogfooding-pattern-retrieval skill

Input: C:\\Users\\17175\\metrics\\dogfooding\\<project>_<timestamp>.json

For each CRITICAL violation (prioritize NASA compliance):
1. Formulate search query
   Example: "Fix Parameter Bomb with 14 parameters to meet NASA limit of 6"

2. Execute vector search
   Command: node C:\\Users\\17175\\scripts\\query-memory-mcp.js --query "<query>" --limit 5

3. Rank retrieved patterns
   Algorithm: similarity*0.4 + success_rate*0.3 + context_match*0.2 + recency*0.1

4. Select best pattern
   Threshold: rank_score ≥ 0.70

5. Store best pattern for application
   Output: C:\\Users\\17175\\metrics\\dogfooding\\retrievals\\best-pattern-<violation-id>.json

Aggregate results:
- Violations with patterns: <count>
- Violations without patterns: <count> (will use fallback strategies)
- Average similarity score: <score>

Proceed to Phase 4 (Safe Application)
`, "code-analyzer");
```

**Script**: `C:\\Users\\17175\\scripts\\dogfood-memory-retrieval.bat`

**MCP Tools Used**:
- `mcp__memory-mcp__vector_search`

**Success Criteria**:
- Patterns retrieved for violations
- Best patterns selected
- Patterns ranked by quality
- Ready for application

---

## When to Use This Skill

Use this skill when:
- Code quality issues are detected (violations, smells, anti-patterns)
- Audit requirements mandate systematic review (compliance, release gates)
- Review needs arise (pre-merge, production hardening, refactoring preparation)
- Quality metrics indicate degradation (test coverage drop, complexity increase)
- Theater detection is needed (mock data, stubs, incomplete implementations)

## When NOT to Use This Skill

Do NOT use this skill for:
- Simple formatting fixes (use linter/prettier directly)
- Non-code files (documentation, configuration without logic)
- Trivial changes (typo fixes, comment updates)
- Generated code (build artifacts, vendor dependencies)
- Third-party libraries (focus on application code)

## Success Criteria

This skill succeeds when:
- **Violations Detected**: All quality issues found with ZERO false negatives
- **False Positive Rate**: <5% (95%+ findings are genuine issues)
- **Actionable Feedback**: Every finding includes file path, line number, and fix guidance
- **Root Cause Identified**: Issues traced to underlying causes, not just symptoms
- **Fix Verification**: Proposed fixes validated against codebase constraints

## Edge Cases and Limitations

Handle these edge cases carefully:
- **Empty Files**: May trigger false positives - verify intent (stub vs intentional)
- **Generated Code**: Skip or flag as low priority (auto-generated files)
- **Third-Party Libraries**: Exclude from analysis (vendor/, node_modules/)
- **Domain-Specific Patterns**: What looks like violation may be intentional (DSLs)
- **Legacy Code**: Balance ideal standards with pragmatic technical debt management

## Quality Analysis Guardrails

CRITICAL RULES - ALWAYS FOLLOW:
- **NEVER approve code without evidence**: Require actual execution, not assumptions
- **ALWAYS provide line numbers**: Every finding MUST include file:line reference
- **VALIDATE findings against multiple perspectives**: Cross-check with complementary tools
- **DISTINGUISH symptoms from root causes**: Report underlying issues, not just manifestations
- **AVOID false confidence**: Flag uncertain findings as "needs manual review"
- **PRESERVE context**: Show surrounding code (5 lines before/after minimum)
- **TRACK false positives**: Learn from mistakes to improve detection accuracy

## Evidence-Based Validation

Use multiple validation perspectives:
1. **Static Analysis**: Code structure, patterns, metrics (connascence, complexity)
2. **Dynamic Analysis**: Execution behavior, test results, runtime characteristics
3. **Historical Analysis**: Git history, past bug patterns, change frequency
4. **Peer Review**: Cross-validation with other quality skills (functionality-audit, theater-detection)
5. **Domain Expertise**: Leverage .claude/expertise/{domain}.yaml if available

**Validation Threshold**: Findings require 2+ confirming signals before flagging as violations.

## Integration with Quality Pipeline

This skill integrates with:
- **Pre-Phase**: Load domain expertise (.claude/expertise/{domain}.yaml)
- **Parallel Skills**: functionality-audit, theater-detection-audit, style-audit
- **Post-Phase**: Store findings in Memory MCP with WHO/WHEN/PROJECT/WHY tags
- **Feedback Loop**: Learnings feed dogfooding-system for continuous improvement


## Phase 4: Safe Application with Sandbox Testing (20-40 sec)

**Agent**: `coder`

**Prompt**:
```javascript
await Task("Safe Fix Applicator", `
Apply fixes with MANDATORY sandbox testing.

⚠️ SAFETY RULES CRITICAL ⚠️
See: C:\\Users\\17175\\docs\\DOGFOODING-SAFETY-RULES.md

For each selected pattern (up to 5 per cycle):

STEP 1: Create Sandbox Environment (5 sec)
Command: mkdir C:\\Users\\17175\\tmp\\dogfood-sandbox-<violation-id>
Command: xcopy /E /I /Q <target-project> C:\\Users\\17175\\tmp\\dogfood-sandbox-<violation-id>

STEP 2: Apply Fix in Sandbox (5-10 sec)
Script: node C:\\Users\\17175\\scripts\\apply-fix-pattern.js \\
  --input best-pattern-<violation-id>.json \\
  --file <target-file> \\
  --sandbox C:\\Users\\17175\\tmp\\dogfood-sandbox-<violation-id>

STEP 3: Run Tests in Sandbox (10-20 sec)
cd C:\\Users\\17175\\tmp\\dogfood-sandbox-<violation-id>
npm test  # or pytest, depending on project

STEP 4: Evaluate Sandbox Results
If tests PASS:
  Proceed to STEP 5 (Apply to production)
If tests FAIL:
  REJECT fix
  Store failure in Memory-MCP with intent: "fix-failure-warning"
  Skip to next pattern

STEP 5: Apply to Production (5 sec)
git stash push -u -m "pre-fix-backup-<timestamp>"
<apply-fix-commands>
npm test  # Verify in production

STEP 6: Commit or Rollback (2 sec)
If production tests PASS:
  git add .
  git commit -m "dogfooding: Applied <pattern-name> - <improvement>

  Safety checks:
  - Sandbox tests: PASSED
  - Production tests: PASSED
  - Violations reduced: <before> → <after>

  Cycle ID: <cycle_id>
  "

  Store success in Memory-MCP
Else:
  git reset --hard HEAD
  git stash pop
  echo "ROLLBACK: Production tests failed"

  Store failure in Memory-MCP

STEP 7: Cleanup Sandbox (1 sec)
rmdir /S /Q C:\\Users\\17175\\tmp\\dogfood-sandbox-<violation-id>

Track metrics:
- Fixes attempted: <count>
- Fixes successful: <count>
- Fixes failed: <count>
- Success rate: <percentage>%
`, "coder");
```

**Script**: `C:\\Users\\17175\\scripts\\apply-fix-pattern.js`

**MCP Tools Used**:
- `mcp__memory-mcp__memory_store` (for success/failure storage)

**Bash Commands**:
```bash
# Create sandbox
mkdir C:\Users\17175\tmp\dogfood-sandbox-<id>
xcopy /E /I /Q <project> C:\Users\17175\tmp\dogfood-sandbox-<id>

# Test in sandbox
cd C:\Users\17175\tmp\dogfood-sandbox-<id>
npm test

# If sandbox passes, apply to production
cd <original-project>
git stash push -u -m "backup-<timestamp>"
<apply-fix>
npm test

# If production passes, commit
git add .
git commit -m "dogfooding: <fix>"

# If production fails, rollback
git reset --hard HEAD
git stash pop

# Cleanup
rmdir /S /Q C:\Users\17175\tmp\dogfood-sandbox-<id>
```

**Success Criteria**:
- All fixes tested in sandbox first
- No broken tests in production
- All failures rolled back
- Success/failure metrics recorded

---

## When to Use This Skill

Use this skill when:
- Code quality issues are detected (violations, smells, anti-patterns)
- Audit requirements mandate systematic review (compliance, release gates)
- Review needs arise (pre-merge, production hardening, refactoring preparation)
- Quality metrics indicate degradation (test coverage drop, complexity increase)
- Theater detection is needed (mock data, stubs, incomplete implementations)

## When NOT to Use This Skill

Do NOT use this skill for:
- Simple formatting fixes (use linter/prettier directly)
- Non-code files (documentation, configuration without logic)
- Trivial changes (typo fixes, comment updates)
- Generated code (build artifacts, vendor dependencies)
- Third-party libraries (focus on application code)

## Success Criteria

This skill succeeds when:
- **Violations Detected**: All quality issues found with ZERO false negatives
- **False Positive Rate**: <5% (95%+ findings are genuine issues)
- **Actionable Feedback**: Every finding includes file path, line number, and fix guidance
- **Root Cause Identified**: Issues traced to underlying causes, not just symptoms
- **Fix Verification**: Proposed fixes validated against codebase constraints

## Edge Cases and Limitations

Handle these edge cases carefully:
- **Empty Files**: May trigger false positives - verify intent (stub vs intentional)
- **Generated Code**: Skip or flag as low priority (auto-generated files)
- **Third-Party Libraries**: Exclude from analysis (vendor/, node_modules/)
- **Domain-Specific Patterns**: What looks like violation may be intentional (DSLs)
- **Legacy Code**: Balance ideal standards with pragmatic technical debt management

## Quality Analysis Guardrails

CRITICAL RULES - ALWAYS FOLLOW:
- **NEVER approve code without evidence**: Require actual execution, not assumptions
- **ALWAYS provide line numbers**: Every finding MUST include file:line reference
- **VALIDATE findings against multiple perspectives**: Cross-check with complementary tools
- **DISTINGUISH symptoms from root causes**: Report underlying issues, not just manifestations
- **AVOID false confidence**: Flag uncertain findings as "needs manual review"
- **PRESERVE context**: Show surrounding code (5 lines before/after minimum)
- **TRACK false positives**: Learn from mistakes to improve detection accuracy

## Evidence-Based Validation

Use multiple validation perspectives:
1. **Static Analysis**: Code structure, patterns, metrics (connascence, complexity)
2. **Dynamic Analysis**: Execution behavior, test results, runtime characteristics
3. **Historical Analysis**: Git history, past bug patterns, change frequency
4. **Peer Review**: Cross-validation with other quality skills (functionality-audit, theater-detection)
5. **Domain Expertise**: Leverage .claude/expertise/{domain}.yaml if available

**Validation Threshold**: Findings require 2+ confirming signals before flagging as violations.

## Integration with Quality Pipeline

This skill integrates with:
- **Pre-Phase**: Load domain expertise (.claude/expertise/{domain}.yaml)
- **Parallel Skills**: functionality-audit, theater-detection-audit, style-audit
- **Post-Phase**: Store findings in Memory MCP with WHO/WHEN/PROJECT/WHY tags
- **Feedback Loop**: Learnings feed dogfooding-system for continuous improvement


## Phase 5: Re-Analysis & Verification (15 sec)

**Agent**: `reviewer`

**Prompt**:
```javascript
await Task("Improvement Verifier", `
Re-run connascence analysis to verify improvements.

Command: C:\\Users\\17175\\scripts\\dogfood-quality-check.bat <target_project>

Compare before/after:
Before Analysis: C:\\Users\\17175\\metrics\\dogfooding\\<project>_<cycle-start-timestamp>.json
After Analysis: C:\\Users\\17175\\metrics\\dogfooding\\<project>_<cycle-end-timestamp>.json

Calculate improvement metrics:
1. Total violations change: <before> → <after> (<percentage>% reduction)
2. Critical violations change: <before_critical> → <after_critical>
3. NASA compliance improvements: <count> violations fixed
4. Code quality score improvement: <before_score> → <after_score>

Improvement Validation:
✅ Pass Criteria:
  - Total violations decreased OR stayed same
  - No NEW critical violations introduced
  - Tests still passing

❌ Fail Criteria:
  - Total violations increased
  - New critical violations introduced
  - Tests failing

If validation fails:
  ALERT: "Cycle introduced regressions - investigate!"
  Rollback all changes from this cycle
  Store failure analysis in Memory-MCP

If validation passes:
  Proceed to Phase 6 (Summary Generation)
`, "reviewer");
```

**MCP Tools Used**:
- `mcp__connascence-analyzer__analyze_workspace`

**Success Criteria**:
- Re-analysis completed
- Improvement metrics calculated
- No regressions detected
- Validation passed

---

## When to Use This Skill

Use this skill when:
- Code quality issues are detected (violations, smells, anti-patterns)
- Audit requirements mandate systematic review (compliance, release gates)
- Review needs arise (pre-merge, production hardening, refactoring preparation)
- Quality metrics indicate degradation (test coverage drop, complexity increase)
- Theater detection is needed (mock data, stubs, incomplete implementations)

## When NOT to Use This Skill

Do NOT use this skill for:
- Simple formatting fixes (use linter/prettier directly)
- Non-code files (documentation, configuration without logic)
- Trivial changes (typo fixes, comment updates)
- Generated code (build artifacts, vendor dependencies)
- Third-party libraries (focus on application code)

## Success Criteria

This skill succeeds when:
- **Violations Detected**: All quality issues found with ZERO false negatives
- **False Positive Rate**: <5% (95%+ findings are genuine issues)
- **Actionable Feedback**: Every finding includes file path, line number, and fix guidance
- **Root Cause Identified**: Issues traced to underlying causes, not just symptoms
- **Fix Verification**: Proposed fixes validated against codebase constraints

## Edge Cases and Limitations

Handle these edge cases carefully:
- **Empty Files**: May trigger false positives - verify intent (stub vs intentional)
- **Generated Code**: Skip or flag as low priority (auto-generated files)
- **Third-Party Libraries**: Exclude from analysis (vendor/, node_modules/)
- **Domain-Specific Patterns**: What looks like violation may be intentional (DSLs)
- **Legacy Code**: Balance ideal standards with pragmatic technical debt management

## Quality Analysis Guardrails

CRITICAL RULES - ALWAYS FOLLOW:
- **NEVER approve code without evidence**: Require actual execution, not assumptions
- **ALWAYS provide line numbers**: Every finding MUST include file:line reference
- **VALIDATE findings against multiple perspectives**: Cross-check with complementary tools
- **DISTINGUISH symptoms from root causes**: Report underlying issues, not just manifestations
- **AVOID false confidence**: Flag uncertain findings as "needs manual review"
- **PRESERVE context**: Show surrounding code (5 lines before/after minimum)
- **TRACK false positives**: Learn from mistakes to improve detection accuracy

## Evidence-Based Validation

Use multiple validation perspectives:
1. **Static Analysis**: Code structure, patterns, metrics (connascence, complexity)
2. **Dynamic Analysis**: Execution behavior, test results, runtime characteristics
3. **Historical Analysis**: Git history, past bug patterns, change frequency
4. **Peer Review**: Cross-validation with other quality skills (functionality-audit, theater-detection)
5. **Domain Expertise**: Leverage .claude/expertise/{domain}.yaml if available

**Validation Threshold**: Findings require 2+ confirming signals before flagging as violations.

## Integration with Quality Pipeline

This skill integrates with:
- **Pre-Phase**: Load domain expertise (.claude/expertise/{domain}.yaml)
- **Parallel Skills**: functionality-audit, theater-detection-audit, style-audit
- **Post-Phase**: Store findings in Memory MCP with WHO/WHEN/PROJECT/WHY tags
- **Feedback Loop**: Learnings feed dogfooding-system for continuous improvement


## Phase 6: Generate Cycle Summary (10-20 sec)

**Agent**: `hierarchical-coordinator`

**Prompt**:
```javascript
await Task("Summary Generator", `
Generate comprehensive cycle summary and update all tracking systems.

Script: node C:\\Users\\17175\\scripts\\generate-cycle-summary.js --cycle-id <cycle_id>

Summary Format:
============================================================
DOGFOODING CYCLE SUMMARY
============================================================
Cycle ID: <cycle_id>
Target Project: <target_project>
Started: <start_timestamp>
Completed: <end_timestamp>
Duration: <duration_seconds>s

PHASE 1 - QUALITY DETECTION:
- Files analyzed: <count>
- Violations found: <count>
  - CRITICAL (NASA): <count>
  - HIGH: <count>
  - MEDIUM: <count>
- Top violations: <list top 3>

PHASE 2 - PATTERN RETRIEVAL:
- Patterns retrieved: <count>
- Average similarity: <score>
- Patterns selected for application: <count>
- Fallback strategies used: <count>

PHASE 3 - SAFE APPLICATION:
- Fixes attempted: <count>
- Sandbox tests:
  - Passed: <count>
  - Failed: <count>
- Production application:
  - Successful: <count>
  - Rolled back: <count>
- Success rate: <percentage>%

PHASE 4 - VERIFICATION:
- Violations before: <count>
- Violations after: <count>
- Improvement: <percentage>% reduction
- NASA compliance improvements: <count> violations fixed
- Code quality score: <before> → <after>

METRICS:
- Total execution time: <seconds>s
- Fixes per second: <rate>
- Success rate: <percentage>%
- Memory-MCP entries added: <count>
- Dashboard updates: <count>

NEXT ACTIONS:
- Next cycle scheduled: <timestamp> (24h from now)
- Target project: <next_project> (round-robin)
- Estimated violations remaining: <count>
============================================================

Save summary to: C:\\Users\\17175\\metrics\\dogfooding\\cycle-summaries\\cycle-<cycle_id>.txt

Store summary in Memory-MCP with metadata:
{
  agent: "hierarchical-coordinator",
  agent_category: "orchestration",
  project: "dogfooding-system",
  intent: "cycle-summary",
  cycle_id: "<cycle_id>",
  target_project: "<target_project>",
  violations_fixed: <count>,
  success_rate: <percentage>,
  timestamp_iso: "<ISO>",
  timestamp_unix: <unix>,
  timestamp_readable: "<readable>"
}
`, "hierarchical-coordinator");
```

**Script**: `C:\\Users\\17175\\scripts\\generate-cycle-summary.js`

**MCP Tools Used**:
- `mcp__memory-mcp__memory_store`

**Output Example**:
```
============================================================
DOGFOODING CYCLE SUMMARY
============================================================
Cycle ID: cycle-20251102120000
Target Project: memory-mcp-triple-system
Started: 2025-11-02T12:00:00Z
Completed: 2025-11-02T12:01:45Z
Duration: 105s

PHASE 1 - QUALITY DETECTION:
- Files analyzed: 49
- Violations found: 45
  - CRITICAL (NASA): 8
  - HIGH: 12
  - MEDIUM: 25
- Top violations:
  1. Parameter Bomb: 14 params in transform_query() (NASA limit: 6)
  2. Deep Nesting: 8 levels in process_batch() (NASA limit: 4)
  3. God Object: 26 methods in VectorIndexer (threshold: 15)

PHASE 2 - PATTERN RETRIEVAL:
- Patterns retrieved: 24
- Average similarity: 0.82
- Patterns selected for application: 5
- Fallback strategies used: 3

PHASE 3 - SAFE APPLICATION:
- Fixes attempted: 5
- Sandbox tests:
  - Passed: 5
  - Failed: 0
- Production application:
  - Successful: 5
  - Rolled back: 0
- Success rate: 100%

PHASE 4 - VERIFICATION:
- Violations before: 45
- Violations after: 37
- Improvement: 17.8% reduction
- NASA compliance improvements: 5 violations fixed
- Code quality score: 72 → 81

METRICS:
- Total execution time: 105s
- Fixes per second: 0.048
- Success rate: 100%
- Memory-MCP entries added: 12
- Dashboard updates: 3

NEXT ACTIONS:
- Next cycle scheduled: 2025-11-03T12:00:00Z (24h from now)
- Target project: connascence (round-robin)
- Estimated violations remaining: 37
============================================================
```

**Success Criteria**:
- Summary generated with all metrics
- Stored in file system
- Stored in Memory-MCP
- Next cycle scheduled

---

## When to Use This Skill

Use this skill when:
- Code quality issues are detected (violations, smells, anti-patterns)
- Audit requirements mandate systematic review (compliance, release gates)
- Review needs arise (pre-merge, production hardening, refactoring preparation)
- Quality metrics indicate degradation (test coverage drop, complexity increase)
- Theater detection is needed (mock data, stubs, incomplete implementations)

## When NOT to Use This Skill

Do NOT use this skill for:
- Simple formatting fixes (use linter/prettier directly)
- Non-code files (documentation, configuration without logic)
- Trivial changes (typo fixes, comment updates)
- Generated code (build artifacts, vendor dependencies)
- Third-party libraries (focus on application code)

## Success Criteria

This skill succeeds when:
- **Violations Detected**: All quality issues found with ZERO false negatives
- **False Positive Rate**: <5% (95%+ findings are genuine issues)
- **Actionable Feedback**: Every finding includes file path, line number, and fix guidance
- **Root Cause Identified**: Issues traced to underlying causes, not just symptoms
- **Fix Verification**: Proposed fixes validated against codebase constraints

## Edge Cases and Limitations

Handle these edge cases carefully:
- **Empty Files**: May trigger false positives - verify intent (stub vs intentional)
- **Generated Code**: Skip or flag as low priority (auto-generated files)
- **Third-Party Libraries**: Exclude from analysis (vendor/, node_modules/)
- **Domain-Specific Patterns**: What looks like violation may be intentional (DSLs)
- **Legacy Code**: Balance ideal standards with pragmatic technical debt management

## Quality Analysis Guardrails

CRITICAL RULES - ALWAYS FOLLOW:
- **NEVER approve code without evidence**: Require actual execution, not assumptions
- **ALWAYS provide line numbers**: Every finding MUST include file:line reference
- **VALIDATE findings against multiple perspectives**: Cross-check with complementary tools
- **DISTINGUISH symptoms from root causes**: Report underlying issues, not just manifestations
- **AVOID false confidence**: Flag uncertain findings as "needs manual review"
- **PRESERVE context**: Show surrounding code (5 lines before/after minimum)
- **TRACK false positives**: Learn from mistakes to improve detection accuracy

## Evidence-Based Validation

Use multiple validation perspectives:
1. **Static Analysis**: Code structure, patterns, metrics (connascence, complexity)
2. **Dynamic Analysis**: Execution behavior, test results, runtime characteristics
3. **Historical Analysis**: Git history, past bug patterns, change frequency
4. **Peer Review**: Cross-validation with other quality skills (functionality-audit, theater-detection)
5. **Domain Expertise**: Leverage .claude/expertise/{domain}.yaml if available

**Validation Threshold**: Findings require 2+ confirming signals before flagging as violations.

## Integration with Quality Pipeline

This skill integrates with:
- **Pre-Phase**: Load domain expertise (.claude/expertise/{domain}.yaml)
- **Parallel Skills**: functionality-audit, theater-detection-audit, style-audit
- **Post-Phase**: Store findings in Memory MCP with WHO/WHEN/PROJECT/WHY tags
- **Feedback Loop**: Learnings feed dogfooding-system for continuous improvement


## Phase 7: Dashboard & Notification (5 sec)

**Agent**: `hierarchical-coordinator`

**Prompt**:
```javascript
await Task("Dashboard Updater", `
Update Grafana dashboard and send notifications.

Script: node C:\\Users\\17175\\scripts\\update-dashboard.js --cycle-id <cycle_id>

Actions:
1. Update SQLite tracking database
   DB: C:\\Users\\17175\\metrics\\dogfooding\\dogfooding.db
   Table: cycles
   Insert:
   {
     cycle_id: "<cycle_id>",
     target_project: "<project>",
     started_at: "<timestamp>",
     completed_at: "<timestamp>",
     duration_seconds: <duration>,
     violations_before: <count>,
     violations_after: <count>,
     fixes_attempted: <count>,
     fixes_successful: <count>,
     success_rate: <percentage>
   }

2. Trigger Grafana dashboard refresh
   Endpoint: http://localhost:3000/api/datasources/proxy/1/refresh

3. Send MCP coordination hooks
   Command: npx claude-flow@alpha hooks post-task \\
     --task-id "dogfooding-cycle-<cycle_id>" \\
     --status "complete" \\
     --violations-fixed "<count>"

4. Optional: Send notification (if configured)
   Example: Slack webhook, email, desktop notification
   Message: "Dogfooding cycle complete: <count> violations fixed in <project>"

5. Schedule next cycle
   Store trigger timestamp in Memory-MCP:
   {
     next_cycle_at: "<ISO timestamp 24h from now>",
     next_target_project: "<next_project>"
   }
`, "hierarchical-coordinator");
```

**Script**: `C:\\Users\\17175\\scripts\\update-dashboard.js`

**MCP Tools Used**:
- `mcp__claude-flow__task_orchestrate` (for next cycle scheduling)

**Bash Commands**:
```bash
# Update SQLite DB
sqlite3 C:\Users\17175\metrics\dogfooding\dogfooding.db \
  "INSERT INTO cycles (cycle_id, target_project, violations_before, violations_after) VALUES ('<id>', '<project>', <before>, <after>)"

# Trigger hook
npx claude-flow@alpha hooks post-task --task-id "cycle-<id>" --status "complete"

# Schedule next cycle (cron or Task Scheduler)
# Windows: schtasks /create /tn "Dogfooding-Cycle" /tr "C:\Users\17175\scripts\dogfood-continuous-improvement.bat" /sc daily /st 12:00
```

**Success Criteria**:
- Database updated
- Dashboard refreshed
- Hooks triggered
- Next cycle scheduled
- Notifications sent (if configured)

---

## When to Use This Skill

Use this skill when:
- Code quality issues are detected (violations, smells, anti-patterns)
- Audit requirements mandate systematic review (compliance, release gates)
- Review needs arise (pre-merge, production hardening, refactoring preparation)
- Quality metrics indicate degradation (test coverage drop, complexity increase)
- Theater detection is needed (mock data, stubs, incomplete implementations)

## When NOT to Use This Skill

Do NOT use this skill for:
- Simple formatting fixes (use linter/prettier directly)
- Non-code files (documentation, configuration without logic)
- Trivial changes (typo fixes, comment updates)
- Generated code (build artifacts, vendor dependencies)
- Third-party libraries (focus on application code)

## Success Criteria

This skill succeeds when:
- **Violations Detected**: All quality issues found with ZERO false negatives
- **False Positive Rate**: <5% (95%+ findings are genuine issues)
- **Actionable Feedback**: Every finding includes file path, line number, and fix guidance
- **Root Cause Identified**: Issues traced to underlying causes, not just symptoms
- **Fix Verification**: Proposed fixes validated against codebase constraints

## Edge Cases and Limitations

Handle these edge cases carefully:
- **Empty Files**: May trigger false positives - verify intent (stub vs intentional)
- **Generated Code**: Skip or flag as low priority (auto-generated files)
- **Third-Party Libraries**: Exclude from analysis (vendor/, node_modules/)
- **Domain-Specific Patterns**: What looks like violation may be intentional (DSLs)
- **Legacy Code**: Balance ideal standards with pragmatic technical debt management

## Quality Analysis Guardrails

CRITICAL RULES - ALWAYS FOLLOW:
- **NEVER approve code without evidence**: Require actual execution, not assumptions
- **ALWAYS provide line numbers**: Every finding MUST include file:line reference
- **VALIDATE findings against multiple perspectives**: Cross-check with complementary tools
- **DISTINGUISH symptoms from root causes**: Report underlying issues, not just manifestations
- **AVOID false confidence**: Flag uncertain findings as "needs manual review"
- **PRESERVE context**: Show surrounding code (5 lines before/after minimum)
- **TRACK false positives**: Learn from mistakes to improve detection accuracy

## Evidence-Based Validation

Use multiple validation perspectives:
1. **Static Analysis**: Code structure, patterns, metrics (connascence, complexity)
2. **Dynamic Analysis**: Execution behavior, test results, runtime characteristics
3. **Historical Analysis**: Git history, past bug patterns, change frequency
4. **Peer Review**: Cross-validation with other quality skills (functionality-audit, theater-detection)
5. **Domain Expertise**: Leverage .claude/expertise/{domain}.yaml if available

**Validation Threshold**: Findings require 2+ confirming signals before flagging as violations.

## Integration with Quality Pipeline

This skill integrates with:
- **Pre-Phase**: Load domain expertise (.claude/expertise/{domain}.yaml)
- **Parallel Skills**: functionality-audit, theater-detection-audit, style-audit
- **Post-Phase**: Store findings in Memory MCP with WHO/WHEN/PROJECT/WHY tags
- **Feedback Loop**: Learnings feed dogfooding-system for continuous improvement


## Phase 8: Cleanup & Cycle Complete (2 sec)

**Agent**: `hierarchical-coordinator`

**Prompt**:
```javascript
await Task("Cycle Finalizer", `
Finalize cycle and prepare for next iteration.

Cleanup Actions:
1. Remove temporary files
   Directory: C:\\Users\\17175\\tmp\\dogfood-*
   Command: rmdir /S /Q C:\\Users\\17175\\tmp\\dogfood-*

2. Archive cycle artifacts
   Source: C:\\Users\\17175\\metrics\\dogfooding\\*_<timestamp>.json
   Destination: C:\\Users\\17175\\metrics\\dogfooding\\archive\\<cycle_id>\\
   Command: mkdir C:\\Users\\17175\\metrics\\dogfooding\\archive\\<cycle_id>
   Command: move C:\\Users\\17175\\metrics\\dogfooding\\*_<timestamp>.* C:\\Users\\17175\\metrics\\dogfooding\\archive\\<cycle_id>\\

3. Update cycle status in Memory-MCP
   Store:
   "# Dogfooding Cycle Complete
   Cycle ID: <cycle_id>
   Status: COMPLETED
   Duration: <seconds>s
   Violations Fixed: <count>
   Success Rate: <percentage>%
   Next Cycle: <timestamp>"

4. Set ready flag for next cycle
   Flag: READY_FOR_NEXT_CYCLE=true
   Store in: C:\\Users\\17175\\metrics\\dogfooding\\status.txt

5. Log cycle completion
   Log: C:\\Users\\17175\\metrics\\dogfooding\\cycles.log
   Entry: "<ISO> | Cycle <cycle_id> | Project: <project> | Fixed: <count> | Success: <percentage>%"

Cycle Complete!
`, "hierarchical-coordinator");
```

**MCP Tools Used**:
- `mcp__memory-mcp__memory_store`

**Success Criteria**:
- Temporary files cleaned up
- Artifacts archived
- Status updated
- Ready for next cycle

---

## When to Use This Skill

Use this skill when:
- Code quality issues are detected (violations, smells, anti-patterns)
- Audit requirements mandate systematic review (compliance, release gates)
- Review needs arise (pre-merge, production hardening, refactoring preparation)
- Quality metrics indicate degradation (test coverage drop, complexity increase)
- Theater detection is needed (mock data, stubs, incomplete implementations)

## When NOT to Use This Skill

Do NOT use this skill for:
- Simple formatting fixes (use linter/prettier directly)
- Non-code files (documentation, configuration without logic)
- Trivial changes (typo fixes, comment updates)
- Generated code (build artifacts, vendor dependencies)
- Third-party libraries (focus on application code)

## Success Criteria

This skill succeeds when:
- **Violations Detected**: All quality issues found with ZERO false negatives
- **False Positive Rate**: <5% (95%+ findings are genuine issues)
- **Actionable Feedback**: Every finding includes file path, line number, and fix guidance
- **Root Cause Identified**: Issues traced to underlying causes, not just symptoms
- **Fix Verification**: Proposed fixes validated against codebase constraints

## Edge Cases and Limitations

Handle these edge cases carefully:
- **Empty Files**: May trigger false positives - verify intent (stub vs intentional)
- **Generated Code**: Skip or flag as low priority (auto-generated files)
- **Third-Party Libraries**: Exclude from analysis (vendor/, node_modules/)
- **Domain-Specific Patterns**: What looks like violation may be intentional (DSLs)
- **Legacy Code**: Balance ideal standards with pragmatic technical debt management

## Quality Analysis Guardrails

CRITICAL RULES - ALWAYS FOLLOW:
- **NEVER approve code without evidence**: Require actual execution, not assumptions
- **ALWAYS provide line numbers**: Every finding MUST include file:line reference
- **VALIDATE findings against multiple perspectives**: Cross-check with complementary tools
- **DISTINGUISH symptoms from root causes**: Report underlying issues, not just manifestations
- **AVOID false confidence**: Flag uncertain findings as "needs manual review"
- **PRESERVE context**: Show surrounding code (5 lines before/after minimum)
- **TRACK false positives**: Learn from mistakes to improve detection accuracy

## Evidence-Based Validation

Use multiple validation perspectives:
1. **Static Analysis**: Code structure, patterns, metrics (connascence, complexity)
2. **Dynamic Analysis**: Execution behavior, test results, runtime characteristics
3. **Historical Analysis**: Git history, past bug patterns, change frequency
4. **Peer Review**: Cross-validation with other quality skills (functionality-audit, theater-detection)
5. **Domain Expertise**: Leverage .claude/expertise/{domain}.yaml if available

**Validation Threshold**: Findings require 2+ confirming signals before flagging as violations.

## Integration with Quality Pipeline

This skill integrates with:
- **Pre-Phase**: Load domain expertise (.claude/expertise/{domain}.yaml)
- **Parallel Skills**: functionality-audit, theater-detection-audit, style-audit
- **Post-Phase**: Store findings in Memory MCP with WHO/WHEN/PROJECT/WHY tags
- **Feedback Loop**: Learnings feed dogfooding-system for continuous improvement


## Error Handling

### If Phase 1 (Quality Detection) Fails:

**Agent**: `hierarchical-coordinator`

```javascript
await Task("Phase 1 Error Handler", `
Quality detection failed. Diagnose and retry.

Diagnosis Steps:
1. Check Connascence Analyzer health
   Command: cd C:\\Users\\17175\\Desktop\\connascence && python -m mcp.cli health-check

2. Check target project exists
   Path: <target_project>

3. Check disk space
   Command: wmic logicaldisk get size,freespace

4. Re-run with verbose logging
   Command: python -m mcp.cli analyze-workspace <project> --verbose

If persistent failure:
- Store error in Memory-MCP with intent: "cycle-error"
- Skip to next project in round-robin
- Alert user with error details
- Schedule retry in 6 hours
`, "hierarchical-coordinator");
```

### If Phase 3 (Application) Fails:

**Agent**: `coder`

```javascript
await Task("Application Error Handler", `
Fix application failed. Execute rollback.

IMMEDIATE ACTIONS:
1. Rollback all changes
   Command: git reset --hard HEAD
   Command: git stash pop (if backup exists)

2. Verify rollback worked
   Command: npm test (should pass)

3. Store failure details in Memory-MCP
   Metadata:
   {
     intent: "fix-application-failure",
     cycle_id: "<cycle_id>",
     pattern_id: "<pattern_id>",
     failure_reason: "<reason>",
     rollback_status: "success",
     DO_NOT_APPLY_THIS_PATTERN: true
   }

4. Update pattern success_rate
   Decrement success rate for failed pattern

5. Continue with next pattern
   Skip failed pattern, proceed to remaining patterns

Never leave codebase broken!
`, "coder");
```

### If Phase 5 (Verification) Detects Regression:

**Agent**: `reviewer`

```javascript
await Task("Regression Handler", `
Regression detected. Rollback entire cycle.

CRITICAL ROLLBACK:
1. Revert all commits from this cycle
   Command: git log --since="<cycle_start_timestamp>" --format="%H"
   Command: git revert <commit_hash_1> <commit_hash_2> ...

2. Verify tests pass after rollback
   Command: npm test

3. Re-run connascence analysis
   Command: C:\\Users\\17175\\scripts\\dogfood-quality-check.bat <project>

4. Store regression analysis
   Metadata:
   {
     intent: "regression-detected",
     cycle_id: "<cycle_id>",
     violations_before: <count>,
     violations_after_fixes: <count>,
     violations_after_rollback: <count>,
     patterns_applied: [<list>],
     INVESTIGATE_THESE_PATTERNS: true
   }

5. Mark patterns as suspicious
   Update success_rate for all patterns applied in this cycle

6. Alert user
   Message: "Cycle <cycle_id> rolled back due to regression. Violations increased from <before> to <after>."

Cycle marked as FAILED_AND_ROLLED_BACK.
`, "reviewer");
```

---

## When to Use This Skill

Use this skill when:
- Code quality issues are detected (violations, smells, anti-patterns)
- Audit requirements mandate systematic review (compliance, release gates)
- Review needs arise (pre-merge, production hardening, refactoring preparation)
- Quality metrics indicate degradation (test coverage drop, complexity increase)
- Theater detection is needed (mock data, stubs, incomplete implementations)

## When NOT to Use This Skill

Do NOT use this skill for:
- Simple formatting fixes (use linter/prettier directly)
- Non-code files (documentation, configuration without logic)
- Trivial changes (typo fixes, comment updates)
- Generated code (build artifacts, vendor dependencies)
- Third-party libraries (focus on application code)

## Success Criteria

This skill succeeds when:
- **Violations Detected**: All quality issues found with ZERO false negatives
- **False Positive Rate**: <5% (95%+ findings are genuine issues)
- **Actionable Feedback**: Every finding includes file path, line number, and fix guidance
- **Root Cause Identified**: Issues traced to underlying causes, not just symptoms
- **Fix Verification**: Proposed fixes validated against codebase constraints

## Edge Cases and Limitations

Handle these edge cases carefully:
- **Empty Files**: May trigger false positives - verify intent (stub vs intentional)
- **Generated Code**: Skip or flag as low priority (auto-generated files)
- **Third-Party Libraries**: Exclude from analysis (vendor/, node_modules/)
- **Domain-Specific Patterns**: What looks like violation may be intentional (DSLs)
- **Legacy Code**: Balance ideal standards with pragmatic technical debt management

## Quality Analysis Guardrails

CRITICAL RULES - ALWAYS FOLLOW:
- **NEVER approve code without evidence**: Require actual execution, not assumptions
- **ALWAYS provide line numbers**: Every finding MUST include file:line reference
- **VALIDATE findings against multiple perspectives**: Cross-check with complementary tools
- **DISTINGUISH symptoms from root causes**: Report underlying issues, not just manifestations
- **AVOID false confidence**: Flag uncertain findings as "needs manual review"
- **PRESERVE context**: Show surrounding code (5 lines before/after minimum)
- **TRACK false positives**: Learn from mistakes to improve detection accuracy

## Evidence-Based Validation

Use multiple validation perspectives:
1. **Static Analysis**: Code structure, patterns, metrics (connascence, complexity)
2. **Dynamic Analysis**: Execution behavior, test results, runtime characteristics
3. **Historical Analysis**: Git history, past bug patterns, change frequency
4. **Peer Review**: Cross-validation with other quality skills (functionality-audit, theater-detection)
5. **Domain Expertise**: Leverage .claude/expertise/{domain}.yaml if available

**Validation Threshold**: Findings require 2+ confirming signals before flagging as violations.

## Integration with Quality Pipeline

This skill integrates with:
- **Pre-Phase**: Load domain expertise (.claude/expertise/{domain}.yaml)
- **Parallel Skills**: functionality-audit, theater-detection-audit, style-audit
- **Post-Phase**: Store findings in Memory MCP with WHO/WHEN/PROJECT/WHY tags
- **Feedback Loop**: Learnings feed dogfooding-system for continuous improvement


## Metrics Tracked

1. **Cycle Duration**: Total seconds per cycle (target: <120s)
2. **Violations Fixed**: Count per cycle (target: ≥3)
3. **Success Rate**: Fixes successful / fixes attempted (target: ≥95%)
4. **Improvement Velocity**: Violations fixed per day (target: ≥5)
5. **Pattern Retrieval Quality**: Average similarity score (target: ≥0.75)
6. **Sandbox Testing Pass Rate**: Sandbox passes / total attempts (target: 100%)
7. **Production Rollback Rate**: Rollbacks / applications (target: ≤5%)
8. **Memory-MCP Storage Growth**: Entries added per cycle
9. **Dashboard Update Latency**: Seconds to update (target: <5s)
10. **Next Cycle Schedule Accuracy**: Scheduled time vs actual time (target: ±5 min)

---

## When to Use This Skill

Use this skill when:
- Code quality issues are detected (violations, smells, anti-patterns)
- Audit requirements mandate systematic review (compliance, release gates)
- Review needs arise (pre-merge, production hardening, refactoring preparation)
- Quality metrics indicate degradation (test coverage drop, complexity increase)
- Theater detection is needed (mock data, stubs, incomplete implementations)

## When NOT to Use This Skill

Do NOT use this skill for:
- Simple formatting fixes (use linter/prettier directly)
- Non-code files (documentation, configuration without logic)
- Trivial changes (typo fixes, comment updates)
- Generated code (build artifacts, vendor dependencies)
- Third-party libraries (focus on application code)

## Success Criteria

This skill succeeds when:
- **Violations Detected**: All quality issues found with ZERO false negatives
- **False Positive Rate**: <5% (95%+ findings are genuine issues)
- **Actionable Feedback**: Every finding includes file path, line number, and fix guidance
- **Root Cause Identified**: Issues traced to underlying causes, not just symptoms
- **Fix Verification**: Proposed fixes validated against codebase constraints

## Edge Cases and Limitations

Handle these edge cases carefully:
- **Empty Files**: May trigger false positives - verify intent (stub vs intentional)
- **Generated Code**: Skip or flag as low priority (auto-generated files)
- **Third-Party Libraries**: Exclude from analysis (vendor/, node_modules/)
- **Domain-Specific Patterns**: What looks like violation may be intentional (DSLs)
- **Legacy Code**: Balance ideal standards with pragmatic technical debt management

## Quality Analysis Guardrails

CRITICAL RULES - ALWAYS FOLLOW:
- **NEVER approve code without evidence**: Require actual execution, not assumptions
- **ALWAYS provide line numbers**: Every finding MUST include file:line reference
- **VALIDATE findings against multiple perspectives**: Cross-check with complementary tools
- **DISTINGUISH symptoms from root causes**: Report underlying issues, not just manifestations
- **AVOID false confidence**: Flag uncertain findings as "needs manual review"
- **PRESERVE context**: Show surrounding code (5 lines before/after minimum)
- **TRACK false positives**: Learn from mistakes to improve detection accuracy

## Evidence-Based Validation

Use multiple validation perspectives:
1. **Static Analysis**: Code structure, patterns, metrics (connascence, complexity)
2. **Dynamic Analysis**: Execution behavior, test results, runtime characteristics
3. **Historical Analysis**: Git history, past bug patterns, change frequency
4. **Peer Review**: Cross-validation with other quality skills (functionality-audit, theater-detection)
5. **Domain Expertise**: Leverage .claude/expertise/{domain}.yaml if available

**Validation Threshold**: Findings require 2+ confirming signals before flagging as violations.

## Integration with Quality Pipeline

This skill integrates with:
- **Pre-Phase**: Load domain expertise (.claude/expertise/{domain}.yaml)
- **Parallel Skills**: functionality-audit, theater-detection-audit, style-audit
- **Post-Phase**: Store findings in Memory MCP with WHO/WHEN/PROJECT/WHY tags
- **Feedback Loop**: Learnings feed dogfooding-system for continuous improvement


## Integration with 3-Part System

**Current Phase**: Phase 3 (Continuous Improvement - Full Cycle)

**Triggers**:
- Manual: `C:\Users\17175\scripts\dogfood-continuous-improvement.bat`
- Scheduled: Daily cron/Task Scheduler at 12:00 UTC
- Event-driven: After git commit hook (optional)
- On-demand: User request via Claude Code

**Delegates To**:
- `sop-dogfooding-quality-detection` - Phase 1 execution
- `sop-dogfooding-pattern-retrieval` - Phase 2 execution

**Works With**:
- `connascence-analyzer` MCP - Code quality analysis
- `memory-mcp` MCP - Pattern storage and retrieval
- `claude-flow` - Coordination hooks
- `hierarchical-coordinator` agent - Cycle orchestration
- `code-analyzer` agent - Quality detection
- `coder` agent - Fix application
- `reviewer` agent - Verification

---

## When to Use This Skill

Use this skill when:
- Code quality issues are detected (violations, smells, anti-patterns)
- Audit requirements mandate systematic review (compliance, release gates)
- Review needs arise (pre-merge, production hardening, refactoring preparation)
- Quality metrics indicate degradation (test coverage drop, complexity increase)
- Theater detection is needed (mock data, stubs, incomplete implementations)

## When NOT to Use This Skill

Do NOT use this skill for:
- Simple formatting fixes (use linter/prettier directly)
- Non-code files (documentation, configuration without logic)
- Trivial changes (typo fixes, comment updates)
- Generated code (build artifacts, vendor dependencies)
- Third-party libraries (focus on application code)

## Success Criteria

This skill succeeds when:
- **Violations Detected**: All quality issues found with ZERO false negatives
- **False Positive Rate**: <5% (95%+ findings are genuine issues)
- **Actionable Feedback**: Every finding includes file path, line number, and fix guidance
- **Root Cause Identified**: Issues traced to underlying causes, not just symptoms
- **Fix Verification**: Proposed fixes validated against codebase constraints

## Edge Cases and Limitations

Handle these edge cases carefully:
- **Empty Files**: May trigger false positives - verify intent (stub vs intentional)
- **Generated Code**: Skip or flag as low priority (auto-generated files)
- **Third-Party Libraries**: Exclude from analysis (vendor/, node_modules/)
- **Domain-Specific Patterns**: What looks like violation may be intentional (DSLs)
- **Legacy Code**: Balance ideal standards with pragmatic technical debt management

## Quality Analysis Guardrails

CRITICAL RULES - ALWAYS FOLLOW:
- **NEVER approve code without evidence**: Require actual execution, not assumptions
- **ALWAYS provide line numbers**: Every finding MUST include file:line reference
- **VALIDATE findings against multiple perspectives**: Cross-check with complementary tools
- **DISTINGUISH symptoms from root causes**: Report underlying issues, not just manifestations
- **AVOID false confidence**: Flag uncertain findings as "needs manual review"
- **PRESERVE context**: Show surrounding code (5 lines before/after minimum)
- **TRACK false positives**: Learn from mistakes to improve detection accuracy

## Evidence-Based Validation

Use multiple validation perspectives:
1. **Static Analysis**: Code structure, patterns, metrics (connascence, complexity)
2. **Dynamic Analysis**: Execution behavior, test results, runtime characteristics
3. **Historical Analysis**: Git history, past bug patterns, change frequency
4. **Peer Review**: Cross-validation with other quality skills (functionality-audit, theater-detection)
5. **Domain Expertise**: Leverage .claude/expertise/{domain}.yaml if available

**Validation Threshold**: Findings require 2+ confirming signals before flagging as violations.

## Integration with Quality Pipeline

This skill integrates with:
- **Pre-Phase**: Load domain expertise (.claude/expertise/{domain}.yaml)
- **Parallel Skills**: functionality-audit, theater-detection-audit, style-audit
- **Post-Phase**: Store findings in Memory MCP with WHO/WHEN/PROJECT/WHY tags
- **Feedback Loop**: Learnings feed dogfooding-system for continuous improvement


## Quick Reference

```bash
# Single cycle execution
C:\Users\17175\scripts\dogfood-continuous-improvement.bat memory-mcp

# Full cycle with all projects (round-robin)
C:\Users\17175\scripts\dogfood-continuous-improvement.bat all

# Dry-run (no fixes applied, just analysis)
C:\Users\17175\scripts\dogfood-continuous-improvement.bat memory-mcp --dry-run

# Expected outputs:
# 1. Cycle summary: metrics/dogfooding/cycle-summaries/cycle-<id>.txt
# 2. Archive: metrics/dogfooding/archive/<cycle_id>/
# 3. Dashboard: Updated Grafana metrics
# 4. Memory-MCP: Cycle summary + all fixes stored
# 5. Git commits: Fixes applied with safety metadata
```

**Total Duration**: 60-120 seconds per cycle
**Agents**: `hierarchical-coordinator`, `code-analyzer`, `coder`, `reviewer`
**Tools**: Connascence Analyzer MCP, Memory-MCP, Claude Flow, Bash, Git, SQLite
**Output**: Automated continuous improvement with safety checks, metrics tracking, and dashboard updates

---

## When to Use This Skill

Use this skill when:
- Code quality issues are detected (violations, smells, anti-patterns)
- Audit requirements mandate systematic review (compliance, release gates)
- Review needs arise (pre-merge, production hardening, refactoring preparation)
- Quality metrics indicate degradation (test coverage drop, complexity increase)
- Theater detection is needed (mock data, stubs, incomplete implementations)

## When NOT to Use This Skill

Do NOT use this skill for:
- Simple formatting fixes (use linter/prettier directly)
- Non-code files (documentation, configuration without logic)
- Trivial changes (typo fixes, comment updates)
- Generated code (build artifacts, vendor dependencies)
- Third-party libraries (focus on application code)

## Success Criteria

This skill succeeds when:
- **Violations Detected**: All quality issues found with ZERO false negatives
- **False Positive Rate**: <5% (95%+ findings are genuine issues)
- **Actionable Feedback**: Every finding includes file path, line number, and fix guidance
- **Root Cause Identified**: Issues traced to underlying causes, not just symptoms
- **Fix Verification**: Proposed fixes validated against codebase constraints

## Edge Cases and Limitations

Handle these edge cases carefully:
- **Empty Files**: May trigger false positives - verify intent (stub vs intentional)
- **Generated Code**: Skip or flag as low priority (auto-generated files)
- **Third-Party Libraries**: Exclude from analysis (vendor/, node_modules/)
- **Domain-Specific Patterns**: What looks like violation may be intentional (DSLs)
- **Legacy Code**: Balance ideal standards with pragmatic technical debt management

## Quality Analysis Guardrails

CRITICAL RULES - ALWAYS FOLLOW:
- **NEVER approve code without evidence**: Require actual execution, not assumptions
- **ALWAYS provide line numbers**: Every finding MUST include file:line reference
- **VALIDATE findings against multiple perspectives**: Cross-check with complementary tools
- **DISTINGUISH symptoms from root causes**: Report underlying issues, not just manifestations
- **AVOID false confidence**: Flag uncertain findings as "needs manual review"
- **PRESERVE context**: Show surrounding code (5 lines before/after minimum)
- **TRACK false positives**: Learn from mistakes to improve detection accuracy

## Evidence-Based Validation

Use multiple validation perspectives:
1. **Static Analysis**: Code structure, patterns, metrics (connascence, complexity)
2. **Dynamic Analysis**: Execution behavior, test results, runtime characteristics
3. **Historical Analysis**: Git history, past bug patterns, change frequency
4. **Peer Review**: Cross-validation with other quality skills (functionality-audit, theater-detection)
5. **Domain Expertise**: Leverage .claude/expertise/{domain}.yaml if available

**Validation Threshold**: Findings require 2+ confirming signals before flagging as violations.

## Integration with Quality Pipeline

This skill integrates with:
- **Pre-Phase**: Load domain expertise (.claude/expertise/{domain}.yaml)
- **Parallel Skills**: functionality-audit, theater-detection-audit, style-audit
- **Post-Phase**: Store findings in Memory MCP with WHO/WHEN/PROJECT/WHY tags
- **Feedback Loop**: Learnings feed dogfooding-system for continuous improvement


## Safety Rules Integration

**MANDATORY**: All fix applications MUST follow safety rules from `C:\Users\17175\docs\DOGFOODING-SAFETY-RULES.md`

Key Safety Rules:
1. ✅ Sandbox testing REQUIRED before production
2. ✅ Automated rollback via git stash
3. ✅ Progressive application (one fix at a time)
4. ✅ Test coverage ≥70% required
5. ✅ CI/CD gate must pass before merge

**Never skip safety checks!** Better to reject a safe fix than apply an unsafe one.

---

## When to Use This Skill

Use this skill when:
- Code quality issues are detected (violations, smells, anti-patterns)
- Audit requirements mandate systematic review (compliance, release gates)
- Review needs arise (pre-merge, production hardening, refactoring preparation)
- Quality metrics indicate degradation (test coverage drop, complexity increase)
- Theater detection is needed (mock data, stubs, incomplete implementations)

## When NOT to Use This Skill

Do NOT use this skill for:
- Simple formatting fixes (use linter/prettier directly)
- Non-code files (documentation, configuration without logic)
- Trivial changes (typo fixes, comment updates)
- Generated code (build artifacts, vendor dependencies)
- Third-party libraries (focus on application code)

## Success Criteria

This skill succeeds when:
- **Violations Detected**: All quality issues found with ZERO false negatives
- **False Positive Rate**: <5% (95%+ findings are genuine issues)
- **Actionable Feedback**: Every finding includes file path, line number, and fix guidance
- **Root Cause Identified**: Issues traced to underlying causes, not just symptoms
- **Fix Verification**: Proposed fixes validated against codebase constraints

## Edge Cases and Limitations

Handle these edge cases carefully:
- **Empty Files**: May trigger false positives - verify intent (stub vs intentional)
- **Generated Code**: Skip or flag as low priority (auto-generated files)
- **Third-Party Libraries**: Exclude from analysis (vendor/, node_modules/)
- **Domain-Specific Patterns**: What looks like violation may be intentional (DSLs)
- **Legacy Code**: Balance ideal standards with pragmatic technical debt management

## Quality Analysis Guardrails

CRITICAL RULES - ALWAYS FOLLOW:
- **NEVER approve code without evidence**: Require actual execution, not assumptions
- **ALWAYS provide line numbers**: Every finding MUST include file:line reference
- **VALIDATE findings against multiple perspectives**: Cross-check with complementary tools
- **DISTINGUISH symptoms from root causes**: Report underlying issues, not just manifestations
- **AVOID false confidence**: Flag uncertain findings as "needs manual review"
- **PRESERVE context**: Show surrounding code (5 lines before/after minimum)
- **TRACK false positives**: Learn from mistakes to improve detection accuracy

## Evidence-Based Validation

Use multiple validation perspectives:
1. **Static Analysis**: Code structure, patterns, metrics (connascence, complexity)
2. **Dynamic Analysis**: Execution behavior, test results, runtime characteristics
3. **Historical Analysis**: Git history, past bug patterns, change frequency
4. **Peer Review**: Cross-validation with other quality skills (functionality-audit, theater-detection)
5. **Domain Expertise**: Leverage .claude/expertise/{domain}.yaml if available

**Validation Threshold**: Findings require 2+ confirming signals before flagging as violations.

## Integration with Quality Pipeline

This skill integrates with:
- **Pre-Phase**: Load domain expertise (.claude/expertise/{domain}.yaml)
- **Parallel Skills**: functionality-audit, theater-detection-audit, style-audit
- **Post-Phase**: Store findings in Memory MCP with WHO/WHEN/PROJECT/WHY tags
- **Feedback Loop**: Learnings feed dogfooding-system for continuous improvement


**Status**: ✅ PRODUCTION READY
**Enforcement**: Automated via sandbox testing + rollback + verification
**Integration**: Part of 3-part dogfooding system (Quality Detection → Pattern Retrieval → Continuous Improvement)
## Core Principles

SOP Dogfooding Continuous Improvement operates on 3 fundamental principles:

### Principle 1: Automation Without Safety Is Chaos
Automated quality improvement must include mandatory safety checks - sandbox testing, rollback capabilities, and verification loops. Automation that breaks production is worse than no automation. The 60-120 second execution time includes comprehensive safety measures, not just fix application speed.

In practice:
- Sandbox environment created for EVERY fix (prevents production breakage)
- Git stash backup before ANY code modification (enables instant rollback)
- Tests run in sandbox BEFORE production application (catch regressions early)
- Production tests run AFTER application (verify fix actually works in target environment)
- Automatic rollback on ANY test failure (never leave codebase broken)

### Principle 2: Continuous Improvement Requires Measurable Progress
Improvement cycles without metrics tracking are invisible - you cannot validate effectiveness or identify regressions. Every cycle must record violations before/after, success rates, and improvement velocity to demonstrate continuous quality gains over time.

In practice:
- Dashboard tracks violations reduced per cycle (target: 5+ per day)
- Success rate measured (fixes successful / fixes attempted, target: 95%+)
- Improvement velocity calculated (violations fixed per day)
- Memory-MCP stores cycle results for trend analysis (are we getting better?)
- Grafana visualizations show quality trajectory over weeks/months

### Principle 3: Progressive Application Beats Big Bang Changes
Applying multiple fixes simultaneously makes root cause analysis impossible when issues occur. Progressive application (up to 5 fixes per cycle, one at a time) isolates failures to specific patterns, enabling pattern-level success rate tracking and rejection of low-quality fix patterns.

In practice:
- Maximum 5 fixes per cycle (prevents overwhelming rollback complexity)
- Each fix applied sequentially with individual sandbox testing
- Failed fixes tracked separately in Memory-MCP (pattern-level failure rates)
- High-success patterns prioritized in future cycles
- Low-success patterns flagged for manual investigation

## Common Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **"Skip Sandbox for Speed"** | Applying fixes directly to production codebase without sandbox testing to save 10-20 seconds. First broken test reveals fix breaks functionality, requiring emergency rollback and manual investigation. | NEVER skip sandbox testing. Cost of fixing broken production (hours of debugging) far exceeds cost of sandbox validation (20 seconds). Sandbox testing is non-negotiable. |
| **"Fix Everything At Once"** | Applying 20+ fixes in single cycle to maximize throughput. When tests fail, impossible to determine which fix caused breakage. Rollback discards all fixes, not just problematic one. | Limit to 5 fixes per cycle, applied progressively. Each fix isolated, tested, and verified before next fix begins. Failed fix does not block other fixes from succeeding. |
| **"Improvement Without Metrics"** | Running dogfooding cycles without tracking violations reduced, success rates, or improvement velocity. Cannot demonstrate value or identify regressions. Quality appears to improve based on subjective assessment, not data. | Track and visualize metrics: violations before/after, success rate per cycle, improvement velocity over time. Dashboard shows objective progress. Metrics justify continued investment in dogfooding infrastructure. |

## Conclusion

SOP Dogfooding Continuous Improvement completes the 3-part dogfooding system by orchestrating automated quality improvement cycles that detect violations, retrieve proven fix patterns from Memory MCP, and apply corrections with mandatory safety checks. The 60-120 second execution time includes comprehensive validation - sandbox testing before production application, automatic rollback on failures, and re-analysis to verify improvements. This ensures automation never breaks production while enabling rapid quality gains.

Use this skill as the top-level orchestrator when you want fully automated continuous improvement without manual intervention. The skill delegates to sop-dogfooding-quality-detection (Phase 1) for violation detection and sop-dogfooding-pattern-retrieval (Phase 2) for fix pattern search, then applies fixes progressively with safety guardrails. Success rate targets (95%+ fixes succeed) and improvement velocity targets (5+ violations fixed per day) provide objective measures of effectiveness.

Integration with Memory MCP enables cross-session learning - fixes that succeed are stored with high success rates, while failed fixes are flagged to prevent future application. Over time, the system learns which fix patterns are reliable for specific violation types, improving fix quality automatically. Teams that run daily dogfooding cycles experience continuous quality improvement with minimal manual effort - violations detected on Day 1 are automatically fixed by Day 3, with full safety validation throughout.