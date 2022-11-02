#!/bin/bash

git fetch -a
git remote prune origin
bash ~/.config/git/bclean.sh
