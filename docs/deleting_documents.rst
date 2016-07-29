Deleting Documents
==================

Documents can be deleted by specifying **index**, **type** and the **id** of
the document.

.. code-block:: lua

  local res, status = client:delete{
    index = "my_index",
    type = "my_type",
    id = "my_id"
  }
