
==================
SaltStack-Formulas
==================

This repository contains tools and documentation for using and extending Salt
formula project ecosystem.

What is content this repo:

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
