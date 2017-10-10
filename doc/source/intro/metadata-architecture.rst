`Home <index.html>`_ SaltStack-Formulas Project Introduction

==========================
Model-driven Architectures
==========================

.. contents::
    :backlinks: none
    :local:

Model Driven Architecture (MDA) is an answer to growing complexity of systems
controlled by configuration management and orchestration tools. It provides
unified node classification with atomic service definitions.


Core Principles
===============

Following list shows core principles of model-driven architectures.

**Atomicity**

  Services are separated with such affinity that allows running them on single
  node.

**Reusability / Replacibility**

  Different services serving the same role can be replaced without affecting
  connected services.

**Service Roles**

  Services may implement multiple roles, these can be then separated to
  individual nodes.

**Dynamic Resources**

  Service metadata is alwyas available for definition of dynamic resources.

**Change Management**

  The strength lies not in descibing the static topology of services but more
  the process of ongoing updates.


Sample Architecture Model
=========================

Following figure show example system that has reasonable amount of services
with some outsourced by 3rd party providers. 

.. figure:: /_images/druidly_system.png
  :width: 90%
  :align: center

We can identify several subsystems within complex application systems.

* Proxy service - Distributing load to application layer
* Application service - Application with caches
* Data persistence - Databases and filesystem storage


Horizontal Services
===================

Certain services span across multiple application systems.

.. figure:: /_images/mda_system_composition.png
  :width: 60%
  :align: center

These services usually into one of following categories:

**Access & control system**

  SSH access, orchestration engine access, user authentication

**Monitoring system**

  Events and metric collections, alarmins, dashboards and notifications

**Essential systems**
  
  Name services, time services, mail trainsports

These horizontal services are not configured directly but rather reuse the
metadata of other services to configure itself (metering agent collects
metrics to collect for metadata of surrounding services).


--------------

.. include:: navigation.txt
