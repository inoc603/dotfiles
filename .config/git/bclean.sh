#!/bin/bash

git branch --merged "${1:-origin/master}" | grep -v "master" | xargs -r git branch -d
