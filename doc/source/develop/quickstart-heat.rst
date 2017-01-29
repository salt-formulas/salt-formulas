`Home <index.html>`_ SaltStack-Formulas Development Documentation

SaltStack-Formulas Heat deployment
==================================

All-in-one (AIO) deployments are a great way to setup an SaltStack-Formulas cloud for:

* a service development environment
* an overview of how all of the OpenStack services and roles play together
* a simple lab deployment for testing

It is possible to run full size proof-of-concept deployment on OpenStack with `Heat template`, the stack has following requirements for cluster deployment: 

* At least 200GB disk space
* 70GB RAM

The single-node deployment has following requirements:

* At least 80GB disk space
* 16GB RAM


Available Heat templates
------------------------

We have prepared two generic OpenStack Salt lab templates, OpenStack in single and OpenStack in cluster configuration. Both are deployed by custom parametrized bootstrap script, which sets up Salt master with OpenStack Salt formula ecosystem and example metadata.

Openstack-salt single setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``openstack_single`` environment consists of three nodes.

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


Openstack-salt cluster setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``openstack_cluster`` environment consists of six nodes.

.. list-table::
   :stub-columns: 1

   *  - **FQDN**
      - **Role**
      - **IP**
   *  - config.openstack.local
      - Salt master node
      - 10.10.10.200
   *  - control01.openstack.local
      - OpenStack control node
      - 10.10.10.201
   *  - control02.openstack.local
      - OpenStack control node
      - 10.10.10.202
   *  - control03.openstack.local
      - OpenStack control node
      - 10.10.10.203
   *  - compute01.openstack.local
      - OpenStack compute node
      - 10.10.10.211
   *  - compute02.openstack.local
      - OpenStack compute node
      - 10.10.10.212


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

The public network is needed for setting up both testing heat stacks. The network ID can be found in Openstack Dashboard or by running following command:


.. code-block:: bash

   $ neutron net-list


Get image ID
~~~~~~~~~~~~

Image ID is required to run OpenStack Salt lab templates, Ubuntu 14.04 LTS is required as config_image and image for one of the supported platforms is required as instance_image, used for OpenStack instances. To lookup for actual installed images run:

.. code-block:: bash

   $ glance image-list


Launching the Heat stack
------------------------

Download heat templates from this repository.

.. code-block:: bash

   $ git clone git@github.com:openstack/salt-formulas.git
   $ cd doc/source/_static/scripts/

Now you need to customize env files for stacks, see examples in envs directory ``doc/source/_static/scripts/envs`` and set required parameters.

Full examples of env files for the two respective stacks:

OpenStack templates generic parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**public_net_id**
  name of external network

**instance_image**
  image for OpenStack instances, must correspond with os_distribution

**config_image**
  image for Salt master node, currently only Ubuntu 14.04 supported

**key_value**
  paste your SSH key here

**salt_source**
  salt-master installation source

  options: 
    - pkg
    - pip

  default:
    - pkg

**salt_version** 
  salt-master version

  options: 
    - latest
    - 2015.8.11
    - 2015.8.10
    - 2015.8.9
    - ...

  default: 
    - latest

**formula_source**
  salt formulas source

  options: 
    - git
    - pkg

  default:
    - git

**formula_path**
  path to formulas

  default: 
    - /usr/share/salt-formulas

**formula_branch**
  formulas git branch

  default:
    - master

**reclass_address**
  reclass git repository

  default:
    - https://github.com/tcpcloud/salt-formulas-model.git

**reclass_branch** 
  reclass git branch

  default: 
    - master

**os_version**
  OpenStack release version

  options: 
    - kilo

  default:
    - kilo

**os_distribution**
  OpenStack nodes distribution

  options: 
    - ubuntu
    - redhat

  default: 
    - ubuntu

**os_networking**
  OpenStack networking engine

  options: 
    - opencontrail
    - neutron

  default: 
    - opencontrail

**os_deployment** 
  OpenStack architecture

  options: 
    - single
    - cluster

  default: 
    - single

**config_hostname**
  salt-master hostname

  default: 
    - config

**config_address**
  salt-master internal IP address

  default: 
    - 10.10.10.200

OpenStack single specific parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**config_domain**
  salt-master domain

  default:
    - openstack.local

**ctl01_name**
  OS controller hostname

  default: 
    - control

**cmp01_name**
  OS compute hostname

  default: 
    - compute

**prx01_name**
  OS proxy hostname

  default: 
    - proxy

OpenStack cluster specific parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**config_domain**
  salt-master domain

  default:
    - openstack-ha.local

