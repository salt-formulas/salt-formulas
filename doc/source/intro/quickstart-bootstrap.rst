`Home <index.html>`_ SaltStack-Formulas Project Introduction

======================================
Bootstrap Salt-Formulas infrastructure
======================================

.. contents::
    :backlinks: none
    :local:

This document's describes scripted way to configure Salt Master node.

To setup the environment according to `Quickstart Configure <quickstart-configure.html>`_ specification.

TL;DR
=====

We uses and script that provide functions to install and configure required primitives and dependencies.

Script with function library is to:

* install and configure *salt master* and *minions*
* install and configure reclass
* bootstrap *salt master* with *salt-formulas* common prerequisites in mind
* validate reclass the model / pillar for all nodes

.. note::

  This script is expected to convert to salt formula in a longterm perspective.


Expected usage in shortcut is:

.. code-block:: bash

    git clone https://github.com/salt-formulas/salt-formulas-scripts /srv/salt/scripts
    source /srv/salt/scripts/bootstrap.sh

Use one of the functions or follow the "setup()" which is executed by default:

.. code-block:: bash

  * source_local_envs()
  * install_reclass()
  * clone_reclass()

  * configure_pkg_repo()
  * configure_salt_master()
  * configure_salt_minion()

  * install_salt_formula_git()
  * install_salt_formula_pkg()
  * install_salt_master_pip()
  * install_salt_master_pkg()
  * install_salt_minion_pip()
  * install_salt_minion_pkg()

  * verify_salt_master()
  * verify_salt_minion()
  * verify_salt_minions()


Quick bootstrap
===============

Bootstrap salt-master
---------------------

(expects salt-formulas reclass model repo)

.. code-block:: bash

  git clone https://github.com/salt-formulas/salt-formulas-scripts /srv/salt/scripts
  
  git clone <model-repository> /srv/salt/reclass
  cd /srv/salt/reclass
  git submodule update --init --recursive
  
  cd /srv/salt/scripts
  
  CLUSTER_NAME=regionOne HOSTNAME=cfg01 DOMAIN=infra.ci.local ./bootstrap.sh
  # OR just
  HOSTNAME=cfg01 DOMAIN=infra.ci.local ./bootstrap.sh

.. note::

  Creates $PWD/.salt-master-setup.sh.passed if succesfully passed the "setup script"
  with the aim to avoid subsequent setup.


Bootstrap salt-minion
---------------------

This is mostly just to makeweight as configure minion as a super simple task that can be achieved by other means as well.

