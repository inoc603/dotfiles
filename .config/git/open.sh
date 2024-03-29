#!/bin/bash

file=${1:-""}
git_branch=${2:-$(git symbolic-ref --quiet --short HEAD)}
git_project_root=$(git config remote.origin.url | sed "s~git@\(.*\):\(.*\)~https://\1/\2~" | sed "s~\(.*\).git\$~\1~")
git_directory=$(git rev-parse --show-prefix)
open ${git_project_root}/tree/${git_branch}/${git_directory}${file}
