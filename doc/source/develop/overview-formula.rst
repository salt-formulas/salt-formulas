`Home <index.html>`_ SaltStack-Formulas Development Documentation

Actual Formula Ecosystem
========================

The SaltStack-Formulas formulas are divided into several groups according to
their purpose. Formulas share same structure and metadata definions, expose
vital information into the Salt Mine for monitoring and audit.

**Infrastructure services**
  Core services needed for basic infrastructure operation.

**Supplemental services**
  Support services as databases, proxies, application servers.

**OpenStack services**
  All supported OpenStack cloud platform services.

**Monitoring services**
  Monitoring, metering and log collecting tools implementing complete
  monitoring stack.

**Integration services**
  Continuous integration services for automated integration and delivery
  pipelines.

Each of the service groups contain of several individual service formulas,
listed in following tables.


Infrastructure services
-----------------------

Core services needed for basic infrastructure operation.

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - backupninja
      - https://github.com/salt-formulas/salt-formula-backupninja
   *  - chrony
      - https://github.com/salt-formulas/salt-formula-chrony
   *  - freeipa
      - https://github.com/salt-formulas/salt-formula-freeipa
   *  - git
      - https://github.com/salt-formulas/salt-formula-git
   *  - glusterfs
      - https://github.com/salt-formulas/salt-formula-glusterfs
   *  - iptables
      - https://github.com/salt-formulas/salt-formula-iptables
   *  - letsecrypt
      - https://github.com/salt-formulas/salt-formula-letsecrypt
   *  - linux
      - https://github.com/salt-formulas/salt-formula-linux
   *  - network
      - https://github.com/salt-formulas/salt-formula-network
   *  - nfs
      - https://github.com/salt-formulas/salt-formula-nfs
   *  - ntp
      - https://github.com/salt-formulas/salt-formula-ntp
   *  - openssh
      - https://github.com/salt-formulas/salt-formula-openssh
   *  - openvpn
      - https://github.com/salt-formulas/salt-formula-openvpn
   *  - reclass
      - https://github.com/salt-formulas/salt-formula-reclass
   *  - salt
      - https://github.com/salt-formulas/salt-formula-salt
   *  - sphinx
      - https://github.com/salt-formulas/salt-formula-sphinx
   *  - squid
      - https://github.com/salt-formulas/salt-formula-squid

.. toctree::

   ../_files/formulas/backupninja/README.rst
   ../_files/formulas/chrony/README.rst
   ../_files/formulas/freeipa/README.rst
   ../_files/formulas/git/README.rst
   ../_files/formulas/glusterfs/README.rst
   ../_files/formulas/iptables/README.rst
   ../_files/formulas/letsencrypt/README.rst
   ../_files/formulas/linux/README.rst
   ../_files/formulas/network/README.rst
   ../_files/formulas/nfs/README.rst
   ../_files/formulas/ntp/README.rst
   ../_files/formulas/openssh/README.rst
   ../_files/formulas/openvpn/README.rst
   ../_files/formulas/reclass/README.rst
   ../_files/formulas/salt/README.rst
   ../_files/formulas/sphinx/README.rst
   ../_files/formulas/squid/README.rst


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
   *  - bird
      - https://github.com/salt-formulas/salt-formula-bird
   *  - cadf
      - https://github.com/salt-formulas/salt-formula-cadf
   *  - cassandra
      - https://github.com/salt-formulas/salt-formula-cassandra
   *  - dovecot
      - https://github.com/salt-formulas/salt-formula-dovecot
   *  - elasticsearch
      - https://github.com/salt-formulas/salt-formula-elasticsearch
   *  - etcd
      - https://github.com/salt-formulas/salt-formula-etcd
   *  - galera
      - https://github.com/salt-formulas/salt-formula-galera
   *  - haproxy
      - https://github.com/salt-formulas/salt-formula-haproxy
   *  - keepalived
      - https://github.com/salt-formulas/salt-formula-keepalived
   *  - knot
      - https://github.com/salt-formulas/salt-formula-knot
   *  - letsencrypt
      - https://github.com/salt-formulas/salt-formula-letsencrypt
   *  - logrotate
      - https://github.com/salt-formulas/salt-formula-logrotate
   *  - memcached
      - https://github.com/salt-formulas/salt-formula-memcached
   *  - mosquitto
      - https://github.com/salt-formulas/salt-formula-mosquitto
   *  - mongodb
      - https://github.com/salt-formulas/salt-formula-mongodb
   *  - mysql
      - https://github.com/salt-formulas/salt-formula-mysql
   *  - nginx
      - https://github.com/salt-formulas/salt-formula-nginx
   *  - openldap
      - https://github.com/salt-formulas/salt-formula-openldap
   *  - postfix
      - https://github.com/salt-formulas/salt-formula-postfix
   *  - postgresql
      - https://github.com/salt-formulas/salt-formula-postgresql
   *  - powerdns
      - https://github.com/salt-formulas/salt-formula-powerdns
   *  - rabbitmq
      - https://github.com/salt-formulas/salt-formula-rabbitmq
   *  - redis
      - https://github.com/salt-formulas/salt-formula-redis
   *  - rsync
      - https://github.com/salt-formulas/salt-formula-rsync
   *  - supervisor
      - https://github.com/salt-formulas/salt-formula-supervisor
   *  - varnish
      - https://github.com/salt-formulas/salt-formula-varnish
   *  - zookeeper
      - https://github.com/salt-formulas/salt-formula-zookeeper

