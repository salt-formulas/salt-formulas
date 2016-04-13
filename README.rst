=============
Salt formulas
=============

This repository contains config and scripts for myrepos tool

Dependencies
============

.. code-block::

    apt-get install myrepos

To add ``gerrit`` remote automatically, set your username:

.. code-block:: bash

    git config --global gitreview.username johndoe

Clone repositories
==================

Simply run ``checkout`` tool without parameters or with formula names, eg.:

.. codeb-lock:: bash

    ./checkout
    ./checkout nova freeipa salt

Update repositories
===================

Pull with rebase in each repo or only one

.. code-block:: bash

    mr --trust-all update
    mr --trust-all -d apache update
