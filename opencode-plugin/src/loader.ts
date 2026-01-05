import path from 'path';
import fg from 'fast-glob';
import { readMarkdown } from './markdown.js';

export interface CommandDefinition {
  name: string;
  alias?: string;
  description: string;
  filePath: string;
  body: string;
  frontmatter: Record<string, unknown>;
}

export interface SkillRecord {
  name: string;
  description: string;
  filePath: string;
  body: string;
  keywords: string[];
}

export interface LoadOptions {
  repoRoot: string;
}

export async function loadCommands(options: LoadOptions): Promise<CommandDefinition[]> {
  const commandRoot = path.join(options.repoRoot, 'commands');
  const files = await fg('**/*.md', { cwd: commandRoot, dot: false });
  const commands: CommandDefinition[] = [];

  for (const relative of files) {
    const filePath = path.join(commandRoot, relative);
    const { body, description, frontmatter } = await readMarkdown(filePath);
    const segments = relative.replace(/\.md$/, '').split(path.sep);
    const filename = segments.pop() ?? '';
    const commandName = buildCommandName(segments, filename);
    const alias = buildCommandAlias(segments, filename);
    commands.push({
      name: commandName,
      alias,
      description,
      filePath,
      body,
      frontmatter,
    });
  }

  return commands;
}

export async function loadSkills(options: LoadOptions): Promise<SkillRecord[]> {
  const skillsRoot = path.join(options.repoRoot, 'skills');
  const files = await fg('**/SKILL.md', { cwd: skillsRoot, dot: false });
  const skills: SkillRecord[] = [];

  for (const relative of files) {
    const filePath = path.join(skillsRoot, relative);
    const { body, description, frontmatter } = await readMarkdown(filePath);
    const name = typeof frontmatter.name === 'string' ? frontmatter.name : path.basename(path.dirname(filePath));
    const keywords = buildKeywords(name, description, body);
    skills.push({
      name,
      description,
      filePath,
      body,
      keywords,
    });
  }

  return skills;
}

function buildCommandName(segments: string[], filename: string): string {
  const parts = [...segments, filename].filter(Boolean);
  return `/${parts.join(':')}`;
}

function buildCommandAlias(segments: string[], filename: string): string | undefined {
  if (!segments.length) return undefined;
  const last = segments[segments.length - 1];
  if (last === filename) {
    const aliasParts = [...segments.slice(0, -1), filename];
    return `/${aliasParts.join(':')}`;
  }
  return undefined;
}

function buildKeywords(name: string, description: string, body: string): string[] {
  const tokens = (text: string) =>
    text
      .toLowerCase()
      .split(/[^a-z0-9]+/i)
      .filter(Boolean);
  return Array.from(new Set([...tokens(name), ...tokens(description), ...tokens(body.slice(0, 400))]));
}
