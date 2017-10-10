`Home <index.html>`_ SaltStack-Formulas Development Documentation

============================
Formula Authoring Guidelines
============================

.. contents::
    :backlinks: none
    :local:

Salt formulas encapsulate specific services. This document contains guidelines
to salt formula creation and maintenance.


Formula Directory Structure
===========================

Formulas follow the same directory structure as Salt official `conventions <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_ and `best practices <http://docs.saltstack.com/en/latest/topics/best_practices.html>`_ described in the SaltStack documentation.

Every formula should have the following directory layout:

.. code-block:: text

    service-formula
    |-- _grains/
    |   `-- service.yml
    |-- _modules/
    |   `-- service.yml
    |-- _states/
    |   `-- service.yml
    |-- service/
    |   `-- files/
    |       |-- service.conf
    |       `-- service-systemd
    |   `-- meta/
    |       |-- sphinx.yml
    |       `-- colletd.yml
    |   |-- map.jinja
    |   |-- init.sls
    |   |-- _common.sls
    |   |-- role1.sls
    |   `-- role2/
    |       |-- init.sls
    |       |-- service.sls
    |       `-- more.sls
    |-- debian/
    |   ├── changelog
    |   ├── compat
    |   ├── control
    |   ├── copyright
    |   ├── docs
    |   ├── install
    |   ├── rules
    |   └── source
    |       └── format
    |-- metadata/
    |   `-- service/
    |       |-- role1/
    |       |   |-- deployment1.yml
    |       |   `-- deployment2.yml
    |       `-- role2/
    |           `-- deployment3.yml
    |-- CHANGELOG.rst
    |-- LICENSE
    |-- pillar.example
    |-- README.rst
    `-- VERSION

Content of the formula directories in more detail.

