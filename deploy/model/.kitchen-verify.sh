#!/bin/bash

## -----------------------------------------------------------------------------
# PREREQ
if [ -e /tmp/kitchen ]; then
  rsync -avh --force --exclude "**/.kitchen" /tmp/kitchen/ /srv/salt/reclass
fi
source /srv/salt/bootstrap.sh
source_local_envs

# FULL BOOTSTRAP
# make sure everything is set-up and exactly as in the model
if [[ $BOOTSTRAP =~ ^(True|true|1|yes)$ ]]; then
  cd /srv/salt/reclass
  if [[ -e .gitmodules ]] && [[ ! -e classes/system/linux ]]; then
    git submodule update --init --recursive --remote || true
  fi
  /srv/salt/bootstrap.sh &&\
  if [[ -e /tmp/kitchen ]]; then sed -i '/BOOTSTRAP=/d' /kitchen.env; fi || exit 1
else
# JUST CONFIGURE AND START SALT-MASTER
# minimal setup to speed up, good-enough for model validation
	mkdir -p /srv/salt/reclass/nodes/_generated;
	cat <<-EOF > /srv/salt/reclass/nodes/_generated/cfg01.$CLUSTER_NAME.local.yml
	classes:
	- cluster.$CLUSTER_NAME.infra.config
	parameters:
	  _param:
	    linux_system_codename: xenial
	    reclass_data_revision:
	    reclass_data_repository:
	    cluster_name: $CLUSTER_NAME
	    cluster_domain: local
	  linux:
	    system:
	      name: cfg01
	      domain: $CLUSTER_NAME.local
	    network:
	       hostname: cfg01
	       fqdn: cfg01.$CLUSTER_NAME.local
	  reclass:
	    storage:
	      data_source:
	        engine: local
	EOF
# RECLASS PREREQUISITES
# remove lock if you need (re)configure salt-master, reclass 2nd time
  if [ ! -e /tmp/.reclass-prerequisite-once.lock ]; then
    # link services (subject of future changes)
    if [ ! -e /srv/salt/reclass/classes/service -a -e /usr/share/salt-formulas/reclass/service ]; then
      rm -rf /srv/salt/reclass/classes/service || true;
      ln -sf /usr/share/salt-formulas/reclass/service /srv/salt/reclass/classes
    fi &&\
    # reload
    service salt-master force-reload &&\
    service salt-minion force-reload &&\
    retry salt-call saltutil.sync_all &&\
    # generate static nodes
    PILLAR='{"reclass":{"storage":{"data_source":{"engine":"local"}}} }' &&\
    salt-call state.apply reclass.storage.node pillar="$PILLAR" &&\
    # generate/mockup dynamic nodes (uses fn from bootstrap.sh)
    mockup_node_registration &&\
    touch /tmp/.salt-services-reload-once.lock || exit 1
  fi
fi



## -----------------------------------------------------------------------------
## VERIFY MASTER AND MINIONS

if [[ ! -e /tmp/.verify-prerequisite-once.lock && ! $RECLASS_IGNORE_CLASS_NOTFOUND =~ ^(True|true|1|yes)$ ]]; then
  sed -i 's/ignore_class_notfound:\s*True.*/ignore_class_notfound: False/' /etc/salt/master.d/reclass.conf
  sed -i 's/ignore_class_notfound:\s*True.*/ignore_class_notfound: False/' /etc/reclass/reclass-config.yml
  service salt-master force-reload
  retry salt-call test.ping
fi

cd /srv/salt/reclass &&\
if [[ -z "$1" ]] ; then
  verify_salt_master &&\
  verify_salt_minions
else
  verify_salt_minion "$1"
fi
