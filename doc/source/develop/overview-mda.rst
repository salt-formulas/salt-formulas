`Home <index.html>`_ SaltStack-Formulas Development Documentation

Model-driven architectures with Salt-formulas
=============================================

Model Driven Architecture (MDA) is an answer to growing complexity of systems
controlled by configuration management tools. It provides unified node
classification with atomic service definitions.

Following list shows core principles of model-driven architectures.

Atomicity

  Services are serated at such level of granularity that.

Reusability/replacibility

  Different services serving same role can be replaced without affecting
  neigbouring services.

System roles

  Services may implement various roles, most often client/server variations.

Dynamic resources

  Service metadata must be alwyas available for dynamically created resources.

Change management

  The strength lies not in descibing the static state of service but more the
  process of everchanging improvements.


Sample MDA Scenario
~~~~~~~~~~~~~~~~~~~~~~

Following image show example system that has reasonable amount of services
with some outsourced by 3rd party providers. The OpenStack architecture is too
big to fit here.

.. figure:: /_images/openstack_system.png
  :width: 100%
  :align: center

We can identify several layers within the largers application systems.

* Proxy layer - Distributing load to application layer
* Application layer - Application with caches
* Persistence layer - Databases

.. figure:: /_images/mda_system_composition.png
  :width: 100%
  :align: center

Application systems are supported by shared subsystems that span across
multiple application systems. These usually are:

- Access & control system - SSH access, orchestration engine access, user authentication
- Monitoring system - Events and metric collections
- Essential systems - DNS, NTP, MTA clients


Service Decomposition 
~~~~~~~~~~~~~~~~~~~~~

The following chapter shows service decomposition of GitLab all-in-one box.

Server level
^^^^^^^^^^^^

Servers contain one or more systems that bring business value and several
maintenance systems that are common to any node. Following list shows basic
systems at almost any node.

- Application systems - Business Logic implementations
- Access & control system - SSH access, orchestration engine access, user authentication
- Monitoring system - Events and metric collections
- Essential systems - DNS, NTP, MTA clients

Systems can be seen at following picture.

.. figure:: /_images/meta_host.png
  :width: 100%
  :align: center

Multiple servers with various systems can are defined by the reclass
definition to aleviate node definitions.


.. code-block:: yaml

    reclass:
      storage:
        node:
          tpc_int_prd_vcs01:
            name: vcs01
            domain: int.prd.tcp.cloudlab.cz
            classes:
            - system.linux.system.kvm
            - system.openssh.server.team.tcpcloud
            - system.gitlab.server.single
            params:
              salt_master_host: ${_param:reclass_config_master}
              gitlab_server_version: '7.7'
              gitlab_server_name: git.tcpcloud.eu
              gitlab_server_email: gitlab@robotice.cz
              gitlab_client_host: git.tcpcloud.eu
              gitlab_client_token: <redacted>
              nginx_site_gitlab_ssl_authority: <redacted>
              nginx_site_gitlab_server_host: git.tcpcloud.eu
              mysql_admin_password: <redacted>
              mysql_gitlab_password: <redacted>
          tpc_int_prd_svc01:
            ..
          tpc_int_prd_svc0N:
            ..

The actual generated definition is in the following code. All of the logic is
encapuslated by system that are customised by set of parameteres, some of
which may be GPG encrypted. This is better form to use in development as
reclass powered metadata requires explicit state declaration that may not be
automatic and just bothers at development stage.

.. code-block:: yaml

    classes:
    - system.linux.system.kvm
    - system.openssh.server.team.tcpcloud
    - system.gitlab.server.single
    parameters:
      _param:
        salt_master_host: master1.robotice.cz
        mysql_admin_password: <redacted>
        gitlab_client_token: <redacted>
        gitlab_server_name: git.tcpcloud.eu
        gitlab_client_host: git.tcpcloud.eu
        mysql_gitlab_password: <redacted>
        nginx_site_gitlab_server_host: git.tcpcloud.eu
        gitlab_server_email: gitlab@robotice.cz
        gitlab_server_version: '7.7'
        nginx_site_gitlab_ssl_authority: <redacted>
      linux:
        system:
          name: vcs01
          domain: int.prd.tcp.cloudlab.cz

System level
^^^^^^^^^^^^

There are usually multiple systems on each server that may span one or more
servers. There are defintions of all-in-one solutions for common systems for
development purposes.

.. figure:: /_images/meta_system.png
  :width: 100%
  :align: center

The systems are classified by simple following rule. 

