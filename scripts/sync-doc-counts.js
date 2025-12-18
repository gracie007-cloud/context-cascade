#!/usr/bin/env node
/**
 * Documentation Count Synchronization Script v1.0
 *
 * PURPOSE: Automatically count components and update all markdown files
 * TRIGGERS: Pre-commit hook, manual run, CI/CD pipeline
 *
 * WHAT IT DOES:
 * 1. Counts actual components by scanning folders
 * 2. Finds all markdown files with hardcoded counts
 * 3. Updates them with current counts
 * 4. Generates a counts.json manifest
 */

const fs = require('fs');
const path = require('path');

const PLUGIN_ROOT = path.resolve(__dirname, '..');

// Component counting configuration
const COMPONENT_CONFIG = {
  skills: {
    path: 'skills',
    pattern: '**/SKILL.md',
    countMethod: 'directories_with_file',
    exclude: ['_pipeline-automation', 'archive', 'backup']
  },
  agents: {
    path: 'agents',
    pattern: '**/*.md',
    countMethod: 'files',
    exclude: ['README.md', 'AGENTS-INDEX.md', 'archive', 'backup']
  },
  commands: {
    path: 'commands',
    pattern: '**/*.md',
    countMethod: 'files',
    exclude: ['README.md', 'INDEX.md', 'archive']
  },
  playbooks: {
    // Playbooks are documented inline in ENHANCED-PLAYBOOK-SYSTEM.md, not as separate files
    // We extract the count from the header: "**Total Playbooks**: 30"
    path: 'playbooks/docs/ENHANCED-PLAYBOOK-SYSTEM.md',
    countMethod: 'header_extract',
    headerPattern: /\*\*Total Playbooks\*\*:\s*(\d+)/
  }
};

// Files to update with counts
const FILES_TO_UPDATE = [
  'README.md',
  'CLAUDE.md',
  'skills/README.md',
  'agents/README.md',
  'commands/README.md',
  'CONTRIBUTING.md'
];

/**
 * Recursively find files matching pattern
 */
function findFiles(dir, pattern, exclude = []) {
  const results = [];

  if (!fs.existsSync(dir)) return results;

  const items = fs.readdirSync(dir, { withFileTypes: true });

  for (const item of items) {
    const fullPath = path.join(dir, item.name);
    const relativePath = path.relative(PLUGIN_ROOT, fullPath);

    // Skip excluded paths
    if (exclude.some(ex => relativePath.includes(ex) || item.name === ex)) {
      continue;
    }

    if (item.isDirectory()) {
      results.push(...findFiles(fullPath, pattern, exclude));
    } else if (item.isFile()) {
      // Simple pattern matching
      if (pattern === '**/*.md' && item.name.endsWith('.md')) {
        results.push(fullPath);
      } else if (pattern === '**/SKILL.md' && item.name === 'SKILL.md') {
        results.push(fullPath);
      }
    }
  }

  return results;
}

/**
 * Count directories containing a specific file
 */
function countDirectoriesWithFile(baseDir, filename, exclude = []) {
  const dirs = new Set();
  const files = findFiles(baseDir, `**/${filename}`, exclude);

  for (const file of files) {
    dirs.add(path.dirname(file));
  }

  return dirs.size;
}

/**
 * Count components based on configuration
 */
function countComponents() {
  const counts = {};

  for (const [name, config] of Object.entries(COMPONENT_CONFIG)) {
    const fullPath = path.join(PLUGIN_ROOT, config.path);

    if (config.countMethod === 'directories_with_file') {
      const filename = config.pattern.replace('**/', '');
      counts[name] = countDirectoriesWithFile(fullPath, filename, config.exclude);
    } else if (config.countMethod === 'files') {
      const files = findFiles(fullPath, config.pattern, config.exclude);
      counts[name] = files.length;
    } else if (config.countMethod === 'header_extract') {
      // Extract count from a header in a documentation file
      try {
        const content = fs.readFileSync(fullPath, 'utf8');
        const match = content.match(config.headerPattern);
        counts[name] = match ? parseInt(match[1], 10) : 0;
      } catch (e) {
        counts[name] = 0;
      }
    }
  }

  counts.timestamp = new Date().toISOString();
  counts.total = counts.skills + counts.agents + counts.commands + counts.playbooks;

  return counts;
}

