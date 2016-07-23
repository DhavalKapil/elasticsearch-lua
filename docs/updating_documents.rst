Updating Documents
==================

Elasticsearch supports updating documents. **index**, **type** and **id**
parameters are required to be passed. The fields needed to be updated in the
document are passed inside the **doc** parameter which is inside the **body**.

.. code-block:: lua

  local res, status = client:update{
    index = "my_index",
    type = "my_type",
    id = "my_id",
    body = {
      doc = {
        my_key = "new_value",
        my_new_key = "another_value"
      }
    }
  }
