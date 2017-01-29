
Server Topology
==================

High availability is the default environment setup. Reference architecture covers only the HA deployment. HA provides replicated servers to prevent single points of failure. Single node deployments are supported for development environments in Vagrant and Heat. 

Production setup consists from several roles of physical nodes:

* Foreman/Ubuntu MaaS
* KVM Control cluster
* Compute nodes

Server role description
-----------------------

Virtual Machine nodes:

SaltMaster node
~~~~~~~~~~~~~~~

SaltMaster node contains supporting installation components for deploying OpenStack cloud as Salt Master, git repositories, package repository, etc.

OpenStack controller nodes
~~~~~~~~~~~~~~~~~~~~~~~~~~

Controller is fail-over cluster for hosting OpenStack core cloud components (Nova, Neutron, Cinder, Glance), OpenContrail control roles and multi-mastar database for all OpenStack services.

OpenContrail controller nodes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

OpenContrail controller is fail-over cluster for hosting OpenContrail Config, Neutron, Control and other services like Cassandra, Zookeeper, Redis, HAProxy, Keepalived fully operated in High Availability.

OpenContrail analytics node
~~~~~~~~~~~~~~~~~~~~~~~~~~~

OpenContrail Analytics node is fail-over cluster for OpenContrail analytics.

Database node
~~~~~~~~~~~~~

MySQL Galera nodes contain multi-master database for all OpenStack and Monitoring services.

Telemetry node
~~~~~~~~~~~~~~

Ceilometer node is separated from central controllers for better performance, maintenance and upgrades. MongoDB cluster is used for storing telemetry data.

Proxy node
~~~~~~~~~~~~~~

This node does proxy for all OpenStack APIs and Dashboards.

Monitoring node
~~~~~~~~~~~~~~~~~~~~

This node contains modules for TCP Monitoring, which include Sensu open source monitoring framework, RabbitMQ and KEDB.

Billometer node
~~~~~~~~~~~~~~~~~~~

This node contains modules for TCP Billing, which include Horizon dashboard.

Metering node
~~~~~~~~~~~~~~~~~

This node contains Graphite, which is a highly scalable real-time graphing system. It includes Graphite's processing backend - Carbon and fixed-size database - Whisper.

.. figure:: /_images/production_architecture.png
  :width: 100%
  :align: center

Reference Architecture
--------------------------

.. figure:: /_images/server_topology.jpg
  :width: 100%
  :align: center

Reclass model for:

* 1x Salt master
* 3x OpenStack, OpenContrail control nodes
* 2x Openstack compute nodes
* 1x Ceilometer, Graphite metering nodes
* 1x Sensu monitoring node
* 1x Heka, ElasticSearch, Kibana node

.. list-table:: Nodes in setup
   :header-rows: 1

   *  - **Hostname**
      - **Description**
      - **IP Address**
   *  - cfg01
      - Salt Master
      - 172.10.10.100
   *  - ctl01
      - Openstack & Opencontrail controller
      - 172.10.10.101
   *  - ctl02
      - Openstack & Opencontrail controller
      - 172.10.10.102
   *  - ctl03
      - Openstack & Opencontrail controller
      - 172.10.10.103
   *  - web01
      - Openstack Dashboard and API proxy
      - 172.10.10.104
   *  - cmp01
      - Compute node
      - 172.10.10.105
   *  - cmp02
      - Compute node
      - 172.10.10.106
   *  - mon01
      - Ceilometer
      - 172.10.10.107
   *  - mtr01
      - Monitoring node
      - 172.10.10.108

All hosts are deployed in `workshop.cloudlab.cz` domain.

Instructions for reclass modification
------------------------------------------

- Fork this repository
- Make customizations according to your environment:

  - ``classes/system/openssh/server/single.yml``

    - setup public SSH key
    - disable password auth
    - comment out root password

  - ``nodes/cfg01.workshop.cloudlab.cz.yml`` and
    ``classes/system/reclass/storage/system/workshop.yml``

    - fix IP addresses
    - fix domain

  - ``classes/system/openstack/common/workshop.yml``

    - fix passwords and keys
    - fix IP addresses

  - ``classes/billometer/server/single.yml`` - set password

  - ``classes/system/graphite`` - set password

--------------

.. include:: navigation.txt
