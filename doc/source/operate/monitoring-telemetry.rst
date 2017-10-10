`Home <index.html>`_ Installation and Operations Manual

=========================
Collecting Telemetry Data
=========================

.. contents::
    :backlinks: none
    :local:

Gathering metrics and other values. There are three basic types of meters that
are stored in the time-series database.

**Cumulative**

  Increasing over time (network or disk usage counters)

**Gauge**

  Discrete items (number of connected users) and fluctuating values (system load)

**Delta**

 Values changing over time (bandwidth)


Collectd/Graphite
=================

Collectd gathers statistics about the system it is running on and stores this
information. Those statistics can then be used to find current performance
bottlenecks (i.e. performance analysis) and predict future system load (i.e.
capacity planning). It's written in C for performance and portability,
allowing it to run on systems without scripting language or cron daemon, such
as embedded systems. At the same time it includes optimizations and features
to handle hundreds of thousands of data sets. It comes with over 90 plugins
which range from standard cases to very specialized and advanced topics. It
provides powerful networking features and is extensible in numerous ways

Graphite is an enterprise-scale monitoring tool that runs well on cheap
hardware. It was originally designed and written by Chris Davis at Orbitz in
2006 as side project that ultimately grew to be a foundational monitoring
tool. In 2008, Orbitz allowed Graphite to be released under the open source
Apache 2.0 license. Since then Chris has continued to work on Graphite and has
deployed it at other companies including Sears, where it serves as a pillar of
the e-commerce monitoring system. Today many large companies use it.

What Graphite does not do is collect data for you, however there are some
tools out there that know how to send data to graphite. Even though it often
requires a little code, sending data to Graphite is very simple.

Graphite consists of 3 software components:

* carbon - a Twisted daemon that listens for time-series data
* whisper - a simple database library for storing time-series data (similar in design to RRD)
* graphite - A Django webapp that renders graphs on-demand using Cairo


Graphite Metrics Functions
--------------------------

The metrics can be adjusted by applying functions on them within the Graphite
composer. Aside the ability to store time-series data Graphite has a lot of
additional functions that can be used to alter time-series data to more
appropriate form, if we want to get the delta from the cumulative metrics or
ad vice versa.

**integral(seriesList)**

    This will show the sum over time, sort of like a continuous addition
    function. Useful for finding totals or trends in metrics that are
    collected per minute.

    Example:

    .. code-block:: yaml

        &target=integral(company.sales.perMinute)

    This would start at zero on the left side of the graph, adding the sales
    each minute, and show the total sales for the time period selected at the
    right side, (time now, or the time specified by ‘&until=’).

**derivative(seriesList)**

    This is the opposite of the integral function. This is useful for taking a
    running total metric and calculating the delta between subsequent data
    points.

    This function does not normalize for periods of time, as a true derivative
    would. Instead see the perSecond() function to calculate a rate of change
    over time.

    Example:

    .. code-block:: yaml

        &target=derivative(company.server.application01.ifconfig.TXPackets)

**sumSeries(*seriesLists)**

    Short form: sum()

    This will add metrics together and return the sum at each datapoint. (See
    integral for a sum over time)

    Example:

    .. code-block:: yaml

        &target=sum(company.server.application*.requestsHandled)

    This would show the sum of all requests handled per minute (provided
    requestsHandled are collected once a minute). If metrics with different
    retention rates are combined, the coarsest metric is graphed, and the sum
    of the other metrics is averaged for the metrics with finer retention
    rates.

Read more about functions at
http://graphite.readthedocs.org/en/latest/functions.html#module-
graphite.render.functions


--------------

.. include:: navigation.txt
