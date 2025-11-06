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

if [ -z $p ]
then
        echo 'not a valid git repo url'
        return 1
fi

echo $p
git clone $shallow $1 ~/src/$p "${args[@]}"
cd ~/src/$p && git branchless init || echo "git branchless init failed"
