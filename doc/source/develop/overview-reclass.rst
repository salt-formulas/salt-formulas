`Home <index.html>`_ SaltStack-Formulas Development Documentation

Reclass Metadata
================

.. contents::
    :backlinks: none
    :local:

Every solution can be described by using several layers of objects, where the
objects of higher layer are combinations of the objects from lower layers. For
example, we may install ‘apache server’ and call it ‘apache service’, but an
object that contains multiple services like ‘apache service’, ‘mysql service’,
and some python scripts (for example keystone), we will call that “keystone
system” and have it on a higher (System) layer. Then we can use a set of
systems to create complete deployment, “openstack cluster”, “kubernetes
cluster” or any other PaaS, IaaS or SaaS solution.

.. figure :: /_images/formula_system_cluster_simple.png
   :width: 90%
   :align: center

   Decomposition of services, systems and clusters

This model has been developed to cope with huge scope deployments, consisting
of hundreds of services running VMs and containers acroess multiple physical
servers or locations. Following text takes apart individual components and
explains them in further detail.


Basic principles
----------------

Metadata is separated into 3 individual layers: service, system and cluster.
The layers are firmly isolated from each other and can be aggregated on south-
north direction and using service interface agreements for objects on the same
level. This approach allows to reuse many already created objects as building
blocks for a new solution reusing the fundamental MDA principles.


