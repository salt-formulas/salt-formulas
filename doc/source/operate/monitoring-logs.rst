`Home <index.html>`_ Installation and Operations Manual

=====================
Collecting Log Events
=====================

.. contents::
    :backlinks: none
    :local:

Our logging stack currently contains following services:

* Heka - log collection, streaming and processing
* Rabbitmq - amqp message broker
* Elasticsearch - indexed log storage
* Kibana - UI for log analysis


Heka
====

Heka is an open source stream processing software system developed by Mozilla.
Heka is a “Swiss Army Knife” type tool for data processing, useful for a wide
variety of different tasks, such as:

* Loading and parsing log files from a file system.
* Accepting statsd type metrics data for aggregation and forwarding to upstream time series data stores such as graphite or InfluxDB.
* Launching external processes to gather operational data from the local system.
* Performing real time analysis, graphing, and anomaly detection on any data flowing through the Heka pipeline.
* Shipping data from one location to another via the use of an external transport (such as AMQP) or directly (via TCP).
* Delivering processed data to one or more persistent data stores.


ElasticSearch
=============

Elasticsearch is a search server based on Lucene.It provides a distributed,
multitenant-capable full-text search engine with an HTTP web interface and
schema-free JSON documents.


Kibana Dashboard
================

Kibana is an open source data visualization plugin for Elasticsearch. It
provides visualization capabilities on top of the content indexed on an
Elasticsearch cluster. Users can create bar, line and scatter plots, or pie
charts and maps on top of large volumes of data.


--------------

.. include:: navigation.txt
