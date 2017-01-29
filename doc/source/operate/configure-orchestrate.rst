
Configuring the Orchestrate service
===================================

Heat server
-----------

Heat control services
*********************

.. code-block:: yaml

    heat:
      server:
        enabled: true
        version: icehouse
        bind:
          metadata:
            address: 10.0.106.10
            port: 8000
          waitcondition:
            address: 10.0.106.10
            port: 8000
          watch:
            address: 10.0.106.10
            port: 8003
        cloudwatch:
          host: 10.0.106.20
        api:
          host: 10.0.106.20
        api_cfn:
          host: 10.0.106.20
        database:
          engine: mysql
          host: 10.0.106.20
          port: 3306
          name: heat
          user: heat
          password: password
        identity:
          engine: keystone
          host: 10.0.106.20
          port: 35357
          tenant: service
          user: heat
          password: password
        message_queue:
          engine: rabbitmq
          host: 10.0.106.20
          port: 5672
          user: openstack
          password: password
          virtual_host: '/openstack'
          ha_queues: True

Heat template deployment
************************

.. code-block:: yaml

    heat:
      control:
        enabled: true
        system:
          web_production:
            format: hot
            template_file: /srv/heat/template/web_cluster.hot
            environment: /srv/heat/env/web_cluster/prd.env
          web_staging:
            format: hot
            template_file: /srv/heat/template/web_cluster.hot
            environment: /srv/heat/env/web_cluster/stg.env

Heat client
-----------

.. code-block:: yaml

    heat:
      client:
        enabled: true
        source:
          engine: git
          address: git@repo.domain.com/heat-templates.git
          revision: master

--------------

.. include:: navigation.txt
