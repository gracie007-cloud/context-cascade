import fs from 'fs/promises';
import path from 'path';
import { parseDocument } from 'yaml';

const allowedSkillKeys = new Set(['name', 'description', 'allowed-tools', 'model']);
const verixPattern = /\[[^\]]*(?:conf:|ground:|state:)[^\]]*\]/i;

async function readJson(filePath) {
  const raw = await fs.readFile(filePath, 'utf8');
  return JSON.parse(raw);
}

function assertCondition(condition, message, errors) {
  if (!condition) {
    errors.push(message);
  }
}

async function validatePlugins(errors) {
  const pluginFiles = await fs.readdir('plugins');
  for (const folder of pluginFiles) {
    const manifestPath = path.join('plugins', folder, 'plugin.json');
    const data = await readJson(manifestPath);

    const arrayOrString = (value) => Array.isArray(value) || typeof value === 'string';
    if (!arrayOrString(data.commands)) {
      errors.push(`${manifestPath}: commands must be an array or string path, not an object.`);
    } else if (Array.isArray(data.commands)) {
      data.commands.forEach((item, idx) => {
        assertCondition(typeof item === 'string', `${manifestPath}: commands[${idx}] must be a string path.`, errors);
      });
    }

    if (!arrayOrString(data.skills)) {
      errors.push(`${manifestPath}: skills must be an array or string path, not an object.`);
    } else if (Array.isArray(data.skills)) {
      data.skills.forEach((item, idx) => {
        assertCondition(typeof item === 'string', `${manifestPath}: skills[${idx}] must be a string path.`, errors);
      });
    }

    if (!(arrayOrString(data.agents))) {
      errors.push(`${manifestPath}: agents must be an array or string path.`);
    } else if (Array.isArray(data.agents)) {
      data.agents.forEach((item, idx) => {
        assertCondition(typeof item === 'string', `${manifestPath}: agents[${idx}] must be a string path.`, errors);
      });
    } else if (typeof data.agents === 'string' && !data.agents.includes('/')) {
      errors.push(`${manifestPath}: agents should reference agent file paths, not bare names.`);
    }

    if (typeof data.hooks !== 'string') {
      if (!data.hooks || typeof data.hooks !== 'object' || !data.hooks.hooks) {
        errors.push(`${manifestPath}: hooks must be a string path or object with a hooks property.`);
      }
    }
  }
}

function parseFrontmatter(content, filePath, errors) {
  const match = content.match(/^---\n([\s\S]*?)\n---\n?/);
  if (!match) {
    errors.push(`${filePath}: missing YAML frontmatter.`);
    return null;
  }

  try {
    const doc = parseDocument(match[1], { version: '1.2' });
    const data = doc.toJS({ json: true });
    if (!data || typeof data !== 'object') {
      errors.push(`${filePath}: frontmatter must be a mapping.`);
      return null;
    }
    return data;
  } catch (error) {
    errors.push(`${filePath}: unable to parse frontmatter (${error.message}).`);
    return null;
  }
}

async function validateSkills(errors) {
  for await (const entry of walk('skills')) {
    if (!entry.path.endsWith('SKILL.md')) continue;
    const content = await fs.readFile(entry.path, 'utf8');
    const data = parseFrontmatter(content, entry.path, errors);
    if (!data) continue;

    assertCondition(Boolean(data.name), `${entry.path}: name is required.`, errors);
    assertCondition(Boolean(data.description), `${entry.path}: description is required.`, errors);

    if (typeof data.description === 'string' && verixPattern.test(data.description)) {
      errors.push(`${entry.path}: description must not contain VERIX metadata markers.`);
    }

    const folderName = path.basename(path.dirname(entry.path));
    if (data.name !== folderName) {
      errors.push(`${entry.path}: name must match folder (${folderName}).`);
    }

    Object.keys(data).forEach((key) => {
      if (allowedSkillKeys.has(key)) return;
      if (!key.startsWith('x-')) {
        errors.push(`${entry.path}: key "${key}" must be renamed to x-${key}.`);
      }
    });
  }
}

async function validateAgents(errors) {
  for await (const entry of walk('agents')) {
    if (!entry.path.endsWith('.md')) continue;
    const content = await fs.readFile(entry.path, 'utf8');
    const data = parseFrontmatter(content, entry.path, errors);
    if (!data) continue;

    assertCondition(Boolean(data.name), `${entry.path}: name is required.`, errors);
    assertCondition(Boolean(data.description), `${entry.path}: description is required.`, errors);
  }
}

async function* walk(dir) {
  const entries = await fs.readdir(dir, { withFileTypes: true });
  for (const entry of entries) {
    if (entry.name.startsWith('.')) {
      continue;
    }
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      yield* walk(fullPath);
    } else if (entry.isFile()) {
      yield { path: fullPath };
    }
  }
}

async function main() {
  const errors = [];
  await validatePlugins(errors);
  await validateSkills(errors);
  await validateAgents(errors);

  if (errors.length) {
    console.error('Validation failed:');
    errors.forEach((error) => console.error(`- ${error}`));
    process.exitCode = 1;
    return;
  }

  console.log('Claude plugin validation passed.');
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
