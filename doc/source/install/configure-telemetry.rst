
Configuring the Telemetry service
=================================

Control nodes
-------------

Ceilometer API
**************

.. code-block:: yaml

    ceilometer:
      server:
        enabled: true
        version: havana
        cluster: true
        secret: pwd
        bind:
          host: 127.0.0.1
          port: 8777
        identity:
          engine: keystone
          host: 127.0.0.1
          port: 35357
          tenant: service
          user: ceilometer
          password: pwd
        message_queue:
          engine: rabbitmq
          host: 127.0.0.1
          port: 5672
          user: openstack
          password: pwd
          virtual_host: '/openstack'
          rabbit_ha_queues: true
        database:
          engine: mongodb
          host: 127.0.0.1
          port: 27017
          name: ceilometer
          user: ceilometer
          password: pwd

Compute nodes
-------------

Ceilometer Graphite publisher
*****************************

.. code-block:: yaml

    ceilometer:
      server:
        enabled: true
        publisher:
          graphite:
            enabled: true
            host: 10.0.0.1
            port: 2003    

Ceilometer agent
****************

.. code-block:: yaml

    ceilometer:
      agent:
        enabled: true
        version: havana
        secret: pwd
        identity:
          engine: keystone
          host: 127.0.0.1
          port: 35357
          tenant: service
          user: ceilometer
          password: pwd
        message_queue:
          engine: rabbitmq
          host: 127.0.0.1
          port: 5672
          user: openstack
          password: pwd
          virtual_host: '/openstack'
          rabbit_ha_queues: true
    
--------------
    
.. include:: navigation.txt
