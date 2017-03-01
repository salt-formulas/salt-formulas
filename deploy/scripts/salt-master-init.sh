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

    $SUDO mkdir -p /srv/salt/reclass/classes/service
    $SUDO mkdir -p /root/.ssh
    echo -e "Host *\n\tStrictHostKeyChecking no\n" | $SUDO tee ~/.ssh/config >/dev/null
    echo -e "Host *\n\tStrictHostKeyChecking no\n" | $SUDO tee /root/.ssh/config >/dev/null
    echo "127.0.1.2  salt" | $SUDO tee -a /etc/hosts >/dev/null

    curl -L https://bootstrap.saltstack.com | $SUDO sh -s -- -M stable 2016.3 &>/dev/null
    $SUDO apt install -qqq -y python-psutil &>/dev/null

    which reclass-salt || {
      test -e /usr/share/reclass/reclass-salt && {
        ln -fs /usr/share/reclass/reclass-salt /usr/bin
      }
    }
}


# Kitchen provisioner bootstrap script
kitchen_bootstrap() {
    log_info "Uploading local reclass"
    #test -e /tmp/reclass/.git && {
      #log_info ".. as git clone"
      #test -e /srv/salt/reclass/.git && git pull -r || git clone /tmp/reclass /srv/salt/reclass
    #} || {
      log_info ".. as static folders"
      rsync -avh --exclude workspace --exclude tmp --exclude temp \
        /tmp/reclass /srv/salt/
    #}
    cd /srv/salt/reclass;
    #export RECLASS_REPOSITORY=file:///tmp/reclass
    export RECLASS_REPOSITORY=${RECLASS_REPOSITORY:-$(git remote get-url origin)}
    export RECLASS_BRANCH=${RECLASS_BRANCH:-$(git rev-parse --abbrev-ref HEAD)}
}

saltmaster_bootstrap() {

    log_info "Setting up Salt master, minion"

    pgrep salt-master | xargs -i{} $SUDO kill -9 {}
    pgrep salt-minion | xargs -i{} $SUDO kill -9 {}
    #HOSTNAME=$(${MASTER_HOSTNAME} | awk -F. '{print $1}')
    #DOMAIN=$(${MASTER_HOSTNAME}   | awk -F. '{print $ARGV[1..]}')


    SCRIPTS=$(dirname $0)
    test -e ${SCRIPTS}/salt-master-setup.sh || \
        curl -sL "https://raw.githubusercontent.com/salt-formulas/salt-formulas/master/deploy/scripts/salt-master-setup.sh" |$SUDO tee ${SCRIPTS}/salt-master-setup.sh >/dev/null; 
        $SUDO chmod +x *.sh;
    test -e ${SCRIPTS}/.salt-master-setup.sh.passed || {
        export SALT_MASTER=localhost
        export MINION_ID=${MASTER_HOSTNAME}
        $SUDO ${SCRIPTS}/salt-master-setup.sh master &> /tmp/salt-master-setup.log || cat /tmp/salt-master-setup.log
        ret=$?
        if [ ${ret} -gt 0 ]; then
          log_err "salt-master-setup.sh exited with: ${ret}."
        else
          $SUDO touch ${SCRIPTS}/.salt-master-setup.sh.passed
        fi
    }

    log_info "Clean up generated"
    cd /srv/salt/reclass
    $SUDO rm -rf /srv/salt/reclass/nodes/_generated/*
    test -e nodes/control && {
      # if "cluster" setup is found, delete the duplicities
      $SUDO rm  -f /srv/salt/reclass/nodes/${MASTER_HOSTNAME}.yml
    }

    log_info "Re/starting salt services"
    $SUDO service salt-master restart
    $SUDO service salt-minion restart
    sleep 10
}

# Init salt master
saltmaster_init() {

    log_info "Runing saltmaster states"
    set -x
    set -e
    $SUDO salt-call saltutil.sync_all >/dev/null

    log_info "Verify SaltMaster, before salt-master is fully initialized"
    $SUDO reclass-salt -p ${MASTER_HOSTNAME} &> /tmp/${MASTER_HOSTNAME}.pillar ||\
      ( log_err "Pillar verification failed."; cat /tmp/${MASTER_HOSTNAME}.pillar; exit 1)

    log_info "State: salt.master.env"
    $SUDO salt-call ${SALT_OPTS} -linfo state.apply salt.master.env ||\
      log_warn "State salt.master.env failed, keep your eyes wide open."

    log_info "State: salt.master.pillar"
    $SUDO salt-call ${SALT_OPTS} state.apply salt.master.pillar pillar='{"reclass":{"storage":{"data_source":{"engine":"local"}}}}'
    # Note: sikp reclass data dir states
    #       in order to avoid pull from configured repo/branch

    git checkout -- /srv/salt/reclass/nodes

    log_info "State: salt.master.storage.node"
    $SUDO salt-call ${SALT_OPTS} state.apply reclass.storage.node

    $SUDO service salt-minion restart >/dev/null
    $SUDO salt-call ${SALT_OPTS} saltutil.sync_all >/dev/null
    set +x
    set +e

    $SUDO sed -i 's/^master:.*/master: localhost/' /etc/salt/minion.d/minion.conf
}


