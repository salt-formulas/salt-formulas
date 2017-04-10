`Home <index.html>`_ SaltStack-Formulas Development Documentation

SaltStack-Formulas Heat deployment
==================================

All-in-one (AIO) deployments are a great way to setup an SaltStack-Formulas cloud for:

* a service development environment
* an overview of how all of the OpenStack services and roles play together
* a simple lab deployment for testing

It is possible to run full size proof-of-concept deployment on OpenStack with
`Heat template`, the stack has following requirements for cluster deployment:

* At least 200GB disk space
* 70GB RAM

The single-node deployment has following requirements:

* At least 80GB disk space
* 16GB RAM


Available Heat templates
------------------------

Application single setup
~~~~~~~~~~~~~~~~~~~~~~~~

The ``app_single`` environment consists of three nodes.

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


Heat client setup
-----------------

The preffered way of installing OpenStack clients is isolated Python
environment. To creat Python environment and install compatible OpenStack
clients, you need to install build tools first.

Ubuntu installation
~~~~~~~~~~~~~~~~~~~

Install required packages:

.. code-block:: bash

   $ apt-get install python-dev python-pip python-virtualenv build-essential

Now create and activate virtualenv `venv-heat` so you can install specific
versions of OpenStack clients.

.. code-block:: bash

   $ virtualenv venv-heat
   $ source ./venv-heat/bin/activate

Use `requirements.txt` from the `SaltStack-Formulas heat templates repository`_ to install
tested versions of clients into activated environment.

.. code-block:: bash

   $ pip install -r requirements.txt

The summary of clients for OpenStack. Following clients were tested with Juno and Kilo
Openstack versions.  

.. literalinclude:: ../../../deploy/scripts/requirements/heat.txt
   :language: python


If everything goes right, you should be able to use openstack clients, `heat`,
`nova`, etc.


Connecting to OpenStack cloud
-----------------------------

Setup OpenStack credentials so you can use openstack clients. You can
download ``openrc`` file from Openstack dashboard and source it or execute
following commands with filled credentials:

.. code-block:: bash

   $ vim ~/openrc

   export OS_AUTH_URL=https://<openstack_endpoint>:5000/v2.0
   export OS_USERNAME=<username>
   export OS_PASSWORD=<password>
   export OS_TENANT_NAME=<tenant>

Now source the OpenStack credentials:

.. code-block:: bash

   $ source openrc

To test your sourced variables:

.. code-block:: bash

   $ env | grep OS

Some resources required for heat environment deployment.

Get network ID
~~~~~~~~~~~~~~

The public network is needed for setting up both testing heat stacks. The
network ID can be found in Openstack Dashboard or by running following
command:


.. code-block:: bash

   $ neutron net-list


Get image ID
~~~~~~~~~~~~

Image ID is required to run OpenStack Salt lab templates, Ubuntu 14.04 LTS is
required as config_image and image for one of the supported platforms is
required as instance_image, used for OpenStack instances. To lookup for actual
installed images run:

.. code-block:: bash

   $ glance image-list


Launching the Heat stack
------------------------

Download heat templates from this repository.

.. code-block:: bash

   $ git clone git@github.com:openstack/salt-formulas.git
   $ cd doc/source/_static/scripts/

Now you need to customize env files for stacks, see examples in envs directory
``doc/source/_static/scripts/envs`` and set required parameters.

Full examples of env files for the two respective stacks:

--------------

.. include:: navigation.txt
