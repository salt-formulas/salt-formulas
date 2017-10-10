`Home <index.html>`_ SaltStack-Formulas Project Introduction

=================================
Deployment Preparation Guidelines
=================================

.. contents::
    :backlinks: none
    :local:

Let's consider simple deployment of single configuration node with one
application and one database node.

* Config node [salt master]
* Application node [python app]
* Database node [postgres db]

To start the simple deployment you need first setup the Salt master.
Installation of salt minions on controlled nodes is then very simple.


Salt Master Formulas
====================

States are delivered by formulas and are stored in ``/srv/salt/env/<env>/``
directory. Environment can be either production [prd] or development [dev].
This directory is correlates with `salt_files` root for given environment. You
can serve multiple environments from single salt master at once, but this
setup is not recommentded.

Usually production environment formulas are delivered by packages and
development environment formulas are delivered by git sourced formulas.

.. code-block:: text

    /srv/salt/env/<env>/
    |-- service1/
    |   |-- itit.sls
    |   |-- role1/
    |   |   |-- service.sls
    |   |   `-- resource.sls
    |   `-- role2.sls
    `-- service2/
        |-- itit.sls
        `-- role.sls

For example basic `linux`, `python-app` and `openssh` services for development
environment in a little shortened version.

.. code-block:: text

    /srv/salt/env/dev/
    |-- linux/
    |   |-- itit.sls
    |   |-- system/
    |   |   |-- repo.sls
    |   |   `-- user.sls
    |   `-- network/
    |       |-- interface.sls
    |       `-- host.sls
    |-- python-app/
    |   |-- itit.sls
    |   |-- server.sls
    `-- openssh/
        |-- itit.sls
        |-- server.sls
        `-- client.sls

More about structure and layout of the formulas can be found in Development
documentation.


Salt Master Metadata
====================

Metadata then define what state formulas in given specific context are
projected to managed nodes.

Following trees shows simple metadata structure for simple python application
deployment. Important parameters are `cluster_name` labeling individual
deployments and `cluster.domain` giving the deployment nodes domain part of
the FQDN.

.. code-block:: text

    /srv/salt/reclass/
    |-- classes/
    |   |-- cluster/
    |   |   `-- deployment/
    |   |       |-- infra/
    |   |       |   `-- config.yml
    |   |       |-- python_app/
    |   |       |   |-- database.yml
    |   |       |   `-- web.yml
    |   |       `-- init.yml
    |   |-- system/
    |   |   |-- python_app/
    |   |   |   `-- server/
    |   |   |       |-- [dev|prd].yml
    |   |   |       `-- [single|cluster].yml
    |   |   |-- postgresql/
    |   |   |   `-- server/
    |   |   |       |-- cluster.yml
    |   |   |       `-- single.yml
    |   |   |-- linux/
    |   |   |   `-- system/
    |   |   |       `-- init.yml
    |   |   `-- deployment2.yml
    |   `-- service/
    |       |-- linux/ [formula metadata]
    |       |-- python-app/ [formula metadata]
    |       `-- openssh/ [formula metadata]
    `-- nodes/
        `-- cfg.cluster.domain.yml

You start with defining single node `cfg.cluster.domain` in nodes directory
and that is core node pointing to your `cluster.deploy.infra.config` class.

Content of the `nodes/cfg.cluster.domain.yml` file:

.. code-block:: yaml

    classes:
    - cluster.deploy.infra.config
    parameters:
      _param:
        reclass_data_revision: master
      linux:
        system:
          name: cfg01
          domain: cluster.domain

Contains pointer to class `cluster.deploy.infra.config` and some basic
parameters.

Content of the `classes/cluster/deploy/infra/config.yml` file:

.. code-block:: yaml

    classes:
    - system.openssh.client
    - system.salt.master.git
    - system.salt.master.formula.git
    - system.reclass.storage.salt
    - cluster.cluster_name
    parameters:
      _param:
        salt_master_base_environment: dev
        reclass_data_repository: git@git.domain.com:reclass-models/salt-model.git
        salt_master_environment_repository: "https://github.com/salt-formulas"
        reclass_data_revision: master
        reclass_config_master: ${_param:infra_config_deploy_address}
        single_address: ${_param:infra_config_address}
      reclass:
        storage:
          node:
            python_app01:
              name: app01
              domain: ${_param:cluster_domain}
              classes:
              - cluster.${_param:cluster_name}.python_app.application
              params:
                salt_master_host: ${_param:reclass_config_master}
                single_address: ${_param:python_application_node01_single_address}
                database_address: ${_param:python_database_node01_single_address}
            python_dbs01:
              name: dbs01
              domain: ${_param:cluster_domain}
              classes:
              - cluster.${_param:cluster_name}.python_app.database
              params:
                salt_master_host: ${_param:reclass_config_master}
                single_address: ${_param:python_database_node01_single_address}

More about structure and layout of the metadata can be found in Metadata
chapter.


--------------

.. include:: navigation.txt
