`Home <index.html>`_ Installation and Operations Manual

Configuring the infrastructure services
=======================================

RabbitMQ
--------

RabbitMQ single node
********************

RabbitMQ as AMQP broker with admin user and vhosts

.. code-block:: yaml

    rabbitmq:
      server:
        enabled: true
        bind:
          address: 0.0.0.0
          port: 5672
        secret_key: rabbit_master_cookie
        admin:
          name: adminuser
          password: pwd
        plugins:
        - amqp_client
        - rabbitmq_management
        virtual_hosts:
        - enabled: true
          host: '/monitor'
          user: 'monitor'
          password: 'password'
    
RabbitMQ as a Stomp broker

.. code-block:: yaml

    rabbitmq:
      server:
        enabled: true
        secret_key: rabbit_master_cookie
        bind:
          address: 0.0.0.0
          port: 5672
        virtual_hosts:
        - enabled: true
          host: '/monitor'
          user: 'monitor'
          password: 'password'
        plugins:
        - rabbitmq_stomp

RabbitMQ cluster
****************

RabbitMQ as base cluster node

.. code-block:: yaml

    rabbitmq:
      server:
        enabled: true
        bind:
          address: 0.0.0.0
          port: 5672
        secret_key: rabbit_master_cookie
        admin:
          name: adminuser
          password: pwd
      cluster:
        enabled: true
        role: master
        mode: disc
        members:
        - name: openstack1
          host: 10.10.10.212
        - name: openstack2
          host: 10.10.10.213

HA Queues definition

.. code-block:: yaml

    rabbitmq:
      server:
        enabled: true
        ...
        virtual_hosts:
        - enabled: true
          host: '/monitor'
          user: 'monitor'
          password: 'password'
          policies:
          - name: HA
            pattern: '^(?!amq\.).*'
            definition: '{"ha-mode": "all"}'
    

MySQL
-----

MySQL database - simple
***********************

.. code-block:: yaml

    mysql:
      server:
        enabled: true
        version: '5.5'
        admin:
          user: root
          password: pwd
        bind:
          address: '127.0.0.1'
          port: 3306
        database:
          name:
            encoding: 'utf8'
            users:
            - name: 'username'
              password: 'password'
              host: 'localhost'
              rights: 'all privileges'
    
MySQL database - configured
***************************

.. code-block:: yaml

    mysql:
      server:
        enabled: true
        version: '5.5'
        admin:
          user: root
          password: pwd
        bind:
          address: '127.0.0.1'
          port: 3306
        key_buffer: 250M
        max_allowed_packet: 32M
        max_connections: 1000
        thread_stack: 512K
        thread_cache_size: 64
        query_cache_limit: 16M
        query_cache_size: 96M
        force_encoding: utf8
        database:
          name:
            encoding: 'utf8'
            users:
            - name: 'username'
              password: 'password'
              host: 'localhost'
              rights: 'all privileges'

Galera database cluster
-----------------------

Galera cluster master node
**************************

.. code-block:: yaml

    galera:
      master:
        enabled: true
        name: openstack
        bind:
          address: 192.168.0.1
          port: 3306
        members:
        - host: 192.168.0.1
          port: 4567
        - host: 192.168.0.2
          port: 4567
        admin:
          user: root
          password: pwd
        database:
          name:
            encoding: 'utf8'
            users:
            - name: 'username'
              password: 'password'
              host: 'localhost'
              rights: 'all privileges'

Galera cluster slave node
*************************

.. code-block:: yaml

    galera:
      slave:
        enabled: true
        name: openstack
        bind:
          address: 192.168.0.2
          port: 3306
        members:
        - host: 192.168.0.1
          port: 4567
        - host: 192.168.0.2
          port: 4567
        admin:
          user: root
          password: pass

Galera cluster - Usage

MySQL Galera check sripts

.. code-block:: bash

    mysql> SHOW STATUS LIKE 'wsrep%';
    
    mysql> SHOW STATUS LIKE 'wsrep_cluster_size' ;"

Galera monitoring command, performed from extra server

.. code-block:: bash

    garbd -a gcomm://ipaddrofone:4567 -g my_wsrep_cluster -l /tmp/1.out -d

1. salt-call state.sls mysql
2. Comment everything starting wsrep* (wsrep_provider, wsrep_cluster, wsrep_sst)
3. service mysql start
4. run on each node mysql_secure_install and filling root password.