/**
 * Update a single file with current counts
 */
function updateFile(filePath, counts) {
  const fullPath = path.join(PLUGIN_ROOT, filePath);

  if (!fs.existsSync(fullPath)) {
    console.log(`  SKIP: ${filePath} (not found)`);
    return { updated: false, reason: 'not_found' };
  }

  let content = fs.readFileSync(fullPath, 'utf8');
  const original = content;

  // Replacement patterns for each component type
  const patterns = [
    // Skills patterns
    { regex: /\b(1[78]\d|19\d|20\d)\s*skills?\b/gi, replacement: `${counts.skills} skills` },
    { regex: /SKILLS\s*\(\d+\)/g, replacement: `SKILLS (${counts.skills})` },
    { regex: /\*\*Status:\*\*\s*\d+\s*skills/gi, replacement: `**Status:** ${counts.skills} skills` },

    // Agents patterns
    { regex: /\b(1\d{2}|20[0-9]|21[0-9]|22[0-9])\s*agents?\b/gi, replacement: `${counts.agents} agents` },
    { regex: /AGENTS\s*\(\d+\)/g, replacement: `AGENTS (${counts.agents})` },
    { regex: /\*\*Status:\*\*\s*\d+\s*agents/gi, replacement: `**Status:** ${counts.agents} agents` },

    // Commands patterns
    { regex: /\b(1\d{2}|20[0-9]|21[0-9]|22[0-9]|23[0-9])\s*commands?\b/gi, replacement: `${counts.commands} commands` },
    { regex: /COMMANDS\s*\(\d+\+?\)/g, replacement: `COMMANDS (${counts.commands})` },
    { regex: /\*\*Total Commands\*\*:\s*\d+/gi, replacement: `**Total Commands**: ${counts.commands}` },

    // Playbooks patterns - more conservative to avoid false positives
    // Only update specific known patterns, not every number-playbook combo
    { regex: /PLAYBOOKS\s*\(\d+\)/g, replacement: `PLAYBOOKS (${counts.playbooks})` },
    { regex: /\*\*Total Playbooks\*\*:\s*\d+/gi, replacement: `**Total Playbooks**: ${counts.playbooks}` },
    { regex: /\b(2[0-9]|3[0-9])\s*playbooks\b/gi, replacement: `${counts.playbooks} playbooks` }
  ];

  for (const { regex, replacement } of patterns) {
    content = content.replace(regex, replacement);
  }

  if (content !== original) {
    fs.writeFileSync(fullPath, content, 'utf8');
    console.log(`  UPDATED: ${filePath}`);
    return { updated: true };
  } else {
    console.log(`  NO CHANGE: ${filePath}`);
    return { updated: false, reason: 'no_changes' };
  }
}

/**
 * Find all markdown files that might contain hardcoded counts
 */
function findAllMarkdownFiles() {
  const mdFiles = [];
  const searchDirs = ['docs', 'skills', 'agents', 'commands', 'playbooks', 'hooks'];

  for (const dir of searchDirs) {
    const fullDir = path.join(PLUGIN_ROOT, dir);
    if (fs.existsSync(fullDir)) {
      mdFiles.push(...findFiles(fullDir, '**/*.md', ['archive', 'backup', '.backup']));
    }
  }

  // Add root-level markdown files
  const rootFiles = fs.readdirSync(PLUGIN_ROOT)
    .filter(f => f.endsWith('.md'))
    .map(f => path.join(PLUGIN_ROOT, f));

  mdFiles.push(...rootFiles);

  return mdFiles;
}