.. toctree::

   ../_files/formulas/apache/README.rst
   ../_files/formulas/bind/README.rst
   ../_files/formulas/bird/README.rst
   ../_files/formulas/cadf/README.rst
   ../_files/formulas/cassandra/README.rst
   ../_files/formulas/dovecot/README.rst
   ../_files/formulas/elasticsearch/README.rst
   ../_files/formulas/etcd/README.rst
   ../_files/formulas/galera/README.rst
   ../_files/formulas/haproxy/README.rst
   ../_files/formulas/keepalived/README.rst
   ../_files/formulas/knot/README.rst
   ../_files/formulas/letsencrypt/README.rst
   ../_files/formulas/logrotate/README.rst
   ../_files/formulas/memcached/README.rst
   ../_files/formulas/mongodb/README.rst
   ../_files/formulas/mosquitto/README.rst
   ../_files/formulas/mysql/README.rst
   ../_files/formulas/nginx/README.rst
   ../_files/formulas/openldap/README.rst
   ../_files/formulas/postfix/README.rst
   ../_files/formulas/postgresql/README.rst
   ../_files/formulas/powerdns/README.rst
   ../_files/formulas/rabbitmq/README.rst
   ../_files/formulas/redis/README.rst
   ../_files/formulas/rsync/README.rst
   ../_files/formulas/supervisor/README.rst
   ../_files/formulas/varnish/README.rst
   ../_files/formulas/zookeeper/README.rst


Programming languages
---------------------

Support programming languages, libraries, environments.

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - java
      - https://github.com/salt-formulas/salt-formula-java
   *  - nodejs
      - https://github.com/salt-formulas/salt-formula-nodejs
   *  - php
      - https://github.com/salt-formulas/salt-formula-php
   *  - python
      - https://github.com/salt-formulas/salt-formula-python
   *  - ruby
      - https://github.com/salt-formulas/salt-formula-ruby

.. toctree::

   ../_files/formulas/java/README.rst
   ../_files/formulas/nodejs/README.rst
   ../_files/formulas/php/README.rst
   ../_files/formulas/python/README.rst
   ../_files/formulas/ruby/README.rst


IoT services
------------

Support for Internet of Things services.

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - ffmpeg
      - https://github.com/salt-formulas/salt-formula-ffmpeg
   *  - kodi
      - https://github.com/salt-formulas/salt-formula-kodi
   *  - home-assistant
      - https://github.com/salt-formulas/salt-formula-home-assistant
   *  - motion
      - https://github.com/salt-formulas/salt-formula-motion
   *  - octoprint
      - https://github.com/salt-formulas/salt-formula-octoprint

.. toctree::

   ../_files/formulas/ffmpeg/README.rst
   ../_files/formulas/kodi/README.rst
   ../_files/formulas/home-assistant/README.rst
   ../_files/formulas/motion/README.rst
   ../_files/formulas/octoprint/README.rst


