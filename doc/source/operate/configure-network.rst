
Configuring the Network service
===============================

Control nodes
-------------

.. code-block:: yaml

    neutron:
      server:
        enabled: true
        version: kilo
        plugin: ml2/contrail
        bind:
          address: 172.20.0.1
          port: 9696
        tunnel_type: vxlan
        public_networks:
        - name: public
          subnets:
          - name: public-subnet
            gateway: 10.0.0.1
            network: 10.0.0.0/24
            pool_start: 10.0.5.20
            pool_end: 10.0.5.200
            dhcp: False
        database:
          engine: mysql
          host: 127.0.0.1
          port: 3306
          name: neutron
          user: neutron
          password: pwd
        identity:
          engine: keystone
          host: 127.0.0.1
          port: 35357
          user: neutron
          password: pwd
          tenant: service
        message_queue:
          engine: rabbitmq
          host: 127.0.0.1
          port: 5672
          user: openstack
          password: pwd
          virtual_host: '/openstack'
        metadata:
          host: 127.0.0.1
          port: 8775
          password: pass
        fwaas: false

Network nodes
-------------

.. code-block:: yaml

    neutron:
      bridge:
        enabled: true
        version: kilo
        tunnel_type: vxlan
        bind:
          address: 172.20.0.2
        database:
          engine: mysql
          host: 127.0.0.1
          port: 3306
          name: neutron
          user: neutron
          password: pwd
        identity:
          engine: keystone
          host: 127.0.0.1
          port: 35357
          user: neutron
          password: pwd
          tenant: service
        message_queue:
          engine: rabbitmq
          host: 127.0.0.1
          port: 5672
          user: openstack
          password: pwd
          virtual_host: '/openstack'

Compute nodes
-------------

.. code-block:: yaml

    neutron:
      switch:
        enabled: true
        version: kilo
        migration: True
        tunnel_type: vxlan
        bind:
          address: 127.20.0.100
        database:
          engine: mysql
          host: 127.0.0.1
          port: 3306
          name: neutron
          user: neutron
          password: pwd
        identity:
          engine: keystone
          host: 127.0.0.1
          port: 35357
          user: neutron
          password: pwd
          tenant: service
        message_queue:
          engine: rabbitmq
          host: 127.0.0.1
          port: 5672
          user: openstack
          password: pwd
          virtual_host: '/openstack'
        
--------------

.. include:: navigation.txt