**_grains/**
  Optional grain modules

**_modules/**
  Optional execution modules

**_states/**
  Optional state modules

**service/**
  Salt state files

**service/meta/**
  Support metadata definitions

**debian/**
  APT Package metadata

**metadata/**
  Reclass metadata


Salt state files
================

Salt state files are located in ``service`` directory.


``service/map.jinja``
---------------------

Map file helps to clean the differences among operating systems and provides
default values so there's no need to provide default value in state files.

Following snippet uses YAML to serialize the data and is the recommended way
to write ``map.jinja`` file as YAML can be easily extended in place.

.. code-block:: text

    {%- load_yaml as role1_defaults %}
    Debian:
      pkgs:
      - python-psycopg2
      dir:
        base: /srv/service/venv
        home: /var/lib/service
    RedHat:
      pkgs:
      - python-psycopg2
      dir:
        base: /srv/service/venv
        home: /var/lib/service
        workspace: /srv/service/workspace
    {%- endload %}

    {%- set role1 = salt['grains.filter_by'](role1_defaults, merge=salt['pillar.get']('service:role1')) %}

Following snippet uses JSON to serialize the data and was favored in past.

.. code-block:: text

    {% set api = salt['grains.filter_by']({
        'Debian': {
            'pkgs': ['salt-api'],
            'service': 'salt-api',
        },
        'RedHat': {
            'pkgs': ['salt-api'],
            'service': 'salt-api',
        },
    }, merge=salt['pillar.get']('salt:api')) %}

Following snippet sets different common role parameters according to
``service:role:source:engine`` pillar variable of given service role.

.. code-block:: text

    {%- set source_engine = salt['pillar.get']('service:role:source:engine') %}

    {%- load_yaml as base_defaults %}
    {%- if source_engine == 'git' %}
    Debian:
      pkgs:
      - python-psycopg2
      dir:
        base: /srv/service/venv
        home: /var/lib/service
        workspace: /srv/service/workspace
    {%- else %}
    Debian:
      pkgs:
      - helpdesk
      dir:
        base: /usr/lib/service
    {%- endif %}
    {%- endload %}


``service/init.sls``
--------------------

Conditional include of individual service roles. Basically this is essential
piece that makes the usage of formulas truly model-driven. You have catalog of
services and this determines according to present metadata what roles get
started. 

Using ``service/init.sls`` file allows the service catalog to be role
independent.

.. code-block:: text

    include:
    {% if pillar.service.role1 is defined %}
    - service.role1
    {% endif %}
    {% if pillar.service.role2 is defined %}
    - service.role2
    {% endif %}

You can use one file as ``role1.sls`` for simple roles. For more complex roles
handling many resources, use individual directories as ``role2``.

.. code-block:: text

    service-formula/
    `-- service/
        |-- role1.sls
        `-- role2/
            |-- init.sls
            |-- service.sls
            |-- resource1.sls
            `-- resource2.sls

Then you can verify the full service catalog on node by following command:

.. code-block:: bash

    root@web01:~# salt-call state.show_top
    [INFO    ] Loading fresh modules for state activity
    local:
        ----------
        base:
            - linux
            - openssh
            - ntp
            - salt
            - backupninja
            - git
            - sphinx
            - python
            - nginx
            - nodejs
            - postgresql
            - rabbitmq
            - redis
            - ruby

Service metadata are stored also as ``services`` grain.

.. code-block:: bash

    root@web01:~# salt-call grains.item services
    local:
        ----------
        services:
            - linux
            - openssh
            - ntp
            - salt
            - backupninja
            - git
            - sphinx
            - python
            - nginx
            - nodejs
            - postgresql
            - rabbitmq
            - redis
            - ruby

And each service roles metadata is stored as detailed ``roles`` grain.

.. code-block:: bash

    root@web01:~# salt-call grains.item roles
    local:
        ----------
        roles:
            - git.client
            - postgresql.server
            - nodejs.environment
            - ntp.client
            - linux.storage
            - linux.system
            - linux.network
            - redis.server
            - rabbitmq.server
            - python.environment
            - backupninja.client
            - nginx.server
            - openssh.client
            - openssh.server
            - salt.minion
            - sphinx.server

.. note::

   It is recommended to run ``state.sls salt`` prior the ``state.highstate``
   command as grains may not be generated properly and some configuration
   parameters may not be set at all.


``service/role1.sls``
---------------------

Actual salt state resources that enforce service existence. Common production
and recommended pattern is to install packages, setup configuration files and
ensure the service is up and running.

.. code-block:: text

    {%- from "redis/map.jinja" import server with context %}
    {%- if server.enabled %}

    redis_packages:
      pkg.installed:
      - names: {{ server.pkgs }}

    {{ server.dir.conf }}/redis.conf:
      file.managed:
      - source: salt://redis/files/redis.conf
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
        - file: {{ server.dir.conf }}/redis.conf

    {%- endif %}

For development purposes other installation than s

.. note::

   The role for ``role.enabled`` condition is to restrict the give service
   role from execution with default parametes, the single error is thrown
   instead. You can optionaly add ``else`` statement to disable or completely
   remove given service role.

   
``service/role2/init.sls``
--------------------------

This approach is used with more complex roles, it is similar to
``service/init.sls``, but uses conditions to further limit the inclusion of
unnecessary files.

For example Linux network role includes conditionally hosts and interfaces.

.. code-block:: text

    {%- from "linux/map.jinja" import network with context %}
    include:
    - linux.network.hostname
    {%- if network.host|length > 0 %}
    - linux.network.host
    {%- endif %}
    {%- if network.interface|length > 0 %}
    - linux.network.interface
    {%- endif %}
    - linux.network.proxy


Coding styles for state files
-----------------------------

Good styling practices for writing salt state declarations.


Line length above 80 characters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As a 'standard code width limit' and for historical reasons - IBM punch card
had exactly 80 columns.


Single line declaration
~~~~~~~~~~~~~~~~~~~~~~~

Avoid extending your code by adding single-line declarations. It makes your
code much cleaner and easier to parse / grep while searching for those
declarations.

The bad example:

.. code-block:: text

  python:
    pkg:
      - installed

The correct example:

.. code-block:: text

    python:
      pkg.installed


No newline at the end of the file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each line should be terminated in a newline character, including the last one.
Some programs have problems processing the last line of a file if it isn't
newline terminated.


Trailing whitespace characters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Trailing whitespaces take more spaces than necessary, any regexp based
searches won't return lines as a result due to trailing whitespace(s).


Reclass metadata files
======================

Each of these files serve as default metadata set for given deployment. Each
service role can have several deployments. For example rabbitmq server role
has following deployments:

* metadata/rabbitmq/server/local.yml
* metadata/rabbitmq/server/single.yml
* metadata/rabbitmq/server/cluster.yml


``metadata/service/role1/local.yml``
------------------------------------

.. code-block:: yaml

    applications:
    - rabbitmq
    parameters:
      _param:
        rabbitmq_admin_user: admin
      rabbitmq:
        server:
          enabled: true
          secret_key: ${_param:rabbitmq_secret_key}
          bind:
            address: 127.0.0.1
            port: 5672
          plugins:
          - amqp_client
          - rabbitmq_management
          admin:
            name: ${_param:rabbitmq_admin_user}
            password: ${_param:rabbitmq_admin_password}


``metadata/service/role1/single.yml``
-------------------------------------

.. code-block:: yaml

    applications:
    - rabbitmq
    parameters:
      _param:
        rabbitmq_admin_user: admin
      rabbitmq:
        server:
          enabled: true
          secret_key: ${_param:rabbitmq_secret_key}
          bind:
            address: 0.0.0.0
            port: 5672
          plugins:
          - amqp_client
          - rabbitmq_management
          admin:
            name: ${_param:rabbitmq_admin_user}
            password: ${_param:rabbitmq_admin_password}


``metadata/service/role1/cluster.yml``
--------------------------------------

.. code-block:: yaml

    applications:
    - rabbitmq
    parameters:
      rabbitmq:
        server:
          enabled: true
          secret_key: ${_param:rabbitmq_secret_key}
          bind:
            address: ${_param:cluster_local_address}
            port: 5672
          plugins:
          - amqp_client
          - rabbitmq_management
          admin:
            name: admin
            password: ${_param:rabbitmq_admin_password}
          host:
            '/openstack':
              enabled: true
              user: openstack
              password: ${_param:rabbitmq_openstack_password}
              policies:
              - name: HA
                pattern: '^(?!amq\.).*' 
                definition: '{"ha-mode": "all"}'
        cluster:
          enabled: true
          name: openstack
          role: ${_param:rabbitmq_cluster_role}
          master: ${_param:cluster_node01_hostname}
          mode: disc
          members:
          - name: ${_param:cluster_node01_hostname}
            host: ${_param:cluster_node01_address}
          - name: ${_param:cluster_node02_hostname}
            host: ${_param:cluster_node02_address}
          - name: ${_param:cluster_node03_hostname}
            host: ${_param:cluster_node03_address}


Parameters like ``${_param:rabbitmq_secret_key}`` are interpolation of common
parameter passed from higher system or cluster levels.


Debian packaging
================

Use of debian packaging is preferable way for deploying production salt
masters and it's formulas. Take basic structure of ``debian`` directory from
some existing formula and modify to suit your formula.

Description of most important files follows.


``debian/changelog``
--------------------

::

  salt-formula-salt (0.1) trusty; urgency=medium

    + Initial release

   -- Ales Komarek <ales.komarek@tcpcloud.eu> Thu, 13 Aug 2015 23:23:41 +0200


``debian/copyright``
--------------------

Licensing informations of the package.

::

  Format: http://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
  Upstream-Name: salt-formula-salt
  Upstream-Contact: Ales Komarek <ales.komarek@tcpcloud.eu>
  Source: https://github.com/tcpcloud/salt-formula-salt

  Files: *
  Copyright: 2014-2015 tcp cloud a.s.
  License: Apache-2.0
    Copyright (C) 2014-2015 tcp cloud a.s.
    .
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    .
    On a Debian system you can find a copy of this license in
    /usr/share/common-licenses/Apache-2.0.


``debian/docs``
---------------

Files listed here will be available in ``/usr/share/doc``.
Don't put COPYRIGHT or LICENSE files here as they are handled in a different
way.


::

  README.rst
  CHANGELOG.rst
  VERSION


``debian/install``
------------------

Defines what is going to be installed in which location.

::

  salt/*                  /usr/share/salt-formulas/env/salt/
  metadata/service/*      /usr/share/salt-formulas/reclass/service/salt/


``debian/control``
------------------

This file keeps metadata of source and binary package.

::

   Source: salt-formula-salt
   Maintainer: tcpcloud Packaging Team <pkg-team@tcpcloud.eu>
   Section: admin
   Priority: optional
   Build-Depends: debhelper (>= 9)
   Standards-Version: 3.9.6
   Homepage: http://www.tcpcloud.eu
   Vcs-Browser: https://github.com/tcpcloud/salt-formula-salt
   Vcs-Git: https://github.com/tcpcloud/salt-formula-salt.git

   Package: salt-formula-salt
   Architecture: all
   Depends: ${misc:Depends}, salt-master, reclass
   Description: Salt salt formula
    Install and configure Salt masters and minions.

Supplemental files
==================

Files that are required to complete information about given formula.

``README.rst``
--------------

A sample skeleton of the ``README.rst`` file:

.. code-block:: rest

    =======
    service
    =======

    Install and configure the Specific service.

    .. note::

        See the full `Salt Formulas installation and usage instructions
        <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

    Available states
    ================

    .. contents::
        :local:

    ``service``
    -----------

    Install the ``service`` package and enable the service.

    ``service.role1``
    -----------------

    Setup individual role.


    Available metadata
    ==================

    .. contents::
        :local:

    ``metadata.service.role.single``
    ----------------------------------

    Setup from system packages.


    ``metadata.service.role.development`
    --------------------------------------

    Setup from git repository.


    Configuration parameters
    ========================

    .. contents::
        :local:

    ``service_secret_key``
    ------------------------------

    ``rabbitmq_service_password``
    -------------------------------------

    ``postgresql_service_password``
    ---------------------------------------

    If development is setup.

    ``service_source_revision``
    ---------------------------

    If development is setup.

    Example reclass
    ===============

    Production setup

    .. code-block:: yaml

        service-single:
          name: service-single
          domain: dev.domain.com
          classes:
          - system.service.server.single
          params:
            rabbitmq_admin_password: cwerfwefzdcdsf
            rabbitmq_secret_key: fsdfwfdsfdsf
            rabbitmq_service_password: fdsf24fsdfsdacadf
            keystone_service_password: fdasfdsafdasfdasfda
            postgresql_service_password: dfdasfdafdsa
            nginx_site_service_host: ${linux:network:fqdn}
            service_secret_key: fda32r

    Development setup

    .. code-block:: yaml

        service-single:
          name: service-single
          domain: dev.domain.com
          classes:
          - system.service.server.development
          params:
            rabbitmq_admin_password: cwerfwefzdcdsf
            rabbitmq_secret_key: fsdfwfdsfdsf
            rabbitmq_service_password: fdsf24fsdfsdacadf
            keystone_service_password: fdasfdsafdasfdasfda
            postgresql_service_password: dfdasfdafdsa
            nginx_site_service_host: ${linux:network:fqdn}
            service_secret_key: fda32r
            service_source_repository: git@git.tcpcloud.eu:python-apps/service.git
            service_source_revision: feature/243


    Example pillar
    ==============

    Install from specific branch of Git

    .. code-block:: yaml

       service:
         server:
           source:
             engine: 'git'
             address: 'git@git.tcpcloud.eu:python-apps/service.git'
             revision: 'feature/214'

    To enable debug logging for both Django and Gunicorn and raise
    number of Gunicorn workers

    .. code-block:: yaml

       service:
         server:
           log_level: 'debug'
           workers: 8

    To change where Django listens

    .. code-block:: yaml

       service:
         server:
           bind:
             address: 'not-localhost'
             port: 9755

    Read more
    =========

    * http://doc.tcpcloud.eu/


``LICENSE``
-----------

Contains license information and terms & conditions how you are allowed to use
and distribute the files of the underlying directories.

.. code-block:: text

      Copyright (c) 2014-2015 Your name

      Licensed under the Apache License, Version 2.0 (the "License");
      you may not use this file except in compliance with the License.
      You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

      Unless required by applicable law or agreed to in writing, software
      distributed under the License is distributed on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
      See the License for the specific language governing permissions and
      limitations under the License.


``VERSION``
-----------

Latest version number, git repository tag, package version as well.

.. code-block:: text

    0.0.2


``CHANGELOG.rst``
-----------------

The ``CHANGELOG.rst`` file should detail the individual versions, their
release date and a set of bullet points for each version highlighting the
overall changes in a given version of the formula.

A sample skeleton of the `CHANGELOG.rst` file:

:file:`CHANGELOG.rst`:

.. code-block:: rest

    service formula
    ===============

    0.0.2 (2014-01-01)

    - Re-organized formula file layout
    - Fixed filename used for upstart logger template
    - Allow for pillar message to have default if none specified

    0.0.1 (2013-01-01)

    - Initial formula setup


Versioning
~~~~~~~~~~

Formula are versioned according to Semantic Versioning, http://semver.org/.

.. note::

    Given a version number MAJOR.MINOR.PATCH, increment the:

    #. MAJOR version when you make incompatible API changes,
    #. MINOR version when you add functionality in a backwards-compatible manner, and
    #. PATCH version when you make backwards-compatible bug fixes.

    Additional labels for pre-release and build metadata are available as
    extensions to the MAJOR.MINOR.PATCH format.

Formula versions are tracked using Git tags as well as the ``VERSION`` file in
the formula repository. The ``VERSION`` file should contain the currently
released version of the particular formula.


Formula unit testing
====================

A smoke-test for invalid Jinja, invalid YAML, or an invalid Salt state
structure can be performed by with the ``state.show_sls`` function:

.. code-block:: bash

    salt '*' state.show_sls service-name

Salt Formulas can then be tested by running each ``.sls`` file via
``state.sls`` and checking the output for the success or failure of each state
in the Formula. This should be done for each supported platform.

.. code-block:: bash

    salt '*' state.sls sls-file-name test


More information
================

* http://docs.saltstack.com/en/latest/topics/best_practices.html
* http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html
* http://docs.saltstack.com/en/latest/topics/development/conventions/style.html

--------------

.. include:: navigation.txt
