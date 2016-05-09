# elasticsearch-lua [![Build Status](https://travis-ci.org/DhavalKapil/elasticsearch-lua.svg?branch=master)](https://travis-ci.org/DhavalKapil/elasticsearch-lua)

> A simple low level client for elasticsearch written in lua.

In accordance with other official low level clients, the client accepts associative arrays in the form of lua table as parameters.

## Features:

1. One-to-one mapping with REST API and other language clients
2. Proper load balancing across all nodes.
3. Pluggable and multiple selection strategies and connection pool.
4. Console logging facility.
5. Almost every parameter is configurable.

## Requirements

`elasticsearch-lua` works for lua >= 5.1 version.

It has been successfully tested for elasticsearch version 1.6.

## Setup

1. Clone this repository and `cd` to it.
2. Download and install ``luarocks``. Follow [these](https://github.com/keplerproject/luarocks/wiki/Installation-instructions-for-Unix) steps. Make sure to change lua's version to 5.3 while installation(default is 5.1).
3. Install dependencies:
```
  [sudo] luarocks install elasticsearch-scm-0.rockspec
```
4. Add the source directory to your lua program's `package.path`.

OR

It can also be installed using luarocks
```
  [sudo] luarocks install --server=http://luarocks.org/manifests/dhavalkapil elasticsearch
```

## Documentation

### Create elasticsearch client instance:

```lua
  local elasticsearch = require "elasticsearch"

  local client = elasticsearch.client{
    hosts = {
      { -- Ignoring any of the following hosts parameters is allowed.
        -- The default shall be set
        protocol = "http",
        host = "localhost",
        port = 9200
      }
    },
    -- Optional parameters
    params = {
      pingTimeout = 2
    }
  }
```

```lua
  -- Will connect to default host/port
  local client = elasticsearch.client()
```

Full list of `params`:

1. `pingTimeout` : The timeout of a connection for ping and sniff request. Default is 1.
2. `selector` : The type of selection strategy to be used. Default is `RoundRobinSelector`.
3. `connectionPool` : The type of connection pool to be used. Default is `StaticConnectionPool`.
4. `connectionPoolSettings` : The connection pool settings,
5. `maxRetryCount` : The maximum times to retry if a particular connection fails.
6. `logLevel` : The level of logging to be done. Default is `warning`.

### Standard call

```lua
local param1, param2 = client:<func>()
```

`param1`: Stores the data returned or `nil` on error

`param2`: Stores the HTTP status code on success or the error message on failure

### Getting info of elasticsearch server

```lua
local data, err = client:info()
```

### Index a document

Everything is represented as a lua table.

```lua
local data, err = client:index{
  index = "my_index",
  type = "my_type",
  id = "my_doc",
  body = {
    my_key = "my_param"
  }
}
```

### Get a document

```lua
data, err = client:get{
  index = "my_index",
  type = "my_type",
  id = "my_doc"
}
```

### Delete a document

```lua
data, err = client:delete{
  index = "my_index",
  type = "my_type",
  id = "my_doc"
}
```
### Searching a document

You can search a document using either query string:

```lua
data, err = client:search{
  index = "my_index",
  type = "my_type",
  q = "my_key:my_param"
}
```

Or either a request body:

```lua
data, err = client:search{
  index = "my_index",
  type = "my_type",
  body = {
    query = {
      match = {
        my_key = "my_param"
      }
    }
  }
}
```

### Update a document

```lua
data, err = client:update{
  index = "my_index",
  type = "my_type",
  id = "my_doc",
  body = {
    doc = {
      my_key = "new_param"
    }
  }
}
```
