`Home <index.html>`_ SaltStack-Formulas Development Documentation

=================
Formula Packaging
=================

.. contents::
    :backlinks: none
    :local:

This section describes process of building distribution packages for various
distributions.

Debian
======

Debian packaging ecosystems is very diversed, there's many ways how to build
and maintain a package.

We have decided to use ``git-buildpackage`` (aka ``gbp``) and support two
source formats depending on formula needs: ``3.0 (native)`` and ``3.0
(quilt)``

Native Packages
---------------

Native source format is for applications made especially for Debian, it
doesn't distinquish upstream vs. debian distribution.
As it's the easiest format available, it's currently used by most of the
formulas. The only requirement is to have ``debian`` directory in formula's
git repository and building the package is as simple as:

.. code-block:: bash

    dpkg-buildpackage -uc -us

or building source package and using cowbuilder:

.. code-block:: bash

    dpkg-buildpackage -S -nc -uc -us
    sudo cowbuilder --build "../salt-formula-somthin_*.dsc"

Disadvantages of using native format is that it's not possible to maintain
stable versions and therefore maintain formula package in Debian distribution.

Quilt Packages
--------------

Quilt format adds more complexity as it distinquish upstream vs. debian
distribution.

**Upstream** is original unmodified source code, originating from Git
repository, Pypy, or some source tarball provided by upsteram, etc. Such
distribution doesn't care about debian packaging and doesn't ship ``debian``
directory.

**Debian** consists of actual ``debian`` directory with everything needed
similar to ``native`` format but as an additional it supports quilt patches.
This feature allows package maintainer to maintain patches to specific
upstream version separately (eg. to backport new features, fixes, etc.).
In this way it's possible to maintain stable versions of software even if it's
no longer supported upstream.

This format doesn't solve way how debian packaging is done, whether it's
tracked in a Git repository, SVN, etc. Then ``git-buildpackage`` comes into
play.

With ``gbp`` it's possible to have separate branch for packaging (eg.
``debian/unstable``) and upstream (usually ``master``) and this is what we are
using to maintain packages for some formulas.

Example branches in such formula can be following:

- ``master``

  - formulas itself

- debian/unstable

  - packaging for Debian, uploaded into ``unstable``
  - if it's needed to patch formula in particular stable release (eg.
    ``stretch``), according branch can be created, eg. ``debian/stretch``

- ``debian/trusty``

  - packaging for specific Ubuntu version
  - uploaded on Launchpad into ``~salt-formulas/ppa``

- ``debian/xenial``

  - packaging for specific Ubuntu version
  - uploaded on Launchpad into ``~salt-formulas/ppa``

This mechanism also utilizes Git tags to mark specific release, eg.
``debian/1.0-1``.

To build package, checkout into debian branch and run:

.. code-block:: bash

    gbp buildpackage --git-ignore-new --git-ignore-branch -S -uc -us

More Information
================

Debian packaging is complex topic so it's good to check some external
resources as well:

- http://honk.sigxcpu.org/projects/git-buildpackage/manual-html/gbp.html


--------------

.. include:: navigation.txt
