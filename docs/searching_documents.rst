Searching Documents
===================

Search is the primary operation of Elasticsearch. The client supports all kinds
of searches supported by the Elasticsearch REST API. There are two different
ways to search.

URI Search
----------

This kind of search uses a query string, which internally translates to a URI
Search. Only a limited number of search options are available in this kind of
search. However, it can be used for quick and handy searches. The optional
**index** and **type** are passed along with **q**, the search query.

.. code-block:: lua

  local res, status = client:search{
    index = "my_index",           -- Optional
    type = "my_type",             -- Optional
    q = "my_key:my_value"
  }

This internally transforms to the following 'curl' request::

  curl -XGET 'http://localhost:9200/my_index/my_type/_search?q=my_key:my_value'

Request Body Search
-------------------

This kind of search involves a search DSL to be passed as **body**. All kinds
of searches are possible using mode. Searches can be restricted to 'index',
'type', or even both, by optionally passing **index** and **type** parameters.

.. code-block:: lua

  local res, status = client:search{
    index = "my_index",
    type = "my_type",
    body = {
      query = {
        match = {
          my_key = "my_value"
        }
      }
    }
  }

The client allows all kinds of searches supported by Elasticsearch. Refer to
the official `documentation <https://www.elastic.co/guide/en/elasticsearch/reference/current/search-request-body.html>`_ of Elasticsearch for details.

Response
--------

The JSON response returned from Elasticsearch is parsed to a Lua table and
returned directly. It consists of some metadata(**took**, **timed_out**, etc.)
and a **hits** table. **hits.total** contains the total number of matches.
**hits.hits** is a lua array and each entry represents one matching document.

.. code-block:: lua

  {
    ["took"] = 3.0,
    ["timed_out"] = false,
    ["_shards"] = {
      ["failed"] = 0.0,
      ["total"] = 5.0,
      ["successful"] = 5.0
    },
    ["hits"] = {
      ["total"] = 1.0,
      ["max_score"] = 7.7399282,
      ["hits"] = {
        ["1"] = {
          ["_index"] = "my_index",
          ["_type"] = "my_type",
          ["_id"] = "my_id",
          ["_score"] = 7.7399282,
          ["_source"] = {
            ["my_key"] = "my_param"
          }
        }
      }
    }
  }

Scan/Scroll Search
------------------

Elasticsearch provides a scan and scroll search functionality for retrieving a
large number of documents efficiently, without paying the penalty of deep
pagination. It works by first executing a 'scan' search. This initiates a
'scan window' which will remain open for the duration of the scan. This
allows proper, consistent pagination. After a 'scan' search, the 'scroll'
search is used to fetch paginated results over that window.

Scan Search
~~~~~~~~~~~

A scan search is just a search request with an additional **search_type** of
**scan**, **scroll** and **size** parameters.

.. code-block:: lua

  local res, status = client:search{
    index = "my_index",
    type = "my_type",
    search_type = "scan",
    scroll = "30s",         -- How long between scroll requests
    size = 50,              -- How many results *per shard* you want back
    body = {
      query = {
        match_all = {}
      }
    }
  }

The scroll id is returned in the response, which is later used while
'scrolling'.

.. code-block:: lua

  local scroll_id = res["_scroll_id"]

Scroll Search
~~~~~~~~~~~~~

Using the above generated **scroll_id**, scroll search can be performed
repeatedly till no more results are found. The client exposes a separate
**scroll** function for this purpose.

.. code-block:: lua

  while true do
    -- Scroll request
    res, status = client:scroll{
      scroll = "30s",
      scroll_id = scroll_id
    }

    -- If no results obtained, break
    if #res["hits"]["hits"] == 0 then
      break
    end

    --
    -- Handle results
    --

    -- Update scroll_id
    scroll_id = res["_scroll_id"]
  end

.. note:: On every request, a new **scroll_id** is generated. Always remember to
          update it.

.. note:: The behavior has changed a lot in Elasticsearch 2.1, we don't have
          *search_type* any more.
