#!/bin/bash

git fetch -a

current_branch="$(git rev-parse --abbrev-ref HEAD)"
remote_main_branch="$(git rev-parse --abbrev-ref origin/HEAD)"
local_main_brach=$(echo $remote_main_branch | cut -d/ -f2)

if [ $current_branch == $local_main_brach ]; then
    git pull --rebase
else
    git fetch origin $local_main_brach:$local_main_brach
fi

git remote prune origin
bash ~/.config/git/bclean.sh
