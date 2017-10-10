`Home <index.html>`_ SaltStack-Formulas Project Introduction

========================
Common Metadata Patterns
========================

.. contents::
    :backlinks: none
    :local:

When working with metadata a lot of common patterns emerge. The formulas reuse
the same patterns to maintain the consistency.


Common Service Metadata
=======================

When some metadata is reused by multiple roles it is possible to add the new
virtual `common` role definition. This common metadata should be then
available to every role.


Service Network Binding
=======================

You can define the address and port on whis the service listens in simple way.


Multiple Backend Structures
===========================

When service plugin mechanism allows to add arbitrary plugins to the
individual roles, it is advised to use following format.


Client Relationship
===================

The client relationship has form of a dictionary. The name of the dictionary
represents the required role [database, cache, identity] and the `engine`
parameter then refers to the actual implementation.


SSL Certificates
================

Multiple service use SSL certificates. There are several possible ways how to
obtain a certificate.


--------------

.. include:: navigation.txt
