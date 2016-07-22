Getting Documents
=================

Like indexing documents, there are several ways to 'get' document(s) from
the Elasticsearch server using `elasticsearch-lua`_.

Getting Single Document
-----------------------

To get a single document, provide **index**, **type** and **id** of the
document.

.. code-block:: lua

  local res, status = client:get{
    index = "my_index",
    type = "my_type",
    id = "my_id"
  }

Getting Multiple Documents
--------------------------

Elasticsearch supports getting multiple documents using a single request. It is
advised to use this method in case you want to retrieve multiple documents. You
need to pass an array of Lua tables to the MGET API. Each table represents
details about one document and consists of three fields **_index**, **_type**
and **_id**.

.. code-block:: lua

  local res, status = client:mget{
    body = {
      docs = {
        -- First document
        {
          ["_index"] = "my_index1",
          ["_type"] = "my_type1",
          ["_id"] = "my_id1"
        },
        -- Second document
        {
          ["_index"] = "my_index2",
          ["_type"] = "my_type2",
          ["_id"] = "my_id2"
        }
      }
    }
  }

In case every document has the same **index** or **type**, they can be specified
separately instead of passing them in every document table.

.. code-block:: lua

  local res, status = client:mget{
    index = "my_index",
    type = "my_type",
    body = {
      docs = {
        -- First document
        {
          ["_id"] = "my_id1"
        },
        -- Second document
        {
          ["_id"] = "my_id2"
        }
      }
    }
  }

.. _elasticsearch-lua: https://github.com/DhavalKapil/elasticsearch-lua
