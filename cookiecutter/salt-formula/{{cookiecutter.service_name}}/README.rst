
==================================
{{cookiecutter.service_name}}
==================================

Service {{cookiecutter.service_name}} description

Sample pillars
==============

Single {{cookiecutter.service_name}} service

.. code-block:: yaml

    {{cookiecutter.service_name}}:
      {{cookiecutter.role_name}}:
        enabled: true
        version: icehouse


Development and testing
=======================

Development and test workflow with `Test Kitchen <http://kitchen.ci>`_ and
`kitchen-salt <https://github.com/simonmcc/kitchen-salt>`_ provisioner plugin.

Test Kitchen is a test harness tool to execute your configured code on one or more platforms in isolation.
There is a ``.kitchen.yml`` in main directory that defines *platforms* to be tested and *suites* to execute on them.

Kitchen CI can spin instances locally or remote, based on used *driver*.
For local development ``.kitchen.yml`` defines a `vagrant <https://github.com/test-kitchen/kitchen-vagrant>`_ or
`docker  <https://github.com/test-kitchen/kitchen-docker>`_ driver.

To use backend drivers or implement your CI follow the section `INTEGRATION.rst#Continuous Integration`__.

The `Busser <https://github.com/test-kitchen/busser>`_ *Verifier* is used to setup and run tests
implementated in `<repo>/test/integration`. It installs the particular driver to tested instance
(`Serverspec <https://github.com/neillturner/kitchen-verifier-serverspec>`_,
`InSpec <https://github.com/chef/kitchen-inspec>`_, Shell, Bats, ...) prior the verification is executed.

Usage:

.. code-block:: shell

  # list instances and status
  kitchen list

  # manually execute integration tests
  kitchen [test || [create|converge|verify|exec|login|destroy|...]] [instance] -t tests/integration

  # use with provided Makefile (ie: within CI pipeline)
  make kitchen



Read more
=========

* links
