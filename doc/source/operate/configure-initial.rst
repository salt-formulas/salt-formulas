
Initial environment configuration
=================================

Linux system setup
------------------

Basic linux box
***************

.. code-block:: yaml

    linux:
      system:
        enabled: true
        name: 'node1'
        domain: 'domain.com'
        cluster: 'system'
        environment: prod
        timezone: 'Europe/Prague'
        utc: true

Linux with defined users (optionaly with password)
**************************************************

.. code-block:: yaml

    linux:
      system:
        ...
        user:
          jdoe:
            name: 'jdoe'
            enabled: true
            sudo: true
            shell: /bin/bash
            full_name: 'Jonh Doe'
            home: '/home/jdoe'
            email: 'jonh@doe.com'
          jsmith:
            name: 'jsmith'
            enabled: true
            full_name: 'Password'
            home: '/home/jsmith'
            password: userpassword

Linux package installation
**************************

Install latest version

.. code-block:: yaml

    linux:
      system:
        ...
        package:
          package-name:
            version: latest

Linux package with specified version and repository

.. code-block:: yaml

    linux:
      system:
        ...
        package:
          package-name:
            version: 2132.323
            repo: 'custom-repo'
            hold: true 

Linux package with specified version and repository - disable GPG check

.. code-block:: yaml

    linux:
      system:
        ...
        package:
          package-name:
            version: 2132.323
            repo: 'custom-repo'
            verify: false

Linux cron job
**************

.. code-block:: yaml

    linux:
      system:
        ...
        job:
          cmd1:
            command: '/cmd/to/run'
            enabled: true
            user: 'root'
            hour: 2
            minute: 0

Linux security limits
*********************

Limit sensu user maximum memory usage to 1GB

.. code-block:: yaml

    linux:
      system:
        ...
        limit:
          sensu:
            enabled: true
            domain: sensu
            limits:
              - type: hard
                item: as
                value: 1000000

Enable autologin on tty1
************************

.. code-block:: yaml

    linux:
      system:
        console:
          tty1:
            autologin: root

Linux Kernel setup
------------------

Install always up to date LTS kernel and headers from Ubuntu trusty

.. code-block:: yaml

    linux:
      system:
        kernel:
          type: generic
          lts: trusty
          headers: true

Install specific kernel version and ensure all other kernel packages are not present. Also install extra modules and headers for this kernel

.. code-block:: yaml

    linux:
      system:
        kernel:
          type: generic
          extra: true
          headers: true
          version: 4.2.0-22

Linux repositories setup
------------------------

RedHat based Linux with additional OpenStack repo

.. code-block:: yaml

    linux:
      system:
        ...
        repo:
          rdo-icehouse:
            enabled: true
            source: 'https://repos.fedorapeople.org/repos/openstack/openstack-kilo/el7/'
            pgpcheck: 0

Ensure system repository to use czech Debian mirror (default: true) Also pin it's packages with priority 900

.. code-block:: yaml

    linux:
      system:
        repo:
          debian:
            default: true
            source: "deb http://ftp.cz.debian.org/debian/ jessie main contrib non-free"
            # Import signing key from URL if needed
            key_url: "http://dummy.com/public.gpg"
            pin:
              - pin: 'origin "ftp.cz.debian.org"'
                priority: 900
                package: '*'

rc.local example

.. code-block:: yaml

    linux:
      system:
        rc:
          local: |
            #!/bin/sh -e
            #
            # rc.local
            #
            # This script is executed at the end of each multiuser runlevel.
            # Make sure that the script will "exit 0" on success or any other
            # value on error.
            #
            # In order to enable or disable this script just change the execution
            # bits.
            #
            # By default this script does nothing.
            exit 0

Linux prompt setup
------------------

Setting prompt is implemented by creating /etc/profile.d/prompt.sh. Every user can have different prompt

