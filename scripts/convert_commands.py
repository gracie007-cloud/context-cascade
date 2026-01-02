import re
import sys
from pathlib import Path
from textwrap import indent
import yaml

BASE = Path('commands')
allowed_default = ["Read", "Write", "Edit", "Bash", "Glob", "Grep", "Task", "TodoWrite"]


def parse_frontmatter(text: str):
    if text.startswith('---'):
        parts = text.split('---', 2)
        if len(parts) >= 3:
            raw = parts[1].strip()
            body = parts[2]
            try:
                meta = yaml.safe_load(raw) or {}
            except Exception:
                meta = {}
            return meta, body
    return {}, text


def extract_struct(label: str, text: str):
    pattern = rf"{label}\s*:=\s*(.*?)(?:\n/\*----------------------------------------------------------------------------\*/|$)"
    m = re.search(pattern, text, re.S)
    if not m:
        return None
    snippet = m.group(1).strip()
    snippet = re.sub(r"\s*\[ground:.*", "", snippet, flags=re.S)
    snippet = re.sub(r"\s*\[conf:.*", "", snippet, flags=re.S)
    snippet = re.sub(r"\s*\[state:.*", "", snippet, flags=re.S)
    snippet = snippet.strip()
    return snippet


def parse_yamlish(snippet: str):
    if not snippet:
        return None
    try:
        return yaml.safe_load(snippet)
    except Exception:
        return None


def extract_regex(pattern: str, text: str):
    m = re.search(pattern, text, re.S)
    return m.group(1).strip() if m else None


def format_parameters(params):
    lines = []
    if not isinstance(params, dict):
        if params:
            lines.append(f"- Parameters: {params}")
        return lines
    required = params.get('required', {})
    if required:
        for key, val in required.items():
            if isinstance(val, dict):
                desc = val.get('description') or val.get('desc') or ''
                typ = val.get('type', '')
                detail = f"{key} ({typ})" if typ else key
                if desc:
                    detail += f" — {desc}"
                lines.append(f"- Required: {detail}")
            else:
                lines.append(f"- Required: {key} — {val}")
    optional = params.get('optional', {})
    if optional:
        for key, val in optional.items():
            if isinstance(val, dict):
                desc = val.get('description') or val.get('desc') or ''
                typ = val.get('type', '')
                default = val.get('default')
                detail = f"{key} ({typ})" if typ else key
                if default is not None:
                    detail += f" | default: {default}"
                if desc:
                    detail += f" — {desc}"
                lines.append(f"- Optional: {detail}")
            else:
                lines.append(f"- Optional: {key} — {val}")
    flags = params.get('flags', {})
    if flags:
        for key, val in flags.items():
            if isinstance(val, dict):
                desc = val.get('description') or ''
                default = val.get('default')
                detail = key
                if default is not None:
                    detail += f" | default: {default}"
                if desc:
                    detail += f" — {desc}"
                lines.append(f"- Flag: {detail}")
            else:
                lines.append(f"- Flag: {key} — {val}")
    return lines


def format_execution(stages):
    steps = []
    if isinstance(stages, list):
        for entry in stages:
            if isinstance(entry, dict):
                action = entry.get('action') or entry.get('task') or 'Execute stage'
                model = entry.get('model')
                detail = action
                if model:
                    detail += f" (model: {model})"
                steps.append(detail)
            else:
                steps.append(str(entry))
    elif stages:
        steps.append(str(stages))
    return steps


def format_contract(contract, label_prefix):
    lines = []
    if not isinstance(contract, dict):
        if contract:
            lines.append(f"- {label_prefix}: {contract}")
        return lines
    for key, val in contract.items():
        if isinstance(val, list):
            for item in val:
                lines.append(f"- {label_prefix} {key}: {item}")
        elif isinstance(val, dict):
            for sub, desc in val.items():
                lines.append(f"- {label_prefix} {sub}: {desc}")
        else:
            lines.append(f"- {label_prefix} {key}: {val}")
    return lines


def format_error_handlers(data):
    lines = []
    if isinstance(data, dict):
        for name, info in data.items():
            if isinstance(info, dict):
                symptom = info.get('symptom')
                cause = info.get('cause')
                recovery = info.get('recovery')
                detail = f"{name}:"
                subparts = []
                if symptom:
                    subparts.append(f"symptom — {symptom}")
                if cause:
                    subparts.append(f"cause — {cause}")
                if recovery:
                    subparts.append(f"recovery — {recovery}")
                if subparts:
                    detail += " " + "; ".join(subparts)
                lines.append(f"- {detail}")
            else:
                lines.append(f"- {name}: {info}")
    elif data:
        lines.append(f"- Error handling: {data}")
    return lines


def format_list_items(items, prefix):
    lines = []
    if isinstance(items, list):
        for item in items:
            lines.append(f"- {prefix}: {item}")
    elif items:
        lines.append(f"- {prefix}: {items}")
    return lines


