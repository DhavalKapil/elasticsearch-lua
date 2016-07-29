Namespaces
==========

The client exposes administrative functionalities through 'namespaces'.

+------------+------------------------------------------------------+
| Namespaces | Functionality                                        |
+============+======================================================+
| indices    | Index related functions such as create, delete, etc. |
+------------+------------------------------------------------------+
| nodes      | Nodes related functions such as stats, info, etc.    |
+------------+------------------------------------------------------+
| cluster    | Cluster related functions such as get and update     |
|            | settings, stats, etc.                                |
+------------+------------------------------------------------------+

These namespaces are accessible as `client.indices`, `client.nodes` and
`client.cluster`. Sample code for using the namespaces:

.. code-block:: lua

  -- Creating an index
  local res, status = client.indices:create{
    index = "my_index"
  }

  -- Getting Nodes Stats
  local res, status = client.nodes:stats()

  -- Getting Cluster Stats
  local res, status = client.cluster:stats()

Refer to the API documentation for a complete listing.
