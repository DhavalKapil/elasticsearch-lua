.. _connection-pool:

Connection Pool
===============

Connection Pool is an internal construct that maintains a list('pool') of
connections to nodes that may be alive or dead. The job of a Connection Pool
is to handle these dead and alive connections and return back an alive
connection to provide the best behavior for the client. In case no alive
connection can be found, a `nil` is returned. There are some in-built
connection pools that you can use or you can even write and use your own custom
connection pool.

.. note:: A connection pool is called every time a request to the Elasticsearch
          server is to be made. It internally uses the selector to choose a
          connection.

In-Built Connection Pools
-------------------------

These connection pools are defined inside `elasticsearch.connectionpool` module.
There are two of them:

* **StaticConnectionPool (Default)**: The StaticConnectionPool selects a
  connection using a selector. It returns the connection if it is alive. If the
  connection is dead and a certain time interval has passed, it is tested
  again. If it is still dead, another connection is selected using the selector
  and the process is repeated. If no alive connection is found, the remaining
  dead connections are tested one by one.

* **SniffConnectionPool**: The SniffConnectionPool iterates the list of
  connections and returns the first alive connection found. For dead
  connections, it pings again to update its status. Also, after a certain time
  interval, it sniffs the existing connections to discover new nodes in the
  cluster and update its list of connections.

To use any particular connection pool you have to specify it in the parameters
while creating a client. By default, the StaticConnectionPool will be used.

.. code-block::lua

  local client = elasticsearch.client{
    hosts = {
      {
        host = "localhost",
        port = "9200"
      }
    },
    params = {
      connectionPool = "StaticConnectionPool"
      -- connectionPool = "SniffConnectionPool"
    }
  }

Custom Connection Pool
----------------------

You can also implement your own custom connection pool and pass it to the
client. To create a custom connection pool, extend
`elasticsearch.connectionpool.ConnectionPool` and implement the
`nextConnection` function.

.. code-block:: lua

  -- Requiring the Base Class
  local ConnectionPool = require "elasticsearch.connectionpool.ConnectionPool"

  -- Create a custom connection pool
  local CustomConnectionPool = ConnectionPool:new()

  -- Implement the constructor function
  function CustomConnectionPool:new(o)
    o = o or {}
    -- Custom initialization code related to your algorithm
    -- End custom code
    setmetatable(o, self)
    self.__index = self
    return o
  end

  -----------------------------------------------------------------------------
  -- Implement the logic to return a single connection
  --
  -- @return  Connection    The connection selected
  -----------------------------------------------------------------------------
  function CustomConnectionPool:nextConnection()
    local connection = -- Select a connection
    return connection
  end

After creating a custom ConnectionPool, it needs to be passed as a parameter
while creating a client:

.. code-block:: lua

  local client = elasticsearch.client{
    params = {
      connectionPool = CustomConnectionPool
    }
  }

.. note:: A string is passed in **connectionPool** when setting an in-built
          Connection Pool. Otherwise, an object is passed while setting a
          custom Connection Pool.