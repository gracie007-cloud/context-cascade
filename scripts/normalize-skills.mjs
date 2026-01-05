import fs from 'fs/promises';
import path from 'path';
import { parseDocument, stringify } from 'yaml';

const allowedKeys = new Set(['name', 'description', 'allowed-tools', 'model']);
const verixPattern = /\[[^\]]*(?:conf:|ground:|state:|assert|neutral|direct|emphatic)[^\]]*\]/gi;

function stripVerix(text) {
  if (typeof text !== 'string') {
    return '';
  }
  return text.replace(verixPattern, '').replace(/\s+/g, ' ').trim();
}

function readFrontmatter(content) {
  const match = content.match(/^---\n([\s\S]*?)\n---\n?([\s\S]*)$/);
  if (!match) return null;
  return { frontmatter: match[1], body: match[2] || '' };
}

function buildFrontmatter(data, folderName) {
  const normalizedName = folderName;
  const sanitizedDescription = stripVerix(data.description) || `Skill guidance for ${folderName.replace(/-/g, ' ')}.`;

  const base = {
    name: normalizedName,
    description: sanitizedDescription
  };

  if (data['allowed-tools'] !== undefined) {
    base['allowed-tools'] = data['allowed-tools'];
  }
  if (data.model !== undefined) {
    base.model = data.model;
  }

  for (const [key, value] of Object.entries(data)) {
    if (allowedKeys.has(key)) continue;
    const targetKey = key.startsWith('x-') ? key : `x-${key}`;
    base[targetKey] = value;
  }

  return stringify(base, { lineWidth: 0, version: '1.2' });
}

async function processSkill(filePath) {
  const content = await fs.readFile(filePath, 'utf8');
  const parsed = readFrontmatter(content);
  if (!parsed) {
    console.warn(`Skipping (no frontmatter): ${filePath}`);
    return false;
  }

  let data = {};
  try {
    const doc = parseDocument(parsed.frontmatter, { version: '1.2' });
    data = doc.toJS({ json: true }) || {};
  } catch (error) {
    console.error(`Failed to parse frontmatter in ${filePath}: ${error.message}`);
    return false;
  }
  const folderName = path.basename(path.dirname(filePath));
  const newFrontmatter = buildFrontmatter(data, folderName);
  const nextContent = `---\n${newFrontmatter}---\n\n${parsed.body}`;
  if (nextContent === content) {
    return false;
  }
  await fs.writeFile(filePath, nextContent, 'utf8');
  return true;
}

async function main() {
  const skillFiles = [];
  for await (const entry of walk('skills')) {
    if (entry.path.endsWith('SKILL.md')) {
      skillFiles.push(entry.path);
    }
  }

  let updated = 0;
  for (const file of skillFiles) {
    const changed = await processSkill(file);
    if (changed) {
      updated += 1;
      console.log(`Updated ${file}`);
    }
  }
  console.log(`Processed ${skillFiles.length} skills; updated ${updated}.`);
}

async function* walk(dir) {
  const entries = await fs.readdir(dir, { withFileTypes: true });
  for (const entry of entries) {
    if (entry.name.startsWith('.')) {
      continue;
    }
    const res = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      yield* walk(res);
    } else if (entry.isFile()) {
      yield { path: res };
    }
  }
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
