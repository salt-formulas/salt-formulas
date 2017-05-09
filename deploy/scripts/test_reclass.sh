#!/usr/bin/env bash

set -e
if [[ $DEBUG =~ ^(True|true|1|yes)$ ]]; then
    set -x
fi

## Configuration
DOCKER_IMAGE=${DOCKER_IMAGE:-"ubuntu:16.04"}
DIST=${DIST:-xenial}
RECLASS_ROOT=${RECLASS_ROOT:-$(pwd)}
MASTER_HOSTNAME=${MASTER_HOSTNAME:-$(basename $(ls nodes/cfg*.yml|head -1) .yml)}
DOCKER_OPTS="${DOCKER_OPTS} -e DEBIAN_FRONTEND=noninteractive -h $(echo ${MASTER_HOSTNAME}|cut -d . -f 1)"

## Functions
log_info() {
    echo "[INFO] $*"
}

log_err() {
    echo "[ERROR] $*" >&2
}

docker_exec() {
    if [[ $DETACH =~ ^(True|true|1|yes)$ ]]; then
        exec_opts="-d"
    else
        exec_opts=""
    fi

    docker exec ${exec_opts} ${ID} /bin/bash -c "$*"
}

_atexit() {
    RETVAL=$?
    trap true INT TERM EXIT

    log_info "Cleaning up"
    docker_exec "chown -R $(id -u):$(id -g) /srv/salt" || true
    docker stop ${ID} >/dev/null || true
    docker rm ${ID} >/dev/null || true

    if [ $RETVAL -ne 0 ]; then
        log_err "Execution failed"
    else
        log_info "Execution successful"
    fi

    return $RETVAL
}


## Main
trap _atexit INT TERM EXIT

log_info "Creating docker container from image ${DOCKER_IMAGE}"
ID=$(docker run ${DOCKER_OPTS} -v ${RECLASS_ROOT}:/srv/salt/reclass -i -t -d ${DOCKER_IMAGE})

log_info "Installing prerequisites"
docker_exec 'curl -L https://bootstrap.saltstack.com | $SUDO sh -s -- -M stable 2016.3'
docker_exec 'apt-update; apt-get install -y curl subversion git python-pip sudo'
docker_exec "svn export --force https://github.com/salt-formulas/salt-formulas/trunk/deploy/scripts /srv/salt/scripts"


log_info "CI Workarounds"
docker_exec "git config --global user.email || git config --global user.email 'ci@ci.local'"
docker_exec "git config --global user.name  || git config --global user.name 'CI'"
# TODO: next two should not be needed, subject to remove on next iteration
docker_exec 'cd /srv/salt/reclass; test ! -e .gitmodules || git submodule update --init --recursive'
docker_exec 'cd /srv/salt/reclass; git commit -am "Fake branch update" || true'

log_info "Setup, Init and verify Salt Master & Minions"
# TODO: to bootstrap can be tweaked by additional env. variables, see salt-master-*.sh
#       for alternatives
# NOTE: in future the salt-master-init.sh will be re-engineered into salt formula.
docker_exec "MASTER_HOSTNAME=$MASTER_HOSTNAME /srv/salt/scripts/salt-master-init.sh"

