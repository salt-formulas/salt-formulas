
Event monitoring
================

**Monitoring Service (Sensu)**

Sensu is often described as the “monitoring router”. Essentially, Sensu takes the results of “check” scripts run across many systems, and if certain conditions are met, passes their information to one or more “handlers”. Checks are used, for example, to determine if a service like Apache is up or down. Checks can also be used to collect data, such as MySQL query statistics or Rails application metrics. Handlers take actions, using result information, such as sending an email, messaging a chat room, or adding a data point to a graph. There are several types of handlers, but the most common and most powerful is “pipe”, a script that receives data via standard input. Check and handler scripts can be written in any language, and the community repository continues to grow!

Sensu properties:

* Written in Ruby, using EventMachine
* Great test coverage with continuous integration via Travis CI
* Can use existing Nagios plugins
* Configuration all in JSON
* Has a message-oriented architecture, using RabbitMQ and JSON payloads
* Packages are “omnibus”, for consistency, isolation, and low-friction deployment

Sensu embraces modern infrastructure design, works elegantly with configuration management tools, and is built for the cloud.

The Sensu framework contains a number of components. The following diagram depicts these core elements and how they interact with one another.

.. image:: https://sensuapp.org/docs/latest/img/sensu-diagram-87a902f0.gif

--------------

.. include:: navigation.txt
