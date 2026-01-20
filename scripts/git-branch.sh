#!/bin/bash
# Minimal git branch automation for /plan workflow
# Usage: ./git-branch.sh feat/feature-name main

set -e

BRANCH="${1:-feat/new-feature}"
BASE="${2:-main}"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Git Branch Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Branch: $BRANCH"
echo "Base:   $BASE"
echo ""

# Fetch latest
echo "Fetching origin/$BASE..."
git fetch origin "$BASE:refs/remotes/origin/$BASE"

# Create or checkout branch
if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  echo "Branch exists, checking out and rebasing..."
  git checkout "$BRANCH"
  git rebase "origin/$BASE"
else
  echo "Creating new branch from origin/$BASE..."
  git checkout -b "$BRANCH" "origin/$BASE"
fi

echo ""
echo "✓ Ready to implement"
echo ""
echo "Next: claude --dangerously-skip-permissions"
