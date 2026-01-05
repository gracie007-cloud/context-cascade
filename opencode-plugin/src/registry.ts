export interface HostContext {
  user?: string;
  metadata?: Record<string, unknown>;
}

export interface OpenCodeHost {
  registerCommand(cmd: {
    name: string;
    description: string;
    run: (args: string, ctx: HostContext) => Promise<string>;
  }): void;
  onUserMessage?(handler: (message: string, ctx: HostContext) => Promise<void>): void;
  addSystemContext?(text: string): void;
}

export interface PluginOptions {
  repoRoot?: string;
  commandPrefix?: string;
  enableSkillInjection?: boolean;
  skillMatchCount?: number;
  skillMatchThreshold?: number;
}
