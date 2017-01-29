#!/bin/bash -e

#
# ENVIRONMENT
#

OS_DISTRIBUTION=${OS_DISTRIBUTION:-ubuntu}
OS_NETWORKING=${OS_NETWORKING:-opencontrail}
OS_DEPLOYMENT=${OS_DEPLOYMENT:-single}
OS_SYSTEM="${OS_DISTRIBUTION}_${OS_NETWORKING}_${OS_DEPLOYMENT}"

SALT_SOURCE=${SALT_SOURCE:-pkg}
SALT_VERSION=${SALT_VERSION:-latest}

FORMULA_SOURCE=${FORMULA_SOURCE:-git}
FORMULA_PATH=${FORMULA_PATH:-/usr/share/salt-formulas}
FORMULA_BRANCH=${FORMULA_BRANCH:-master}
FORMULA_REPOSITORY=${FORMULA_REPOSITORY:-deb [arch=amd64] http://apt.tcpcloud.eu/nightly/ trusty tcp-salt}
FORMULA_GPG=${FORMULA_GPG:-http://apt.tcpcloud.eu/public.gpg}

if [ "$FORMULA_SOURCE" == "git" ]; then
  SALT_ENV="dev"
elif [ "$FORMULA_SOURCE" == "pkg" ]; then
  SALT_ENV="prd"
fi

RECLASS_ADDRESS=${RECLASS_ADDRESS:-https://github.com/tcpcloud/openstack-salt-model.git}
RECLASS_BRANCH=${RECLASS_BRANCH:-master}
RECLASS_SYSTEM=${RECLASS_SYSTEM:-$OS_SYSTEM}

CONFIG_HOSTNAME=${CONFIG_HOSTNAME:-config}
CONFIG_DOMAIN=${CONFIG_DOMAIN:-openstack.local}
CONFIG_HOST=${CONFIG_HOSTNAME}.${CONFIG_DOMAIN}
CONFIG_ADDRESS=${CONFIG_ADDRESS:-10.10.10.200}

MINION_MASTER=${MINION_MASTER:-$CONFIG_ADDRESS}
MINION_HOSTNAME=${MINION_HOSTNAME:-minion}
MINION_ID=${MINION_HOSTNAME}.${CONFIG_DOMAIN}

install_salt_minion_pkg()
{
    echo -e "\nInstalling salt minion ...\n"

    if [ "$SALT_VERSION" == "latest" ]; then
      apt-get install -y salt-common salt-minion
    else
      apt-get install -y --force-yes salt-common=$SALT_VERSION salt-minion=$SALT_VERSION
    fi

    echo -e "\nPreparing base OS repository ...\n"

    echo -e "deb [arch=amd64] http://apt.tcpcloud.eu/nightly/ trusty main security extra tcp" > /etc/apt/sources.list
    wget -O - http://apt.tcpcloud.eu/public.gpg | apt-key add -

    apt-get clean
    apt-get update

    if [ "$SALT_VERSION" == "latest" ]; then
      apt-get install -y salt-common salt-minion
    else
      apt-get install -y --force-yes salt-common=$SALT_VERSION salt-minion=$SALT_VERSION
    fi

    echo -e "\nInstalling salt minion ...\n"

    [ ! -d /etc/salt/minion.d ] && mkdir -p /etc/salt/minion.d
    echo -e "master: $MINION_MASTER\nid: $MINION_ID" > /etc/salt/minion.d/minion.conf

    service salt-minion restart
}

install_salt_minion_pip()
{
    echo -e "\nInstalling salt minion ...\n"

    echo -e "\nPreparing base OS repository ...\n"

    echo -e "deb [arch=amd64] http://apt.tcpcloud.eu/nightly/ trusty main security extra tcp" > /etc/apt/sources.list
    wget -O - http://apt.tcpcloud.eu/public.gpg | apt-key add -

    apt-get clean
    apt-get update

    echo -e "\nInstalling salt minion ...\n"

    if [ -x "`which invoke-rc.d 2>/dev/null`" -a -x "/etc/init.d/salt-minion" ] ; then
        apt-get purge -y salt-minion salt-common && apt-get autoremove -y
    fi

    apt-get install -y python-pip python-dev zlib1g-dev reclass git

    if [ "$SALT_VERSION" == "latest" ]; then
        pip install salt
    else
        pip install salt==$SALT_VERSION
    fi

    [ ! -d /etc/salt/minion.d ] && mkdir -p /etc/salt/minion.d
    echo -e "master: $MINION_MASTER\nid: $MINION_ID" > /etc/salt/minion.d/minion.conf

    wget -O /etc/init.d/salt-minion https://anonscm.debian.org/cgit/pkg-salt/salt.git/plain/debian/salt-minion.init && chmod 755 /etc/init.d/salt-minion
    ln -s /usr/local/bin/salt-minion /usr/bin/salt-minion

    service salt-minion restart
}

if [ "$SALT_SOURCE" == "pkg" ]; then
    install_salt_minion_pkg
elif [ "$SALT_SOURCE" == "pip" ]; then
    install_salt_minion_pip
fi
