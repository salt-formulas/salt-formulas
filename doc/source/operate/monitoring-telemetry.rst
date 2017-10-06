`Home <index.html>`_ SaltStack-Formulas Operation Manual



Telemetry collecting
====================

Collectd/Graphite
*****************

Collectd gathers statistics about the system it is running on and stores this information. Those statistics can then be used to find current performance bottlenecks (i.e. performance analysis) and predict future system load (i.e. capacity planning). It's written in C for performance and portability, allowing it to run on systems without scripting language or cron daemon, such as embedded systems. At the same time it includes optimizations and features to handle hundreds of thousands of data sets. It comes with over 90 plugins which range from standard cases to very specialized and advanced topics. It provides powerful networking features and is extensible in numerous ways

Graphite is an enterprise-scale monitoring tool that runs well on cheap hardware. It was originally designed and written by Chris Davis at Orbitz in 2006 as side project that ultimately grew to be a foundational monitoring tool. In 2008, Orbitz allowed Graphite to be released under the open source Apache 2.0 license. Since then Chris has continued to work on Graphite and has deployed it at other companies including Sears, where it serves as a pillar of the e-commerce monitoring system. Today many large companies use it.

What Graphite does not do is collect data for you, however there are some tools out there that know how to send data to graphite. Even though it often requires a little code, sending data to Graphite is very simple.

There are three basic types of meters that are stored in the time-series database.

* Cumulative: increasing over time (network or disk usage counters)
* Gauge: discrete items (number of connected users) and fluctuating values (system load)
* Delta: values changing over time (bandwidth)

Graphite consists of 3 software components:

* carbon - a Twisted daemon that listens for time-series data
* whisper - a simple database library for storing time-series data (similar in design to RRD)
* graphite - A Django webapp that renders graphs on-demand using Cairo


Graphite composer
*****************

Graphite composer is a graphical tool for manipulating graphite metrics and tuning up functions applied to metrics.


Graphite metrics functions
**************************

The metrics can be adjusted by applying functions on them within the Graphite composer. Aside the ability to store time-series data Graphite has a lot of additional functions that can be used to alter time-series data to more appropriate form, if we want to get the delta from the cumulative metrics or ad vice versa.

**integral(seriesList)**

    This will show the sum over time, sort of like a continuous addition function. Useful for finding totals or trends in metrics that are collected per minute.

    Example:

    .. code-block:: yaml

        &target=integral(company.sales.perMinute)

    This would start at zero on the left side of the graph, adding the sales each minute, and show the total sales for the time period selected at the right side, (time now, or the time specified by ‘&until=’).

**derivative(seriesList)**

    This is the opposite of the integral function. This is useful for taking a running total metric and calculating the delta between subsequent data points.

    This function does not normalize for periods of time, as a true derivative would. Instead see the perSecond() function to calculate a rate of change over time.

    Example:

    .. code-block:: yaml

        &target=derivative(company.server.application01.ifconfig.TXPackets)

**sumSeries(*seriesLists)**

    Short form: sum()

    This will add metrics together and return the sum at each datapoint. (See integral for a sum over time)

    Example:

    .. code-block:: yaml

        &target=sum(company.server.application*.requestsHandled)

    This would show the sum of all requests handled per minute (provided requestsHandled are collected once a minute). If metrics with different retention rates are combined, the coarsest metric is graphed, and the sum of the other metrics is averaged for the metrics with finer retention rates.

Read more about functions at http://graphite.readthedocs.org/en/latest/functions.html#module-graphite.render.functions

Get aggregated CPU usage of a node in percents
**********************************************

In this task we'll look at how to get some useful metric out of data gathered by collectd. The CPU usage is in form of counters. We basically sum value of all states for all CPUs and sum value of idle state for all CPUs and transform these 2 by asPercent function to percentage value. As we are doing ratio there's no need for derivation.

.. code-block:: yaml

    sumSeries(default_prd.nodename.cpu.*.idle)
    # sum of all CPU idle state counters

    sumSeries(default_prd.nodename.cpu.*.*)
    # sum of all CPU state counters

    asPercent(sumSeries(default_prd.nodename.cpu.*.idle), sumSeries(default_prd.nodename.cpu.*.*))
    # gives percentual ratio of two metrics and in our case the ratio of free cpu, to get ratio of used CPU, the resulting series should be scaled by -1 and ofsetted by 100.

Send arbitrary metric to Graphite
*********************************

It is possible to send metrics to graphite from a bash script or from within an application.Graphite understands messages with this format:

.. code-block:: yaml

    metric_path value timestamp\n

* `metric_path` is the metric namespace that you want to populate.
* `value` is the value that you want to assign to the metric at this time.
* `timestamp` is the unix epoch time.

Try send following metric from any node in the cluster:

.. code-block:: bash

    root@cfg01:~# echo "test.bash.stats 42 `date +%s`" | nc mon01 2003

--------------

.. include:: navigation.txt
