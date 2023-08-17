#!/bin/bash

remote_main_branch="$(git rev-parse --abbrev-ref origin/HEAD)"
local_main_brach=$(echo $remote_main_branch | cut -d/ -f2)

git branch --merged "$remote_main_branch" | grep -v "$local_main_brach" | xargs -r git branch -d
