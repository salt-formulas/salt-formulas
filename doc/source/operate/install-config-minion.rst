`Home <index.html>`_ Installation and Operations Manual

=========================
Target Nodes Installation
=========================

.. contents::
    :backlinks: none
    :local:

On most distributions, you can set up a Salt Minion with the `Salt Bootstrap
<https://github.com/saltstack/salt-bootstrap>`_ .

.. note::

    In every two-step example, you would be well-served to examine the
    downloaded file and examine it to ensure that it does what you expect.


Using ``curl`` to install latest git:

.. code:: console

  curl -L https://bootstrap.saltstack.com -o install_salt.sh
  sudo sh install_salt.sh git develop

Using ``wget`` to install your distribution's stable packages:

.. code:: console

  wget -O install_salt.sh https://bootstrap.saltstack.com
  sudo sh install_salt.sh

Install a specific version from git using ``wget``:

.. code:: console

  wget -O install_salt.sh https://bootstrap.saltstack.com
  sudo sh install_salt.sh -P git v2015.5

On the above example we added `-P` which will allow PIP packages to be installed if required but 
it's no a necessary flag for git based bootstraps.

Basic minion Configuration
---------------------------

Salt configuration is very simple. The only requirement for setting up a minion is to set the location of the master in the minion configuration file.

The configuration files will be installed to :file:`/etc/salt` and are named
after the respective components, :file:`/etc/salt/master`, and :file:`/etc/salt/minion`.

Setting ``Salt Master host``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Although there are many Salt Minion configuration options, configuring
a Salt Minion is very simple. By default a Salt Minion will
try to connect to the DNS name "salt"; if the Minion is able to
resolve that name correctly, no configuration is needed.

If the DNS name "salt" does not resolve to point to the correct
location of the Master, redefine the "master" directive in the minion
configuration file, typically ``/etc/salt/minion``, as follows:

.. code-block:: diff

   - #master: salt
   + master: 10.0.0.1

Setting ``Salt minion ID``
~~~~~~~~~~~~~~~~~~~~~~~~~~

Then explicitly declare the ID for this minion to use. Since Salt uses
detached IDs it is possible to run multiple minions on the same machine but
with different IDs.

.. code-block:: yaml

  id: foo.bar.com

After updating the configuration files, restart the Salt minion.

.. code-block:: bash

  # Ubuntu
  service salt-minion restart

  # Redhat
  systemctl enable salt-minion.service
  systemctl start salt-minion

See the `minion configuration reference <https://docs.saltstack.com/en/latest/ref/configuration/minion.html>`_
for more details about other configurable options.


--------------

.. include:: navigation.txt
