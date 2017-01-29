`Home <index.html>`_ SaltStack-Formulas Development Documentation

Formula guidelines
==================

The SaltStack-Formulas formulas are stored in the formulas directory `/usr/share/salt-formulas/env`.

There are several top-level formulas that are run to prepare the host machines
before actually deploying OpenStack and associated services.

Running Formulas
----------------

The recommended way of running formulas is through Salt orchestration framework.
Orchestration is accomplished in salt primarily through the `Orchestrate Runner`_. 

.. code-block:: yaml

    salt-run state.orchestrate orch.system

Or directly calling formula by Salt state module. 

.. code-block:: bash

    salt-call state.sls formula

Setting up the Physical Hosts
-----------------------------

Run `salt-run state.orchestrate orch.bare_metal` to set up the physical hosts for further setup.

Setting up Infrastructure Services
----------------------------------

Infrastructure services services such as RabbitMQ, memcached, galera, and monitoring services which are not actually OpenStack services, but that OpenStack relies on.

Run `salt-run state.orchestrate orch.infrastructure` to install these services.

Setting up OpenStack Services
-----------------------------

Running `salt-run state.orchestrate orch.openstack` will install the following OpenStack services:

    * Keystone
    * Nova
    * Glance
    * Cinder
    * Neutron
    * Horizon

Optional services

    * Heat
    * Ceilometer
    * Swift

.. _Orchestrate Runner: https://docs.saltstack.com/en/latest/ref/runners/index.html

--------------

.. include:: navigation.txt