.. code-block:: yaml

    linux:
      system:
        prompt:
          root: \\n\\[\\033[0;37m\\]\\D{%y/%m/%d %H:%M:%S} $(hostname -f)\\[\\e[0m\\]\\n\\[\\e[1;31m\\][\\u@\\h:\\w]\\[\\e[0m\\]
          default: \\n\\D{%y/%m/%d %H:%M:%S} $(hostname -f)\\n[\\u@\\h:\\w]

Linux network setup
-------------------

Linux interface/route setup
***************************

Linux with default static network interfaces, default gateway interface and DNS servers

.. code-block:: yaml

    linux:
      network:
        enabled: true
        interface:
          eth0:
            enabled: true
            type: eth
            address: 192.168.0.102
            netmask: 255.255.255.0
            gateway: 192.168.0.1
            name_servers:
            - 8.8.8.8
            - 8.8.4.4
            mtu: 1500

Linux with bonded interfaces and disabled NetworkManager

.. code-block:: yaml

    linux:
      network:
        enabled: true
        interface:
          eth0:
            type: eth
            ...
          eth1:
            type: eth
            ...
          bond0:
            enabled: true
            type: bond
            address: 192.168.0.102
            netmask: 255.255.255.0
            mtu: 1500
            use_in:
            - interface: ${linux:interface:eth0}
            - interface: ${linux:interface:eth0}
        network_manager:
          disable: true

Linux with vlan interface_params

.. code-block:: yaml

    linux:
      network:
        enabled: true
        interface:
          vlan69:
            type: vlan
            use_interfaces:
            - interface: ${linux:interface:bond0}

Linux networks with routes defined

.. code-block:: yaml

    linux:
      network:
        enabled: true
        gateway: 10.0.0.1
        default_interface: eth0
        interface:
          eth0:
            type: eth
            route:
              default:
                address: 192.168.0.123
                netmask: 255.255.255.0
                gateway: 192.168.0.1

Linux network bridges
*********************

Native linux bridges

.. code-block:: yaml

    linux:
      network:
        interface:
          eth1:
            enabled: true
            type: eth
            proto: manual
            up_cmds:
            - ip address add 0/0 dev $IFACE
            - ip link set $IFACE up
            down_cmds:
            - ip link set $IFACE down
          br-ex:
            enabled: true
            type: bridge
            address: ${linux:network:host:public_local:address}
            netmask: 255.255.255.0
            use_interfaces:
            - eth1

OpenVSwitch bridges

.. code-block:: yaml

    linux:
      network:
        bridge: openvswitch
        interface:
          eth1:
            enabled: true
            type: eth
            proto: manual
            up_cmds:
            - ip address add 0/0 dev $IFACE
            - ip link set $IFACE up
            down_cmds:
            - ip link set $IFACE down
          br-ex:
            enabled: true
            type: bridge
            address: ${linux:network:host:public_local:address}
            netmask: 255.255.255.0
            use_interfaces:
            - eth1

Other network related configuration
***********************************

Linux with network manager

.. code-block:: yaml

    linux:
      network:
        enabled: true
        network_manager: true

/etc/hosts configuration

.. code-block:: yaml

    linux:
      network:
        ...
        host:
          node1:
            address: 192.168.10.200
            names:
            - node2.domain.com
            - service2.domain.com
          node2:
            address: 192.168.10.201
            names:
            - node2.domain.com
            - service2.domain.com

/etc/resolv.conf configuration

.. code-block:: yaml

    linux:
      network:
        resolv:
          dns:
            - 8.8.4.4
            - 8.8.8.8
          domain: my.example.com
          search:
            - my.example.com
            - example.com

Linux storage setup
-------------------

Linux with mounted Samba

.. code-block:: yaml

    linux:
      storage:
        enabled: true
        mount:
          samba1:
          - path: /media/myuser/public/
          - device: //192.168.0.1/storage
          - file_system: cifs
          - options: guest,uid=myuser,iocharset=utf8,file_mode=0777,dir_mode=0777,noperm

Linux with file swap

.. code-block:: yaml

    linux:
      storage:
        enabled: true
        swap:
          file:
            enabled: true
            engine: file
            device: /swapfile
            size: 1024
    
LVM group vg1 with one device and data volume mounted into /mnt/data

.. code-block:: yaml


    linux:
      storage:
        mount:
          data:
            device: /dev/vg1/data
            file_system: ext4
            path: /mnt/data
        lvm:
          vg1:
            enabled: true
            devices:
              - /dev/sdb
            volume:
              data:
                size: 40G
                mount: ${linux:storage:mount:data}

OpenSSH client
--------------

OpenSSH client with shared private key

.. code-block:: yaml

    openssh:
      client:
        enabled: true
        user:
          root:
            enabled: true
            private_key: ${private_keys:vaio.newt.cz}
            user: ${linux:system:user:root}

OpenSSH client with individual private key and known host

.. code-block:: yaml

    openssh:
      client:
        enabled: true
        user:
          root:
            enabled: true
            user: ${linux:system:user:root}
            known_hosts:
            - name: repo.domain.com
              type: rsa
              fingerprint: dd:fa:e8:68:b1:ea:ea:a0:63:f1:5a:55:48:e1:7e:37

OpenSSH server
--------------

OpenSSH server with configuration parameters

.. code-block:: yaml

    openssh:
      server:
        enabled: true
        permit_root_login: true
        public_key_auth: true
        password_auth: true
        host_auth: true
        banner: Welcome to server!
    
OpenSSH server with auth keys for users

.. code-block:: yaml
  
    openssh:
      server:
        enabled: true
        ...
        user:
          user1:
            enabled: true
            user: ${linux:system:user:user1}
            public_keys:
            - ${public_keys:user1}
          root:
            enabled: true
            user: ${linux:system:user:root}
            public_keys:
            - ${public_keys:user1}

OpenSSH server for use with FreeIPA

.. code-block:: yaml

    openssh:
      server:
        enabled: true
        public_key_auth: true
        authorized_keys_command:
          command: /usr/bin/sss_ssh_authorizedkeys
          user: nobody
    
Salt minion configuration
-------------------------

Simple Salt minion

.. code-block:: yaml

    salt:
      minion:
        enabled: true
        master:
          host: master.domain.com

Multi-master Salt minion

.. code-block:: yaml

    salt:
      minion:
        enabled: true
        masters:
        -  host: master1.domain.com
        -  host: master2.domain.com

Salt minion with salt mine options

.. code-block:: yaml

    salt:
      minion:
        enabled: true
        master:
          host: master.domain.com
        mine:
          interval: 60
          module:
            grains.items: []
            network.interfaces: []

Salt minion with graphing dependencies

.. code-block:: yaml

    salt:
      minion:
        enabled: true
        graph_states: true
        master:

NTP client
----------

.. code-block:: yaml

    ntp:
      client:
        enabled: true
        strata:
        - ntp.cesnet.cz
        - ntp.nic.cz

--------------

.. include:: navigation.txt