Service level (Basic function units)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Individual service meta-data fragments are present in salt formulas and can be
reused in multiple contexts. Service level roles implement atomicity. Service
models are used to spin up some service and configure it with defaults. These
models are then mapped to the salt formulas functionality and provided in the
packages for formulas (but for reclass, you may replace the service model with
your own model.

You store basic configurations of managed services in `metadata/service`
directory.

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


System level (Business function units)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Aggregation of services performing given role in business IT infrastructure.
System level models are the sets of the ‘services’ combined in a such way that
the result of the installation of these services will produce a ready-to-use
application (system) on integration level. In the ‘system’ model, you can not
only include the ‘services’, but also override some ‘services’ options to get
the system with the expected functionality.

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


Cluster level (Deployment units)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
   :width: 90%
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


Deployment models
-----------------

Keeping consistency across multiple models/deployments has proven to be the
most difficult part of keeping things running smooth over time with evolving
configuration management. You have multiple strategies on how to manage your
metadata for different scales.

The service level metadata can be handled in common namespace not by formulas
itself, but it is recommended to keep the relevant metadata states


Shared cluster and system level
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If every deployment only defined on system level, you need to keep copy of all
system definitions at all deployments. This is suitable only for small number
of deployments.


Separate cluster and system level
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

With introduction of new features and services shared deployments does not
provide necessary flexibility to cope with the change. Having service metadata
provided along formulas helps to deliver the up-to-date models to the
deployments, but does not reflect changes on the system level. Also the need
of multiple parallel deployments lead to adjusting the structure of metadata
with new common system level and only cluster level for individual
deployment(s). The cluster layer only contains soft parametrization and class
references.


Separate cluster and multiple system levels
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When customer is reusing the provided system, but also has formulas and system
on its own. Customer is free to create its own system level classes.

.. figure :: /_images/formula_system_cluster.png
   :width: 90%
   :align: center

   Multiple system levels for customer based data

In this setup a customer is free to reuse the generic formulas with generic
systems. At the same time he's free to create formulas of it's own as well as
custom systems.


Metadata types
--------------

The reclass deals with complex data structures we call 'hard' metadata, that
you don't need to manage directly, but we have introduced so called 'soft'
metadata, as siple list of most frequent changed properties of 'hard' metadata
model.


.. figure :: /_images/soft_hard_metadata.png
   :width: 90%
   :align: center

   Interpolating `soft` parameters in `hard` metadata structure


The 'soft' metadata
~~~~~~~~~~~~~~~~~~~

Is the special key-value store in reclass called _param, this contains keys
that are interpolated to the 'hard' metadata. These are parameters that are
attached at the node definition.

.. code-block:: yaml

    parameters:
      _param:
        service_database_host: hostname.domain.com

All of these values are preferably scalar and can be referenced as
``${_param:service_database_host}`` parameter.


The 'Hard' metadata
~~~~~~~~~~~~~~~~~~~

This metadata are the complex metadata structures that can contain
interpolation stings pointing to the 'soft' metadata.

.. code-block:: yaml

    parameters:
      python-application:
        server:
          database:
            name: database_name
            host: ${_param:service_database_host}


Handling sensitive metadata
---------------------------

Sensitive data refers to any information that you would not wish to share with
anyone accessing a server. This could include data such as passwords, keys, or
other information. For sensitive data we use the GPG renderer on salt master
to cipher all sensitive data.

To generate a cipher from a secret use following command:

.. code-block:: bash

    $ echo -n "supersecret" | gpg --homedir --armor --encrypt -r <KEY-name>

The ciphered secret is stored in block of text within ``PGP MESSAGE``
delimiters, which are part of cipher.

.. code-block:: text

      -----BEGIN PGP MESSAGE-----
      Version: GnuPG v1
      -----END PGP MESSAGE-----

Following example shows full use of generated cipher for virtually any secret.

.. code-block:: yaml

    parameters:
      _param:
        rabbitmq_secret_key: |
          -----BEGIN PGP MESSAGE-----
          Version: GnuPG v1

          hQEMAweRHKaPCfNeAQf9GLTN16hCfXAbPwU6BbBK0unOc7i9/etGuVc5CyU9Q6um
          QuetdvQVLFO/HkrC4lgeNQdM6D9E8PKonMlgJPyUvC8ggxhj0/IPFEKmrsnv2k6+
          cnEfmVexS7o/U1VOVjoyUeliMCJlAz/30RXaME49Cpi6No2+vKD8a4q4nZN1UZcG
          RhkhC0S22zNxOXQ38TBkmtJcqxnqT6YWKTUsjVubW3bVC+u2HGqJHu79wmwuN8tz
          m4wBkfCAd8Eyo2jEnWQcM4TcXiF01XPL4z4g1/9AAxh+Q4d8RIRP4fbw7ct4nCJv
          Gr9v2DTF7HNigIMl4ivMIn9fp+EZurJNiQskLgNbktJGAeEKYkqX5iCuB1b693hJ
          FKlwHiJt5yA8X2dDtfk8/Ph1Jx2TwGS+lGjlZaNqp3R1xuAZzXzZMLyZDe5+i3RJ
          skqmFTbOiA==
          =Eqsm
          -----END PGP MESSAGE-----
      rabbitmq:
        server:
          secret_key: ${_param:rabbitmq_secret_key}
          ...

As you can see the GPG encrypted parameters can be further referenced with
reclass interpolation ``${_param:rabbitmq_secret_key}`` statement.


Creating new models
-------------------

Following text shows steps that may be undertaken to implement new
functionality, new solution or entire deployment:


Creating a new formula (Service level)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If some of required services are missing, you can create a new service formula
for salt with the default model that describe the basic setup of the service.
The process of creating new formula uses Cookiecutter to spead it up.

`/srv/salt/reclass/classes/service/<service_name>/` with the folder (or a
symlink to) of your own service model.


Creating new a business unit (System level)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If some ‘system’ is missing, then you can create a new ‘system’ from the set
of ‘services’ and extend the ‘services’ models with necessary settings for the
system (additional ports for haproxy, additional network interfaces for
neutron, etc).


Creating new deployment (Cluster level)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Determine which systems should be used in the new solution (nova, neutron,
ceph, horizon, …). If all necessary systems was already created and included
into global system level, than it can be just included.


Making changes to existing models
---------------------------------

When you decided to add or modify some options in the existing models, that
the right place of the modification should be considered depending of the
severity of the change:


Updating existing formula (Service level)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Change the model in salt-formula-<service-name> for some global improvements.
For example: if the change is related to the change in the new package version
of this service; the change is fixing some bug or improve
performance or security of the service and should be applied for every
cluster.

Example where the common changes can be applied to the service:
https://github.com/openstack/salt-formula-horizon/tree/
master/metadata/service/server/


Updating business unit (System level)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Change the system level for a specific application, if the base services don’t
provide required configurations for the application functionality. Example
where the application-related change can be applied to the service,


Updating deployment configurations (Cluster level)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Changes on the cluster level are related to the requirements that are specific
for this particular cluster solution, for example: number and names of nodes;
domain name; IP addresses; network interface names and configurations;
locations of the specific ‘systems’ on the specific nodes; and other things
that are used by formulas for services.

--------------

.. include:: navigation.txt