OpenStack services
------------------

All supported OpenStack cloud platform services.

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - aodh
      - https://github.com/salt-formulas/salt-formula-aodh
   *  - avinetworks
      - https://github.com/salt-formulas/salt-formula-avinetworks
   *  - billometer
      - https://github.com/salt-formulas/salt-formula-billometer
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
   *  - openvstorage
      - https://github.com/salt-formulas/salt-formula-openvstorage
   *  - rally
      - https://github.com/salt-formulas/salt-formula-rally
   *  - sahara
      - https://github.com/salt-formulas/salt-formula-sahara
   *  - swift
      - https://github.com/salt-formulas/salt-formula-swift
   *  - tempest
      - https://github.com/salt-formulas/salt-formula-tempest

.. toctree::

   ../_files/formulas/aodh/README.rst
   ../_files/formulas/avinetworks/README.rst
   ../_files/formulas/billometer/README.rst
   ../_files/formulas/ceilometer/README.rst
   ../_files/formulas/cinder/README.rst
   ../_files/formulas/glance/README.rst
   ../_files/formulas/heat/README.rst
   ../_files/formulas/horizon/README.rst
   ../_files/formulas/keystone/README.rst
   ../_files/formulas/magnum/README.rst
   ../_files/formulas/midonet/README.rst
   ../_files/formulas/murano/README.rst
   ../_files/formulas/opencontrail/README.rst
   ../_files/formulas/neutron/README.rst
   ../_files/formulas/nova/README.rst
   ../_files/formulas/opencontrail/README.rst
   ../_files/formulas/rally/README.rst
   ../_files/formulas/sahara/README.rst
   ../_files/formulas/swift/README.rst
   ../_files/formulas/tempest/README.rst


Monitoring services
-------------------

Monitoring, metering and log collecting tools implementing complete monitoring
stack.

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - collectd
      - https://github.com/salt-formulas/salt-formula-collectd
   *  - fluentd
      - https://github.com/salt-formulas/salt-formula-fluentd
   *  - grafana
      - https://github.com/salt-formulas/salt-formula-grafana
   *  - graphite
      - https://github.com/salt-formulas/salt-formula-graphite
   *  - heka
      - https://github.com/salt-formulas/salt-formula-heka
   *  - influxdb
      - https://github.com/salt-formulas/salt-formula-influxdb
   *  - kedb
      - https://github.com/salt-formulas/salt-formula-kedb
   *  - kibana
      - https://github.com/salt-formulas/salt-formula-kibana
   *  - nagios
      - https://github.com/salt-formulas/salt-formula-nagios
   *  - rsyslog
      - https://github.com/salt-formulas/salt-formula-rsyslog
   *  - sensu
      - https://github.com/salt-formulas/salt-formula-sensu
   *  - statsd
      - https://github.com/salt-formulas/salt-formula-statsd

.. toctree::

   ../_files/formulas/collectd/README.rst
   ../_files/formulas/fluentd/README.rst
   ../_files/formulas/grafana/README.rst
   ../_files/formulas/graphite/README.rst
   ../_files/formulas/heka/README.rst
   ../_files/formulas/influxdb/README.rst
   ../_files/formulas/kedb/README.rst
   ../_files/formulas/kibana/README.rst
   ../_files/formulas/nagios/README.rst
   ../_files/formulas/rsyslog/README.rst
   ../_files/formulas/sensu/README.rst
   ../_files/formulas/statsd/README.rst


Integration services
--------------------

Continuous integration services for automated integration and delivery
pipelines.

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - aptly
      - https://github.com/salt-formulas/salt-formula-aptly
   *  - artifactory
      - https://github.com/salt-formulas/salt-formula-artifactory
   *  - gerrit
      - https://github.com/salt-formulas/salt-formula-gerrit
   *  - gitlab
      - https://github.com/salt-formulas/salt-formula-gitlab
   *  - gource
      - https://github.com/salt-formulas/salt-formula-gource
   *  - jenkins
      - https://github.com/salt-formulas/salt-formula-jenkins
   *  - owncloud
      - https://github.com/salt-formulas/salt-formula-owncloud
   *  - packer
      - https://github.com/salt-formulas/salt-formula-packer
   *  - roundcube
      - https://github.com/salt-formulas/salt-formula-roundcube

