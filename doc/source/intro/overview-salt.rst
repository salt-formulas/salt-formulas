`Home <index.html>`_ SaltStack-Formulas Project Introduction

SaltStack Operations
====================

SaltStack-Formulas Deployment uses Salt configuration platform to install and
manage OpenStack. Salt is an automation platform that greatly simplifies
system and application deployment. Salt infrastructure uses asynchronous and
reliable RAET protocol to communicate and it provides speed of task execution
and message transport.

Salt uses *formulas* to define resources written in the YAML language that
orchestrate the individual parts of system into the working entity. For more
information, see `Salt Formulas <https://docs.saltstack.com/en/latest/topics/d
evelopment/conventions/formulas.html>`_.

This guide refers to the host running Salt formulas and metadata service as
the *master* and the hosts on which Salt installs the SaltStack-Formulas as
the *minions*.

A recommended minimal layout for deployments involves five target hosts in
total: three infrastructure hosts, and two compute host. All hosts require one
network interface. More information on setting up target hosts can be found in
`the section called "Server topology" <overview-server-topology.html>`_.

For more information on physical, logical, and virtual network interfaces
within hosts see `the section called "Server networking" <overview-server-
networking.html>`_.


Using SaltStack
---------------

Remote execution principles carry over all aspects of Salt platform. Command
are made of:

**Target**

  Matching minion ID with globbing,regular expressions, Grains matching, Node
  groups, compound matching is possible

**Function**
  
  Commands haveform: module.function, arguments are YAML formatted, compound
  commands are possible


Targetting minions
~~~~~~~~~~~~~~~~~~

Examples of different kinds of targetting minions:

.. code-block:: bash

    salt '*' test.version
    salt -E '.*' apache.signal restart
    salt -G 'os:Fedora' test.version
    salt '*' cmd.exec_code python 'import sys; print sys.version'


SaltStack commands
~~~~~~~~~~~~~~~~~~

Minion inner facts

.. code-block:: bash

    salt-call grains.items

Minion external parameters

.. code-block:: bash

    salt-call pillar.data

Run the full configuration catalog

.. code-block:: bash

    salt-call state.highstate

Run one given service from catalog

.. code-block:: bash

    salt-call state.sls servicename




Pillar is an interface for Salt designed to offer global values that are
distributed to all minions. The ext_pillar option allows for any number of
external pillar interfaces to be called to populate the pillar data.

Pillars are tree-like structures of data defined on the Salt Master and passed
through to the minions. They allow confidential, targeted data to be securely
sent only to the relevant minion. Pillar is therefore one of the most
important systems when using Salt.


Pillar metadata
---------------

Pillar data is managed in a similar way as the Salt State Tree. It is the
default metadata source for states.


Reclass metadata
----------------

Reclass is an “external node classifier” (ENC) for Salt, Ansible or Puppet and
has ability to merge data sources in recursive way and interpolate variables.


Installation
~~~~~~~~~~~~

Installation from git or from the package.

.. code-block:: bash
    
    cd /tmp
    git clone https://github.com/madduck/reclass.git
    cd reclass
    python setup.py install
    mkdir /etc/reclass
    vim /etc/reclass/reclass-config.yml

And set the content to the following to setup reclass as salt-master metadata
source.

.. code-block:: yaml

    storage_type: yaml_fs
    pretty_print: True
    output: yaml
    inventory_base_uri: /srv/salt/reclass

To test reclass you can use CLI to get the complete service catalog or 



--------------

.. include:: navigation.txt
