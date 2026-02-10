#!/bin/bash

# git wt {branch-name} - create or switch to a worktree
# Worktrees are created at $HOME/src/.worktree/{PROJECT_PATH}/{branch-name}

set -e

if [ -z "$1" ]; then
    echo "Usage: git wt <branch-name>"
    exit 1
fi

branch="$1"

# Get the git root of the current repo
git_root=$(git rev-parse --show-toplevel)

# Extract project path relative to $HOME/src
# e.g., /Users/eddie.huang/src/github.com/inoc603/dotfiles -> github.com/inoc603/dotfiles
project_path="${git_root#$HOME/src/}"

if [ "$project_path" = "$git_root" ]; then
    echo "Error: Repository is not under \$HOME/src"
    exit 1
fi

# Construct worktree path
worktree_path="$HOME/src/.worktree/$project_path/$branch"

if [ -d "$worktree_path" ]; then
    echo "Worktree already exists at: $worktree_path"
    cd "$worktree_path" && exec $SHELL
else
    # Create parent directory if needed
    mkdir -p "$(dirname "$worktree_path")"

    # Check if branch exists
    if git show-ref --verify --quiet "refs/heads/$branch"; then
        # Branch exists locally, create worktree for it
        git worktree add "$worktree_path" "$branch"
    elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
        # Branch exists on remote, create worktree tracking it
        git worktree add "$worktree_path" "$branch"
    else
        # Branch doesn't exist, create new branch
        git worktree add -b "$branch" "$worktree_path"
    fi

    echo "Created worktree at: $worktree_path"
    cd "$worktree_path" && exec $SHELL
fi
