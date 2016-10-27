.. _selector:

Selector
========

The selector is an internal structure used in the client. Given an array of
connections, it chooses a single connection. Some selectors don't even worry
much about the internals of the connection. There are some in-built selectors
that you can use or you can even write and use your own custom selector.

.. note:: A selector is called every time a request to the Elasticsearch
          server is to be made. The list of all available connections are
          passed to the selector.

In-Built Selectors
------------------

These selectors are defined inside `elasticsearch.selectors` module. There are
three of them:

* **RoundRobinSelector (Default)**: The connections are selected in a round robin
  fashion. i.e. #1 connection will be chosen on the first request, #2
  connection will be chosen on the second request and so on. This ensures a
  nearly even load across each node in the cluster.

* **StickyRoundRobinSelector**: This selector will always return('stick') the same
  connection each time, unless a request fails. In that case, it will move on to
  the next connection in a round robin fashion. This case is ideal for
  persistent connections where a considerable time is spent in opening and
  closing connections.

* **RandomSelector**: This selector returns a random connection from the list
  irrespective of whether it is `alive` or `not`. It internally uses
  `math.random` function.

To use any particular selector you have to specify it in the parameters while
creating a client. By default, the RoundRobinSelector will be used.

.. code-block:: lua

  local client = elasticsearch.client{
    hosts = {
      {
        host = "localhost",
        port = "9200"
      }
    },
    params = {
      selector = "StickyRoundRobinSelector"
      -- selector = "RoundRobinSelector"
      -- selector = "RandomSelector"
    }
  }

Custom Selector
---------------

You can also implement your own custom selector and pass it to the client.
To create a custom selector, extend `elasticsearch.selector.Selector` and
implement the `selectNext` function.

.. code-block:: lua

  -- Requiring the Base Class
  local Selector = require "elasticsearch.selector.Selector"

  -- Create a custom selector
  local CustomSelector = Selector:new()

  -- Implement the constructor function
  function CustomSelector:new(o)
    o = o or {}
    -- Custom initialization code related to your algorithm
    -- End custom code
    setmetatable(o, self)
    self.__index = self
    return o
  end

  -----------------------------------------------------------------------------
  -- Implement the logic to select and return a single connection from
  -- an array of connections
  --
  -- @param   connections   A table of connections
  -- @return  Connection    The connection selected
  -----------------------------------------------------------------------------
  function CustomSelector:selectNext(connections)
    local connection = -- Select a connection
    return connection
  end

After creating a custom selector, it needs to be passed as a parameter while
creating a client:

.. code-block:: lua

  local client = elasticsearch.client{
    params = {
      selector = CustomSelector
    }
  }

.. note:: A string is passed in **selector** when setting an in-built selector.
          Otherwise, an object is passed while setting a custom selector.
