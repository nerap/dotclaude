# Claude Code Configuration

Production-ready Claude Code configs based on [everything-claude-code](https://github.com/affaan-m/everything-claude-code).

## Structure

```
dotclaude/
├── agents/           # Specialized subagents
│   ├── planner.md          # Planning specialist (creates timestamped plans)
│   └── executor.md         # Execution agent (implements plans mechanically)
├── commands/         # Slash commands
│   ├── plan.md             # /plan command (invokes planner agent)
│   └── exec.md             # /exec command (invokes executor agent)
├── rules/            # Always-follow guidelines
│   ├── security.md         # Security requirements
│   ├── coding-style.md     # File organization, immutability
│   ├── testing.md          # TDD, coverage requirements
│   └── git-workflow.md     # Commit format, branching
├── skills/           # Domain knowledge
│   └── nextjs-tailwind-patterns.md
├── scripts/          # Utilities
│   └── plan-template.sh    # Template for auto-generated execution scripts
├── templates/        # Project templates (not stowed)
│   ├── CLAUDE.md.template  # Project context template
│   └── plan-skeleton.md    # Plan format reference
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

### Two-Phase Development

This configuration supports a **plan-then-execute** workflow:

#### Phase 1: Planning

```bash
# User runs /plan command
/plan Add dark mode support

# Planner agent:
# 1. Reads CLAUDE.md for project context
# 2. Researches codebase with Grep, Glob, Read
# 3. Creates TWO files in .claude/plans/active/:
#    - PLAN-20260120-dark-mode.md (detailed plan)
#    - PLAN-20260120-dark-mode.sh (execution script)
# 4. Makes .sh executable

# Files are created automatically, no approval needed
```

#### Phase 2: Execution

```bash
# User runs /exec command with plan name
/exec PLAN-20260120-dark-mode.md

# Executor agent:
# 1. Loads plan from .claude/plans/active/
# 2. Executes each step mechanically
# 3. Commits after each step (quality gates run via hooks)
# 4. Creates PR when all steps complete
# 5. Updates plan status to "completed"

# Alternative: Run the .sh script directly
./.claude/plans/active/PLAN-20260120-dark-mode.sh
```

### Plan File Structure

Plans are stored locally in `.claude/plans/active/` (not committed to git):

```
.claude/plans/active/
├── PLAN-20260120-dark-mode.md    # Detailed plan
├── PLAN-20260120-dark-mode.sh    # Execution script (auto-generated)
├── PLAN-20260119-user-auth.md    # Previous plan
└── PLAN-20260119-user-auth.sh    # Previous script
```

## Philosophy

- **Plan-Driven**: Create detailed execution plans before coding
- **Two-Agent System**: Planner creates plans, executor implements them mechanically
- **Timestamped Plans**: All plans stored with YYYYMMDD timestamps for tracking
- **Modular**: Rules, agents, skills, commands are separate
- **Quality**: Hooks enforce standards automatically before each commit
- **Flexible**: Add project-specific configs via .claude/settings.local.json

## Based On

[The Shorthand Guide to Everything Claude Code](https://x.com/affaanmustafa/status/2012378465664745795) by [@affaanmustafa](https://x.com/affaanmustafa)
