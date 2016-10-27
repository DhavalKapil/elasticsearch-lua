JSON Arrays and Lua Tables
==========================

Elasticsearch uses JSON API. The request body and the response returned is in
JSON format. `elasticsearch-lua`_ converts JSON to Lua table and vice versa
using the `lua-cjson`_ library. Hence, the user directly works with Lua tables.
The request body passed to the client and the response returned by the client
is a Lua table.

Sample example conversion:

.. code-block:: json

  {
    "query": {
      "match": { "content": "quick brown fox" }
    },
    "sort": [
      {
        "time": { "order": "desc" }
      },
      {
        "popularity": { "order": "desc" }
      }
    ]
  }

Note the presence of an array in the above JSON. While creating a
corresponding Lua table, take care to handle arrays using the standard
1-indexable format:

.. code-block:: lua

  {
    query = {
      match = { content = "quick brown fox" }
    },
    sort = {
      {
        time = { order = "desc" }
      },
      {
        popularity = { order = "desc" }
      }
    }
  }

.. _elasticsearch-lua: https://github.com/DhavalKapil/elasticsearch-lua

.. _lua-cjson: https://luarocks.org/modules/luarocks/lua-cjson