.. code-block:: bash

    Enter current password for root (enter for none):
    OK, successfully used password, moving on...
    
    Setting the root password ensures that nobody can log into the MySQL
    root user without the proper authorisation.
    
    Set root password? [Y/n] y
    New password:
    Re-enter new password:
    Password updated successfully!
    Reloading privilege tables..
     ... Success!
    
    By default, a MySQL installation has an anonymous user, allowing anyone
    to log into MySQL without having to have a user account created for
    them.  This is intended only for testing, and to make the installation
    go a bit smoother.  You should remove them before moving into a
    production environment.
    
    Remove anonymous users? [Y/n] y
     ... Success!
    
    Normally, root should only be allowed to connect from 'localhost'.  This
    ensures that someone cannot guess at the root password from the network.
    
    Disallow root login remotely? [Y/n] n
     ... skipping.
    
    By default, MySQL comes with a database named 'test' that anyone can
    access.  This is also intended only for testing, and should be removed
    before moving into a production environment.
    
    Remove test database and access to it? [Y/n] y
     - Dropping test database...
     ... Success!
     - Removing privileges on test database...
     ... Success!
    
    Reloading the privilege tables will ensure that all changes made so far
    will take effect immediately.

    Reload privilege tables now? [Y/n] y
     ... Success!
    
    Cleaning up...

5. service mysql stop
6. uncomment all wsrep* lines except first server, where leave only in my.cnf wsrep_cluster_address='gcomm://';
7. start first node
8. Start third node which is connected to first one
9. Start second node which is connected to third one
10. After starting cluster, it must be change cluster address at first starting node without restart database and change config my.cnf.

.. code-block:: bash

    mysql> SET GLOBAL wsrep_cluster_address='gcomm://10.0.0.2';

Metering database (Graphite)
----------------------------

1. Set up the monitoring node for metering.

.. code-block:: bash

    root@cfg01:~# salt 'mon01*' state.sls git,rabbitmq,postgresql
    root@cfg01:~# salt 'mon01*' state.sls graphite,apache

2. Make some manual adjustments.

.. code-block:: bash

    root@mon01:~# service carbon-aggregator start
    root@mon01:~# apt-get install python-django=1.6.1-2ubuntu0.11
    root@mon01:~# service apache2 restart

3. Update all client nodes in infrastructure for metrics service.

.. code-block:: bash

    root@cfg01:~# salt "*" state.sls collectd.client

4. Check the browser for the metering service output

    http://185.22.97.69:8080

Monitoring server (Sensu)
-------------------------

Instalation
***********

1. Set up the monitoring node.

.. code-block:: bash

    root@cfg01:~# salt 'mon01*' state.sls git,rabbitmq,redis
    root@cfg01:~# salt 'mon01*' state.sls sensu

2. Update all client nodes in infrastructure.

.. code-block:: bash

    root@cfg01:~# salt "*" state.sls sensu.client

3. Update check defitions based on model on Sensu server.

.. code-block:: bash

    root@cfg01:~# salt "*" state.sls sensu.client
    root@cfg01:~# salt "*" state.sls salt
    root@cfg01:~# salt "*" mine.flush
    root@cfg01:~# salt "*" mine.update
    root@cfg01:~# salt "*" service.restart salt-minion
    root@cfg01:~# salt "mon*" state.sls sensu.server

    # as 1-liner

    salt "*" state.sls sensu.client; salt "*" state.sls salt.minion; salt "*" mine.flush; salt "*" mine.update; salt "*" service.restart salt-minion; salt "mon*" state.sls sensu.server

    salt 'mon*' service.restart rabbimq-server; salt 'mon*' service.restart sensu-server; salt 'mon*' service.restart sensu-api; salt '*' service.restart sensu-client

4. View the monitored infrastructure in web user interface.

.. code-block:: bash

    http://185.22.97.69:8088

Creating checks
---------------

Check can be created in 2 separate ways.

Service driven checks
*********************

Checks are created and populated by existing services. Check definition is stored at ``formula_name/files/sensu.conf``. For example SSH service creates check that checks running process.

.. code-block:: yaml

    local_openssh_server_proc:
      command: "PATH=$PATH:/usr/lib64/nagios/plugins:/usr/lib/nagios/plugins check_procs -a '/usr/sbin/sshd' -u root -c 1:1"
      interval: 60
      occurrences: 1
      subscribers:
      - local-openssh-server

Arbitrary check definitions
***************************

These checks are custom created from definition files located in ``system.sensu.server.checks``, this class must be included in monitoring node definition.

.. code-block:: yaml

    parameters:
      sensu:
        server:
          checks:
          - name: local_service_name_proc
            command: "PATH=$PATH:/usr/lib64/nagios/plugins:/usr/lib/nagios/plugins check_procs -C service-name"
            interval: 60
            occurrences: 1
            subscribers:
            - local-service-name-server

Create file ``/etc/sensu/conf.d/check_graphite.json``:

.. code-block:: yaml

    {
      "checks": {
        "remote_graphite_users": {
          "subscribers": [
            "remote-network"
          ],
          "command": "~/sensu-plugins-graphite/bin/check-graphite-stats.rb --host 127.0.0.1 --period -2mins --target 'default_prd.*.users.users'  --warn 1 --crit 2",
          "handlers": [
            "default"
          ],
          "occurrences": 1,
          "interval": 30
        }
      }
    }

Restart sensu-server

.. code-block:: bash

    root@mon01:~# service sensu-server restart
        
--------------
    
.. include:: navigation.txt
