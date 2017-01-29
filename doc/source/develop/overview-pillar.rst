`Home <index.html>`_ SaltStack-Formulas Development Documentation

Service classification
======================

Pillar is an interface for Salt designed to offer global values that are distributed to all minions. The ext_pillar option allows for any number of external pillar interfaces to be called to populate the pillar data.

Pillar metadata
---------------

Pillar data is managed in a similar way as the Salt State Tree. It is the default metadata source for 

Reclass reclass
---------------

Reclass is an “external node classifier” (ENC) for Salt, Ansible or Puppet and has ability to merge data sources in recursive way and interpolate variables. I

reclass installation
~~~~~~~~~~~~~~~~~~

First we will install the application and then configure it.

.. code-block:: bash
    
    cd /tmp
    git clone https://github.com/madduck/reclass.git
    cd reclass
    python setup.py install
    mkdir /etc/reclass
    vim /etc/reclass/reclass-config.yml

And set the content to the following to setup reclass as salt-master metadata source.

.. code-block:: yaml

    storage_type: yaml_fs
    pretty_print: True
    output: yaml
    inventory_base_uri: /srv/salt/reclass

To test reclass you can use CLI to get the complete service catalog or 


--------------

.. include:: navigation.txt
