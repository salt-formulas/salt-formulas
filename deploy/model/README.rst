===========================
Repository with pillar data
===========================

This ``deploy/model`` serve as shared common place to link any tools related to the build of the pillar data model for the
deployment.


Reclass model
===========================

Most of the salt-formulas deployments are deployed with `reclass <http://reclass.pantsfullofunix.net/>`_ an “external node classifier” (ENC).
More informations can be found at `reclass overview http://salt-formulas.readthedocs.io/en/latest/develop/overview-reclass.htm`_.


Local model verification
---------------------------

Tools to verify locally or during CI the consistency of a model.

**.verify.sh**

Verification script that may be used locally on salt-master or during automated CI with test-kitchen.

On already deployed salt master, use as:

.. code-block:: bash

  svn export --force https://github.com/salt-formulas/salt-formulas/trunk/deploy/model ${RECLASS_REPO_PATH:-/srv/salt/reclass}

  cd /srv/salt/reclass
  ./.verify.sh
  ./.verify.sh [NODE FQDN]


**.kitchen.yml**

Test-Kitchen is rehearsal test framework that allows to spin a docker container and bootstrap salt-master with desired
configuration.

More details related the ``kitchen-salt`` and usage with salt-formulas you may find at `salt-formulas testing documentation <https://salt-formulas.readthedocs.io/en/latest/develop/testing-formulas.html>`_

Command ``kitchen converge`` uses ``.verify.sh`` script as simple ``provisioner`` script.

.. code-block:: bash

  svn export --force https://github.com/salt-formulas/salt-formulas/trunk/deploy/model ${RECLASS_REPO_PATH:-.}

  kitchen list
  kitchen converge
  kitchen verify


