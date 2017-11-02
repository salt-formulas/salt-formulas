`Home <index.html>`_ SaltStack-Formulas Project Introduction

========================
Common Metadata Patterns
========================

.. contents::
    :backlinks: none
    :local:

When working with metadata a lot of common patterns emerge over the time. The
formulas reuse these patterns to maintain the cross-formula consistency.


Creating Service Metadata
=========================

Following points are selected as the most frequently asked questions and try
to explain the design patters behind our metadata modes.


Service Formula Roles
---------------------

The service roles provide level of separation for the formulas, if your
service can be split across multiple nodes you should use the role. You can
imagine role as simple kubernetes Kubernetes Pods. For example a ``sensu``
formula has following roles defined:

**server**

  Definion of server service that sends commands to the clients andconsumes
  the responses.

**client**

  Client role is installed on each of the client nodes and uses the support
  metadata concept to get the metadata from installed services.

**dashoboard**
  
  Optional definion of Uchiwa dashboard.

You monitoring node can have all 3 roles running on single node, and that is completely OK.


Scalar Parameters
-----------------

Always keep in mind that we model the resources not the configurations.
However tempting can it be to just iterate the config dictionaries and adding
all the values, it is not recommended. This approach prevents further
parameter schema definition as well as allowing to add the defaults, etc.

Don't do following snippet, it may save you same at the start but with at the
price of untestable and unpredictable results:

.. warning::

  .. code-block:: yaml

    service:
      role:
        config:
          option1: value1
          ...
          optionN: valueN


Common Service Metadata
-----------------------

When some metadata is reused by multiple roles it is possible to add the new
virtual `common` role definition. This common metadata should be then
available to every role.

The definition in the pillar metadata file:

.. code-block:: yaml

  service:
    common:
      param1: value1
      ...
      paramN: valueN

And the corresponding code for joining the metadata in the ``map.jinja``.

.. code-block:: jinja

  {% set raw_server = salt['grains.filter_by']({
      'Debian': {...},
  }, merge=salt['pillar.get']('memcached:common')) %}

  {% set server = raw_server, merge=salt['pillar.get']('memcached:server')) %}


Modelling and Iterating Resource Sets
-------------------------------------

Resource sets are resources provided by the service formula, for example for
MySQL and PostgreSQL formula ``database`` is a resource set, for NGINX or
Apache formula a member of resource set is ``vhost``. Users, repositories,
packages, jobs, interfaces, routes, mounts etc in the Linux formula are also
good example of this pattern.

.. code-block:: yaml

  mysql:
    server:
      database:
        database_name:
          param1: value1
          param2: value2

Following snippet shows defined `virtual hosts` for the Nginx.

.. code-block:: yaml

  nginx:
    server:
      vhost:
        vhost_name:
          param1: value1
          param2: value2


Service Network Binding
-----------------------

You can define the address and port on whis the service listens in simple way.
For single network binding you can use following code.

.. code-block:: yaml

  memcached:
    server:
      enabled: true
      maxconn: 8192
      bind:
        address: 0.0.0.0
        port: 11211
        protocol: tcp


Service Backend Structure
-------------------------

When service plugin mechanism allows to add arbitrary plugins to the
individual roles, it is advised to use following format. Following snippet
shows multiple defined backends, in this case it's pillar data sources.

.. code-block:: yaml

  salt:
    master:
      pillar:
        engine: composite
        reclass:
          index: 1
          storage_type: yaml_fs
          inventory_base_uri: /srv/salt/reclass
          propagate_pillar_data_to_reclass: False
          ignore_class_notfound: False
        saltclass:
          path: /srv/salt/saltclass
        nacl:
          index: 99

.. note::

    The reason for existence of ``engine`` parameter is to separate various
    implementations. For relational databases we can determine what specific
    database is used to construct proper connection strings.


Client Relationship
-------------------

The client relationship has form of a dictionary. The name of the dictionary
represents the required role [database, cache, identity] and the `engine`
parameter then refers to the actual implementation. Following snippet shows
single service to service relation.

.. code-block:: yaml

  keystone:
    server:
      message_queue:
        engine: rabbitmq
        host: 200.200.200.200
        port: 5672
        user: openstack
        password: redacted
        virtual_host: '/openstack'
        ha_queues: true

Following snippet shows backend with multiple members.

.. code-block:: yaml

  keystone:
    server:
      cache:
        engine: memcached
        members:
        - host: 200.200.200.200
          port: 11211
        - host: 200.200.200.201
          port: 11211
        - host: 200.200.200.202
          port: 11211


SSL Certificates
----------------

Multiple service use SSL certificates. There are several possible ways how to
obtain a certificate.

TODO


Using Service Support Metadata
==============================

You can think of support metadata as the k8s annotations for other services to
pickup and be configured accordingly. This concept is heavily used in the
definition of monitoring, documentation, etc.

