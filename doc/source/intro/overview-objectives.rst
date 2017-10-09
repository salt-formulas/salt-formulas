`Home <index.html>`_ SaltStack-Formulas Project Introduction

==================
Project Objectives
==================

Project provides standards to define service models and processes with ability
to reuse these components in varying contexts. Metadata model shared accross
all services let us explore underlying relationships that ease the management
of infrastructures acoross whole life-span.

The project has little different objectives compare to official salt-formulas.
The general orientation of project may be similar to the official salt
formulas but the major differences lie at meta-data model and clear
decomposition which being consistent accross all formulas in SaltStack-
Formulas project.


Collateral Bonuses
==================

Adhering to the standards allows further services to be declared and
configured in dynamic way, consuming metadata of surrounding services. This
include following domains:
 
* Dynamic monitoring: Event collecting, telemetry with dashboards, alarms with notifications
* Dynamic backup: Data backuping and restoring 
* Dynamic security: Firewall rules, router configurations
* Dynamic documentation, topology visualizations
* Dynamic audit profiles and beacons

All these can be generated out of your existing infrastructure without need
for any further parametrisation.


--------------

.. include:: navigation.txt
