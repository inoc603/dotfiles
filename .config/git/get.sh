#!/bin/bash

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
git clone $1 ~/src/$p
