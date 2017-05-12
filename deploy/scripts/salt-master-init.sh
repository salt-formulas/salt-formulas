#!/usr/bin/env bash

# generate and validate reclass-salt-model
# expected to be executed in isolated environment, ie: docker

if [[ $DEBUG =~ ^(True|true|1|yes)$ ]]; then
    set -x
    SALT_LOG_LEVEL="--state-verbose=true -ldebug"
fi

## Env Options
options() {
    export LC_ALL=C
    SALT_LOG_LEVEL="--state-verbose=false -lerror"
    SALT_OPTS="${SALT_OPTS:- --state-output=changes --retcode-passthrough --force-color $SALT_LOG_LEVEL }"
    RECLASS_ROOT=${RECLASS_ROOT:-/srv/salt/reclass}
    BOOTSTRAP_SALTSTACK=${BOOTSTRAP_SALTSTACK:-True}
    BOOTSTRAP_SALTSTACK_OPTS=${BOOTSTRAP_SALTSTACK:- -d -M stable 2016.3 }

    # source environment & configuration
    # shopt -u dotglob
    if ls /*.env ; then source /*.env else echo "No /*.env was found."; fi
    if ls .*.env ; then source .*.env else echo "No .*.env was found."; fi

    export MAGENTA='\033[0;95m'
    export YELLOW='\033[1;33m'
    export BLUE='\033[0;35m'
    export CYAN='\033[0;96m'
    export RED='\033[0;31m'
    export NC='\033[0m' # No Color'
}

## Functions
log_info() {
    echo -e "${YELLOW}[INFO] $* ${NC}"
}

log_warn() {
    echo -e "${MAGENTA}[WARN] $* ${NC}"
}

log_err() {
    echo -e "${RED}[ERROR] $* ${NC}" >&2
}

_atexit() {
    RETVAL=$?
    trap true INT TERM EXIT

    if [ $RETVAL -ne 0 ]; then
        log_err "Execution failed"
    else
        log_info "Execution successful"
    fi
    return $RETVAL
}


## Main

system_config() {
    log_info "System configuration"

    # salt-formulas custom modules dependencies, etc:
    $SUDO apt install -qqq -y iproute2 curl sudo apt-transport-https python-psutil python-apt python-m2crypto python-oauth python-pip &>/dev/null

    $SUDO mkdir -p /srv/salt/reclass/classes/service
    $SUDO mkdir -p /root/.ssh
    echo -e "Host *\n\tStrictHostKeyChecking no\n" | $SUDO tee ~/.ssh/config >/dev/null
    echo -e "Host *\n\tStrictHostKeyChecking no\n" | $SUDO tee /root/.ssh/config >/dev/null
    echo "127.0.1.2  salt" | $SUDO tee -a /etc/hosts >/dev/null

    if [[ $BOOTSTRAP_SALTSTACK =~ ^(True|true|1|yes)$ ]]; then
        curl -L https://bootstrap.saltstack.com | $SUDO sh -s -- ${BOOTSTRAP_SALTSTACK_OPTS} &>/dev/null || true
    fi

    which reclass-salt || {
      test -e /usr/share/reclass/reclass-salt && {
        ln -fs /usr/share/reclass/reclass-salt /usr/bin
      }
    }
}


saltmaster_bootstrap() {

    log_info "Salt master, minion setup (salt-master-setup.sh)"
    test -n "$MASTER_HOSTNAME" || exit 1

    pgrep salt-master | xargs -i{} $SUDO kill -9 {}
    pgrep salt-minion | xargs -i{} $SUDO kill -9 {}
    SCRIPTS=$(dirname $0)
    test -e ${SCRIPTS}/salt-master-setup.sh || \
        curl -sL "https://raw.githubusercontent.com/salt-formulas/salt-formulas/master/deploy/scripts/salt-master-setup.sh" |$SUDO tee ${SCRIPTS}/salt-master-setup.sh > /dev/null;
        $SUDO chmod +x *.sh;
    test -e ${SCRIPTS}/.salt-master-setup.sh.passed || {
        export SALT_MASTER=localhost
        export MINION_ID=${MASTER_HOSTNAME}
        if ! [[ $DEBUG =~ ^(True|true|1|yes)$ ]]; then
          SALT_MASTER_SETUP_OUTPUT='/dev/stdout'
        fi
        if ! $SUDO ${SCRIPTS}/salt-master-setup.sh master &> ${SALT_MASTER_SETUP_OUTPUT:-/tmp/salt-master-setup.log}; then
          cat /tmp/salt-master-setup.log
          log_err "salt-master-setup.sh failed."
          exit 1
        else
          $SUDO touch ${SCRIPTS}/.salt-master-setup.sh.passed
        fi
    }

    log_info "Clean up generated"
    cd /srv/salt/reclass
    $SUDO rm -rf /srv/salt/reclass/nodes/_generated/*

    log_info "Re/starting salt services"
    $SUDO service salt-master restart
    $SUDO service salt-minion restart
    sleep 10
}

# Init salt master
saltmaster_init() {

    log_info "Runing saltmaster states"
    test -n "$MASTER_HOSTNAME" || exit 1

    set -e
    $SUDO salt-call saltutil.sync_all >/dev/null

    # TODO: Placeholder update saltmaster spec (nodes/FQDN.yml) to be able to bootstrap with minimal configuration
    # (ie: with linux, git, salt formulas)

    #log_info "Verify SaltMaster, before salt-master is fully initialized"
    #if ! $SUDO reclass-salt -p ${MASTER_HOSTNAME} &> /tmp/${MASTER_HOSTNAME}.pillar;then
    #   log_warn "Node verification before initialization failed."; cat /tmp/${MASTER_HOSTNAME}.pillar;
    #fi

    log_info "State: salt.master.env"
    if ! $SUDO salt-call ${SALT_OPTS} -linfo state.apply salt.master.env; then
      log_warn "State salt.master.env failed, keep your eyes wide open."
    fi

    log_info "State: salt.master.pillar"
    $SUDO salt-call ${SALT_OPTS} state.apply salt.master.pillar pillar='{"reclass":{"storage":{"data_source":{"engine":"local"}}}}'
    # Note: sikp reclass data dir states
    #       in order to avoid pull from configured repo/branch

    # Revert temporary SaltMaster minimal configuration, if any
    git status
    git checkout -- /srv/salt/reclass/nodes

    log_info "State: salt.master.storage.node"
    $SUDO salt-call ${SALT_OPTS} state.apply reclass.storage.node

    log_info "Re/starting salt services"
    $SUDO sed -i 's/^master:.*/master: localhost/' /etc/salt/minion.d/minion.conf
    $SUDO service salt-minion restart >/dev/null
    $SUDO salt-call ${SALT_OPTS} saltutil.sync_all >/dev/null
    
    verify_salt_master
    set +e

}


