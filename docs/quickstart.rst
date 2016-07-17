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
