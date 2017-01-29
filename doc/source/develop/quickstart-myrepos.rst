`Home <index.html>`_ SaltStack-Formulas Development Documentation

Myrepos synchronisation
=======================


Installation
------------

.. code-block:: bash

    apt-get install myrepos

To add ``gerrit`` remote automatically, set your username:

.. code-block:: bash

    git config --global gitreview.username johndoe

To avoid using ``--trust-all`` option, add this .mrconfig into trusts file:

.. code-block:: bash

    echo $PWD/.mrconfig >> ~/.mrtrust

Clone repositories
------------------

Simply run ``checkout`` tool without parameters or with formula names, eg.:

.. code-block:: bash

    ./checkout
    ./checkout nova freeipa salt

Or with some parallelism:

.. code-block:: bash

    mr --trust-all --force -j 4 checkout

Update repositories
-------------------

Pull with rebase in each repo or only one

.. code-block:: bash

    mr --trust-all update
    mr --trust-all -d tcpcloud update
    mr --trust-all -d tcpcloud/apache update

Read more
---------

- https://wiki.debian.org/Teams/Ruby/Packaging
- https://myrepos.branchable.com/