function verify_salt_master() {
    #set -e

    log_info "Verify Salt master"
    test -n "$MASTER_HOSTNAME" || exit 1

    if [[ $DEBUG =~ ^(True|true|1|yes)$ ]]; then
      $SUDO reclass-salt -p ${MASTER_HOSTNAME} |tee ${MASTER_HOSTNAME}.pillar_verify | tail -n 50
      $SUDO salt-call ${SALT_OPTS} --id=${MASTER_HOSTNAME} grains.item roles | tee /tmp/${MASTER_HOSTNAME}.pillar_verify
      salt-call --no-color grains.items
      salt-call --no-color pillar.data
    fi
    $SUDO salt-call ${SALT_OPTS} --id=${MASTER_HOSTNAME} state.show_lowstate | tee -a /tmp/${MASTER_HOSTNAME}.pillar_verify
}

function verify_salt_minion() {
  node=$1
  log_info "Verifying ${node}"
  if [[ $DEBUG =~ ^(True|true|1|yes)$ ]]; then
    $SUDO reclass-salt -p ${node} >  /tmp/${node}.pillar_verify || continue
    $SUDO salt-call ${SALT_OPTS} --id=${node} grains.item roles  | tee /tmp/${node}.pillar_verify || continue
  fi
  $SUDO salt-call ${SALT_OPTS} --id=${node} state.show_lowstate  | tee -a /tmp/${node}.pillar_verify || continue
}

function verify_salt_minions() {
    #set -e

    NODES=$(find /srv/salt/reclass/nodes/ -name "*.yml" | grep -v "cfg")

    # Parallel
    #echo $NODES | parallel --no-notice -j 2 --halt 2 "reclass-salt -p \$(basename {} .yml) > {}.pillar_verify"
    #ls -lrta *.pillar_verify | tail -n 1 | xargs -n1 tail -n30

    function filterFails() {
        grep -v '/grains' | tee -a $1 | tail -n20
    }

    log_info "Verify nodes"
    passed=0
    for node in ${NODES}; do
        node=$(basename $node .yml)

        # filter first in cluster.. ctl-01, mon-01, etc..
        if [[ "${node//.*}" =~ 01 || "${node//.*}" =~ 02  ]] ;then
            verify_salt_minion ${node}
        else
            echo Skipped $node.
        fi
        passed=$(($passed+1))
    done
    # fail on failures
    total=$(echo $NODES | xargs -n1 echo |wc -l)
    test ! $passed -lt $total || log_err "Results: $passed of $total passed."
    test ! $passed -lt $total || {
      tail -n50 /tmp/*.pillar_verify
      return 1
    }
}


options
# detect if file is being sourced
[[ "$0" != "$BASH_SOURCE"  ]] || {
    trap _atexit INT TERM EXIT
    system_config

    saltmaster_bootstrap &&\
    saltmaster_init &&\

    verify_salt_minions
}
