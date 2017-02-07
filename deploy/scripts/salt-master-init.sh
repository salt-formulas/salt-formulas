#!/usr/bin/env bash

# generate and validate reclass-salt-model
# expected to be executed in isolated environment, ie: docker

if [[ $DEBUG =~ ^(True|true|1|yes)$ ]]; then
    set -x
fi

## Env Options
options() {
    export LC_ALL=C
    SUDO=${SUDO:-}
    SALT_OPTS="${SALT_OPTS:- --state-output=changes --state-verbose=false --retcode-passthrough --force-color -lerror}"
    RECLASS_ROOT=${RECLASS_ROOT:-$(pwd)}

    # source environment & configuration
    # shopt -u dotglob
    if ls /*.env ; then source /*.env else echo "No /*.env was found."; fi
    if ls .*.env ; then source .*.env else echo "No .*.env was found."; fi

    export YELLOW='\033[1;33m'
    export RED='\033[0;31m'
    export NC='\033[0m' # No Color'
}

## Functions
log_info() {
    echo -e "${YELLOW}[INFO] $* ${NC}"
}

log_warn() {
    echo -e "\n[WARN] $*"
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
    #export RECLASS_ADDRESS=file:///tmp/reclass
    export RECLASS_ADDRESS=${RECLASS_ADDRESS:-$(git remote get-url origin)}
    export RECLASS_BRANCH=${RECLASS_BRANCH:-$(git rev-parse --abbrev-ref HEAD)}
}

saltmaster_bootstrap() {

    log_info "Setting up Salt master, minion"
    cd
    pgrep salt-master | xargs -i{} $SUDO kill -9 {}
    pgrep salt-minion | xargs -i{} $SUDO kill -9 {}
    #HOSTNAME=$(${MASTER_HOSTNAME} | awk -F. '{print $1}')
    #DOMAIN=$(${MASTER_HOSTNAME}   | awk -F. '{print $ARGV[1..]}')

    # ########################################
    # TODO: bootstrap script to merge here
    # ########################################
    test -e bootstrap.sh || \
        curl -skL "https://raw.githubusercontent.com/tcpcloud/salt-bootstrap-test/master/bootstrap.sh" |$SUDO tee bootstrap.sh >/dev/null; $SUDO chmod +x *.sh;
    test -e bootstrap.sh.lock || {
        export SALT_MASTER=localhost
        export MINION_ID=${MASTER_HOSTNAME}
        if $SUDO ./bootstrap.sh master &>/dev/null ; then
          $SUDO touch bootstrap.sh.lock
        else
          log_err "Bootstrap.sh exited with: $?."
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
init_salt_master() {

    log_info "Runing saltmaster states"
    set -x
    $SUDO salt-call saltutil.sync_all >/dev/null

    log_info "Reclass-salt SaltMaster node check, prior salt-master is fully initialized"
    $SUDO reclass-salt -p ${MASTER_HOSTNAME} &> ${MASTER_HOSTNAME}_pre.out || cat ${MASTER_HOSTNAME}_pre.out

    #$SUDO reclass-salt -p ${MASTER_HOSTNAME} >  ${MASTER_HOSTNAME}.tmp  || (tail -n 50 ${MASTER_HOSTNAME}.tmp; false)
    if [[ $MASTER_INIT_STATES =~ ^(True|true|1|yes)$ ]]; then
        $SUDO salt-call ${SALT_OPTS} state.sls salt.master || log_warn "Friendly errors may pass"
    else
        $SUDO salt-call ${SALT_OPTS} state.sls salt.master.env || log_warn "Friendly errors may pass"
        $SUDO salt-call ${SALT_OPTS} state.sls salt.master.pillar pillar='{"reclass":{"storage":{"data_source":{"engine":"local"}}}}'
                                                            # sikp reclass data dir states
                                                            # in order to avoid pull from configured repo/branch
        $SUDO salt-call ${SALT_OPTS} state.sls reclass.storage.node
    fi

    $SUDO service salt-minion restart >/dev/null
    $SUDO salt-call ${SALT_OPTS} saltutil.sync_all >/dev/null
    set +x

    # Instantinate Salt Master
    if [[ $MASTER_INIT_STATES =~ ^(True|true|1|yes)$ ]]; then
    #  salt-call ${SALT_OPTS} state.sls reclass
        $SUDO salt-call ${SALT_OPTS} state.sls salt
        $SUDO sed -i 's/^master:.*/master: localhost/' /etc/salt/minion.d/minion.conf
    fi
}


function verify_salt_master() {
    #set -e

    log_info "Verify Salt master"
    $SUDO reclass-salt -p ${MASTER_HOSTNAME} >  ${MASTER_HOSTNAME}.out
    $SUDO salt-call ${SALT_OPTS} --id=${MASTER_HOSTNAME} state.show_lowstate >>  ${MASTER_HOSTNAME}.out
    $SUDO salt-call ${SALT_OPTS} --id=${MASTER_HOSTNAME} grains.item roles   >>  ${MASTER_HOSTNAME}.out
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
        grep -v '/etc/salt/grains' | tee -a $1 | tail -n20
    }

    log_info "Verify nodes"
    passed=0
    for node in ${NODES}; do
        node=$(basename $node .yml)

        # filter first in cluster.. ctl-01, mon-01, etc..
        if [[ "${node//.*}" =~ "01" ]] ;then
  
            log_info "Verifying ${node}"
            $SUDO reclass-salt -p ${node} >  ${node}.out || continue
            $SUDO salt-call ${SALT_OPTS} --id=${node} state.show_lowstate  >>  ${node}.out || continue
            $SUDO salt-call ${SALT_OPTS} --id=${node} grains.item roles    >>  ${node}.out || continue
            # || (tail -n 50 $node.out; false)
        else
            echo Skipped $node.
        fi
        passed=$(($passed+1))
    done
    # fail on failures
    total=$(echo $NODES | xargs -n1 echo |wc -l)
    test ! $passed -lt $total || (log_err "Results: $passed of $total passed."; exit 1)
}


# detect if file is being sourced
[[ "$0" != "$BASH_SOURCE"  ]] || {
    trap _atexit INT TERM EXIT
    options
    system_config
    test ! -e /tmp/reclass || kitchen_bootstrap

    saltmaster_bootstrap
    init_salt_master        > ${MASTER_HOSTNAME}.tmp  || (tail -n 50 ${MASTER_HOSTNAME}.tmp; false)

    verify_salt_master
    verify_salt_minions
}
