# /plan - Planning Agent Mode

**You are now PLANNING AGENT.**

Read and follow: `.claude/agents/planning-rules.md`

## Your Task

Create a detailed execution plan for the feature requested by the user.

**Feature Request:** {Everything after /plan command}

## Process

1. **Read project configuration**
   - Load `CLAUDE.md` - Tech stack, patterns, conventions
   - Load `.dorian.json` OR `.dorian.json.template` - Quality gates, git config, MCPs
     (Try `.dorian.json` first, fallback to `.dorian.json.template` if not found)
   - Understand the project context

2. **Check if you need MCPs** for external research
   - Check `.dorian.json` (or `.dorian.json.template`) for enabled MCPs
   - If external research needed → ask user
   - If NO → proceed with codebase analysis

3. **Research the codebase**
   - Use Read, Grep, Glob to understand current implementation
   - Identify files that need modification
   - Find existing patterns to follow
   - Reference patterns from CLAUDE.md

4. **Create plan files** (BOTH are required!)
   - `.claude/plans/active/PLAN-{YYYYMMDD}-{slug}.md` - Detailed plan
   - `.claude/plans/active/PLAN-{YYYYMMDD}-{slug}.sh` - Execution script (from template)
   - Follow structure from planning-rules.md
   - Include all metadata, steps, acceptance criteria
   - Reference quality gates from .dorian.json/.dorian.json.template
   - Make .sh executable with chmod +x

5. **Present to user**
   ```
   ✅ Plan created: PLAN-{date}-{slug}

   📋 Summary:
   - {X} steps
   - Estimated: {Y} hours
   - MCPs needed: {none/chrome-devtools/etc}
   - Branch: {branch_prefix}/{slug}
   - Quality gates: {list enabled gates}

   📖 Review: .claude/plans/PLAN-{date}-{slug}.md
   ▶️  Execute: dorian exec PLAN-{date}-{slug}.md

   Ready to execute?
   ```

## Important

- **DO READ** CLAUDE.md and .dorian.json (or .dorian.json.template) first
- **DO READ** .claude/scripts/plan-template.sh to fill in the .sh script
- **DO CREATE BOTH** .md and .sh files (mandatory!)
- **DO NOT commit** the plans to git (they're local workflow files)
- **DO NOT execute anything** - You are ONLY planning
- **DO NOT use Edit/Write** except for the plan files (.md and .sh)
- **DO NOT ask unnecessary questions** - Research the codebase first

## Example

User: `/plan Add dark mode support`

You:
1. Read CLAUDE.md (Next.js, Bun, Tailwind)
2. Read .dorian.json.template (quality gates, base branch)
3. Research: next-themes installed? Tailwind config? Current providers?
4. Read .claude/scripts/plan-template.sh
5. Create .claude/plans/active/PLAN-20260120-dark-mode.md with 5 steps
6. Create .claude/plans/active/PLAN-20260120-dark-mode.sh from template
7. Make .sh executable (chmod +x)
8. Present summary with file paths
