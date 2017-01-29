
============================
Configuration node setup
========================


Configuring the operating system
================================

The configuration files will be installed to :file:`/etc/salt` and are named
after the respective components, :file:`/etc/salt/master`, and
:file:`/etc/salt/minion`.

By default the Salt master listens on ports 4505 and 4506 on all
interfaces (0.0.0.0). To bind Salt to a specific IP, redefine the
"interface" directive in the master configuration file, typically
``/etc/salt/master``, as follows:

.. code-block:: diff

   - #interface: 0.0.0.0
   + interface: 10.0.0.1

After updating the configuration file, restart the Salt master.
for more details about other configurable options.
Make sure that mentioned ports are open by your network firewall.

Open salt master config

.. code-block:: bash

    vim /etc/salt/master.d/master.conf

And set the content to the following, enabling dev environment and reclass metadata source.

.. code-block:: yaml

    file_roots:
      base:
      - /srv/salt/env/dev
      - /srv/salt/env/base

    pillar_opts: False

    reclass: &reclass
      storage_type: yaml_fs
      inventory_base_uri: /srv/salt/reclass

    ext_pillar:
      - reclass: *reclass

    master_tops:
      reclass: *reclass

And set the content to the following to setup reclass as salt-master metadata source.

.. code-block:: bash

    vim /etc/reclass/reclass-config.yml

.. code-block:: yaml

    storage_type: yaml_fs
    pretty_print: True
    output: yaml
    inventory_base_uri: /srv/salt/reclass

Configure the master service

.. code-block:: bash

  	# Ubuntu
  	service salt-master restart
  	# Redhat
  	systemctl enable salt-master.service
  	systemctl start salt-master


See the `master configuration reference <https://docs.saltstack.com/en/latest/ref/configuration/master.html>`_
for more details about other configurable options.



Setting up package repository
================================

Use ``curl`` to install your distribution's stable packages. Examine the downloaded file ``install_salt.sh`` to ensure that it contains what you expect (bash script). You need to perform this step even for salt-master instalation as it adds official saltstack package management PPA repository.

.. code:: console

  apt-get install vim curl git-core
  curl -L https://bootstrap.saltstack.com -o install_salt.sh
  sudo sh install_salt.sh

Install the Salt master from the apt repository with the apt-get command after you installed salt-minion.

.. code-block:: bash

  sudo apt-get install salt-minion salt-master reclass

.. Note::

Instalation is tested on Ubuntu Linux 12.04/14.04, but should work on any distribution with python 2.7 installed.
You should keep Salt components at current stable version.


Configuring Secure Shell (SSH) keys
===================================

Generate SSH key file for accessing your reclass metadata and development formulas.

.. code-block:: bash

    mkdir /root/.ssh
    ssh-keygen -b 4096 -t rsa -f /root/.ssh/id_rsa -q -N ""
    chmod 400 /root/.ssh/id_rsa

Create SaltStack environment file root, we will use ``dev`` environment.

.. code-block:: bash

    mkdir /srv/salt/env/dev -p

Get the reclass metadata definition from the git server.

.. code-block:: bash

    git clone git@github.com:tcpcloud/workshop-salt-model.git /srv/salt/reclass

Get the core formulas from git repository server needed to setup the rest.

.. code-block:: bash

    git clone git@github.com:tcpcloud/salt-formula-linux.git /srv/salt/env/dev/linux -b develop
    git clone git@github.com:tcpcloud/salt-formula-salt.git /srv/salt/env/dev/salt -b develop
    git clone git@github.com:tcpcloud/salt-formula-openssh.git /srv/salt/env/dev/openssh -b develop
    git clone git@github.com:tcpcloud/salt-formula-git.git /srv/salt/env/dev/git -b develop


--------------

.. include:: navigation.txt
