==================
SaltStack-Formulas
==================

.. image:: https://readthedocs.org/projects/salt-formulas/badge/?version=latest
    :target: http://salt-formulas.readthedocs.io/en/latest/?badge=latest
    :alt: Documentation Status

.. image:: https://badges.gitter.im/Join%20Chat.svg
    :target: https://gitter.im/salt-formulas/Lobby
    :alt: Join Chat on Gitter.im


This repository contains tools and documentation for using and extending Salt
formula project ecosystem.

Contents of this repository:

**cookiecutter**
  A template for quick prototyping of new formulas.

**doc**
  Sphinx driven salt-formulas project documentation.

**formulas**
  Actual formula ecosystem formulas. Using git submodules and myrepos to
  manage.

**scripts**
  Scripts and helpers to work with this repository.

**deploy/heat**
  Running salt-formulas on OpenStack Heat provisioner.

**deploy/vagrant**
  Running salt-formulas on Vagrant provisioner.

**deploy/scripts**
  Deployment and bootstrap scripts

Checkout formulas
=================

Formulas are registered as submodules with commit marking current release. To
checkout latest release, simply init and update submodules:

.. code-block:: bash

    git submodule init
    git submodule update

To checkout master branch and start developing, you can use myrepos tool:

.. code-block:: bash

    mr --trust-all -j4 run git checkout master
    mr --trust-all -j4 update

To make this simpler, you can use ``Makefile`` for the same:

.. code-block:: bash

    make submodules
    make update

Building docs
=============

Documentation source is living in ``doc`` directory and is including readmes
from formulas directory (so you should ensure they are cloned before building
documentation).

In most cases, you want to build html or pdf so you can use these two
``Makefile`` targets:

.. code-block:: bash

    make html
    make pdf

Results will be in ``doc/build`` directory.

Add new formula
===============

To add new formula into the ecosystems, follow these steps:

1. Request creation of repository on Github salt-formulas organization,
   include link to current version of formula for review. To do this, join
   mailing list and use it to let others know
   (salt-formulas@freelists.org)
2. Push your code into new repository, you can also tag new version
3. Run ``./scripts/add_repo.sh formula_name`` to add new Git submodule
4. Re-generate ``.mrconfig`` with ``./scripts/gen_mrconfig.py``, that script
   will scrape ``github.com/salt-formulas`` and generate up-to-date
   `.mrconfig` file
5. Include new formula readme in ``doc/source/develop/overview-formula.rst``
6. Create pull request with ``formulas/new_formula_name`` (new submodule) and
   updated ``.mrconfig``

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula.

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

You should also subscribe to mailing list (salt-formulas@freelists.org):

    https://www.freelists.org/list/salt-formulas

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
