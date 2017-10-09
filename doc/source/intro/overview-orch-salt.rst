`Home <index.html>`_ SaltStack-Formulas Project Introduction

==================================
SaltStack Configuration Management
==================================

SaltStack-Formulas uses Salt configuration platform to install and manage
infrastructures. Salt is an automation platform that greatly simplifies system
and application deployment. Salt uses service *formulas* to define resources
written in the YAML language that orchestrate the individual parts of system
into the working entity.


Pillar metadata
===============

Pillar is an interface for Salt designed to offer global values that are
distributed to all minions. The ext_pillar option allows for any number of
external pillar interfaces to be called to populate the pillar data.

Pillars are tree-like structures of data defined on the Salt Master and passed
through to the minions. They allow confidential, targeted data to be securely
sent only to the relevant minion. Pillar is therefore one of the most
important systems when using Salt.


--------------

.. include:: navigation.txt
