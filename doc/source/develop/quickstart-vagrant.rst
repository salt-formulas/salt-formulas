`Home <index.html>`_ SaltStack-Formulas Development Documentation

Starting Vagrant Deployment
===========================

All-in-one (AIO) deployments are a great way to setup an SaltStack-Formulas cloud
for:

* a service development environment
* an overview of how all of the OpenStack services and roles play together
* a simple lab deployment for testing

Although AIO builds aren't suitable for large production deployments, they're
great for small proof-of-concept deployments.

It's strongly recommended to have hardware that meets the following
requirements before starting an AIO deployment:

* CPU with `hardware-assisted virtualization`_ support
* At least 80GB disk space
* 8GB RAM

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

Add the generic ubuntu1404 image for virtualbox virtualization.

.. code-block:: bash

    $ vagrant box add ubuntu/trusty64

    ==> box: Loading metadata for box 'ubuntu/trusty64'
        box: URL: https://atlas.hashicorp.com/ubuntu/trusty64
    ==> box: Adding box 'ubuntu/trusty64' (v20160122.0.0) for provider: virtualbox
        box: Downloading: https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/20160122.0.0/providers/virtualbox.box
    ==> box: Successfully added box 'ubuntu/trusty64' (v20160122.0.0) for 'virtualbox'!


Environment setup 
-----------------

The environment consists of three nodes.

.. list-table::
   :stub-columns: 1

   *  - **FQDN**
      - **Role**
      - **IP**
   *  - config.openstack.local
      - Salt master node
      - 10.10.10.200
   *  - control.openstack.local
      - OpenStack control node
      - 10.10.10.201
   *  - compute.openstack.local
      - OpenStack compute node
      - 10.10.10.202



Minion configuration files
~~~~~~~~~~~~~~~~~~~~~~~~~~

Download salt-formulas

Look at configuration files for each node deployed.

``scripts/minions/config.conf`` configuration:

.. literalinclude:: /_static/scripts/minions/config.conf
   :language: yaml

``scripts/minions/control.conf`` configuration:

.. literalinclude:: /_static/scripts/minions/control.conf
   :language: yaml

``scripts/minions/compute.conf`` configuration:

.. literalinclude:: /_static/scripts/minions/compute.conf
   :language: yaml


Vagrant configuration file
~~~~~~~~~~~~~~~~~~~~~~~~~~

The main vagrant configuration for SaltStack-Formulas deployment is located at
``scripts/Vagrantfile``.

.. literalinclude:: /_static/scripts/Vagrantfile
   :language: ruby


Salt master bootstrap from package
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The salt-master bootstrap is located at ``scripts/bootstrap/salt-
master-pkg.sh`` and is accessible from the virtual machine at ``/vagrant
/bootstrap/salt-master-pkg.sh``.

.. literalinclude:: /_static/scripts/bootstrap/salt-master-pkg.sh
   :language: bash

Salt master pip based bootstrap
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The salt-master bootstrap is located at ``scripts/bootstrap/salt- master-
pip.sh`` and is accessible from the virtual machine at ``/vagrant/bootstrap
/salt-master-pip.sh``.

.. literalinclude:: /_static/scripts/bootstrap/salt-master-pip.sh
   :language: bash

Launching the Vagrant nodes
---------------------------

Check the status of the deployment environment.

.. code-block:: bash

    $ cd /srv/vagrant-openstack
    $ vagrant status
    
    Current machine states:

    openstack_config          not created (virtualbox)
    openstack_control         not created (virtualbox)
    openstack_compute         not created (virtualbox)

Setup SaltStack-Formulas config node, launch it and connect to it using following
commands, it cannot be provisioned by vagrant salt, as the salt master is not
configured yet.

.. code-block:: bash

    $ vagrant up openstack_config
    $ vagrant ssh openstack_config


Bootstrap Salt master
~~~~~~~~~~~~~~~~~~~~~

Bootstrap the salt master service on the config node, it can be configured
with following parameters:

.. code-block:: bash

    $ export RECLASS_ADDRESS=https://github.com/tcpcloud/salt-formulas-model.git
    $ export CONFIG_HOST=config.openstack.local

To deploy salt-master from packages, run on config node:

.. code-block:: bash

    $ /vagrant/bootstrap/salt-master-pkg.sh

To deploy salt-master from pip, run on config node:

.. code-block:: bash

    $ /vagrant/bootstrap/salt-master-pip.sh

Now setup the SaltStack-Formulas control node. Launch it using following command:

.. code-block:: bash

    $ vagrant up openstack_control

Now setup the SaltStack-Formulas compute node. Launch it using following command:

.. code-block:: bash

    $ vagrant up openstack_compute

To orchestrate the services accross all nodes, run following command on config
node:

.. code-block:: bash

    $ salt-run state.orchestrate orchestrate

The installation is now over, you should be able to access the user interface
of cloud deployment at your control node.

.. _hardware-assisted virtualization: https://en.wikipedia.org/wiki/Hardware-assisted_virtualization
.. _Vagrant downloads page: https://www.vagrantup.com/downloads.html


--------------

.. include:: navigation.txt
