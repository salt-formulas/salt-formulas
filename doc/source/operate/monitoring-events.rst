`Home <index.html>`_ Installation and Operations Manual

================
Event Monitoring
================

.. contents::
    :backlinks: none
    :local:

The overall health of the systems is measured continuously. The metering
system collects metrics from the systems and store them in time-series
database for furher evaluation and analysys. The log collecting system
collects logs from all systems, transforms them to unified form and stores
them for analysis. The monitoring system checks for functionality of separate
systems and raises events in case of threshold breach. The monitoring systems
may query log and time-series databases for accident patterns and raise an
event if anomaly is detected.

.. figure :: /_images/monitoring_system.svg
   :width: 100%
   :align: center

**The difference between monitoring and metering systems**

Monitoring is generally used to check for functionality on the overall system
and to figure out if the hardware for the overall installation and usage needs
to be scaled up. With monitoring, we also do not care that much if we have
lost some samples in between. Metering is required for information gathering
on usage as a base for resource utilisation. Many monitoring checks are simple
meter checks with threshold definitions.


Monitoring Service (Sensu)
==========================

Sensu is often described as the “monitoring router”. Essentially, Sensu takes
the results of “check” scripts run across many systems, and if certain
conditions are met, passes their information to one or more “handlers”. Checks
are used, for example, to determine if a service like Apache is up or down.
Checks can also be used to collect data, such as MySQL query statistics or
Rails application metrics. Handlers take actions, using result information,
such as sending an email, messaging a chat room, or adding a data point to a
graph. There are several types of handlers, but the most common and most
powerful is “pipe”, a script that receives data via standard input. Check and
handler scripts can be written in any language, and the community repository
continues to grow!

Sensu properties:

* Written in Ruby, using EventMachine
* Great test coverage with continuous integration via Travis CI
* Can use existing Nagios plugins
* Configuration all in JSON
* Has a message-oriented architecture, using RabbitMQ and JSON payloads
* Packages are “omnibus”, for consistency, isolation, and low-friction deployment

Sensu embraces modern infrastructure design, works elegantly with configuration management tools, and is built for the cloud.

--------------

.. include:: navigation.txt
