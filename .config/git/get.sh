#!/bin/bash

# Check if --shallow flag is provided
shallow=""
args=()
for arg in "${@:2}"; do
    if [[ "$arg" == "--shallow" ]]; then
        shallow="--depth 1"
    else
        args+=("$arg")
    fi
done

p=$(echo $1 | sed -n 's/^https:\/\/\(.*\)\.git$/\1/p')
if [ -z $p ]
then
        p=$(echo $1 | sed -n 's/^git@\(.*\)\.git$/\1/p' | sed -e 's/\:/\//g')
fi
# Support project web URLs without .git suffix (e.g. https://gitlab.awx.im/devops/productivity/dbm)
if [ -z $p ]
then
        p=$(echo $1 | sed -n 's/^https:\/\/\(.*\)$/\1/p' | sed 's/\/*$//')
fi

if [ -z $p ]
then
        echo 'not a valid git repo url'
        return 1
fi

echo $p
url=$1
# Append .git for web URLs so git clone works
if [[ "$url" != *.git ]]; then
        url="${url}.git"
fi
git clone $shallow $url ~/src/$p "${args[@]}"
cd ~/src/$p && git branchless init || echo "git branchless init failed"
