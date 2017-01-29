==================
SaltStack-Formulas
==================

.. image:: https://readthedocs.org/projects/salt-formulas/badge/?version=latest
    :target: http://salt-formulas.readthedocs.io/en/latest/?badge=latest
    :alt: Documentation Status

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
   include link to current version of formula for review
2. Push your code into new repository, you can also tag new version
3. Run ``./scripts/add_repo.sh formula_name`` to add new Git submodule
4. Re-generate ``.mrconfig`` with ``./scripts/gen_mrconfig.py``, that script
   will scrape ``github.com/salt-formulas`` and generate up-to-date
   `.mrconfig` file
5. Create pull request with ``formulas/new_formula_name`` (new submodule) and
   updated ``.mrconfig``
