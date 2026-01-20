# Claude Code Configuration

Production-ready Claude Code configs based on [everything-claude-code](https://github.com/affaan-m/everything-claude-code).

## Structure

```
dotclaude/
├── agents/           # Specialized subagents
│   └── planner.md          # Planning specialist
├── commands/         # Slash commands
│   └── plan.md             # /plan command
├── rules/            # Always-follow guidelines
│   ├── security.md         # Security requirements
│   ├── coding-style.md     # File organization, immutability
│   ├── testing.md          # TDD, coverage requirements
│   └── git-workflow.md     # Commit format, branching
├── skills/           # Domain knowledge
│   └── nextjs-tailwind-patterns.md
├── scripts/          # Utilities
│   └── git-branch.sh       # Optional git automation
└── hooks/            # Event-based automation
    └── hooks.json          # Copy to ~/.claude/settings.json
```

## Installation

Automatically installed via dotfiles `install.sh`:

```bash
# Clones this repo to ~/config/dotclaude
# Stows to ~/.claude
stow --dir="$HOME/config" --target="$HOME/.claude" -S dotclaude
```

## Hooks Setup

Hooks are **not stowed**. Copy them manually to your settings:

```bash
# Copy hooks to settings.json
cat ~/config/dotclaude/hooks/hooks.json
# Then merge into ~/.claude/settings.json
```

## Project-Specific Quality Gates

For project-specific quality gates, add hooks to your project's `.claude/settings.local.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "tool == \"Bash\" && tool_input.command contains \"git commit\"",
        "hooks": [{
          "type": "command",
          "command": "#!/bin/bash\ncd apps/web && bun test && tsc --noEmit && bun run check"
        }],
        "description": "Run quality gates before commit"
      }
    ]
  }
}
```

## Workflow

### Planning

```bash
# User runs /plan command
/plan Add dark mode support

# Planner agent creates inline plan
# - Restate requirements
# - Break into phases
# - Identify risks
# - Wait for approval

# User approves
yes

# Implementation happens in same session
```

### Optional Git Automation

```bash
# After /plan approval, optionally run:
~/.claude/scripts/git-branch.sh feat/dark-mode main

# Then continue implementation with:
claude --dangerously-skip-permissions
```

## Philosophy

- **Simple**: Inline plans, no file storage
- **Modular**: Rules, agents, skills are separate
- **Quality**: Hooks enforce standards automatically
- **Flexible**: Add project-specific configs as needed

## Based On

[The Shorthand Guide to Everything Claude Code](https://x.com/affaanmustafa/status/2012378465664745795) by [@affaanmustafa](https://x.com/affaanmustafa)
