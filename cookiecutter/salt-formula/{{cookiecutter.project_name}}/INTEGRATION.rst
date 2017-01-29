
Continuous Integration
======================

We are using Jenkins to spin a kitchen instances in Docker or OpenStack environment.

If you would like to repeat, then you may use ``.kitchen.<backend>.yml`` configuration yaml in the main directory
to override ``.kitchen.yml`` at some points.
Usage: ``KITCHEN_LOCAL_YAML=.kitchen.<driver>.yml kitchen verify server-ubuntu-1404 -t tests/integration``.
Example: ``KITCHEN_LOCAL_YAML=.kitchen.docker.yml kitchen verify server-ubuntu-1404 -t tests/integration``.

Be aware of fundamental differences of backends. The formula verification scripts are primarily tested with
Vagrant driver.

CI uses a tuned `make kitchen` target defined in `Makefile` to perform following (Kitchen Test) actions:

1. *create*, provision an test instance (VM, container)
2. *converge*, run a provisioner (shell script, kitchen-salt)
3. *verify*, run a verification (inspec, other may be added)
4. *destroy*


Test Kitchen
------------


To install Test Kitchen is as simple as:

.. code-block:: shell

  # install kitchen
  gem install test-kitchen

  # install required plugins
  gem install kitchen-vagrant kitchen-docker kitchen-salt

  # install additional plugins & tools
  gem install kitchen-openstack kitchen-inspec busser-serverspec

  kitchen list
  kitchen test

of course you have to have installed Ruby and it's package manager `gem <https://rubygems.org/>`_ first.

One may be satisfied installing it system-wide right from OS package manager which is preferred installation method.
For advanced users or the sake of complex environments you may use `rbenv <https://github.com/rbenv/rbenv>`_ for user side ruby installation.

 * https://github.com/rbenv/rbenv
 * http://kitchen.ci/docs/getting-started/installing

An example steps then might be:

.. code-block:: shell

  # get rbenv
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv

  # configure
  cd ~/.rbenv && src/configure && make -C src     # don't worry if it fails
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"'>> ~/.bash_profile
  # Ubuntu Desktop note: Modify your ~/.bashrc instead of ~/.bash_profile.
  cd ~/.rbenv; git fetch

  # install ruby-build, which provides the rbenv install command
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

  # list all available versions:
  rbenv install -l

  # install a Ruby version
  # maybe you will need additional packages: libssl-dev, libreadline-dev, zlib1g-dev
  rbenv install 2.0.0-p648

  # activate
  rbenv local 2.0.0-p648

  # install test kitchen
  gem install test-kitchen


An optional ``Gemfile`` in the main directory may contain Ruby dependencies to be required for Test Kitchen workflow.
To install them you have to install first ``gem install bundler`` and then run ``bundler install``.



Verifier
--------

The `Busser <https://github.com/test-kitchen/busser>`_ *Verifier* goes with test-kitchen by default.
It is used to setup and run tests implemented in `<repo>/test/integration`. It guess and installs the particular driver to tested instance.
By default `InSpec <https://github.com/chef/kitchen-inspec>`_ is expected.

You may avoid to install busser framework if you configure specific verifier in `.kitchen.yml` and install it kitchen plugin locally:

	verifier:
		name: serverspec

If you would to write another verification scripts than InSpec store them in ``<repo>/tests/integration/<suite>/<busser>/*``.
``Busser <https://github.com/test-kitchen/busser>`` is a test setup and execution framework under test kitchen.



InSpec
~~~~~~

Implement integration tests under ``<repo>/tests/integration/<suite>/<busser>/*`` directory with ``_spec.rb`` filename
suffix.

Docs:

* https://github.com/chef/inspec
* https://github.com/chef/kitchen-inspec


