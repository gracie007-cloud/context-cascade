---
name: reflect-off
description: Disable automatic session reflection on stop hook
allowed-tools:
- Read
- Write
- Edit
- Bash
model: sonnet
x-version: 1.0.0
x-category: tooling
x-vcl-compliance: v3.1.1
---



---



---

## Library-First Directive

This agent operates under library-first constraints:

1. **Pre-Check Required**: Before writing code, search:
   - `.claude/library/catalog.json` (components)
   - `.claude/docs/inventories/LIBRARY-PATTERNS-GUIDE.md` (patterns)
   - `D:\Projects\*` (existing implementations)

2. **Decision Matrix**:
   | Result | Action |
   |--------|--------|
   | Library >90% | REUSE directly |
   | Library 70-90% | ADAPT minimally |
   | Pattern documented | FOLLOW pattern |
   | In existing project | EXTRACT and adapt |
   | No match | BUILD new |

---

## Library-First Directive

This agent operates under library-first constraints:

1. **Pre-Check Required**: Before writing code, search:
   - `.claude/library/catalog.json` (components)
   - `.claude/docs/inventories/LIBRARY-PATTERNS-GUIDE.md` (patterns)
   - `D:\Projects\*` (existing implementations)

2. **Decision Matrix**:
   | Result | Action |
   |--------|--------|
   | Library >90% | REUSE directly |
   | Library 70-90% | ADAPT minimally |
   | Pattern documented | FOLLOW pattern |
   | In existing project | EXTRACT and adapt |
   | No match | BUILD new |

---

## STANDARD OPERATING PROCEDURE

### Purpose
- Primary action: Disable automatic reflection that triggers when a session ends

### Trigger Conditions
- Command syntax: /reflect-off
- Run to disable automatic reflection; manual /reflect still works

### Inputs and Options
- No parameters required

### Execution Phases
1. Update state file at ~/.claude/reflect-enabled
2. Set value to "false"
3. Confirm deactivation to user
4. Stop hook will no longer trigger reflect skill

### Success Criteria and Outputs
- State file updated
- Confirmation message displayed
- Future sessions will NOT auto-reflect

### Error Handling and Recovery
- If state file doesn't exist: Create with "false" value
- If write fails: Report permission error with remediation

### Chaining and Coordination
- Disables: session-reflect-stop.sh hook
- Related: /reflect-on, /reflect-status

### Memory and Tagging
- State stored in: ~/.claude/reflect-enabled
- No Memory MCP storage needed (local state only)

### Example Invocation
```bash
/reflect-off
```

### Output Format
```
Automatic reflection DISABLED.

Sessions will no longer auto-reflect on end.
Manual /reflect command still available.

Use /reflect-on to re-enable.
Use /reflect-status to check current state.
```

Confidence: 0.90 (ceiling: observation 0.95) - Simple toggle command.

---

## VCL COMPLIANCE APPENDIX (Internal Reference)

[[HON:teineigo]] [[MOR:root:R-F-L]] [[COM:Reflect+Off]] [[CLS:ge_command]] [[EVD:-DI<gozlem>]] [[ASP:sov.]] [[SPC:path:/commands/tooling/reflect]]
[commit|confident] <promise>REFLECT_OFF_COMMAND_VERILINGUA_VERIX_COMPLIANT</promise> [conf:0.90] [state:confirmed]
