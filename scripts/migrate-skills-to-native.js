#!/usr/bin/env node
/**
 * Migrate Context Cascade Skills to Claude Code Native Format
 * Version: 2.0.0
 *
 * This script:
 * 1. Converts skills to official Claude Code format (name, description, allowed-tools)
 * 2. Preserves custom metadata in SKILL-meta.yaml
 * 3. Handles deeply nested skill directories
 * 4. Maps skill categories to appropriate allowed-tools
 * 5. Validates output format
 * 6. Generates migration report
 */

const fs = require('fs');
const path = require('path');

const SKILLS_SOURCE = path.join(__dirname, '..', 'skills');
const SKILLS_TARGET = path.join(__dirname, '..', 'skills-native');

// Tool mappings by category - what tools each skill type typically needs
const CATEGORY_TOOLS = {
  delivery: 'Read, Write, Edit, Bash, Task, TodoWrite, Glob, Grep',
  foundry: 'Read, Write, Edit, Task, TodoWrite, Glob, Grep',
  operations: 'Read, Write, Edit, Bash, Task, TodoWrite, Glob, Grep',
  orchestration: 'Read, Task, TodoWrite, Glob, Grep',
  platforms: 'Read, Write, Edit, Bash, Task, TodoWrite, Glob, Grep, WebFetch',
  quality: 'Read, Glob, Grep, Task, TodoWrite',
  research: 'Read, Glob, Grep, WebSearch, WebFetch, Task, TodoWrite',
  security: 'Read, Glob, Grep, Bash, Task, TodoWrite',
  specialists: 'Read, Write, Edit, Bash, Task, TodoWrite, Glob, Grep',
  tooling: 'Read, Write, Edit, Bash, Task, TodoWrite, Glob, Grep'
};

// Special tool overrides for specific skills
const SKILL_TOOL_OVERRIDES = {
  'code-review-assistant': 'Read, Glob, Grep',
  'deep-research-orchestrator': 'Read, Glob, Grep, WebSearch, WebFetch, Task, TodoWrite',
  'clarity-linter': 'Read, Glob, Grep',
  'theater-detection-audit': 'Read, Glob, Grep, Bash',
  'functionality-audit': 'Read, Glob, Grep, Bash, Task',
  'smart-bug-fix': 'Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite',
  'feature-dev-complete': 'Read, Write, Edit, Bash, Task, TodoWrite, Glob, Grep'
};