.. toctree::

   ../_files/formulas/aptly/README.rst
   ../_files/formulas/artifactory/README.rst
   ../_files/formulas/gerrit/README.rst
   ../_files/formulas/gitlab/README.rst
   ../_files/formulas/gource/README.rst
   ../_files/formulas/jenkins/README.rst
   ../_files/formulas/owncloud/README.rst
   ../_files/formulas/packer/README.rst
   ../_files/formulas/roundcube/README.rst


Deployment services
-------------------

Deployment services for automated delivery pipelines.

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - gateone
      - https://github.com/salt-formulas/salt-formula-gateone
   *  - foreman
      - https://github.com/salt-formulas/salt-formula-foreman
   *  - isc-dhcp
      - https://github.com/salt-formulas/salt-formula-isc-dhcp
   *  - libvirt
      - https://github.com/salt-formulas/salt-formula-libvirt
   *  - maas
      - https://github.com/salt-formulas/salt-formula-maas
   *  - stackstorm
      - https://github.com/salt-formulas/salt-formula-stackstorm
   *  - tftpd-hpa
      - https://github.com/salt-formulas/salt-formula-tftpd-hpa
   *  - vagrant
      - https://github.com/salt-formulas/salt-formula-vagrant
   *  - virtualbox
      - https://github.com/salt-formulas/salt-formula-virtualbox

.. toctree::

   ../_files/formulas/gateone/README.rst
   ../_files/formulas/foreman/README.rst
   ../_files/formulas/isc-dhcp/README.rst
   ../_files/formulas/libvirt/README.rst
   ../_files/formulas/maas/README.rst
   ../_files/formulas/stackstorm/README.rst
   ../_files/formulas/tftpd-hpa/README.rst
   ../_files/formulas/vagrant/README.rst
   ../_files/formulas/virtualbox/README.rst


Container services
------------------

Container services for automated container management.

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - calico
      - https://github.com/salt-formulas/salt-formula-calico
   *  - dekapod
      - https://github.com/salt-formulas/salt-formula-dekapod
   *  - docker
      - https://github.com/salt-formulas/salt-formula-docker
   *  - kubernetes
      - https://github.com/salt-formulas/salt-formula-kubernetes

.. toctree::

   ../_files/formulas/calico/README.rst
   ../_files/formulas/dekapod/README.rst
   ../_files/formulas/docker/README.rst
   ../_files/formulas/kubernetes/README.rst


Web applications
----------------

Automated management of web-based applications.

.. list-table::
   :widths: 33 66
   :header-rows: 1
   :stub-columns: 1

   *  - Formula
      - Repository
   *  - flower
      - https://github.com/salt-formulas/salt-formula-flower
   *  - jupyter
      - https://github.com/salt-formulas/salt-formula-jupyter
   *  - leonardo
      - https://github.com/salt-formulas/salt-formula-leonardo
   *  - mayan
      - https://github.com/salt-formulas/salt-formula-mayan
   *  - moodle
      - https://github.com/salt-formulas/salt-formula-moodle
   *  - openode
      - https://github.com/salt-formulas/salt-formula-openode
   *  - redmine
      - https://github.com/salt-formulas/salt-formula-redmine
   *  - sentry
      - https://github.com/salt-formulas/salt-formula-sentry
   *  - suitecrm
      - https://github.com/salt-formulas/salt-formula-suitecrm
   *  - taiga
      - https://github.com/salt-formulas/salt-formula-taiga
   *  - wordpress
      - https://github.com/salt-formulas/salt-formula-wordpress

.. toctree::

   ../_files/formulas/flower/README.rst
   ../_files/formulas/jupyter/README.rst
   ../_files/formulas/leonardo/README.rst
   ../_files/formulas/mayan/README.rst
   ../_files/formulas/moodle/README.rst
   ../_files/formulas/openode/README.rst
   ../_files/formulas/redmine/README.rst
   ../_files/formulas/sentry/README.rst
   ../_files/formulas/suitecrm/README.rst
   ../_files/formulas/taiga/README.rst
   ../_files/formulas/wordpress/README.rst


--------------

.. include:: navigation.txt
