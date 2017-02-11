#!/bin/bash

# Script to add Kitchen configuration to existing formulas.
# usage:
# curl -skL "https://raw.githubusercontent.com/salt-formulas/salt-formulas/master/cookiecutter/salt-formula/kitchen-init.sh" | bash -s --

# source gist:
# https://gist.github.com/epcim/b0368794e69e6807635b0c7268e5ceec

# CONFIG
###################################

export driver=${driver:-docker}       # vagrant, dokken, openstack, ...
export verifier=${verifier:-inspec}   # serverspec, pester

export formula=${formula:-$(awk -F: '/^name/{gsub(/[\ \"]/,"");print $2}' metadata.yml)}
export suites=$(ls tests/pillar|xargs -I{} basename {} .sls)

export SOURCE_REPO_URI="https://raw.githubusercontent.com/salt-formulas/salt-formulas/master/cookiecutter/salt-formula/%7B%7Bcookiecutter.service_name%7D%7D"

which envtpl &> /dev/null || {
  echo "ERROR: missing prerequisite, install 'envtpl' first : sudo pip install envtpl"
  exit 1
}

# INIT
###################################
test ! -e .kitchen.yml || {
  kitchen init -D kitchen-${driver} -P kitchen-salt --no-create-gemfile
  echo .kitchen >> .gitignore
  echo .bundle  >> .gitignore
  echo .vendor  >> .gitignore
  rm -rf test
  rm -f .kitchen.yml
  rm -f chefignore
}


# CONFIGURE & SCAFFOLD TEST DIR
###################################
test -d tests/integration || {
    mkdir -p tests/integration
}
# Generate suites:
#  for suite in $(echo $suites|xargs); do
#    mkdir -p tests/integration/$suite/$verifier
#    touch    tests/integration/$suite/$verifier/default_spec.rb
#  done
#  mkdir -p tests/integration/helpers/$verifier/
#  touch    tests/integration/helpers/$verifier/spec_helper.rb
#}


# .KITCHEN.YML
###################################

test -e .kitchen.yml || \
  envtpl < <(curl -skL  "${SOURCE_REPO_URI}/.kitchen.${driver}.yml" -- | sed 's/cookiecutter\.kitchen_//g' ) > .kitchen.yml

[[ "$driver" != "docker" ]] && {
  test -e .kitchen.docker.yml || \
    envtpl < <(curl -skL  "${SOURCE_REPO_URI}/.kitchen.docker.yml" -- | sed 's/cookiecutter\.kitchen_//g') > .kitchen.docker.yml
}

[[ "$driver" != "vagrant" ]] && {
  test -e .kitchen.vagrant.yml || \
    envtpl < <(curl -skL  "${SOURCE_REPO_URI}/.kitchen.vagrant.yml" -- | sed 's/cookiecutter\.kitchen_//g') > .kitchen.vagrant.yml
}

[[ "$driver" != "openstack" ]] && {
  test -e .kitchen.openstack.yml || \
    envtpl < <(curl -skL  "${SOURCE_REPO_URI}/.kitchen.openstack.yml" -- | sed 's/cookiecutter\.kitchen_//g') > .kitchen.openstack.yml
}

# .TRAVIS.YML
###################################

test -e .travis.yml || \
  curl -skL  "${SOURCE_REPO_URI}/.travis.yml" -o .travis.yml


# ADD CHANGES
#############

echo "**************************************"
echo "To update to latest test scripts, run:"
echo "SOURCE_REPO_URI=${SOURCE_REPO_URI}"
echo 'curl -skL  "${SOURCE_REPO_URI}/Makefile" -o Makefile'
echo 'curl -skL  "${SOURCE_REPO_URI}/tests/run_tests.sh" -o tests/run_tests.sh'

git add \
  .gitignore \
  .kitchen.yml \
  .travis.yml

git status
