
Configuring the Volume service
==============================

Ceph backend
-------------------

.. code-block:: yaml

    cinder:
      controller:
        enabled: true
        backend:
          ceph_backend:
            type_name: standard-iops
            backend: ceph_backend
            pool: volumes
            engine: ceph
            user: cinder
            secret_uuid: da74ccb7-aa59-1721-a172-0126b1aa4e3e
            client_cinder_key: AQDOavlU6BsSJsmoAnFR906mvdgdfRqLHwu0Uw==


Hitachi VSP backend
-------------------

Cinder setup with Hitachi VPS

.. code-block:: yaml

    cinder:
      controller:
        enabled: true
        backend:
          hus100_backend:
            name: HUS100
            backend: hus100_backend
            engine: hitachi_vsp
            connection: FC


IBM Storwize backend
--------------------

.. code-block:: yaml

    cinder:
      volume:
        enabled: true
        backend:
          7k2_SAS:
            engine: storwize
            type_name: 7k2 SAS disk
            host: 192.168.0.1
            port: 22
            user: username
            password: pass
            connection: FC/iSCSI
            multihost: true
            multipath: true
            pool: SAS7K2
          10k_SAS:
            engine: storwize
            type_name: 10k SAS disk
            host: 192.168.0.1
            port: 22
            user: username
            password: pass
           connection: FC/iSCSI
            multihost: true
            multipath: true
            pool: SAS10K

Solidfire backend
-------------------

Cinder setup with Hitachi VPS

.. code-block:: yaml

    cinder:
      controller:
        enabled: true
        backend:
          hus100_backend:
            name: HUS100
            backend: hus100_backend
            engine: hitachi_vsp
            connection: FC

--------------

.. include:: navigation.txt