function verify_salt_master() {
    #set -e

    log_info "Verify Salt master"
    $SUDO reclass-salt -p ${MASTER_HOSTNAME} |tee ${MASTER_HOSTNAME}.pillar_verify | tail -n 50
    $SUDO salt-call ${SALT_OPTS} --id=${MASTER_HOSTNAME} state.show_lowstate >>  /tmp/${MASTER_HOSTNAME}.pillar_verify
    $SUDO salt-call ${SALT_OPTS} --id=${MASTER_HOSTNAME} grains.item roles   >>  /tmp/${MASTER_HOSTNAME}.pillar_verify
    #salt-call --no-color grains.items
    #salt-call --no-color pillar.data
}


function verify_salt_minions() {
    #set -e

    NODES=$(ls /srv/salt/reclass/nodes/_generated)

    # Parallel
    #echo $NODES | parallel --no-notice -j 2 --halt 2 "reclass-salt -p \$(basename {} .yml) > {}.out"
    #ls -lrta *.out | tail -n 1 | xargs -n1 tail -n30

    function filterFails() {
        grep -v '/grains' | tee -a $1 | tail -n20
    }

    log_info "Verify nodes"
    passed=0
    for node in ${NODES}; do
        node=$(basename $node .yml)

        # filter first in cluster.. ctl-01, mon-01, etc..
        if [[ "${node//.*}" =~ 01 || "${node//.*}" =~ 02  ]] ;then
  
            log_info "Verifying ${node}"
            $SUDO reclass-salt -p ${node} >  /tmp/${node}.out || continue
            $SUDO salt-call ${SALT_OPTS} --id=${node} state.show_lowstate  >>  /tmp/${node}.out || continue
            $SUDO salt-call ${SALT_OPTS} --id=${node} grains.item roles    >>  /tmp/${node}.out || continue
            # || (tail -n 50 $node.out; false)
        else
            echo Skipped $node.
        fi
        passed=$(($passed+1))
    done
    # fail on failures
    total=$(echo $NODES | xargs -n1 echo |wc -l)
    test ! $passed -lt $total || log_err "Results: $passed of $total passed."
    test ! $passed -lt $total || return 1
}


options
# detect if file is being sourced
[[ "$0" != "$BASH_SOURCE"  ]] || {
    trap _atexit INT TERM EXIT
    system_config
    test ! -e /tmp/reclass || kitchen_bootstrap

    saltmaster_bootstrap &&\
    saltmaster_init        > /tmp/${MASTER_HOSTNAME}.init  || (tail -n 50 /tmp/${MASTER_HOSTNAME}.init; exit 1) &&\

    verify_salt_master &&\
    verify_salt_minions &&\

    log_info "Don't forget to remove /etc/apt/sources.list.d/bootstrap.list once not required"
}
