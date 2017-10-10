`Home <index.html>`_ Installation and Operations Manual

================================
Monitoring, Metering and Logging
================================

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


--------------

.. include:: navigation.txt