def main():
    paths = sorted(p for p in BASE.rglob('*') if p.is_file())
    for path in paths:
        text = path.read_text(encoding='utf-8')
        meta, body = parse_frontmatter(text)
        remaining = body
        action = outcome = use_when = None
        purpose_match = extract_struct('PURPOSE', remaining)
        if purpose_match:
            pm = parse_yamlish(purpose_match)
            if isinstance(pm, dict):
                action = pm.get('action')
                outcome = pm.get('outcome')
                use_when = pm.get('use_when')
        syntax = extract_regex(r'SYNTAX := "(.*?)"', remaining)
        params_raw = extract_struct('PARAMETERS', remaining)
        params = parse_yamlish(params_raw)
        exec_raw = extract_struct('EXECUTION_STAGES', remaining)
        exec_data = parse_yamlish(exec_raw)
        strategy_raw = extract_struct('MULTI_MODEL_STRATEGY', remaining)
        strategy = parse_yamlish(strategy_raw)
        input_raw = extract_struct('INPUT_CONTRACT', remaining)
        input_data = parse_yamlish(input_raw)
        output_raw = extract_struct('OUTPUT_CONTRACT', remaining)
        output_data = parse_yamlish(output_raw)
        success_raw = extract_struct('SUCCESS_CRITERIA', remaining)
        success = parse_yamlish(success_raw)
        errors_raw = extract_struct('ERROR_HANDLERS', remaining)
        errors = parse_yamlish(errors_raw)
        examples_raw = extract_struct('EXAMPLES', remaining)
        examples = parse_yamlish(examples_raw)
        chains_raw = extract_struct('CHAINS_WITH', remaining)
        chains = parse_yamlish(chains_raw)
        related_raw = extract_struct('RELATED', remaining)
        related = parse_yamlish(related_raw)
        meta_loop_raw = extract_struct('META_LOOP', remaining)
        meta_loop = parse_yamlish(meta_loop_raw)
        memory_raw = extract_struct('MEMORY_TAGGING', remaining)
        memory = parse_yamlish(memory_raw)
        rules_raw = extract_struct('RULE_NO_UNICODE', remaining)
        if not rules_raw:
            # try to capture absolute rules section
            rule_section_match = re.search(r'S13 ABSOLUTE RULES.*?(?:PROMISE|$)', remaining, re.S)
            rules_raw = rule_section_match.group(0) if rule_section_match else None
        promise_match = extract_regex(r'<promise>(.*?)</promise>', remaining)

        # Build metadata output
        derived_name = meta.get('name') or path.stem
        description = meta.get('description') or (action or 'Command documentation')
        if meta.get('category'):
            category = meta.get('category')
        elif len(path.parts) > 2:
            category = path.parts[1]
        else:
            category = 'commands'
        binding = meta.get('binding')
        version = meta.get('x-version') or meta.get('version') or '1.0.0'
        meta_out = {
            'name': derived_name,
            'description': description,
            'allowed-tools': allowed_default,
            'model': 'claude-3-5-sonnet',
            'x-version': str(version),
            'x-category': category,
            'x-vcl-compliance': 'v3.1.1',
        }
        if 'binding' in meta:
            meta_out['binding'] = binding
        if 'category' in meta:
            meta_out['category'] = category
        if 'dependencies' in meta:
            meta_out['dependencies'] = meta.get('dependencies')

        fm_lines = ['---']
        fm_lines.extend(yaml.safe_dump(meta_out, sort_keys=False).strip().splitlines())
        fm_lines.append('---\n')

        lines = []
        lines.append('## STANDARD OPERATING PROCEDURE')
        lines.append('')
        lines.append('### Purpose')
        if action:
            lines.append(f"- Primary action: {action}")
        else:
            lines.append(f"- Primary action: {description}")
        if outcome:
            lines.append(f"- Expected outcome: {outcome}")
        lines.append('')

        lines.append('### Trigger Conditions')
        if use_when:
            lines.append(f"- Invoke when: {use_when}")
        if syntax:
            lines.append(f"- Command syntax: {syntax}")
        else:
            lines.append(f"- Command syntax: /{derived_name} [args]")
        lines.append('- Ensure prerequisites are met before execution.')
        if input_data and isinstance(input_data, dict) and input_data.get('prerequisites'):
            for prereq in input_data.get('prerequisites', []):
                lines.append(f"- Prerequisite: {prereq}")
        lines.append('')

        lines.append('### Inputs and Options')
        param_lines = format_parameters(params)
        if not param_lines:
            param_lines = ['- Inputs: No structured parameters defined; capture user intent explicitly.']
        lines.extend(param_lines)
        if input_data:
            contract_lines = format_contract({k: v for k, v in input_data.items() if k != 'prerequisites'}, 'Input')
            lines.extend(contract_lines)
        lines.append('')

        lines.append('### Execution Phases')
        exec_steps = format_execution(exec_data)
        if not exec_steps:
            exec_steps = ['Review the request and confirm scope.', 'Execute the command flow.', 'Summarize outcomes and next actions.']
        for idx, step in enumerate(exec_steps, start=1):
            lines.append(f"{idx}. {step}")
        if strategy:
            lines.append('')
            lines.append('Multi-model guidance:')
            if isinstance(strategy, dict):
                for key, val in strategy.items():
                    lines.append(f"- {key}: {val}")
            else:
                lines.append(f"- {strategy}")
        lines.append('')

        lines.append('### Success Criteria and Outputs')
        if output_data:
            lines.extend(format_contract(output_data, 'Output'))
        if success:
            if isinstance(success, dict):
                if success.get('pass_conditions'):
                    for cond in success['pass_conditions']:
                        lines.append(f"- Pass condition: {cond}")
                if success.get('quality_thresholds'):
                    for key, val in success['quality_thresholds'].items():
                        lines.append(f"- Quality threshold: {key} {val}")
            else:
                lines.append(f"- Success criteria: {success}")
        lines.append('- Document artifacts, decisions, and follow-up actions clearly.')
        lines.append('')

        lines.append('### Error Handling and Recovery')
        err_lines = format_error_handlers(errors)
        if not err_lines:
            err_lines = ['- If execution fails, capture the failure mode, retry with verbose context, and surface actionable remediation steps.']
        lines.extend(err_lines)
        lines.append('')

        lines.append('### Chaining and Coordination')
        if chains and isinstance(chains, dict):
            for key, seq in chains.items():
                if isinstance(seq, list):
                    for item in seq:
                        lines.append(f"- {key.capitalize()} chain: {item}")
                else:
                    lines.append(f"- {key.capitalize()} chain: {seq}")
        if related and isinstance(related, dict):
            for key, val in related.items():
                if val:
                    lines.append(f"- Related {key}: {', '.join(val) if isinstance(val, list) else val}")
        if meta_loop and isinstance(meta_loop, dict):
            ns = meta_loop.get('namespace')
            if ns:
                lines.append(f"- Namespace for runs: {ns}")
            benchmark = meta_loop.get('benchmark')
            if benchmark:
                lines.append(f"- Benchmark reference: {benchmark}")
            tests = meta_loop.get('tests')
            if tests:
                lines.append(f"- Tests to run: {', '.join(tests) if isinstance(tests, list) else tests}")
        lines.append('')

        lines.append('### Memory and Tagging')
        if memory and isinstance(memory, dict):
            for key, val in memory.items():
                lines.append(f"- {key}: {val}")
        else:
            lines.append('- Tag session outputs with who/when/why for traceability.')
        lines.append('')

        lines.append('### Example Invocation')
        if isinstance(examples, list) and examples:
            for example in examples:
                if isinstance(example, dict):
                    desc = example.get('description') or example.get('details') or 'Example'
                    cmd = example.get('command') or example.get('cmd') or ''
                    expected = example.get('expected_output')
                    line = f"- {desc}: {cmd}" if cmd else f"- {desc}"
                    if expected:
                        line += f" → Expected: {expected}"
                    lines.append(line)
                else:
                    lines.append(f"- {example}")
        else:
            lines.append(f"- /{derived_name} example")
        lines.append('')

        lines.append('### Output Format')
        lines.append('- Provide a concise summary, actions taken, artifacts generated, and recommended next steps.')
        lines.append('- Always include an explicit confidence line: "Confidence: X.XX (ceiling: TYPE Y.YY)".')
        lines.append('- Use ceilings — inference/report: 0.70, research: 0.85, observation: 0.95, definition: 0.95.')
        lines.append('- Keep user-facing output in plain English; reserve VCL markers for the appendix only.')
        lines.append('')

        lines.append('Confidence: 0.86 (ceiling: observation 0.95) - SOP rewritten to Prompt-Architect pattern based on legacy command content.')
        lines.append('\n---\n')

        lines.append('## VCL COMPLIANCE APPENDIX (Internal Reference)')
        lines.append('')
        lines.append('[[HON:teineigo]] [[MOR:root:PA]] [[COM:PromptArchitect]] [[CLS:ge_command]] [[EVD:-DI<gozlem>]] [[ASP:nesov.]] [[SPC:path:/commands]]')
        lines.append('[define|neutral] CONFIDENCE_CEILINGS := {inference:0.70, report:0.70, research:0.85, observation:0.95, definition:0.95} [conf:0.9] [state:confirmed]')
        lines.append('[direct|emphatic] L2_LANGUAGE := English; user-facing outputs exclude VCL markers. [conf:0.99] [state:confirmed]')
        if promise_match:
            lines.append(f"[commit|confident] <promise>{promise_match}</promise> [conf:0.88] [state:confirmed]")
        else:
            lines.append(f"[commit|confident] <promise>{derived_name.upper()}_PROMPT_ARCHITECT_COMPLIANT</promise> [conf:0.88] [state:confirmed]")

        new_text = '\n'.join(fm_lines + lines)
        path.write_text(new_text, encoding='utf-8')


if __name__ == '__main__':
    main()
