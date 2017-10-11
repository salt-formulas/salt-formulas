`Home <index.html>`_ SaltStack-Formulas Project Introduction

========================
Standard Metadata Layout
========================

.. contents::
    :backlinks: none
    :local:

Metadata models are separated into 3 individual layers: service, system and
cluster. The layers are firmly isolated from each other and can be aggregated
on south-north direction and using service interface agreements for objects on
the same level. This approach allows to reuse many already created objects
both on service and system layers as building blocks for a new solutions and
deployments following the fundamental MDA principles.


Basic Functional Units (Service Class Level)
============================================

The services are the atomic units of config management. SaltStack formula or
Puppet recipe with default metadata set can be considered as a service. Each
service implements one or more roles and together with other services form
systems. Following list shows decomposition

- Formula - Set of states that perform together atomic service
- State - Declarative definition of various resources (package, files, services)
- Module - Imperative interaction enforcing defined state for each State

Meta-data fragments for individual services are stored in salt formulas and
can be reused in multiple contexts. Service level roles set the granularity of
service to certain level, role is limited to 1 virtual machine or container
aggregation. Service models are used to provide models with defaults for
various contexts. This the low level modelling, where models are directly
mapped to the Salt formula functions and get projected to the actual nodes.

.. figure:: /_images/meta_service.png
  :width: 60%
  :align: center

Given Redis formula from Gitlab example we set basic set of parametes that can
be used for actual service configuration as well as support services
configuration.

Basic service metadata is present in `metadata/service` directory of every
service formula.

