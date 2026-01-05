---
name: i18n-automation
description: Automate internationalization and localization with safe key management, locale plumbing, and validated translations.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite
model: sonnet
x-version: 3.2.0
x-category: delivery
x-vcl-compliance: v3.1.1
x-cognitive-frames:
  - HON
  - MOR
  - COM
  - CLS
  - EVD
  - ASP
  - SPC
---




## STANDARD OPERATING PROCEDURE

### Purpose
Enable reliable multi-lingual delivery by externalizing strings, wiring locale infrastructure, and validating translations.

### Trigger Conditions
- **Positive:** adding new locales, fixing missing translations, setting up i18n libraries, RTL enablement, pluralization issues.
- **Negative:** content-only rewrites without code changes (route to `documentation`).

### Guardrails
- **Structure-first:** maintain `examples/`, `tests/`, `resources/`, `references/`.
- **Constraint extraction:** HARD (locales, privacy/PII rules, release windows), SOFT (copy tone), INFERRED (fallback order, locale negotiation) — confirm inferred.
- **Confidence ceilings:** `{inference/report:0.70, research:0.85, observation/definition:0.95}` for locale behavior and translation claims.
- **Safety:** never hardcode secrets/PII in translations; keep placeholders intact.
- **Validation:** syntax-check translation files; test RTL, plural rules, and formatting boundaries.

### Execution Phases
1. **Assessment & Plan**
   - Identify target locales, libraries, file formats, and delivery constraints.
   - Inventory untranslated strings; design key namespaces.
2. **Implementation**
   - Externalize strings; add interpolation context; implement locale detection + fallback.
   - Wire date/number formatting and RTL toggles; store snippets in `examples/`.
3. **Translation Workflow**
   - Prepare source files; protect placeholders; integrate vendor pipelines if applicable.
   - Record guidance and glossaries in `references/`.
4. **Validation**
   - Run lint/schema checks on locale files; test pluralization + ICU messages.
   - Exercise UI in each locale (including RTL); capture artifacts in `resources/`.
5. **Release & Monitor**
   - Add regression tests in `tests/`; document rollout/rollback.
   - Summarize coverage, risks, and **Confidence: X.XX (ceiling: TYPE Y.YY)**.

### Output Format
- Constraints (HARD/SOFT/INFERRED) with confirmation status.
- Key namespaces, locale settings, and validation results.
- Deployment/rollback notes and evidence references.
- Confidence statement with ceiling.

### Validation Checklist
- [ ] Strings externalized; keys namespaced; placeholders preserved.
- [ ] Locale detection + fallback verified; RTL support tested when relevant.
- [ ] Pluralization and formatting checked with boundary values.
- [ ] Lint/schema checks run; tests captured in `tests/`.
- [ ] Sources and advisories stored in `references/`; artifacts in `resources/`.

### MCP / Memory Tags
- Namespace: `skills/delivery/i18n-automation/{project}/{locale}`
- Tags: `WHO=i18n-automation-{session}`, `WHY=skill-execution`, `WHAT=localization`

Confidence: 0.70 (ceiling: inference 0.70) - SOP integrates skill-forge structure-first and prompt-architect constraint/ceiling discipline.

---

## VCL COMPLIANCE APPENDIX
- [[HON:teineigo]] [[MOR:root:I-18-N]] [[COM:I18n+Automation]] [[CLS:ge_skill]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:path:/skills/delivery/i18n-automation]]
  - Structure-first directories enforced for localization tasks.
- [[HON:teineigo]] [[MOR:root:C-N-S]] [[COM:Constraint+Extraction]] [[CLS:ge_principle]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:axis:analysis]]
  - HARD/SOFT/INFERRED constraints documented and confirmed.
- [[HON:teineigo]] [[MOR:root:E-P-S]] [[COM:Epistemic+Ceiling]] [[CLS:ge_rule]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:coord:EVD-CONF]]
  - Confidence ceilings applied to translation, locale, and rollout claims.

### Methodology (Plan-and-Solve Pattern)

1. **Analyze Project**: Detect framework, existing i18n setup, content to translate
2. **Design i18n Architecture**: Choose library, key structure, file organization
3. **Extract Content**: Identify all translatable strings and create keys
4. **Generate Translations**: Create locale files with translations
5. **Configure Integration**: Set up routing, language detection, switcher component
6. **Validate**: Test all locales, check RTL, verify SEO metadata

### Framework Support

**Next.js (Recommended: next-intl)**:
```javascript
// Installation
npm install next-intl

// Configuration: next.config.js
const createNextIntlPlugin = require('next-intl/plugin');
const withNextIntl = createNextIntlPlugin();

module.exports = withNextIntl({
  i18n: {
    locales: ['en', 'ja', 'es', 'fr'],
    defaultLocale: '

---
<!-- S4 SUCCESS CRITERIA                                                          -->
---

[define|neutral] SUCCESS_CRITERIA := {
  primary: "Skill execution completes successfully",
  quality: "Output meets quality thresholds",
  verification: "Results validated against requirements"
} [ground:given] [conf:1.0] [state:confirmed]

---
<!-- S5 MCP INTEGRATION                                                           -->
---

[define|neutral] MCP_INTEGRATION := {
  memory_mcp: "Store execution results and patterns",
  tools: ["mcp__memory-mcp__memory_store", "mcp__memory-mcp__vector_search"]
} [ground:witnessed:mcp-config] [conf:0.95] [state:confirmed]

---
<!-- S6 MEMORY NAMESPACE                                                          -->
---

[define|neutral] MEMORY_NAMESPACE := {
  pattern: "skills/delivery/i18n-automation/{project}/{timestamp}",
  store: ["executions", "decisions", "patterns"],
  retrieve: ["similar_tasks", "proven_patterns"]
} [ground:system-policy] [conf:1.0] [state:confirmed]

[define|neutral] MEMORY_TAGGING := {
  WHO: "i18n-automation-{session_id}",
  WHEN: "ISO8601_timestamp",
  PROJECT: "{project_name}",
  WHY: "skill-execution"
} [ground:system-policy] [conf:1.0] [state:confirmed]

---
<!-- S7 SKILL COMPLETION VERIFICATION                                             -->
---

[direct|emphatic] COMPLETION_CHECKLIST := {
  agent_spawning: "Spawn agents via Task()",
  registry_validation: "Use registry agents only",
  todowrite_called: "Track progress with TodoWrite",
  work_delegation: "Delegate to specialized agents"
} [ground:system-policy] [conf:1.0] [state:confirmed]

---
<!-- S8 ABSOLUTE RULES                                                            -->
---

[direct|emphatic] RULE_NO_UNICODE := forall(output): NOT(unicode_outside_ascii) [ground:windows-compatibility] [conf:1.0] [state:confirmed]

[direct|emphatic] RULE_EVIDENCE := forall(claim): has(ground) AND has(confidence) [ground:verix-spec] [conf:1.0] [state:confirmed]

[direct|emphatic] RULE_REGISTRY := forall(agent): agent IN AGENT_REGISTRY [ground:system-policy] [conf:1.0] [state:confirmed]

---
<!-- PROMISE                                                                      -->
---

[commit|confident] <promise>I18N_AUTOMATION_VERILINGUA_VERIX_COMPLIANT</promise> [ground:self-validation] [conf:0.99] [state:confirmed]
