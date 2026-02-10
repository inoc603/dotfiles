#!/bin/bash

git fetch -a

current_branch="$(git rev-parse --abbrev-ref HEAD)"
remote_main_branch="$(git rev-parse --abbrev-ref origin/HEAD || (git remote set-head origin -a && git rev-parse --abbrev-ref origin/HEAD))"
local_main_brach=$(echo $remote_main_branch | cut -d/ -f2)

if [ $current_branch == $local_main_brach ]; then
    git pull --rebase
else
    git fetch origin $local_main_brach:$local_main_brach
fi

git remote prune origin

# Clean up worktrees for merged branches before deleting them
git_root=$(git rev-parse --show-toplevel)
project_path="${git_root#$HOME/src/}"
if [ "$project_path" != "$git_root" ]; then
    worktree_base="$HOME/src/.worktree/$project_path"
    for branch in $(git branch --merged "$remote_main_branch" | grep -v "$local_main_brach" | sed 's/^[* ]*//'); do
        worktree_path="$worktree_base/$branch"
        if [ -d "$worktree_path" ]; then
            # Check if worktree has uncommitted changes
            if git -C "$worktree_path" diff --quiet && git -C "$worktree_path" diff --cached --quiet; then
                echo "Removing worktree for merged branch: $branch"
                git worktree remove "$worktree_path"
            else
                echo "Skipping worktree for $branch: has uncommitted changes"
            fi
        fi
    done
fi

bash ~/.config/git/bclean.sh

# Prune stale worktree references
git worktree prune
