#!/bin/bash

git fetch -a

current_branch="$(git rev-parse --abbrev-ref HEAD)"

if [ $current_branch == "master" ]; then
    git pull --rebase
else
    git fetch origin master:master
fi

git remote prune origin
bash ~/.config/git/bclean.sh