/**
 * Scan for files with outdated counts
 */
function auditCounts(counts) {
  console.log('\n=== AUDIT: Finding files with hardcoded counts ===\n');

  const mdFiles = findAllMarkdownFiles();
  const filesWithCounts = [];

  // Patterns to detect hardcoded counts
  const detectPatterns = [
    { type: 'skills', regex: /\b(1[78]\d|19\d)\s*skills?\b/gi },
    { type: 'agents', regex: /\b(1\d{2}|20[0-9]|21[0-9])\s*agents?\b/gi },
    { type: 'commands', regex: /\b(1\d{2}|20[0-9]|21[0-9]|22[0-9])\s*commands?\b/gi }
  ];

  for (const file of mdFiles) {
    const content = fs.readFileSync(file, 'utf8');
    const relativePath = path.relative(PLUGIN_ROOT, file);
    const matches = [];

    for (const { type, regex } of detectPatterns) {
      const found = content.match(regex);
      if (found) {
        matches.push({ type, count: found.length, examples: found.slice(0, 3) });
      }
    }

    if (matches.length > 0) {
      filesWithCounts.push({ file: relativePath, matches });
    }
  }

  console.log(`Found ${filesWithCounts.length} files with hardcoded counts:\n`);

  for (const { file, matches } of filesWithCounts.slice(0, 20)) {
    console.log(`  ${file}:`);
    for (const { type, count, examples } of matches) {
      console.log(`    - ${type}: ${count} occurrences (e.g., ${examples.join(', ')})`);
    }
  }

  if (filesWithCounts.length > 20) {
    console.log(`  ... and ${filesWithCounts.length - 20} more files`);
  }

  return filesWithCounts;
}

/**
 * Main execution
 */
function main() {
  const args = process.argv.slice(2);
  const mode = args[0] || 'update';

  console.log('=== Documentation Count Sync ===\n');
  console.log(`Plugin Root: ${PLUGIN_ROOT}\n`);

  // Count components
  console.log('Counting components...\n');
  const counts = countComponents();

  console.log('Current Counts:');
  console.log(`  Skills:    ${counts.skills}`);
  console.log(`  Agents:    ${counts.agents}`);
  console.log(`  Commands:  ${counts.commands}`);
  console.log(`  Playbooks: ${counts.playbooks}`);
  console.log(`  TOTAL:     ${counts.total}`);
  console.log(`  Timestamp: ${counts.timestamp}\n`);

  // Save counts manifest
  const manifestPath = path.join(PLUGIN_ROOT, 'docs', 'COMPONENT-COUNTS.json');
  fs.mkdirSync(path.dirname(manifestPath), { recursive: true });
  fs.writeFileSync(manifestPath, JSON.stringify(counts, null, 2));
  console.log(`Saved manifest: docs/COMPONENT-COUNTS.json\n`);

  if (mode === 'audit') {
    // Audit mode - just find files with counts
    auditCounts(counts);
  } else if (mode === 'update') {
    // Update mode - update primary files
    console.log('Updating primary documentation files...\n');

    const results = { updated: 0, skipped: 0 };

    for (const file of FILES_TO_UPDATE) {
      const result = updateFile(file, counts);
      if (result.updated) results.updated++;
      else results.skipped++;
    }

    console.log(`\nSummary: ${results.updated} files updated, ${results.skipped} skipped`);
  } else if (mode === 'update-all') {
    // Update ALL markdown files with counts
    console.log('Updating ALL markdown files with counts...\n');

    const filesWithCounts = auditCounts(counts);
    let updated = 0;

    for (const { file } of filesWithCounts) {
      const result = updateFile(file, counts);
      if (result.updated) updated++;
    }

    console.log(`\nUpdated ${updated} files`);
  }

  console.log('\n=== Done ===');
}

// Export for use as module
module.exports = { countComponents, updateFile, auditCounts };

// Run if executed directly
if (require.main === module) {
  main();
}