Basics of Support Metadata
--------------------------

In formula there's ``meta`` directory, each service that needs to extract some
data has file with ``service.yml`` for example ``collectd.yml``, ``telegrag.yml``.


Service Documentation
---------------------

Following snippet shows how we can provide metadata for dynamic documentation
creation for Glance service.

.. code-block:: yaml

  doc:
    name: Glance
    description: The Glance project provides services for discovering, registering, and retrieving virtual machine images.
    role:
    {%- if pillar.glance.server is defined %}
    {%- from "glance/map.jinja" import server with context %}
      server:
        name: server
        endpoint:
          glance_api:
            name: glance-api
            type: glance-api
            address: http://{{ server.bind.address }}:{{ server.bind.port }}
            protocol: http
          glance_registry:
            name: glance-registry
            type: glance-registry
            address: http://{{ server.registry.host }}:{{ server.registry.port }}
            protocol: http
        param:
          bind:
            value: {{ server.bind.address }}:{{ server.bind.port }}
          version:
            name: "Version"
            value: {{ server.version }}
          workers:
            name: "Number of workers"
            value: {{ server.workers }}
          database_host:
            name: "Database"
            value: {{ server.database.user }}@{{ server.database.host }}:{{ server.database.port }}//{{ server.database.name }}
          message_queue_ip:
            name: "Message queue"
            value: {{ server.message_queue.user }}@{{ server.message_queue.host }}:{{ server.message_queue.port }}{{ server.message_queue.virtual_host }}
          identity_host:
            name: "Identity service"
            value: {{ server.identity.user }}@{{ server.identity.host }}:{{ server.identity.port }}
          storage_engine:
            name: "Glance storage engine"
            value: {{ server.storage.engine }}
          packages:
            value: |
              {%- for pkg in server.pkgs %}
              {%- set pkg_version = "dpkg -l "+pkg+" | grep "+pkg+" | awk '{print $3}'" %}
              * {{ pkg }}: {{ salt['cmd.run'](pkg_version) }}
              {%- endfor %}
    {%- endif %}



Service monitoring checks
-------------------------

Let's have our memcached service and look how the monitoring is defined for
this service.

We start with definitions of metric collections.

.. code-block:: yaml

  {%- from "memcached/map.jinja" import server with context %}
  {%- if server.get('enabled', False) %}
  agent:
    input:
      procstat:
        process:
          memcached:
            exe: memcached
      memcached:
        servers:
          - address: {{ server.bind.address | replace("0.0.0.0", "127.0.0.1") }}
            port: {{ server.bind.port }}
  {%- endif %}

We also define the functional monitoring for the collected metrics.

.. code-block:: yaml

  {%- from "memcached/map.jinja" import server with context %}
  {%- if server.get('enabled', False) %}
  server:
    alert:
      MemcachedProcessDown:
        if: >-
          procstat_running{process_name="memcached"} == 0
        {% raw %}
        labels:
          severity: warning
          service: memcached
        annotations:
          summary: 'Memcached service is down'
          description: 'Memcached service is down on node {{ $labels.host }}'
        {% endraw %}
  {%- endif %}

Also the definition of the dashboard for the collected metrics is provided.

.. code-block:: yaml

  dashboard:
    memcached_prometheus:
      datasource: prometheus
      format: json
      template: memcached/files/grafana_dashboards/memcached_prometheus.json
    memcached_influxdb:
      datasource: influxdb
      format: json
      template: memcached/files/grafana_dashboards/memcached_influxdb.json
    main_influxdb:
      datasource: influxdb
      row:
        ost-middleware:
          title: Middleware
          panel:
            memcached:
              title: Memcached
              links:
              - dashboard: Memcached
                title: Memcached
                type: dashboard
              target:
                cluster_status:
                  rawQuery: true
                  query: SELECT last(value) FROM cluster_status WHERE cluster_name = 'memcached' AND environment_label = '$environment' AND $timeFilter GROUP BY time($interval) fill(null)
    main_prometheus:
      datasource: prometheus
      row:
        ost-middleware:
          title: Middleware
          panel:
            memcached:
              title: Memcached
              links:
              - dashboard: Memcached
                title: Memcached
                type: dashboard
              target:
                cluster_status:
                  expr: avg(memcached_up) by (name)

This snippet appends panel to the main dashboard at grafana and creates a new
dashboard. The prometheus and influxdb time-series are supported out of box
throughout all formulas.


Virtual Machines versus Containers
==================================

The containers and services share great deal of parameters, but the way they
are delivered is differnt accross various container platforms.


Virtual machine service deployment models
-----------------------------------------

* local deployemnt
* single deployment
* cluster deployment


Container metadata requirements
-------------------------------

* Metadata for docker swarm
* Metadata for kubenetes


--------------

.. include:: navigation.txt

