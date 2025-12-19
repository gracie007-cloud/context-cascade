# Enforcement System Limitations

## Critical Understanding

This document details what the enforcement system **CANNOT** do due to Claude Code hook constraints. Understanding these limitations is critical for setting proper expectations.

## Hook System Constraints

### 1. Parameter Inspection Limitation

**Problem**: Hooks CANNOT inspect tool parameters in PreToolUse

**Impact**:
- Cannot see Task() parameters (agent_type, agent_name, task_description)
- Cannot see Skill() parameters (skill name, skill arguments)
- Cannot validate parameters BEFORE tool executes
- Cannot block invalid parameters proactively

**Example**:
```javascript
// User code
Task("Build feature X", "...", "generic-builder")  // INVALID agent type

// What we WANT to do in PreToolUse hook
if (agent_type not in registry) {
    display("ERROR: Invalid agent type")
    exit 2  // Block the tool call
}

// What we CAN actually do
display("Remember to use registry agent types!")
// Tool executes anyway, validation happens AFTER (PostToolUse)
```

**Workaround**:
- Display strong reminders in PreToolUse (preventive)
- Validate in PostToolUse (reactive detection)
- Parse transcript asynchronously (async validation)
- Log violations to state for analysis

**Why This Matters**:
- Cannot prevent invalid agent spawns in real-time
- Detection is always reactive, never preventive
- User must self-enforce based on reminders

---

### 2. Input/Output Modification Limitation

**Problem**: Hooks CANNOT modify tool inputs or outputs

**Impact**:
- Cannot auto-correct invalid agent types
- Cannot inject missing TodoWrite calls
- Cannot fix malformed parameters
- Cannot augment tool inputs with context

**Example**:
```javascript
// User code
Task("...", "...", "generic-coder")  // INVALID

// What we WANT to do
modify_input(agent_type = "coder")  // Auto-fix to registry type

// What we CAN actually do
detect_violation()
display("VIOLATION: Use 'coder' not 'generic-coder'")
// User must manually fix
```

**Workaround**:
- Display violation with suggested fix
- Log for later analysis
- Guide user to correct action
- Cannot force correction

**Why This Matters**:
- System is reminder-based, not enforcement-based
- Cannot guarantee compliance, only encourage it
- Violations can still occur despite hooks

---

### 3. Transcript Access Limitation

**Problem**: Hooks CANNOT access conversation transcript in real-time

**Impact**:
- Cannot see previous tool calls
- Cannot correlate Skill -> Task -> TodoWrite pattern in real-time
- Cannot read Claude's reasoning
- Cannot detect patterns across multiple turns

**Example**:
```javascript
// Conversation flow
Turn 1: Skill("planner")
Turn 2: Write("file.py", "...")  // Should have called Task() first!

// What we WANT to do in Turn 2
if (previous_tool == "Skill" && current_tool != "Task") {
    violation("skipped_task")
}

// What we CAN actually do
// Each hook runs in isolation, doesn't know about Turn 1
// Must use state file to accumulate history
```

**Workaround**:
- Use state file to track cross-tool patterns
- Parse history.jsonl asynchronously
- Accumulate state across hook invocations
- Check compliance in PostToolUse hooks

**Why This Matters**:
- Pattern detection is delayed
- Cannot catch violations in real-time
- Must rely on state accumulation

---

### 4. Forced Tool Invocation Limitation

**Problem**: Hooks CANNOT inject or force tool calls

**Impact**:
- Cannot auto-invoke TodoWrite if missing
- Cannot force Task() after Skill()
- Cannot inject required tools
- Cannot modify execution flow

**Example**:
```javascript
// User invokes Skill but forgets Task
Skill("planner")
// Should call Task() here
Write("file.py", "...")  // Oops, skipped Task()

// What we WANT to do
if (skill_invoked && !task_called) {
    force_invoke(Task(...))  // Auto-inject missing Task
}

// What we CAN actually do
detect_violation()
display("ERROR: Must call Task() after Skill()")
// Cannot force the call
```

**Workaround**:
- Display strong reminders
- Log violations
- Show compliance checklists
- Hope Claude follows guidance

**Why This Matters**:
- Cannot guarantee SOP pattern is followed
- Can only detect and report violations
- Compliance depends on Claude's cooperation

---

### 5. Blocking with Validation Limitation

**Problem**: Hooks CAN block (exit 2) but CANNOT validate first

**Impact**:
- Can block execution unconditionally
- Cannot block ONLY if validation fails (since cannot validate)
- Blocking is all-or-nothing
- No conditional blocking based on parameters

**Example**:
```javascript
// What we WANT to do
PreToolUse on Task:
    if (agent_type not in registry) {
        exit 2  // Block ONLY if invalid
    }

// What we CAN actually do
PreToolUse on Task:
    // Cannot see agent_type!
    // Can only exit 2 unconditionally (blocks ALL Tasks)
    // Or exit 0 unconditionally (blocks NO Tasks)
```

**Workaround**:
- Never block (always exit 0)
- Use reminders and reactive validation
- Log violations in PostToolUse
- Trust Claude to follow reminders

**Why This Matters**:
- Cannot selectively block invalid actions
- Blocking would prevent ALL tool uses, not just invalid ones
- Must rely on passive enforcement

---

### 6. Real-time Compliance Checking Limitation

**Problem**: Hooks cannot check multi-step compliance in real-time

