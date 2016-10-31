Installation
============

`elasticsearch-lua`_ has the following requirements:

* Lua 5.1 or higher

There are two ways to install `elasticsearch-lua`_:

Using luarocks
-----------------

`luarocks`_ is the package manager for Lua modules. To install Lua and LuaRocks
`luaver`_ can be used. You can directly install `elasticsearch-lua`_ using
LuaRocks::

  $ luarocks install elasticsearch

The client will be installed and you can `require 'elasticsearch'` anywhere in
your Lua code. If `elasticsearch-lua`_ is a dependency, add it in your rockspec
file::

  dependencies = {
    "elasticsearch"
  }

Directly from source
--------------------

`elasticsearch-lua`_ can also be installed directly from the source. However
this is not recommended.

* Clone the repository::
    
    git clone https://github.com/DhavalKapil/elasticsearch-lua.git

* Install the following dependencies:

  * `luasocket`_

  * `lua-cjson`_

  * `lunitx`_

.. note:: `lunitx`_ is *not* needed for using the client. You will need to
          install it **only if** you wish to run tests.

* Add the following code to use `elasticsearch-lua`_:

  .. code-block:: lua

    package.path = package.path .. ";/path/to/elasticsearch-lua/src/?.lua";

    local elasticsearch = require "elasticsearch";

.. _elasticsearch-lua: https://github.com/DhavalKapil/elasticsearch-lua

.. _luarocks: https://luarocks.org/

.. _luaver: https://dhavalkapil.com/luaver

.. _luasocket: https://luarocks.org/modules/luarocks/luasocket

.. _lua-cjson: https://luarocks.org/modules/luarocks/lua-cjson

.. _lunitx: https://luarocks.org/modules/luarocks/lunitx
