
Orchestrate infrastrucutre services
===================================

First execute basic states on all nodes to ensure Salt minion, system and
OpenSSH are set up.

.. code-block:: bash

   salt '*' state.sls linux,salt,openssh,ntp


Support infrastructure deployment
---------------------------------

Metering node is deployed by running highstate:

.. code-block:: bash

   salt 'mtr*' state.highstate

On monitoring node, git needs to be setup first:

.. code-block:: bash

   salt 'mon*' state.sls git
   salt 'mon*' state.highstate


--------------

.. include:: navigation.txt
