`Home <index.html>`_ SaltStack-Formulas Development Documentation

Formula ecosystem
=================

The SaltStack-Formulas formulas are divided into several groups according to their purpose. Formulas share same structure and metadata definions, expose vital information into the Salt Mine for monitoring and audit.

**Infrastructure services**
  Core services needed for basic infrastructure operation.

**Supplemental services**
  Support services as databases, proxies, application servers.

**OpenStack services**
  All supported OpenStack cloud platform services.

**Monitoring services**
  Monitoring, metering and log collecting tools implementing complete monitoring stack.

**Integration services**
  Continuous integration services for automated integration and delivery pipelines.

Each of the service groups contain of several individual service formulas, listed in following tables.


Infrastructure services
-----------------------

Core services needed for basic infrastructure operation.

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - foreman
      - https://github.com/salt-formulas/salt-formula-foreman
   *  - freeipa
      - https://github.com/salt-formulas/salt-formula-freeipa
   *  - git
      - https://github.com/salt-formulas/salt-formula-git
   *  - glusterfs
      - https://github.com/salt-formulas/salt-formula-glusterfs
   *  - iptables
      - https://github.com/salt-formulas/salt-formula-iptables
   *  - linux
      - https://github.com/salt-formulas/salt-formula-linux
   *  - maas
      - https://github.com/salt-formulas/salt-formula-maas
   *  - ntp
      - https://github.com/salt-formulas/salt-formula-ntp
   *  - openssh
      - https://github.com/salt-formulas/salt-formula-openssh
   *  - reclass
      - https://github.com/salt-formulas/salt-formula-reclass
   *  - salt
      - https://github.com/salt-formulas/salt-formula-salt

.. toctree::

   ../_files/formulas/git/README.rst
   ../_files/formulas/glusterfs/README.rst
   ../_files/formulas/linux/README.rst
   ../_files/formulas/openssh/README.rst
   ../_files/formulas/reclass/README.rst
   ../_files/formulas/salt/README.rst


Supplemental services
---------------------

Support services as databases, proxies, application servers.

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - apache
      - https://github.com/salt-formulas/salt-formula-apache
   *  - bind
      - https://github.com/salt-formulas/salt-formula-bind
   *  - dovecot
      - https://github.com/salt-formulas/salt-formula-dovecot
   *  - elasticsearch
      - https://github.com/salt-formulas/salt-formula-elasticsearch
   *  - galera
      - https://github.com/salt-formulas/salt-formula-galera
   *  - git
      - https://github.com/salt-formulas/salt-formula-git
   *  - haproxy
      - https://github.com/salt-formulas/salt-formula-haproxy
   *  - keepalived
      - https://github.com/salt-formulas/salt-formula-keepalived
   *  - letsencrypt
      - https://github.com/salt-formulas/salt-formula-letsencrypt
   *  - memcached
      - https://github.com/salt-formulas/salt-formula-memcached
   *  - mongodb
      - https://github.com/salt-formulas/salt-formula-mongodb
   *  - mysql
      - https://github.com/salt-formulas/salt-formula-mysql
   *  - nginx
      - https://github.com/salt-formulas/salt-formula-nginx
   *  - postfix
      - https://github.com/salt-formulas/salt-formula-postfix
   *  - postgresql
      - https://github.com/salt-formulas/salt-formula-postgresql
   *  - rabbitmq
      - https://github.com/salt-formulas/salt-formula-rabbitmq
   *  - redis
      - https://github.com/salt-formulas/salt-formula-redis
   *  - supervisor
      - https://github.com/salt-formulas/salt-formula-supervisor
   *  - varnish
      - https://github.com/salt-formulas/salt-formula-varnish


OpenStack services
------------------

All supported OpenStack cloud platform services.

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - ceilometer
      - https://github.com/salt-formulas/salt-formula-ceilometer
   *  - cinder
      - https://github.com/salt-formulas/salt-formula-cinder
   *  - glance
      - https://github.com/salt-formulas/salt-formula-glance
   *  - heat
      - https://github.com/salt-formulas/salt-formula-heat
   *  - horizon
      - https://github.com/salt-formulas/salt-formula-horizon
   *  - keystone
      - https://github.com/salt-formulas/salt-formula-keystone
   *  - magnum
      - https://github.com/salt-formulas/salt-formula-magnum
   *  - midonet
      - https://github.com/salt-formulas/salt-formula-midonet
   *  - murano
      - https://github.com/salt-formulas/salt-formula-murano
   *  - neutron
      - https://github.com/salt-formulas/salt-formula-neutron
   *  - nova
      - https://github.com/salt-formulas/salt-formula-nova
   *  - opencontrail
      - https://github.com/salt-formulas/salt-formula-opencontrail
   *  - swift
      - https://github.com/salt-formulas/salt-formula-swift


Monitoring services
-------------------

Monitoring, metering and log collecting tools implementing complete monitoring stack.

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - collectd
      - https://github.com/salt-formulas/salt-formula-collectd
   *  - graphite
      - https://github.com/salt-formulas/salt-formula-graphite
   *  - heka
      - https://github.com/salt-formulas/salt-formula-heka
   *  - kibana
      - https://github.com/salt-formulas/salt-formula-kibana
   *  - sensu
      - https://github.com/salt-formulas/salt-formula-sensu
   *  - sphinx
      - https://github.com/salt-formulas/salt-formula-sphinx
   *  - statsd
      - https://github.com/salt-formulas/salt-formula-sensu


Integration services
--------------------

Continuous integration services for automated integration and delivery pipelines.

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - aptly
      - https://github.com/salt-formulas/salt-formula-aptly
   *  - gerrit
      - https://github.com/salt-formulas/salt-formula-gerrit
   *  - gitlab
      - https://github.com/salt-formulas/salt-formula-gitlab
   *  - jenkins
      - https://github.com/salt-formulas/salt-formula-jenkins
   *  - owncloud
      - https://github.com/salt-formulas/salt-formula-owncloud
   *  - roundcube
      - https://github.com/salt-formulas/salt-formula-roundcube
