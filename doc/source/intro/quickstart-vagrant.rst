`Home <index.html>`_ SaltStack-Formulas Project Introduction


Quick Deployment with Vagrant
=============================

All-in-one (AIO) deployments are a great way to setup an infrastructure for:

* a service development environment
* an overview of how all of the OpenStack services and roles play together
* a simple lab deployment for testing

Although AIO builds aren't suitable for large production deployments, they're
great for small proof-of-concept deployments.

It's strongly recommended to have hardware that meets the following
requirements before starting an AIO deployment:

* CPU with `hardware-assisted virtualization`_ support
* At least 20GB disk space
* 2GB RAM


Vagrant setup
-------------

Installing Vagrant is extremely easy for many operating systems. Go to the
`Vagrant downloads page`_ and get the appropriate installer or package for
your platform. Install the package using standard procedures for your
operating system.

The installer will automatically add vagrant to your system path so that it is
available in shell. Try logging out and logging back in to your system (this
is particularly necessary sometimes for Windows) to get the updated system
path up and running.

Add the generic ubuntu1604 image for virtualbox virtualization.

.. code-block:: bash

    $ vagrant box add ubuntu/xenial64

    ==> box: Loading metadata for box 'ubuntu/xenial64'
        box: URL: https://atlas.hashicorp.com/ubuntu/xenial4
    ==> box: Adding box 'ubuntu/xenial64' (v20160122.0.0) for provider: virtualbox
        box: Downloading: https://vagrantcloud.com/ubuntu/boxes/xenial64/versions/20160122.0.0/providers/virtualbox.box
    ==> box: Successfully added box 'ubuntu/xenial64' (v20160122.0.0) for 'virtualbox'!


Environment setup 
-----------------

The environment consists of three nodes.

.. list-table::
   :stub-columns: 1

   *  - **FQDN**
      - **Role**
      - **IP**
   *  - config.cluster.local
      - Salt master node
      - 10.10.10.200
   *  - service.cluster.local
      - Managed node
      - 10.10.10.201



Minion configuration files
~~~~~~~~~~~~~~~~~~~~~~~~~~

Download salt-formulas

Look at configuration files for each node deployed.

``scripts/minions/config.conf`` configuration:

.. literalinclude:: ../_files/vagrant/minions/config.conf
   :language: yaml

``scripts/minions/service.conf`` configuration:

.. literalinclude:: ../_files/vagrant/minions/service.conf
   :language: yaml


Vagrant configuration file
~~~~~~~~~~~~~~~~~~~~~~~~~~

The main vagrant configuration for SaltStack-Formulas deployment is located at
``scripts/Vagrantfile``.

.. literalinclude:: ../_files/vagrant/Vagrantfile
   :language: ruby


Salt master bootstrap from package
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The salt-master bootstrap is located at ``scripts/bootstrap/salt-
master-pkg.sh`` and is accessible from the virtual machine at ``/vagrant
/bootstrap/salt-master-pkg.sh``.

.. literalinclude:: ../_files/scripts/salt-master-init.sh
   :language: bash


Launching the Vagrant nodes
---------------------------

Check the status of the deployment environment.

.. code-block:: bash

    $ cd /srv/vagrant-cluster
    $ vagrant status
    
    Current machine states:

    cluster_config          not created (virtualbox)
    cluster_service         not created (virtualbox)

Setup config node, launch it and connect to it using following commands, it
cannot be provisioned by vagrant salt, as the salt master is not configured
yet.

.. code-block:: bash

    $ vagrant up cluster_config
    $ vagrant ssh cluster_config


Bootstrap Salt master
~~~~~~~~~~~~~~~~~~~~~

Bootstrap the salt master service on the config node, it can be configured
with following parameters:

.. code-block:: bash

    $ export RECLASS_ADDRESS=https://github.com/salt-formulas/salt-formulas-model.git
    $ export CONFIG_HOST=config.cluster.local

To deploy salt-master from packages, run on config node:

.. code-block:: bash

    $ /vagrant/bootstrap/salt-master-setup.sh

Now setup the server node. Launch it using following command:

.. code-block:: bash

    $ vagrant up cluster_service


To orchestrate all defined services accross all nodes, run following command
on config node:

.. code-block:: bash

    $ salt-run state.orchestrate orchestrate

.. _hardware-assisted virtualization: https://en.wikipedia.org/wiki/Hardware-assisted_virtualization
.. _Vagrant downloads page: https://www.vagrantup.com/downloads.html


--------------

.. include:: navigation.txt