function parseYamlFrontmatter(content) {
  // Try standard format first (starts with ---)
  let frontmatterMatch = content.match(/^---\r?\n([\s\S]*?)\r?\n---/);

  // If no match, try to find frontmatter after markdown header
  // Pattern: # Title\n\n---\nyaml...\n---
  if (!frontmatterMatch) {
    frontmatterMatch = content.match(/^#[^\n]*[\r\n]+---\r?\n([\s\S]*?)\r?\n---/);
    if (frontmatterMatch) {
      // Extract body after the frontmatter
      const afterFrontmatter = content.slice(content.indexOf(frontmatterMatch[0]) + frontmatterMatch[0].length).trim();
      return {
        metadata: parseYamlContent(frontmatterMatch[1]),
        body: afterFrontmatter
      };
    }
  }

  if (!frontmatterMatch) return { metadata: {}, body: content };

  const yamlContent = frontmatterMatch[1];
  const body = content.slice(frontmatterMatch[0].length).trim();

  return { metadata: parseYamlContent(yamlContent), body };
}

function parseYamlContent(yamlContent) {
  // Simple YAML parser for our use case
  const metadata = {};
  let currentKey = null;
  let currentValue = [];
  let inArray = false;

  // Normalize line endings
  const lines = yamlContent.replace(/\r\n/g, '\n').replace(/\r/g, '\n').split('\n');

  for (const line of lines) {
    const keyMatch = line.match(/^([a-z_-]+):\s*(.*)$/i);

    if (keyMatch && !line.startsWith('  ') && !line.startsWith('\t')) {
      // Save previous key if exists
      if (currentKey) {
        metadata[currentKey] = inArray ? currentValue : currentValue.join(' ').trim();
      }

      currentKey = keyMatch[1];
      const value = keyMatch[2].trim();

      if (value === '' || value === '|' || value === '>') {
        currentValue = [];
        inArray = false;
      } else if (value.startsWith('[')) {
        // Inline array
        metadata[currentKey] = value.slice(1, -1).split(',').map(s => s.trim().replace(/['"]/g, ''));
        currentKey = null;
      } else {
        currentValue = [value.replace(/['"]/g, '')];
        inArray = false;
      }
    } else if (line.match(/^\s*-\s+(.+)$/)) {
      // Array item
      const itemMatch = line.match(/^\s*-\s+(.+)$/);
      if (itemMatch) {
        if (!inArray) {
          currentValue = [];
          inArray = true;
        }
        currentValue.push(itemMatch[1].trim().replace(/['"]/g, ''));
      }
    } else if (line.match(/^\s+\S/)) {
      // Continuation of multiline value
      currentValue.push(line.trim());
    }
  }

  // Save last key
  if (currentKey) {
    metadata[currentKey] = inArray ? currentValue : currentValue.join(' ').trim();
  }

  return metadata;
}

function createOfficialSkillMd(name, description, allowedTools, body) {
  // Truncate description to 1024 chars (official limit)
  let desc = description || `Skill for ${name}`;
  if (desc.length > 1024) {
    desc = desc.substring(0, 1021) + '...';
  }

  // Clean description - single line, no special chars
  desc = desc.replace(/\n/g, ' ').replace(/\s+/g, ' ').trim();

  let frontmatter = `---
name: ${name}
description: ${desc}`;

  if (allowedTools) {
    frontmatter += `\nallowed-tools: ${allowedTools}`;
  }

  frontmatter += '\n---\n\n';

  return frontmatter + body;
}

function createMetadataYaml(metadata, category, sourcePath) {
  const meta = {
    // Preserve original metadata
    ...metadata,
    // Add migration info
    _migration: {
      source_path: sourcePath,
      category: category,
      migrated_at: new Date().toISOString(),
      version: '2.0.0'
    }
  };

  // Convert to YAML string
  let yaml = '# Custom metadata preserved from original skill\n';
  yaml += '# This file is used by Context Cascade hooks for extended functionality\n\n';

  for (const [key, value] of Object.entries(meta)) {
    if (Array.isArray(value)) {
      yaml += `${key}:\n`;
      for (const item of value) {
        yaml += `  - ${item}\n`;
      }
    } else if (typeof value === 'object' && value !== null) {
      yaml += `${key}:\n`;
      for (const [subKey, subValue] of Object.entries(value)) {
        yaml += `  ${subKey}: ${subValue}\n`;
      }
    } else {
      yaml += `${key}: ${value}\n`;
    }
  }

  return yaml;
}

function findAllSkills(dir, category = '', results = []) {
  if (!fs.existsSync(dir)) return results;

  const entries = fs.readdirSync(dir, { withFileTypes: true });

  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);

    if (entry.isDirectory()) {
      // Check if this directory contains SKILL.md
      const skillMdPath = path.join(fullPath, 'SKILL.md');
      if (fs.existsSync(skillMdPath)) {
        results.push({
          path: fullPath,
          name: entry.name,
          category: category || path.basename(dir)
        });
      } else {
        // Recurse into subdirectory
        findAllSkills(fullPath, category || entry.name, results);
      }
    }
  }

  return results;
}

function migrateSkill(skillInfo, targetDir) {
  const { path: sourcePath, name: dirName, category } = skillInfo;
  const skillMdPath = path.join(sourcePath, 'SKILL.md');

  try {
    const content = fs.readFileSync(skillMdPath, 'utf8');
    const { metadata, body } = parseYamlFrontmatter(content);

    // Determine skill name
    const skillName = metadata.name || dirName;

    // Clean skill name (lowercase, hyphens only)
    const cleanName = skillName
      .toLowerCase()
      .replace(/[^a-z0-9-]/g, '-')
      .replace(/-+/g, '-')
      .replace(/^-|-$/g, '')
      .substring(0, 64);

    // Get description
    let description = metadata.description;
    if (!description) {
      // Try to extract from first paragraph
      const firstPara = body.match(/^#.*?\n\n([^#\n].*?)(?:\n\n|$)/s);
      description = firstPara ? firstPara[1].replace(/\n/g, ' ').trim() : `Skill for ${cleanName}`;
    }

    // Determine allowed tools
    const allowedTools = SKILL_TOOL_OVERRIDES[cleanName] || CATEGORY_TOOLS[category] || CATEGORY_TOOLS.delivery;

    // Create target directory
    const skillTargetDir = path.join(targetDir, cleanName);
    if (!fs.existsSync(skillTargetDir)) {
      fs.mkdirSync(skillTargetDir, { recursive: true });
    }

    // Create official SKILL.md
    const officialContent = createOfficialSkillMd(cleanName, description, allowedTools, body);
    fs.writeFileSync(path.join(skillTargetDir, 'SKILL.md'), officialContent);

    // Create SKILL-meta.yaml with preserved custom fields
    const customFields = { ...metadata };
    delete customFields.name;
    delete customFields.description;

    if (Object.keys(customFields).length > 0 || category) {
      const metaContent = createMetadataYaml(customFields, category, sourcePath);
      fs.writeFileSync(path.join(skillTargetDir, 'SKILL-meta.yaml'), metaContent);
    }

    // Copy other files (case-insensitive check for SKILL.md on Windows)
    const files = fs.readdirSync(sourcePath);
    for (const file of files) {
      if (file.toLowerCase() !== 'skill.md') {
        const srcFile = path.join(sourcePath, file);
        const destFile = path.join(skillTargetDir, file);
        const stat = fs.statSync(srcFile);

        if (stat.isDirectory()) {
          copyDirRecursive(srcFile, destFile);
        } else {
          fs.copyFileSync(srcFile, destFile);
        }
      }
    }

    return {
      success: true,
      originalName: skillName,
      name: cleanName,
      category,
      description: description.substring(0, 80) + '...',
      allowedTools
    };

  } catch (error) {
    return {
      success: false,
      originalName: dirName,
      category,
      error: error.message
    };
  }
}

function copyDirRecursive(src, dest) {
  if (!fs.existsSync(dest)) {
    fs.mkdirSync(dest, { recursive: true });
  }
  const entries = fs.readdirSync(src, { withFileTypes: true });
  for (const entry of entries) {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);
    if (entry.isDirectory()) {
      copyDirRecursive(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}

function validateSkill(skillDir) {
  const skillMdPath = path.join(skillDir, 'SKILL.md');
  if (!fs.existsSync(skillMdPath)) {
    return { valid: false, error: 'Missing SKILL.md' };
  }

  const content = fs.readFileSync(skillMdPath, 'utf8');

  // Check frontmatter
  if (!content.startsWith('---\n')) {
    return { valid: false, error: 'Missing YAML frontmatter' };
  }

  // Check required fields
  if (!content.includes('name:')) {
    return { valid: false, error: 'Missing name field' };
  }
  if (!content.includes('description:')) {
    return { valid: false, error: 'Missing description field' };
  }

  // Check name format
  const nameMatch = content.match(/^name:\s*(.+)$/m);
  if (nameMatch) {
    const name = nameMatch[1].trim();
    if (!/^[a-z0-9-]+$/.test(name)) {
      return { valid: false, error: `Invalid name format: ${name}` };
    }
    if (name.length > 64) {
      return { valid: false, error: `Name too long: ${name.length} chars (max 64)` };
    }
  }

  // Check description length
  const descMatch = content.match(/^description:\s*(.+)$/m);
  if (descMatch && descMatch[1].length > 1024) {
    return { valid: false, error: `Description too long: ${descMatch[1].length} chars (max 1024)` };
  }

  return { valid: true };
}

function main() {
  console.log('========================================');
  console.log('Context Cascade Skill Migration v2.0.0');
  console.log('========================================\n');

  // Create target directory
  if (!fs.existsSync(SKILLS_TARGET)) {
    fs.mkdirSync(SKILLS_TARGET, { recursive: true });
  }

  // Find all skills recursively
  console.log('Scanning for skills...\n');
  const skills = findAllSkills(SKILLS_SOURCE);
  console.log(`Found ${skills.length} skills to migrate\n`);

  const results = {
    migrated: [],
    failed: [],
    validated: [],
    invalid: []
  };

  // Migrate each skill
  for (const skillInfo of skills) {
    const result = migrateSkill(skillInfo, SKILLS_TARGET);

    if (result.success) {
      console.log(`[OK] ${result.category}/${result.originalName} -> ${result.name}`);
      results.migrated.push(result);

      // Validate the migrated skill
      const validation = validateSkill(path.join(SKILLS_TARGET, result.name));
      if (validation.valid) {
        results.validated.push(result.name);
      } else {
        console.log(`  [WARN] Validation: ${validation.error}`);
        results.invalid.push({ name: result.name, error: validation.error });
      }
    } else {
      console.log(`[FAIL] ${result.category}/${result.originalName}: ${result.error}`);
      results.failed.push(result);
    }
  }

  // Generate summary
  console.log('\n========================================');
  console.log('Migration Summary');
  console.log('========================================');
  console.log(`Total skills found:    ${skills.length}`);
  console.log(`Successfully migrated: ${results.migrated.length}`);
  console.log(`Failed:                ${results.failed.length}`);
  console.log(`Validated:             ${results.validated.length}`);
  console.log(`Invalid:               ${results.invalid.length}`);
  console.log(`Output directory:      ${SKILLS_TARGET}`);

  // Write detailed report
  const report = {
    timestamp: new Date().toISOString(),
    source: SKILLS_SOURCE,
    target: SKILLS_TARGET,
    summary: {
      total: skills.length,
      migrated: results.migrated.length,
      failed: results.failed.length,
      validated: results.validated.length,
      invalid: results.invalid.length
    },
    migrated: results.migrated,
    failed: results.failed,
    invalid: results.invalid
  };

  fs.writeFileSync(
    path.join(SKILLS_TARGET, 'migration-report.json'),
    JSON.stringify(report, null, 2)
  );

  console.log(`\nDetailed report: ${path.join(SKILLS_TARGET, 'migration-report.json')}`);

  // Create index file
  const indexContent = `# Skills Native Index

Generated: ${new Date().toISOString()}

## Migrated Skills (${results.migrated.length})

| Name | Category | Description |
|------|----------|-------------|
${results.migrated.map(s => `| ${s.name} | ${s.category} | ${s.description.substring(0, 50)}... |`).join('\n')}

## Failed Migrations (${results.failed.length})

${results.failed.map(f => `- **${f.category}/${f.originalName}**: ${f.error}`).join('\n')}

## Validation Issues (${results.invalid.length})

${results.invalid.map(i => `- **${i.name}**: ${i.error}`).join('\n')}
`;

  fs.writeFileSync(path.join(SKILLS_TARGET, 'INDEX.md'), indexContent);

  return results;
}

// Run if called directly
if (require.main === module) {
  main();
}

module.exports = { main, migrateSkill, parseYamlFrontmatter, validateSkill };
