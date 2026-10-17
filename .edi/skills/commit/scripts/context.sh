#!/bin/bash
# Gather git context for the commit skill

echo "## Branch"
git branch --show-current

echo ""
echo "## Status"
git status --short

echo ""
echo "## Staged diff"
staged=$(git diff --cached)
if [ -n "$staged" ]; then
    echo "$staged"
else
    echo "(nothing staged)"
fi

echo ""
echo "## Unstaged diff"
unstaged=$(git diff)
if [ -n "$unstaged" ]; then
    echo "$unstaged"
else
    echo "(nothing unstaged)"
fi

echo ""
echo "## Recent commits"
git log --oneline -10
