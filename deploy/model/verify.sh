#!/bin/bash

eval $(find / -maxdepth 1 -name '*.env' | xargs -0 -n1 --no-run-if-empty echo source)
eval $(find . -maxdepth 1 -name '*.env' | xargs -0 -n1 --no-run-if-empty echo source)
export MASTER_HOSTNAME=${MASTER_HOSTNAME:-`hostname -f`}

# BOOTSTRAP
if [[ $BOOTSTRAP =~ ^(True|true|1|yes)$ ]]; then
  # WORKAROUNDs for Kitchen
  test ! -e /tmp/kitchen  || (mkdir -p /srv/salt/reclass; rsync -avh /tmp/kitchen/ /srv/salt/reclass)
  # work in salt root
  cd /srv/salt/reclass
  # clone system-level if missing
  if [[ -e .gitmodules ]] && [[ ! -e classes/system/linux ]]; then
    git submodule update --init --recursive || true
  fi
  /srv/salt/scripts/salt-master-init.sh
fi

# VERIFY
export BOOTSTRAP_SALTSTACK=False
cd /srv/salt/reclass &&\
source /srv/salt/scripts/salt-master-init.sh &&\
options &&\
system_config && \\
if [[ -z "$1" ]] ; then
  verify_salt_master &&\
  verify_salt_minions
else
  verify_salt_minion "$1"
fi
