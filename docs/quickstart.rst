Quickstart
===============

A quick guide for installing and using `elasticsearch-lua`_.

.. _elasticsearch-lua: https://github.com/DhavalKapil/elasticsearch-lua

Installation
------------

* Directly using luarocks::

    $ luarocks install --server=http://luarocks.org/dev elasticsearch

* Using elasticsearch as a dependency in your project

  * Add elasticsearch in your 'rockspec'::

      dependencies = {
        "elasticsearch"
      }

  * Install dependencies using luarocks::

      $ luarocks install --server=http://luarocks.org/dev <your_rockspec_file>

Setting up Client
-----------------

Requiring elasticsearch in source file:

.. code-block:: lua

  local elasticsearch = require "elasticsearch"

Creating a client:

.. code-block:: lua

  local client = elasticsearch.client{
    hosts = {
      {
        host = "localhost",
        port = "9200"
      }
    }
  }

.. note:: **host** and **port** are optional. In case any parameter is not specified,
          **host** defaults to 'localhost' and **port** defaults to '9200'.

Operations
----------

elasticsearch-lua uses Lua tables to pass parameters for any operation. Common keys
include **index**, **type**, **id** and **body**. Each kind of operation may have
additional parameters. The **body** itself is a Lua table.

Every operation returns two values

.. code-block:: lua

  local value1, value2 = client:operation()

The result depends on whether the operation succeeded or failed

+--------+------------------+---------------+
|        | Success          | Failure       |
+========+==================+===============+
| value1 | Actual result    | nil           |
+--------+------------------+---------------+
| value2 | HTTP status code | error message |
+--------+------------------+---------------+

Indexing Documents
~~~~~~~~~~~~~~~~~~

To index a document, you need to pass **index**, **type**, **id** and **body**
as parameters:

.. code-block:: lua

  local res, status = client:index{
    index = "my_index",
    type = "my_type",
    id = "my_id",
    body = {
      my_key = "my_value"
    }
  }

On success, the response will be returned in **res** as a Lua table and the
HTTP status code in **status**. Sample output:

.. code-block:: lua

  {
    ["_index"] = "my_index",
    ["_type"] = "my_type",
    ["_id"] = "my_id",
    ["created"] = true,
    ["_version"] = 1.0,
    ["_shards"] = {
      ["successful"] = 1.0,
      ["failed"] = 0.0,
      ["total"] = 2.0,
    }
  }

Getting Documents
~~~~~~~~~~~~~~~~~

To get a document, you need to pass **index**, **type** and **id** of the
document as parameters:

.. code-block:: lua

  local res, status = client:get{
    index = "my_index",
    type = "my_type",
    id = "my_id"
  }

The following response is returned if the document can be retrieved:

.. code-block:: lua
  
  {
    ["_index"] = "my_index",
    ["_type"] = "my_type",
    ["_id"] = "my_id",
    ["found"] = true,
    ["_version"] = 1.0,
    ["_source"] = {
      ["my_key"] = "my_value"
    }
  }

Otherwise, if the document is not present or cannot be retrieved,
**nil** and an **error string** is returned.

Searching Documents
~~~~~~~~~~~~~~~~~~~

For searching documents, you can either perform a URI based search(by passing
a **q** parameter) or a request body search(by passing the search DSL in
**body** parameter). Searches can be restricted to 'index', 'type', or even
both, by optionally passing **index** and **type** parameters. A sample request
body search:

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

The returned response consists of some metadata(**took**, **timed_out**, etc.)
and a **hits** table. **hits.total** contains the total number of matches.
**hits.hits** is a lua array, each entry represents one matching document.

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

Deleting Documents
~~~~~~~~~~~~~~~~~~

To delete a document, you need to pass **index**, **type**, **id** and **body**
as parameters:

.. code-block:: lua

  local res, status = client:delete{
    index = "my_index",
    type = "my_type",
    id = "my_id"
  }

On deletion, the following response is returned back:

.. code-block:: lua

  {
    ["_index"] = "my_index",
    ["_type"] = "my_type",
    ["_id"] = "my_id",
    ["found"] = true,
    ["_version"] = 2.0,
    ["_shards"] = {
      ["failed"] = 0.0,
      ["total"] = 2.0,
      ["successful"] = 1.0,
    }
  }

Wrap up
-------

This was just a brief overview of using elasticsearch-lua. The **client**
functions, the **body** parameter and the response returned bears resemblance
with the Elasticsearch REST API.

Read the rest of the documentation to know more about the client.
