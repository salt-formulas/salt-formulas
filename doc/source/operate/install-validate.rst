`Home <index.html>`_ Installation and Operations Manual

===========================
Validate Configuration Node
===========================

.. contents::
    :backlinks: none
    :local:

Now it's time to validate your configuration infrastrucuture.

Check validity of reclass data for entire infrastructure:

.. code-block:: bash

    reclass-salt --top

It will return service catalog of entire infrastructure.

Get reclass data for specific node:

.. code-block:: bash

    reclass-salt --pillar ctl01.workshop.cloudlab.cz

Verify that all salt minions are accepted at master:

.. code-block:: bash

    root@cfg01:~# salt-key
    Accepted Keys:
    cfg01.workshop.cloudlab.cz
    mtr01.workshop.cloudlab.cz
    Denied Keys:
    Unaccepted Keys:
    Rejected Keys:

Verify that all Salt minions are responding:

.. code-block:: bash

    root@cfg01:~# salt '*workshop.cloudlab.cz' test.ping
    cfg01.workshop.cloudlab.cz:
        True
    mtr01.workshop.cloudlab.cz:
        True
    web01.workshop.cloudlab.cz:
        True
    cmp02.workshop.cloudlab.cz:
        True
    cmp01.workshop.cloudlab.cz:
        True
    mon01.workshop.cloudlab.cz:
        True
    ctl02.workshop.cloudlab.cz:
        True
    ctl01.workshop.cloudlab.cz:
        True
    ctl03.workshop.cloudlab.cz:
        True

Get IP addresses of minions:

.. code-block:: bash

    root@cfg01:~# salt "*.workshop.cloudlab.cz" grains.get ipv4"

Show top states (installed services) for all nodes in the infrastructure.

.. code-block:: bash

    root@cfg01:~# salt '*' state.show_top
    [INFO    ] Loading fresh modules for state activity
    nodeXXX:
        ----------
        base:
            - git
            - linux
            - ntp
            - salt
            - collectd
            - openssh
            - reclass

--------------

.. include:: navigation.txt