**Impact**:
- Cannot verify Skill -> Task -> TodoWrite pattern as it happens
- Cannot detect missing steps until after fact
- Cannot correlate tools across turns in real-time

**Example**:
```javascript
// Expected pattern
Skill("planner")      // Step 1
Task("coder", ...)    // Step 2
TodoWrite({todos})    // Step 3

// What we WANT to do
After each step, check if pattern is being followed

// What we CAN actually do
Wait until later, check state file, detect violations retroactively
```

**Workaround**:
- Accumulate state across hooks
- Check compliance in PostToolUse
- Use check_compliance() function
- Generate compliance reports

**Why This Matters**:
- Violations detected after they occur
- Cannot prevent pattern violations in real-time
- Must rely on post-hoc analysis

---

## What CAN Be Enforced

Despite limitations, the system CAN:

### 1. Display Strong Reminders
- Inject enforcement rules at critical points
- Show agent registry before Task spawns
- Display SOP pattern after Skill invokes
- Remind about TodoWrite after Task spawns

**Effectiveness**: Medium - depends on Claude following reminders

---

### 2. Passive Validation
- Check compliance in PostToolUse
- Detect violations after they occur
- Log to state file for analysis
- Generate compliance reports

**Effectiveness**: High - reliably detects all violations

---

### 3. State Tracking
- Log all skill invocations
- Log all agent spawns
- Track TodoWrite calls
- Record violations

**Effectiveness**: High - complete history tracking

---

### 4. Violation Detection
- Identify missing Task() after Skill()
- Identify missing TodoWrite() after Task()
- Identify generic/non-registry agents
- Identify skipped phases

**Effectiveness**: High - catches all violation types

---

### 5. Pattern Retention
- Inject patterns before context compaction
- Ensure rules survive context loss
- Display reminders at session start/end

**Effectiveness**: High - critical for long sessions

---

### 6. Session Memory
- Track compliance across conversation
- Archive state at session end
- Analyze historical compliance
- Feed data to improvement system

**Effectiveness**: High - enables learning

---

## Enforcement Strategy Given Limitations

### Layer 1: Preventive (Reminders)
- **When**: UserPromptSubmit, PreToolUse
- **What**: Display enforcement rules
- **Goal**: Prevent violations through awareness
- **Limitation**: Cannot force compliance

### Layer 2: Detective (Validation)
- **When**: PostToolUse, async parsing
- **What**: Check compliance, detect violations
- **Goal**: Identify all violations
- **Limitation**: Detection is reactive

### Layer 3: Corrective (Feedback)
- **When**: After violation detected
- **What**: Display checklists, log violations
- **Goal**: Guide toward compliance
- **Limitation**: Cannot force correction

### Layer 4: Learning (Long-term)
- **When**: Session end, analysis
- **What**: Archive violations, generate metrics
- **Goal**: Feed into recursive improvement
- **Limitation**: Improvement takes time

---

## Workaround Summary

| Limitation | Workaround | Effectiveness |
|------------|------------|---------------|
| Cannot inspect parameters | Async transcript parsing | Medium - delayed |
| Cannot modify inputs | Display suggested fixes | Low - manual fix |
| Cannot access transcript | State file accumulation | Medium - works |
| Cannot force tool calls | Strong reminders | Low - hope-based |
| Cannot validate+block | Reactive validation | Medium - after fact |
| Cannot real-time check | Post-hoc analysis | High - catches all |

---

## Acceptance Criteria

Given these limitations, enforcement "success" means:

1. **100% Violation Detection**: All violations caught (after fact)
2. **Clear Reminders**: Strong guidance displayed at all decision points
3. **Complete State Tracking**: All actions logged
4. **Actionable Feedback**: Violations include suggested fixes
5. **Pattern Retention**: Rules survive context compaction
6. **Historical Analysis**: Compliance trends tracked

**NOT**:
- 100% Prevention (cannot force compliance)
- Real-time Blocking (cannot validate before execution)
- Automatic Correction (cannot modify inputs)

---

## Future Improvements

If Claude Code adds hook capabilities:

### 1. Parameter Inspection
```javascript
PreToolUse on Task:
    agent_type = get_parameter("agent_type")
    if (agent_type not in registry) {
        exit 2  // Can now block selectively!
    }
```

### 2. Input Modification
```javascript
PreToolUse on Task:
    if (agent_type == "generic-coder") {
        modify_parameter("agent_type", "coder")  // Auto-fix
    }
```

### 3. Transcript Access
```javascript
PostToolUse on Write:
    prev_tools = get_conversation_history()
    if (prev_tools[-1] == "Skill" && current_tool != "Task") {
        violation("skipped_task")
        exit 2  // Block in real-time
    }
```

### 4. Tool Injection
```javascript
PostToolUse on Task:
    if (!will_call("TodoWrite")) {
        inject_tool_call(TodoWrite(...))  // Auto-inject
    }
```

---

## Bottom Line

**The enforcement system is REMINDER-BASED, not ENFORCEMENT-BASED.**

- It GUIDES toward compliance (preventive reminders)
- It DETECTS violations (reactive validation)
- It TRACKS history (state accumulation)
- It ANALYZES patterns (compliance metrics)

**It CANNOT:**
- Force compliance
- Prevent violations in real-time
- Auto-correct invalid actions
- Guarantee Claude follows rules

**Success depends on:**
1. Strong, clear reminders
2. Comprehensive violation detection
3. Actionable feedback
4. Claude's cooperation

This is a **guardrail system**, not a **enforcement system**.
