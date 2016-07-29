Indexing Documents
==================

Elasticsearch accepts documents in the form of JSON. In `elasticsearch-lua`_
documents are passed as Lua tables. There are several ways to index documents.

Indexing Single Document
------------------------

To index a document, you need to pass **index** and **type** as parameters.
The document to be indexed is passed as a Lua table using the **body**
parameter. Optionally, you can also provide an **id** for the document or let
Elasticsearch generate it for you.

.. code-block:: lua

  local res, status = client:index{
    index = "my_index",
    type = "my_type",
    id = "my_id",            -- Optional
    body = {
      my_key = "my_value"
    }
  }

You can specify additional parameters such as **routing**, **refresh**, etc.
alongside **index**, **type**.

.. code-block:: lua

  local res, status = client:index{
    index = "my_index",
    type = "my_type",
    id = "my_id",            -- Optional
    routing = "company_xyz", -- Optional
    body = {
      my_key = "my_value"
    }
  }

Refer to the Elasticsearch `documentation <https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html>`_ for a complete list of allowed parameters.

Indexing Bulk Documents
-----------------------

Elasticsearch also supports bulk indexing of documents (indexing more than one
document in one HTTP request). It is advised to use the Bulk API if you have
to index many documents together. The client accepts an array of tables. You
have to specify a pair of tables for every document. The first represents
an action('index') in this context and the second represents the body. So
basically the array consists of action, body, action, body, etc. tables.

.. code-block:: lua

  local res, status = client:bulk{
    body = {
      -- First action
      {
        index = {
          ["_index"] = "my_index1",
          ["_type"] = "my_type1"
        }
      },
      -- First body
      {
        my_key1 = "my_value1",
      },
      -- Second action
      {
        index = {
          ["_index"] = "my_index2",
          ["_type"] = "my_type2"
        }
      },
      -- Second body
      {
        my_key2 = "my_value2",
      }
    }
  }

You can also specify a common **index** or a **type** separately that would be
used as default in every action.

.. code-block:: lua

  local res, status = client:bulk{
    index = "my_index",
    body = {
      -- First action
      {
        index = {
          ["_type"] = "my_type1"
        }
      },
      -- First body
      {
        my_key1 = "my_value1",
      },
      -- Second action
      {
        index = {
          ["_type"] = "my_type2"
        }
      },
      -- Second body
      {
        my_key2 = "my_value2",
      }
    }
  }

.. _elasticsearch-lua: https://github.com/DhavalKapil/elasticsearch-lua
