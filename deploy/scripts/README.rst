==============
Deploy scripts
==============

This ``deploy/scripts`` serve as shared common place to link any deployment tools.


**bootstrap-salt.sh**
**bootstrap-salt.ps1**

Salt bootstrap scripts. Local copy of upstream `https://bootstrap.saltstack.com/`_.


**salt-master-setup.sh**

Script to install and configure salt *minion* but mostly *salt master* with *salt-formulas* common prerequisites in mind.
Configuration driven by environment variables, see source for more details...

.. code-block:: bash

  # reclass
  export RECLASS_ADDRESS=<repo url>   ## if not already cloned in /srv/salt/reclass >

  # formula
  export FORMULAS_BRANCH=master
  export FORMULAS_SOURCE=git

  # system / host / salt master minion id
  export HOSTNAME=cfg01
  export DOMAIN=infra.ci.local
  #export MINION_ID

  # salt
  export SALT_MASTER_BOOTSTRAP_MINIMIZED=False
  export BOOTSTRAP_SALTSTACK_OPTS=" -dX stable 2016.3"
  export EXTRA_FORMULAS="prometeus"

  # environment
  SALT_SOURCE=${SALT_SOURCE:-pkg}
  SALT_VERSION=${SALT_VERSION:-latest}


**salt-master-init.sh**

Script to bootstrap *salt master* and verify the model. To install salt master uses ``salt-master-setup.sh``.
Configuration driven by environment variables.

.. code-block:: bash

  cd /srv/salt/scripts
  MASTER_HOSTNAME=cfg01.infra.ci.local ./salt-master-init.sh

.. note:
  Creates /srv/salt/scripts/.salt-master-setup.sh if succesfully passed the "setup script" 
  with the aim to avoid subsequent run's.


**formula-fetch.sh**

Script to install formulas with dependencies.


**salt-state-apply-trend.sh**

Simple script to invoking highstate on whole infrastructure with ``test=true``. Json output is aggregated with `jq`
(Failed/Success/Changes/Errors) and compared with previous run.


Bootstrap the Salt Master node
==============================
(expects salt-formulas reclass model repo)

.. code-block:: bash

  apt-get update
  apt-get install git curl subversion

  svn export --force https://github.com/salt-formulas/salt-formulas/trunk/deploy/scripts \
  /srv/salt/scripts

  git clone <model-repository> /srv/salt/reclass
  git submodule update --init --recursive
  # or
  # (if system level is not add yet)
  git submodule add https://github.com/Mirantis/reclass-system-salt-model \
    /srv/salt/reclass/classes/system/

  cd /srv/salt/scripts
  MASTER_HOSTNAME=cfg01.infra.ci.local ./salt-master-init.sh


