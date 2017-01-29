.. salt-formulas documentation master file

=================================
SaltStack-Formulas' Documentation
=================================


Overview
========

This project provides scalable and reliable IT automation using SaltStack for
installing and operating wide variety of services. It provides standards to
define services models and processes with ability to reuse these software
resources at varying contexts.


Contents
========

.. toctree::
   :maxdepth: 2

   install/index
   operate/index
   develop/index


History
=======

This project is successor of OpenStack-Salt project which under OpenStack Big
Tent initiative provided resources for installing and operating OpenStack
deployments. The scope of current project is much wider than management of
OpenStack installations and provides generic formula ecosystem capable of
managing multiple systems. This was one the main reasons we have decided to abandon the original foundation.

The project seems to bring unwanted split in Salt community with overlapping
functions. The orchestration part may be similar to the official salt formulas
but the major difference lies at meta-data model which being consistent
accross all formulas in SaltStack-Formulas project allows further functions as
dynamic monitoring, telemetry, events collecting, backups, security,
documentation or audits.  It is possible to merge the two formula worlds but
compromise has to be made on both sides and there's not yeat clear path
defined to achieve this.


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
