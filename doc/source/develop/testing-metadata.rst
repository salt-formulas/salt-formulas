
Metadata testing
================

Pillars are tree-like structures of data defined on the Salt Master and passed through to the minions. They allow confidential, targeted data to be securely sent only to the relevant minion. Pillar is therefore one of the most important systems when using Salt.


Testing scenarios
-----------------

Testing plan tests each formula with the example pillars covering all possible deployment setups:

The first test run covers ``state.show_sls`` call to ensure that it parses properly with debug output.

The second test covers ``state.sls`` to run the state definition, and run ``state.sls again, capturing output, asserting that ``^Not Run:`` is not present in the output, because if it is then it means that a state cannot detect by itself whether it has to be run or not and thus is not idempotent.


metadata.yml
~~~~~~~~~~~~

.. code-block:: yaml

    name: "service"
    version: "0.2"
    source: "https://github.com/tcpcloud/salt-formula-service"


--------------

.. include:: navigation.txt
