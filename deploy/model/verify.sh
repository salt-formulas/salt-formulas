#!/bin/bash

# ENV variables for MASTER_HOSTNAME composition
#export HOSTNAME=${`hostname -s`}
#export DOMAIN=${`hostname -d`}
cd /srv/salt/scripts; git pull -r || true; source bootstrap.sh || exit 1

# BOOTSTRAP
if [[ $BOOTSTRAP =~ ^(True|true|1|yes)$ ]]; then
  # workarounds for kitchen
  test ! -e /tmp/kitchen  || (mkdir -p /srv/salt/reclass; rsync -avh /tmp/kitchen/ /srv/salt/reclass)
  cd /srv/salt/reclass
  # clone latest system-level if missing
  if [[ -e .gitmodules ]] && [[ ! -e classes/system/linux ]]; then
    git submodule update --init --recursive --remote || true
  fi
  source_local_envs
  /srv/salt/scripts/bootstrap.sh
  if [[ -e /tmp/kitchen ]]; then sed -i '/export BOOTSTRAP=/d' /kitchen.env; fi
fi

# VERIFY
export RECLASS_IGNORE_CLASS_NOTFOUND=False
cd /srv/salt/reclass &&\
if [[ -z "$1" ]] ; then
  verify_salt_master &&\
  verify_salt_minions
else
  verify_salt_minion "$1"
fi
