`Home <index.html>`_ SaltStack-Formulas Project Introduction

==========================
Model-driven Architectures
==========================

.. contents::
    :backlinks: none
    :local:

We have the formula structures covered, now we can proceed to define how the
metadata is modelled and key patterns we need to know to build nice standard
models.

Model Driven Architecture (MDA) is an answer to growing complexity of systems
controlled by configuration management and orchestration tools. It provides
unified node classification with atomic service definitions.


Core Principles
===============

Following table shows the core principles for creating model-driven
architectures.

.. list-table::
   :stub-columns: 1 
   :header-rows: 0

   *  - Atomicity
      - Services are separated with such affinity that allows running them on single   node.
   *  - Reusability / Replacibility
      - Different services serving the same role can be replaced without affecting connected services.
   *  - Service Roles
      - Services may implement multiple roles, these can be then separated to individual nodes.
   *  - Dynamic Resources
      - Service metadata is alwyas available for definition of dynamic resources.
   *  - Change Management
      - The strength lies not in descibing the static topology of services but more the process of ongoing updates.


Sample Model Architecture
=========================

Following figure show sample system that has around 10 services with some
outsourced by 3rd party service providers.

.. figure:: /_images/druidly_system.png
  :width: 90%
  :align: center

We can identify several subsystem layers within this complex application
system.

* Proxy service - Distributing load to application layer
* Application service - Application with caches
* Data persistence - Databases and filesystem storage


Horizontally Scaled Services
============================

Certain services span across multiple application systems. These usually play
critical roles in system maintenance and are essential for smooth ongoing
operations.

.. figure:: /_images/mda_system_composition.png
  :width: 60%
  :align: center

These services usually fit into one of following categories:

.. list-table::
   :stub-columns: 1 
   :header-rows: 0

   *  - Access / Control
      - SSH access, orchestration engine access, user authentication.
   *  - Monitoring
      - Events and metric collections, alarmins, dashboards and notifications.
   *  - Essential
      - Name services, time services, mail transports, etc ...
  
These horizontal services are not entirely configured directly but rather
reuse the metadata of other surrounding services to configure itself (for
example metering agent collects metrics to collect for metadata of surrounding
services on the same node, node exports also metadata for external metric
collector to pick).


--------------

.. include:: navigation.txt
