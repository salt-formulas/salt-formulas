
============================================
Generate a team accounts from CSV input file
============================================

Modify team.sh in order to properly parse your input file.
Example usage to generate individuals yaml configs:

.. code-block:: bash

  ./team.sh team.csv
  mv \*.yml [MODEL TEAM DIRECTORY]/


To create ``init.yml`` loading all accounts, use:

.. code-block:: bash

  cd [MODEL TEAM DIRECTORY]
  echo 'classes:' > init.yml
  ls| xargs -I{} basename {} .yml | sed 's/^/- /' >> init.yml
