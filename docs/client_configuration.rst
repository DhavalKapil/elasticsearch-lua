Client Configuration
====================

`elasticsearch-lua`_ was designed to allow users to configure almost all of the
parameters. The standard way of creating and configuring the client is:

.. code-block:: lua

  local client = elasticsearch.client{
    hosts = {
    -- array of elasticsearch hosts
      {
        protocol = "http",
        host = "localhost",
        port = "9200"
      }
    },
    params = {
      -- additional parameters to configure the client
      pingTimeout = 2,
      logLevel = "warn"
    }
  }

Every configuration passed while creating a client is *optional*. Default
settings are used for configurations that are not provided by the user, as
detailed below.

Host Configuration
------------------

A '**host**' refers to a single node of elasticsearch server. It may or may not
be part of a cluster. Hosts are specified by using the key **hosts**. It
consists of an array of hosts, wherein each host has 3 parameters:

* **protocol** : The underlying protocol to be used while communicating with the
  host. Defaults to '**http**'. (Presently, the client only supports **http**)

* **host**: The domain name or the IP address at which the host is running.
  Defaults to '**localhost**'.

* **port**: The port on which the host is listening. Defaults to '**9200**'.

.. _elasticsearch-lua: https://github.com/DhavalKapil/elasticsearch-lua

Additional Parameters
---------------------

You can also specify some additional parameters to configure the elasticsearch
server. Again, these parameters are optional and have default values.

+----------------+-----------------------------------------------------+----------------------+
|   Parameter    |                       Description                   |       Default        |
+================+=====================================================+======================+
| pingTimeout    | The timeout (in seconds) for any ping or sniff      |          1           |
|                |                                                     |                      |
|                | HTTP request made by the client to the              |                      |
|                |                                                     |                      |
|                | elasticsearch server                                |                      |
+----------------+-----------------------------------------------------+----------------------+
| requestEngine  | The connection request ending to be used. For       |     'LuaSocket'      |
|                |                                                     |                      |
|                | more details, see :ref:`connection`.                |                      |
+----------------+-----------------------------------------------------+----------------------+
| selector       | The selector to be used. For more details, see      | 'RoundRobinSelector' |
|                |                                                     |                      |
|                | :ref:`selector`.                                    |                      |
+----------------+-----------------------------------------------------+----------------------+
| connectionPool | The connection pool to be used. For more details,   |'StaticConnectionPool'|
|                |                                                     |                      |
|                | see :ref:`connection-pool`.                         |                      |
+----------------+-----------------------------------------------------+----------------------+
| maxRetryCount  | The number of times to retry an HTTP request        |          5           |
|                |                                                     |                      |
|                | before exiting with a *TransportError*              |                      |
+----------------+-----------------------------------------------------+----------------------+
| logLevel       | The level of the inbuilt console logger. Follows    |        'WARN'        |
|                |                                                     |                      |
|                | the convention of log4j: ALL, DEBUG, ERROR,         |                      |
|                |                                                     |                      |
|                | FATAL, INFO, OFF, TRACE, WARN. (ignores case)       |                      |
+----------------+-----------------------------------------------------+----------------------+