.. code-block:: text

    service-formula/
    `-- metadata/
        `-- service/
            |-- role1/
            |   |-- deployment1.yml
            |   `-- deployment2.yml
            `-- role2/
                `-- deployment3.yml

For example RabbitMQ service in various deployments.

.. code-block:: text

    rabbitmq/
    `-- metadata/
        `-- service/
            `-- server/
                |-- single.yml
                `-- cluster.yml


The metadata fragment `/srv/salt/reclass/classes/service/service-formula` maps
to `/srv/salt/env/formula-name/metadata/service` so then you can easily refer
the metadata as `service.formula-name.role1.deployment1` class for example.

Example `metadata/service/server/cluster.yml` for the cluster setup PostgreSQL
server.

.. code-block:: yaml

    parameters:
      postgresql:
        server:
          enabled: true
          bind:
            address: '127.0.0.1'
            port: 5432
            protocol: tcp
          clients:
          - '127.0.0.1'
         cluster:
           enabled: true
           members:
           - node01
           - node02
           - node03

Example `metadata/service/server/cluster.yml` for the single PostgreSQL
server.

.. code-block:: yaml

    parameters:
      postgresql:
        server:
          enabled: true
          bind:
            address: '0.0.0.0'
            port: 5432
            protocol: tcp

Example `metadata/service/server/cluster.yml` for the standalone PostgreSQL
server.

.. code-block:: yaml

    parameters:
      postgresql:
        server:
          enabled: true
          bind:
            address: '127.0.0.1'
            port: 5432
            protocol: tcp
          clients:
          - '127.0.0.1'

There are about 140 formulas in several categories. You can look at complete
`Formula Ecosystem <extending-formulas.html>`_ chapter.


Business Function Unit (System Class Level)
===========================================

Aggregation of services performing given role in business IT infrastructure.
System level models are the sets of the ‘services’ combined in a such way that
the result of the installation of these services will produce a ready-to-use
application (system) on integration level. In the ‘system’ model, you can not
only include the ‘services’, but also override some ‘services’ options to get
the system with the expected functionality.

.. figure:: /_images/meta_system.png
  :width: 60%
  :align: center

The systems are usually one of the following type:

**Single**

  Usually all-in-one application system on a node (Taiga, Gitlab)

**Multi**

  Multiple all-in-one application systems on a node (Horizon, Wordpress)

**Cluster**

  Service is part of a cluster (OpenStack controllers, large-scale web
  applications)

**Container**

  Service is run as Docker container

For example, in the service ‘haproxy’ there is only one port configured by
default (haproxy_admin_port: 9600) , but the system ‘horizon’ add to the
service ‘haproxy’ several new ports, extending the service model and getting
the system components integrated with each other.

.. code-block:: text

    system/
    `-- business-system/
        |-- role1/
        |   |-- deployment1.yml
        |   `-- deployment2.yml
        `-- role2/
            `-- deployment3.yml

For example Graphite server with Carbon collector.

.. code-block:: text

    system/
    `-- graphite/
        |-- server/
        |   |-- single.yml
        |   `-- cluster.yml
        `-- collector/
            |-- single.yml
            `-- cluster.yml

Example `classes/system/graphite/collector/single.yml` for the standalone
Graphite Carbon installation.

.. code-block:: yaml

    classes:
    - service.memcached.server.local
    - service.graphite.collector.single
    parameters:
      _param:
        rabbitmq_monitor_password: password
      carbon:
        relay:
          enabled: false

Example `classes/system/graphite/collector/single.yml` for the standalone
Graphite web server installation. Where you combine your individual formulas
to functional business unit of single node scope.

.. code-block:: yaml

    classes:
    - service.memcached.server.local
    - service.postgresql.server.local
    - service.graphite.server.single
    - service.apache.server.single
    - service.supervisor.server.single
    parameters:
      _param:
        graphite_secret_key: secret
        postgresql_graphite_password: password
        apache2_site_graphite_host: ${_param:single_address}
        rabbitmq_graphite_password: password
        rabbitmq_monitor_password: password
        rabbitmq_admin_password: password
        rabbitmq_secret_key: password
      apache:
        server:
          modules:
          - wsgi
          site:
            graphite_server:
              enabled: true
              type: graphite
              name: server
              host:
                name: ${_param:apache2_site_graphite_host}
      postgresql:
        server:
          database:
            graphite:
              encoding: UTF8
              locale: cs_CZ
              users:
              - name: graphite
                password: ${_param:postgresql_graphite_password}
                host: 127.0.0.1
                rights: all privileges


Product Deployments (Cluster Class Level)
=========================================

Cluster/deployment level aggregating systems directly referenced by individual
host nodes or container services. Cluster is the set of models that combine
the already created ‘system’ objects into different solutions. We can override
any settings of ‘service’ or ‘system’ level from the ‘cluster’ level with the
highest priority.

Also, for salt-based environments here are specified the list of nodes and
some specific parameters for different nodes (future ‘inventory’ files for
salt,  future generated pillars that will be used by salt formulas). The
actual mapping is defined, where each node is member of specific cluster and
is implementing specific role(s) in systems.

.. figure :: /_images/cluster_detail.png
   :width: 80%
   :align: center

   Cluster level in detail

If we want not just to re-use an object, we can change its behaviour depending
of the requirements of a solution. We define basic defaults on service level,
then we can override these default params for specific system needs and then
if needed provide overrides per deployment basis. For example, a database
engine, HA approaches, IO scheduling policy for kernel and other settings may
vary from one solution to another.

Default structure for cluster level has following strucuture:

.. code-block:: text

    cluster/
    `-- deployment1/
        |-- product1/
        |   |-- cluster1.yml
        |   `-- cluster2.yml
        `-- product2/
            `-- cluster3.yml

Where deployments is usually one datacenter, product realises full business
units [OpenStack cloud, Kubernetes cluster, etc]

For example deployment Graphite server with Carbon collector.

.. code-block:: text

    cluster/
    `-- demo-lab/
        |-- infra/
        |   |-- config.yml
        |   `-- integration.yml
        `-- monitoring/
            `-- monitor.yml

Example ``demo-lab/monitoring/monitor.yml`` class implementing not only
Graphite services butr also grafana sever and sensu server.

.. code-block:: yaml

    classes:
    - system.grapite.collector.single
    - system.grapite.server.single
    - system.grafana.server.single
    - system.grafana.client.single
    - system.sensu.server.cluster
    - cluster.demo-lab

Cluster level classes can be shared by members of the particular cluster or by
single node.


Node/Cluster Classification (Node Level)
========================================

Servers contain one or more systems that bring business value and several
maintenance systems that are common to any node. Services running on single
host can be viewed as at following picture.

.. figure:: /_images/meta_host.png
  :width: 60%
  :align: center

Nodes generally include cluster level classes which include relevant system
classes and these include service level classes which configure individual
formulas to work.

.. figure:: /_images/metadata_structure.svg
  :width: 90%
  :align: center

The previous figure shows the real composition of individual metadata
fragments that form the complete service catalog for each managed node.


--------------

.. include:: navigation.txt
