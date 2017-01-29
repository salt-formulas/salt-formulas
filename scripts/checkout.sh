#!/bin/bash -e

git submodule init
git submodule sync
git submodule update

if [ -z $1 ]; then
    mr --trust-all -j4 --force checkout
else
    for repo in $@; do
        mr --trust-all -j4 --force -d $repo checkout
    done
fi
