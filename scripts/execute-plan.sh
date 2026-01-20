#!/bin/bash
# Execute a plan in a different worktree with full git automation
# Usage: execute-plan.sh <branch-name> <base-branch> [plan-file]
#
# Example:
#   cd ~/work/agency.git/2
#   execute-plan.sh feat/screenshots main ~/work/agency.git/1/.plan.md

set -e

BRANCH="${1:?Branch name required}"
BASE="${2:-main}"
PLAN_FILE="${3:-.plan.md}"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Execute Plan with Git Automation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Branch:    $BRANCH"
echo "Base:      $BASE"
echo "Plan:      $PLAN_FILE"
echo "Worktree:  $(pwd)"
echo ""

# Check if plan file exists
if [ ! -f "$PLAN_FILE" ]; then
  echo "❌ Plan file not found: $PLAN_FILE"
  exit 1
fi

# Git setup
echo "📦 Setting up git branch..."
git fetch origin "$BASE:refs/remotes/origin/$BASE"

if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  echo "   Branch exists, checking out and rebasing..."
  git checkout "$BRANCH"
  git rebase "origin/$BASE"
else
  echo "   Creating new branch from origin/$BASE..."
  git checkout -b "$BRANCH" "origin/$BASE"
fi

echo "✓ Branch ready: $BRANCH"
echo ""

# Read plan
echo "📋 Plan Summary:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
head -20 "$PLAN_FILE"
echo "..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Confirmation
read -p "Continue with execution? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

echo ""
echo "🚀 Ready to execute!"
echo ""
echo "Next steps:"
echo ""
echo "  1. Run Claude Code:"
echo "     claude --dangerously-skip-permissions"
echo ""
echo "  2. Tell Claude:"
echo "     Read the plan from $PLAN_FILE and implement it."
echo "     Commit each step with conventional commits."
echo "     Create a PR when done."
echo ""
echo "  3. Or copy/paste this:"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cat << 'PROMPT'
Read the plan from .plan.md and implement it step by step.

For each major change:
1. Implement the changes
2. Commit with conventional commit format
3. Continue to next step

After all steps complete:
1. Push the branch
2. Create PR with gh:
   gh pr create --title "feat: [summarize feature]" --body "Implementation summary"

Start now.
PROMPT
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
