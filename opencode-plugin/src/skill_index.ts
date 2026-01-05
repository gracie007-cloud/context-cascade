import { SkillRecord } from './loader.js';

export interface SkillIndexOptions {
  matchCount?: number;
  threshold?: number;
}

export interface SkillMatch {
  skill: SkillRecord;
  score: number;
}

export class SkillIndex {
  private readonly skills: SkillRecord[];

  private readonly matchCount: number;

  private readonly threshold: number;

  constructor(skills: SkillRecord[], options: SkillIndexOptions = {}) {
    this.skills = skills;
    this.matchCount = options.matchCount ?? 2;
    this.threshold = options.threshold ?? 6;
  }

  match(query: string): SkillMatch[] {
    const tokens = tokenize(query);
    const scores: SkillMatch[] = [];

    for (const skill of this.skills) {
      const skillTokens = new Set(skill.keywords);
      let score = 0;
      for (const token of tokens) {
        if (skillTokens.has(token)) {
          score += 2;
        }
        if (token === skill.name.toLowerCase()) {
          score += 3;
        }
      }
      if (score >= this.threshold) {
        scores.push({ skill, score });
      }
    }

    return scores.sort((a, b) => b.score - a.score).slice(0, this.matchCount);
  }
}

function tokenize(text: string): string[] {
  return text
    .toLowerCase()
    .split(/[^a-z0-9]+/i)
    .filter(Boolean);
}
