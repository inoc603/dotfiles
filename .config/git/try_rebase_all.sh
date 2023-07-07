#!/bin/bash

git branch | grep -v master | xargs -I{} bash -c "git checkout {}; git rebase origin/master || git rebase --abort"
