`Home <index.html>`_ SaltStack-Formulas Development Documentation


Integration testing
===================

There are requirements, in addition to Salt's requirements, which need to be
installed in order to run the test suite. Install the line below.

.. code-block:: bash

   pip install -r requirements/dev_python27.txt

Once all require requirements are set, use ``tests/runtests.py`` to run all of
the tests included in Salt's test suite. For more information, see --help.

Running the tests
-----------------

An alternative way of invoking the test suite is available in setup.py:

.. code-block:: bash

   ./setup.py test

Instead of running the entire test suite, there are several ways to run only
specific groups of tests or individual tests:

* Run unit tests only: ./tests/runtests.py --unit-tests
* Run unit and integration tests for states: ./tests/runtests.py --state
* Run integration tests for an individual module: ./tests/runtests.py -n integration.modules.virt
* Run unit tests for an individual module: ./tests/runtests.py -n unit.modules.virt_test
* Run an individual test by using the class and test name (this example is for the test_default_kvm_profile test in the integration.module.virt)

Running Unit tests without integration test daemons
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Since the unit tests do not require a master or minion to execute, it is often
useful to be able to run unit tests individually, or as a whole group, without
having to start up the integration testing daemons. Starting up the master,
minion, and syndic daemons takes a lot of time before the tests can even start
running and is unnecessary to run unit tests. To run unit tests without
invoking the integration test daemons, simple remove the /tests portion of the
runtests.py command:

.. code-block:: bash

   ./runtests.py --unit

All of the other options to run individual tests, entire classes of tests, or entire test modules still apply.


Destructive integration tests
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Salt is used to change the settings and behavior of systems. In order to
effectively test Salt's functionality, some integration tests are written to
make actual changes to the underlying system. These tests are referred to as
"destructive tests". Some examples of destructive tests are changes may be
testing the addition of a user or installing packages. By default, destructive
tests are disabled and will be skipped.

Generally, destructive tests should clean up after themselves by attempting to
restore the system to its original state. For instance, if a new user is
created during a test, the user should be deleted after the related test(s)
have completed. However, no guarantees are made that test clean-up will
complete successfully. Therefore, running destructive tests should be done
with caution.

To run tests marked as destructive, set the ``--run-destructive`` flag:

.. code-block:: bash

   ./tests/runtests.py --run-destructive

Automated test runs
-------------------

Jenkins server executes series of tests across supported platforms. The tests
executed from SaltStack-Formulas's Jenkins server create fresh virtual
machines for each test run, then execute destructive tests on the new, clean
virtual machines.

When a pull request is submitted to SaltStack-Formulas's repository, Jenkins
runs Salt's test suite on a couple of virtual machines to gauge the pull
request's viability to merge into SaltStack-Formulas's develop branch. If
these initial tests pass, the pull request can then merged into SaltStack-
Formulas's develop branch by one of SaltStack-Formulas's core developers,
pending their discretion. If the initial tests fail, core developers may
request changes to the pull request. If the failure is unrelated to the
changes in question, core developers may merge the pull request despite the
initial failure.

Once the pull request is merged into SaltStack-Formulas's develop branch, a
new set of Jenkins virtual machines will begin executing the test suite. The
develop branch tests have many more virtual machines to provide more
comprehensive results.

--------------

.. include:: navigation.txt
