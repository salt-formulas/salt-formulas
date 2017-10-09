`Home <index.html>`_ Installation and Operations Manual

Configuring the Dashboard service
=================================

OS Horizon from package
-----------------------

Simple Horizon setup
********************

.. code-block:: yaml

    linux:
      system:
        name: horizon
        repo:
         - cloudarchive-kilo:
            enabled: true
            source: 'deb http://ubuntu-cloud.archive.canonical.com/ubuntu trusty-updates/kilo main'
            pgpcheck: 0
    horizon:
      server:
        manage_repo: true
        enabled: true
        secret_key: SECRET
        host:
          name: cloud.lab.cz
        cache:
          engine: 'memcached'
          host: '127.0.0.1'
          port: 11211
          prefix: 'CACHE_HORIZON'
        identity:
          engine: 'keystone'
          host: '127.0.0.1'
          port: 5000
          api_version: 2
        mail:
          host: '127.0.0.1'

Simple Horizon setup with branding
**********************************

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        branding: 'OpenStack Company Dashboard'
        default_dashboard: 'admin'
        help_url: 'http://doc.domain.com'

Horizon setup with SSL
**********************

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        secret_key: MEGASECRET
        version: juno
        ssl:
          enabled: true
          authority: CA_Authority
        host:
          name: cloud.lab.cz
        cache:
          engine: 'memcached'
          host: '127.0.0.1'
          port: 11211
          prefix: 'CACHE_HORIZON'
        identity:
          engine: 'keystone'
          host: '127.0.0.1'
          port: 5000
          api_version: 2
        mail:
          host: '127.0.0.1'
   
Horizon setup with multiple regions
***********************************

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        version: juno
        secret_key: MEGASECRET
        cache:
          engine: 'memcached'
          host: '127.0.0.1'
          port: 11211
          prefix: 'CACHE_HORIZON'
        identity:
          engine: 'keystone'
          host: '127.0.0.1'
          port: 5000
          api_version: 2
        mail:
          host: '127.0.0.1'
        regions:
        - name: cluster1
          address: http://cluster1.example.com:5000/v2.0
        - name: cluster2
          address: http://cluster2.example.com:5000/v2.0

Horizon setup with sensu plugin
*******************************

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        version: juno
        sensu_api:
          host: localhost
          port: 4567
        plugins:
        - name: monitoring
          app: horizon_monitoring
          source:
            type: git
            address: git@repo1.robotice.cz:django/horizon-monitoring.git
            revision: master
        - name: api-mask
          app: api_mask
          mask_url: 'custom-url.cz'
          mask_protocol: 'http'
          source:
            type: git
            address: git@repo1.robotice.cz:django/horizon-api-mask.git
            revision: master

Horizon Sensu plugin with multiple endpoints
********************************************

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        version: juno
        sensu_api:
          dc1:
            host: localhost
            port: 4567
          dc2:
            host: anotherhost
            port: 4567

Horizon setup with Billometer plugin
************************************

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        version: juno
        billometer_api:
          host: localhost
          port: 9753
          api_version: 1
        plugins:
        - name: billing
          app: horizon_billing
          source:
            type: git
            address: git@repo1.robotice.cz:django/horizon-billing.git
            revision: master

Horizon setup with Contrail plugin
**********************************

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        version: icehouse
        plugins:
        - name: contrail
          app: contrail_openstack_dashboard
          override: true
          source:
            type: git
            address: git@repo1.robotice.cz:django/horizon-contrail.git
            revision: master

Horizon setup with sentry log handler
*************************************

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        version: juno
        ...
        logging:
          engine: raven
          dsn: http://pub:private@sentry1.test.cz/2
    
OS Horizon from Git repository (multisite support)
--------------------------------------------------

Simple Horizon setup
********************

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        app:
          default:
            secret_key: MEGASECRET
            source:
              engine: git
              address: https://github.com/openstack/horizon.git
              revision: stable/kilo
            cache:
              engine: 'memcached'
              host: '127.0.0.1'
              port: 11211
              prefix: 'CACHE_DEFAULT'
            identity:
              engine: 'keystone'
              host: '127.0.0.1'
              port: 5000
              api_version: 2
            mail:
              host: '127.0.0.1'

Themed Horizon multisite
************************

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        app:
          openstack1c:
            secret_key: SECRET1
            source:
              engine: git
              address: https://github.com/openstack/horizon.git
              revision: stable/kilo
            plugin:
              contrail:
                app: contrail_openstack_dashboard
                override: true
                source:
                  type: git
                  address: git@repo1.robotice.cz:django/horizon-contrail.git
                  revision: master
              theme:
                app: site1_theme
                source:
                  type: git
                  address: git@repo1.domain.com:django/horizon-site1-theme.git
            cache:
              engine: 'memcached'
              host: '127.0.0.1'
              port: 11211
              prefix: 'CACHE_SITE1'
            identity:
              engine: 'keystone'
              host: '127.0.0.1'
              port: 5000
              api_version: 2
            mail:
              host: '127.0.0.1'
          openstack2:
            secret_key: SECRET2
            source:
              engine: git
              address: https://repo1.domain.com/openstack/horizon.git
              revision: stable/kilo
            plugin:
              contrail:
                app: contrail_openstack_dashboard
                override: true
                source:
                  type: git
                  address: git@repo1.domain.com:django/horizon-contrail.git
                  revision: master
              monitoring:
                app: horizon_monitoring
                source:
                  type: git
                  address: git@domain.com:django/horizon-monitoring.git
                  revision: master
              theme:
                app: bootswatch_theme
                source:
                  type: git
                  address: git@repo1.robotice.cz:django/horizon-bootswatch-theme.git
                  revision: master
            cache:
              engine: 'memcached'
              host: '127.0.0.1'
              port: 11211
              prefix: 'CACHE_SITE2'
            identity:
              engine: 'keystone'
              host: '127.0.0.1'
              port: 5000
              api_version: 3
            mail:
              host: '127.0.0.1'

Horizon with API versions override
**********************************

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        app:
          openstack_api_overrride:
            secret_key: SECRET
            api_versions:
              identity: 3
              volume: 2
            source:
              engine: git
              address: https://github.com/openstack/horizon.git
              revision: stable/kilo

Horizon with changed dashboard behaviour
----------------------------------------

.. code-block:: yaml

    horizon:
      server:
        enabled: true
        app:
          openstack_dashboard_overrride:
            secret_key: SECRET
            dashboards:
              settings:
                enabled: true
              project:
                enabled: false
                order: 10
              admin:
                enabled: false
                order: 20
            source:
              engine: git
              address: https://github.com/openstack/horizon.git
              revision: stable/kilo
    
--------------
    
.. include:: navigation.txt
