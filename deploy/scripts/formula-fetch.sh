#!/bin/bash

# Usage:
#    ./formula-fetch.sh <Formula URL> <Name> <Branch>
#
# Example:
#    GIT_FORMULAS_PATH=.vendor/formulas ./formula-fetch.sh https://github.com/salt-formulas/salt-formula-salt
#    --
#    GIT_FORMULAS_PATH=/usr/share/salt-formulas/env/_formulas
#    xargs -n1 ./formula-fetch.sh < dependencies.txt


# Parse git dependencies from metadata.yml
# $1 - path to <formula>/metadata.yml
# sample to output:
#    https://github.com/salt-formulas/salt-formula-git git
#    https://github.com/salt-formulas/salt-formula-salt salt
function fetchGitFormulaDependencies {
    sed -e "/ name\| source/!d" -e 's/^.*:\ //g' -e '$a\\n' -e '/^\s*$/d' "$1" | tac | xargs -n2 echo fetchGitFormula
}

# Fetch formula from git repo
# $1 - formula git repo url
# $2 - formula name (optional)
# $3 - branch (optional)
function fetchGitFormula {
    export SUDO=${SUDO:-""}
    export GIT_FORMULAS_PATH=${GIT_FORMULAS_PATH:-/usr/share/salt-formulas/env/_formulas}
    test -d "$GIT_FORMULAS_PATH" || "$SUDO mkdir" "$GIT_FORMULAS_PATH"
    if [ "$1" ]; then
        source="$1"
        name="$2"
        test -n "$name" || name="${source//*salt-formula-}"
        test -z "$3" && branch=master || branch=$3
        echo "Processing: $name"
        if test -e "$GIT_FORMULAS_PATH/$name"; then
            pushd "$GIT_FORMULAS_PATH/$name"
            test ! -e .git || git pull -r
            popd
        else
            echo git clone "$source" "$GIT_FORMULAS_PATH/$name" -b "$branch"
            git clone "$source" "$GIT_FORMULAS_PATH/$name" -b "$branch"
        fi
        # install dependencies
        if test -e "$GIT_FORMULAS_PATH/$name/metadata.yml"; then
            eval "$(fetchGitFormulaDependencies "$GIT_FORMULAS_PATH/$name/metadata.yml")"
        fi
    else
        echo Usage: fetchGitFormula "<git repo>" "[local formula directory name]" "[branch]"
    fi
}


# detect if file is being sourced
[[ "$0" != "$BASH_SOURCE" ]] || {
    # if executed, run implicit function
    fetchGitFormula "${@}"
}

