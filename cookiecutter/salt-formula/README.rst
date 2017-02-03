cookiecutter-salt-formula
=========================

A cookiecutter template for Salt Formula.

Installation
============

.. code-block:: bash

    pip install cookiecutter

    cd cookiecutter

    cookiecutter salt-formula


Init Test Kitchen configuration
===============================

Follow the `salt formula testing <https://salt-formulas.readthedocs.io/en/latest/develop/testing-formulas.html>`_ guidelines and
automated CI in the main `documentation <https://salt-formulas.readthedocs.io/en/latest/develop/testing.html>`_.

To generate ``.kitchen.yml`` for new or existing project:

- install `envtpl`, renders jinja2 templates with shell environment variables
- install required gems, it depends on drivers configured to be used (docker by default)

.. code-block:: shell

    pip install envtpl
    gem install kitchen-docker kitchen-salt [kitchen-openstack kitchen-vagrant kitchen-inspec busser-serverspec]

Once you create your `tests/pillar` structure (required if you want to auto-populate kitchen yaml with test suites)

.. code-block:: shell

    # cd <formula repository>
    ../kitchen-init.sh

Instantly, to add kitchen configuration into existing repository:

.. code-block:: shell

    # cd <formula repository>
    curl -skL "https://raw.githubusercontent.com/salt-formulas/salt-formulas/master/cookiecutter/salt-formula/kitchen-init.sh" | bash -s --

