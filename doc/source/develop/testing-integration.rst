`Home <index.html>`_ SaltStack-Formulas Development Documentation

===================
Testing Salt models
===================

.. contents::
    :backlinks: none
    :local:

In order to test your model you may use kitchen-salt again.

To validate model use:


Kitchen-salt to validate mode
=============================

With the below approach you may validate or even deploy your model in any platform the `kitchen-test` support.

.. note: Most of the salt-formulas deployments are deployed with reclass an “external node classifier” (ENC).
         The examples below expect's usage of reclass for ext_pillar data.
         More information about reclass can be found at:
         `reclass overview <http://salt-formulas.readthedocs.io/en/latest/develop/overview-reclass.htm>`_.

Expected repository structure:

.. code-block:: shell

  ➜  tree -L 3
  .
  ├── classes
  │   │  
  │   ├── service
  │   │  
  │   ├── system
  │   │  
  │   ├── cluster
  │   │   ├── k8s-aio-calico
  │   │   ├── k8s-aio-contrail
  │   │   ├── k8s-ha-calico
  │   │   ├── k8s-ha-calico-cloudprovider
  │   │   ├── k8s-ha-calico-syndic
  │   │   ├── k8s-ha-contrail
  │   │   ├── os-aio-contrail
  │   │   ├── os-aio-ovs
  │   │   ├── os-ha-contrail
  │   │   ├── os-ha-contrail-40
  │   │   ├── os-ha-contrail-ironic
  │   │   ├── os-ha-ovs
  │   │   ├── os-ha-ovs-ceph
  │   │  
  │
  ├── Makefile
  ├── README.rst
  │
  ├── verify.sh


Place this ``kitchen.yml`` and ``verify.sh`` to to your model repo.

.. note: The above files has maintained upstream at
         `github.com/salt-formulas/deploy/model <https://github.com/salt-formulas/salt-formulas/tree/master/deploy/model>`_.

Example ``kitchen.yml``:

.. code-block:: yaml

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
        #image: ubuntu:16.04
        image: tcpcloud/salt-models-testing # With preinstalled dependencies (faster)
        platform: ubuntu
        hostname: cfg01.<%= cluster %>.local
        provision_command:
          - apt-get update
          - apt-get install -y git curl python-pip
          - pip install --upgrade pip
          - git clone https://github.com/salt-formulas/salt-formulas-scripts /srv/salt/scripts
          - cd /srv/salt/scripts; git pull -r; cd -
          # NOTE: Configure ENV options as needed, example:
          - echo "
              export BOOTSTRAP=1;\n
              export CLUSTER_NAME=<%= cluster %>;\n
              export FORMULAS_SOURCE=pkg;\n
              export RECLASS_VERSION=master;\n
              export RECLASS_IGNORE_CLASS_NOTFOUND=True;\n
              export RECLASS_IGNORE_CLASS_REGEXP='service.*';\n
              export EXTRA_FORMULAS="";\n
            " > /kitchen.env
            #export RECLASS_SOURCE_PATH=/usr/lib/python2.7/site-packages/reclass;\n
            #export PYTHONPATH=$RECLASS_SOURCE_PATH:$PYTHONPATH;\n
    <% end %>

  suites:
    - name: cluster

Example ``verify.sh``:

.. code-block:: yaml

  #!/bin/bash

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
    /srv/salt/scripts/bootstrap.sh &&\
    if [[ -e /tmp/kitchen ]]; then sed -i '/BOOTSTRAP=/d' /kitchen.env; fi
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


Usage:

.. code-block:: yaml

  kitchen list

  Instance                                  Driver  Provisioner  Verifier  Transport  Last Action    Last Error
  -------------------------------------------------------------------------------------------------------------
  cluster-k8s-aio-calico                    Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-k8s-aio-contrail                  Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-k8s-ha-calico                     Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-k8s-ha-calico-cloudprovider       Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-k8s-ha-calico-syndic              Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-k8s-ha-contrail                   Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-os-aio-contrail                   Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-os-aio-ovs                        Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-os-ha-contrail                    Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-os-ha-contrail-40                 Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-os-ha-contrail-ironic             Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-os-ha-ovs                         Docker  Shell        Busser    Ssh        <Not Created>  <None>
  cluster-os-ha-ovs-ceph                    Docker  Shell        Busser    Ssh        <Not Created>  <None>
  ...

Once all require requirements are set, use ``tests/runtests.py`` to run all of
the tests included in Salt's test suite. For more information, see --help.


Running the Tests
=================


--------------

.. include:: navigation.txt
