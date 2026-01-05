import fs from 'fs/promises';
import path from 'path';
import matter from 'gray-matter';

export interface ParsedMarkdown {
  frontmatter: Record<string, unknown>;
  body: string;
  description: string;
}

export async function readMarkdown(filePath: string): Promise<ParsedMarkdown> {
  const content = await fs.readFile(filePath, 'utf8');
  const parsed = matter(content);
  const frontmatter = parsed.data ?? {};
  const body = parsed.content.trim();

  let description = '';
  if (typeof frontmatter.description === 'string') {
    description = frontmatter.description.trim();
  }

  if (!description) {
    const firstLine = body.split('\n').find((line) => line.trim().length > 0) ?? '';
    description = firstLine.replace(/^#+\s*/, '').trim();
  }

  return { frontmatter, body, description };
}

export async function getRepoRoot(startDir: string = process.cwd()): Promise<string> {
  let current = path.resolve(startDir);
  const marker = 'commands';
  while (true) {
    const candidate = path.join(current, marker);
    if (candidate === current) break;
    try {
      await fs.access(candidate);
      return current;
    } catch {
      const parent = path.dirname(current);
      if (parent === current) break;
      current = parent;
    }
  }
  return process.cwd();
}