.. code-block:: bash

  export HTTPS_PROXY="http://proxy.your.corp:8080"; export HTTP_PROXY=$HTTPS_PROXY
  
  export MASTER_HOSTNAME=cfg01.infra.ci.local || export MASTER_IP=10.0.0.10
  export MINION_ID=$(hostname -f)             || export HOSTNAME=prx01 DOMAIN=infra.ci.local
  source <(curl -qL https://raw.githubusercontent.com/salt-formulas/salt-formulas-scripts/master/bootstrap.sh)
  install_salt_minion_pkg

Advanced usage
==============

The script is fully driven by environment variables. That's Pros and known Cons of course.

Additional bootstrap ENV variables
----------------------------------
(for full list of options see the *bootstrap.sh* source)
  
.. code-block:: bash

    # reclass
    export RECLASS_ADDRESS=<repo url>   ## if not already cloned in /srv/salt/reclass >

    # formula
    export FORMULAS_BRANCH=master
    export FORMULAS_SOURCE=git

    # system / host / salt master minion id
    export HOSTNAME=cfg01
    export DOMAIN=infra.ci.local
    # Following variables are calculated from the above if not provided
    #export MINION_ID
    #export MASTER_HOSTNAME
    #export MASTER_IP

    # salt
    export BOOTSTRAP_SALTSTACK_OPTS=" -dX stable 2016.3"
    export EXTRA_FORMULAS="prometeus"
    SALT_SOURCE=${SALT_SOURCE:-pkg}
    SALT_VERSION=${SALT_VERSION:-latest}
    
    # bootstrap control
    export SALT_MASTER_BOOTSTRAP_MINIMIZED=False
    export CLUSTER_NAME=<%= cluster %>
    
    # workarounds (forked reclass)
    export RECLASS_IGNORE_CLASS_NOTFOUND=False
    export EXTRA_FORMULAS="prometheus telegraph"

Bootstrap Salt Master in a container for model validation purposes
------------------------------------------------------------------

We use this to check the model during CI. The example count's with using forked version of 
`Reclass <https://github.com/salt-formulas/reclass>` with additional features, like ability to ignore missing
classes during the bootstrap.

To spin a container we uses a kitchen-test framework. The setup required you may find in the `Testing formulas section
<../develop/testing-formulas.html#requirements`

Assume you have a repository with your reclass model. Add to this repository following files. Both files can be found at 
`salt-formulas/deploy/model <https://github.com/salt-formulas/salt-formulas/tree/master/deploy/model>` repo.

``.kitchen.yml``:

.. code-block:: bash

    ---
    driver:
      name: docker
      use_sudo: false
      volume:
        - <%= ENV['PWD'] %>:/tmp/kitchen

    provisioner:
      name: shell
      script: verify.sh

    platforms:
      <% `find classes/cluster -maxdepth 1 -mindepth 1 -type d | tr '_' '-' |sort -u`.split().each do |cluster| %>
      <% cluster=cluster.split('/')[2] %>
      - name: <%= cluster %>
        driver_config:
          # image: ubuntu:16.04
          image: tcpcloud/salt-models-testing # With preinstalled dependencies (faster)
          platform: ubuntu
          hostname: cfg01.<%= cluster %>.local
          provision_command:
            - apt-get update
            - apt-get install -y git curl python-pip
            - git clone https://github.com/salt-formulas/salt-formulas-scripts /srv/salt/scripts
            - cd /srv/salt/scripts; git pull -r; cd -
            # NOTE: Configure ENV options as needed, example:
            - echo "
                export BOOTSTRAP=1;\n
                export CLUSTER_NAME=<%= cluster %>;\n
                export FORMULAS_SOURCE=pkg;\n
                export RECLASS_VERSION=dev;\n
                export RECLASS_IGNORE_CLASS_NOTFOUND=True;\n
                export EXTRA_FORMULAS="";\n
              " > /kitchen.env
              #export RECLASS_SOURCE_PATH=/usr/lib/python2.7/site-packages/reclass;\n
              #export PYTHONPATH=$RECLASS_SOURCE_PATH:$PYTHONPATH;\n
      <% end %>

    suites:
      - name: cluster


``verify.sh``:

.. code-block:: bash

    #!/bin/bash

    # ENV variables for MASTER_HOSTNAME composition
    # export HOSTNAME=${`hostname -s`}
    # export DOMAIN=${`hostname -d`}
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


Then with ``kitchen list`` command list the models in repository to test and finally converge and salt master instance where
you will trigger the validation.


.. code-block:: bash

  $ kitchen list

  Instance                                  Driver  Provisioner  Verifier  Transport  Last Action    Last Error
  -------------------------------------------------------------------------------------------------------------
  cluster-aaa-ha-freeipa                    Docker  Shell        Busser    Ssh        Created
  cluster-ceph-ha                           Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-k8s-aio-calico                    Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-k8s-ha-calico                     Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-aio-contrail                  Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-aio-ovs                       Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-ha-contrail                   Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-ha-ovs                        Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-ha-ovs-syndic                 Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-virt-liberty-dvr              Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-virt-liberty-ovs              Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-virt-mitaka-contrail          Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-virt-mitaka-dvr               Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-virt-mitaka-ovs               Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-virt-ocata-aio                Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-virt-ocata-contrail           Docker  Shell        Busser    Ssh        Created
  cluster-ost-virt-ocata-contrail-nfv       Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-virt-ocata-dvr                Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-virt-ocata-k8s-calico         Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-virt-ocata-k8s-calico-dyn     Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-virt-ocata-k8s-calico-min     Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-virt-ocata-k8s-contrail       Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-virt-ocata-ovs                Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-virt-ocata-ovs-dpdk           Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-ost-virt-ocata-ovs-ironic         Docker  Shell        Busser    Ssh        <Not Created>  <None>


To converge an instance:

.. code-block:: bash

  $ kitchen converge cluster-ost-virt-ocata-contrail


To verify the model (reclass model)
-----------------------------------

You may use a custom module build for this purpose in `reclass formula https://github.com/salt-formulas/salt-formula-reclass`.

.. code-block:: bash

  $SUDO salt-call ${SALT_OPTS} --id=${MASTER_HOSTNAME} reclass.validate_yaml
  $SUDO salt-call ${SALT_OPTS} --id=${MASTER_HOSTNAME} reclass.validate_pillar
  $SUDO salt-call ${SALT_OPTS} --id=${MASTER_HOSTNAME} grains.item roles
  $SUDO salt-call ${SALT_OPTS} --id=${MASTER_HOSTNAME} state.show_lowstate
  $SUDO salt-call --no-color grains.items
  $SUDO salt-call --no-color pillar.data
  $SUDO reclass --nodeinfo ${HOSTNAME}