Single

  Usually all-in-one application system on a node (Taiga, Gitlab)

Multi

  Multiple all-in-one application systems on a node (Horizon, Wordpress)

Cluster

  Node is par of larger cluster of nodes (OpenStack controllers, larger webapp
  applications)

Redis itself does not form any system but is part of many well know
applications, the following example shows usage of Redis within complex Gitlab
system.

.. code-block:: yaml

    classes:
    - service.git.client
    - service.gitlab.server.single
    - service.nginx.server.single
    - service.mysql.server.local
    - service.redis.server.local
    parameters:
      _param:
        nginx_site_gitlab_host: ${linux:network:fqdn}
        mysql_admin_user: root
        mysql_admin_password: password
        mysql_gitlab_password: password
      mysql:
        server:
          database:
            gitlab:
              encoding: UTF8
              locale: cs_CZ
              users:
              - name: gitlab
                password: ${_param:mysql_gitlab_password}
                host: 127.0.0.1
                rights: all privileges
      nginx:
        server:
          site:
            gitlab_server:
              enabled: true
              type: gitlab
              name: server
              ssl:
                enabled: true
                authority: ${_param:nginx_site_gitlab_ssl_authority}
                certificate: ${_param:nginx_site_gitlab_host}
                mode: secure
              host:
                name: ${_param:nginx_site_gitlab_server_host}
                port: 443

Service level
^^^^^^^^^^^^^^^^^^^^

The services are the atomic units of config management. SaltStack formula or
Puppet recipe with default metadata set can be considered as a service. Each
service implements one or more roles and together with other services form
systems. Following list shows decomposition

- Formula - Set of states that perform together atomic service
- State - Declarative definition of various resources (package, files, services)
- Module - Imperative interaction enforcing defined state for each State

Given Redis formula from Gitlab example we set basic set of parametes that can
be used for actual service configuration as well as support services
configuration.


.. figure:: /_images/meta_service.png
  :width: 100%
  :align: center

Following code shows sample Redis formula showing several states: pkg, systl,
file and service.

.. code-block:: yaml

    {%- from "redis/map.jinja" import server with context %}
    {%- if server.enabled %}

    redis_packages:
      pkg.installed:
      - names: {{ server.pkgs }}

    vm.overcommit_memory:
      sysctl.present:
        - value: 1

    {{ server.conf_dir }}:
      file.managed:
      - source: {{ conf_file_source }}
      - template: jinja
      - user: root
      - group: root
      - mode: 644
      - require:
        - pkg: redis_packages

    redis_service:
      service.running:
      - enable: true
      - name: {{ server.service }}
      - watch:
        - file: {{ server.conf_dir }}

    {%- endif %}

Along with the actual definition of node there are service level metadata
fragments for common situations. Following fragment shows localhost only Redis
database.

.. code-block:: yaml

    applications:
    - redis
    parameters:
      redis:
        server:
          enabled: true
          bind:
            address: 127.0.0.1
            port: 6379
            protocol: tcp

Service Decomposition 
~~~~~~~~~~~~~~~~~~~~~

reclass has some features that make it unique:

- Including and deep merging of data structures through usage of classes
- Parameter interpolation for cross-referencing parameter values

The system aggregation level:

.. code-block:: yaml

    classes:
    - system.linux.system.kvm
    - system.openssh.server.team.tcpcloud
    - system.gitlab.server.single
    parameters:
      _param:
        salt_master_host: master1.robotice.cz
        mysql_admin_password: <redacted>
        gitlab_client_token: <redacted>
        gitlab_server_name: git.tcpcloud.eu
        gitlab_client_host: git.tcpcloud.eu
        mysql_gitlab_password: <redacted>
        nginx_site_gitlab_server_host: git.tcpcloud.eu
        gitlab_server_email: gitlab@robotice.cz
        gitlab_server_version: '7.7'
        nginx_site_gitlab_ssl_authority: <redacted>

The single system level:

.. code-block:: yaml

    classes:
    - service.git.client
    - service.gitlab.server.single
    - service.nginx.server.single
    - service.mysql.server.local
    - service.redis.server.local
    parameters:
      _param:
        nginx_site_gitlab_host: ${linux:network:fqdn}
        mysql_admin_user: root
        mysql_admin_password: password
        mysql_gitlab_password: password

The single service level:

.. code-block:: yaml

    applications:
    - redis
    parameters:
      redis:
        server:
          enabled: true
          bind:
            address: 127.0.0.1
            port: 6379
            protocol: tcp

--------------

.. include:: navigation.txt