**ctl01_name**
  OS controller 1 hostname

  default: 
    - control01

**ctl02_name**
  OS controller 2 hostname

  default: 
    - control02

**ctl03_name**
  OS controller 3 hostname

  default: 
    - control03

**cmp01_name**
  OS compute 1 hostname

  default: 
    - compute01

**cmp02_name**
  OS compute 2 hostname

  default:
    - compute02
  
**prx01_name**
  OS proxy hostname
    
  default: 
    - proxy

openstack_single.hot environment examples
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**OpenStack Kilo on Ubuntu with OpenContrail networking**

``/_static/scripts/envs/openstack_single_kilo_ubuntu_opencontrail.env.example``

.. literalinclude:: /_static/scripts/envs/openstack_single_kilo_ubuntu_opencontrail.env.example
   :language: yaml

**OpenStack Kilo on Ubuntu with Neutron DVR networking**

``/_static/scripts/envs/openstack_single_kilo_ubuntu_neutron.env.example``

.. literalinclude:: /_static/scripts/envs/openstack_single_kilo_ubuntu_neutron.env.example
   :language: yaml

**OpenStack Kilo on CentOS/RHEL with OpenContrail networking**

``/_static/scripts/envs/openstack_single_kilo_redhat_opencontrail.env.example``

.. literalinclude:: /_static/scripts/envs/openstack_single_kilo_redhat_opencontrail.env.example
   :language: yaml

openstack_cluster.hot environment examples
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**OpenStack Kilo on Ubuntu with OpenContrail networking**

``/_static/scripts/envs/openstack_cluster_kilo_ubuntu_opencontrail.env.example``

.. literalinclude:: /_static/scripts/envs/openstack_cluster_kilo_ubuntu_opencontrail.env.example
   :language: yaml

**OpenStack Kilo on CentOS/RHEL with OpenContrail networking**

``/_static/scripts/envs/openstack_cluster_kilo_ubuntu_opencontrail.env.example``

.. literalinclude:: /_static/scripts/envs/openstack_cluster_kilo_ubuntu_opencontrail.env.example
   :language: yaml

.. code-block:: bash

   $ heat stack-create -e envs/ENV_FILE -f openstack_single.hot
   $ heat stack-create -e envs/ENV_FILE -f openstack_cluster.hot

If everything goes right, stack should be ready in a few minutes. You can verify by running following commands:

.. code-block:: bash

   $ heat stack-list
   $ nova list

You should be also able to log in as root to public IP provided by ``nova list`` command. When this cluster is deployed, you canlog in to the instances through the Salt master node.

Current state of supported env configurations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :stub-columns: 1

   *  - **ENV configuration**
      - **Single Status**
      - **Cluster Status**
   *  - OS Kilo Ubuntu with OpenContrail
      - Stable
      - Stable
   *  - OS Kilo RedHat single with OpenContrail
      - Experimental
      - Experimental
   *  - OS Kilo Ubuntu single with Neutron DVR
      - Experimental
      - NONE

OpenStack Heat templates
~~~~~~~~~~~~~~~~~~~~~~~~

**OpenStack single Heat template**

``/_static/scripts/openstack_single.hot``

.. literalinclude:: /_static/scripts/openstack_single.hot
   :language: yaml

**OpenStack cluster Heat template**

``/_static/scripts/openstack_cluster.hot``

.. literalinclude:: /_static/scripts/openstack_cluster.hot
   :language: yaml

Openstack-salt testing labs
---------------------------

You can use publicly available labs offered by technology partners.  

Testing lab at `tcp cloud`
~~~~~~~~~~~~~~~~~~~~~~~~~~

Company tcp cloud has provided 100 cores and 400 GB of RAM divided in 5 separate projects, each with quotas set to 20 cores and 80 GB of RAM. Each project is capable of running both single and cluster deployments.

Endpoint URL:
    **https://cloudempire-api.tcpcloud.eu:35357/v2.0**

.. list-table::
   :stub-columns: 1

   *  - **User**
      - **Project**
      - **Domain**
   *  - openstack_salt_user01
      - openstack_salt_lab01
      - default
   *  - openstack_salt_user02
      - openstack_salt_lab02
      - default
   *  - openstack_salt_user03
      - openstack_salt_lab03
      - default
   *  - openstack_salt_user04
      - openstack_salt_lab04
      - default
   *  - openstack_salt_user05
      - openstack_salt_lab05
      - default

To get the access credentials and full support, visit ``#salt-formulas`` IRC channel.

--------------

.. include:: navigation.txt
