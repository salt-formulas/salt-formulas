`Home <index.html>`_ SaltStack-Formulas Development Documentation

Deployment authoring guidelines
===============================

Let's consider simple deployment of single configuration node with one
application and one database node.

* Config node [salt master]
* Application node [python app]
* Database node [postgres db]

To start the simple deployment you need first setup the Salt master.
Installation of salt minions on controlled nodes is then very simple.


Salt master states
------------------

States are delivered by formulas and are stored in ``/srv/salt/env/<env>/``
directory. Environment can be either production [prd] or development [dev].
This directory is correlates with `salt_files` root for given env. You can
serve multiple environments from single salt master at once, but this setup is
not recommentded.

Usually production environment formulas are delivered by packages and
development environment formulas are delivered by git sourced formulas.

Salt formulas represent resources that can be automatically installed
configured at managed nodes.

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


Salt master metadata
--------------------

Metadata then define what state formulas in given specific context are
projected to managed nodes.

Following trees shows simple metadata structure for simple python application
deployment. Important parameters are `cluster_name` labeling individual
deployments and `cluster.domain` giving the deployment nodes domain part of
the FQDN.

.. code-block:: text

    /srv/salt/reclass/
    |-- classes/
    |   |-- cluster_name/
    |   |   |-- infra/
    |   |   |   `-- config.yml
    |   |   |-- python-app/
    |   |   |   |-- database.yml
    |   |   |   `-- web.yml
    |   |   `-- init.yml
    |   |-- system/
    |   |   |-- python-app/
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


Salt master metadata
--------------------

You start with defining single node `cfg.cluster.domain` in nodes directory
and that is core node pointing to your `cluster_name.infra.config` class.

Content of the `nodes/cfg.cluster.domain.yml` file:



Content of the `classes/cluster/cluster_name/infra/config.yml` file:



--------------

.. include:: navigation.txt
