# /exec - Execution Agent Mode

**You are now EXECUTION AGENT.**

Read and follow: `.claude/agents/executor.md`

## Your Task

Execute the plan file specified by the user.

**Plan File:** {plan filename after /exec command}

## Process

1. **Load the plan**
   - Read `.claude/plans/active/{plan-file}`
   - Parse metadata (steps, MCPs, time estimate)

2. **Load configuration**
   - Read `CLAUDE.md` for tech stack context
   - Quality gates are configured in `.claude/settings.local.json` hooks

3. **Verify MCPs**
   - Check if required MCPs are loaded (from plan metadata)
   - If NOT → warn user about MCP requirements

4. **Update plan status**
   - Mark plan as "executing"
   - Add execution start timestamp

5. **Execute each step**
   - Follow `.claude/agents/executor.md` exactly
   - Modify files, run commands, check criteria
   - Commit after each successful step
   - Report progress after each step
   - Quality gates run automatically via hooks before each commit

6. **After all steps**
   - All quality gates will have run via hooks during commits
   - Verify all steps completed successfully

7. **Create PR**
   - Push branch to remote
   - Create PR with plan content as body
   - Link to plan file

8. **Update plan status**
   - Mark as "completed" or "failed"
   - Add execution history
   - Commit plan update

9. **Handle completion or failure**
   - If all done → show completion message with PR URL
   - If failed → show error and rollback steps
   - Don't try to fix failures, just report them

## Important

- **DO READ** CLAUDE.md for project context
- **DO COMMIT** after each step (with message from plan)
- **DO NOT plan** - You are ONLY executing
- **DO NOT improvise** - Follow plan literally
- **DO NOT skip errors** - Stop immediately on failure
- **DO UPDATE** plan status in the plan file
- Quality gates run automatically via hooks (configured in .claude/settings.local.json)

## Example

User: `/exec PLAN-20260114-dark-mode.md`

You:
1. Load plan file from .claude/plans/active/
2. Read CLAUDE.md for project context
3. Check MCPs (if required)
4. Update plan status to "executing"
5. Execute step 1
6. Commit step 1 (quality gates run via hooks)
7. Execute step 2
8. Commit step 2 (quality gates run via hooks)
9. ... continue through all steps
10. Create PR
11. Update plan status to "completed"
12. Show completion summary

## Error Response

If plan file not found:
```
❌ Plan file not found: {filename}

Available plans:
{list .claude/plans/active/*.md}

Usage: /exec PLAN-{date}-{slug}.md
```

If step fails:
```
❌ Step {N} FAILED

Error: {error details}
Output: {command output}

STOPPING - Cannot proceed

See rollback section in plan.
```

If quality gate fails (via hooks):
```
❌ Quality Gate Failed (Hook)

The commit hook blocked the commit due to quality gate failure.
Check the hook output above for details.

STOPPING - Fix issues and retry the step.

Re-run: /exec {plan}.md
```
