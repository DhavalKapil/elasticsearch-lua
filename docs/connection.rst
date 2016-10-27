.. _connection:

Connection
==========

A connection represents the lowest level of bare interaction with the
Elasticsearch server in the form of HTTP requests. The client presently
supports HTTP requests using the `LuaSocket`_ library.

.. _LuaSocket: http://w3.impa.br/~diego/software/luasocket/

Each time a request is to be made, the `request` function is called. However,
support is provided to overload this function. While creating the client,
`requestEngine` can be passed in `params`.

.. code-block:: lua

  local client = elasticsearch.client{
    hosts = {
      {
        host = "localhost",
        port = "9200"
      }
    },
    params = {
      requestEngine = customRequestEngine
    }
  }

`customRequestEngine` should be a Lua function which takes as arguments the
http `method`, `uri`, `body` and `timeout`. It should return a table `response` with
keys `code`, `statusCode` and `body`.

.. code-block:: lua

  -----------------------------------------------------------------------------
  -- Makes a request to target server
  --
  -- @param   method  The HTTP method to be used
  -- @param   uri     The HTTP URI for the request
  -- @param   body    The body to passed if any
  -- @param   timeout The timeout(if any) in seconds
  --
  -- @return  table   The response returned
  -----------------------------------------------------------------------------
  function customRequestEngine(method, uri, body, timeout)
    -- Make an HTTP 'method' request to 'uri' with 'body' and 'timeout'
    response.code       = -- non nil for a successful request
    response.statusCode = -- HTTP status code returned
    response.body       = -- Response body
    return response
  end
