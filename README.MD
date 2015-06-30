# elasticsearch-lua

> A simple low level client for elasticsearch written in lua.

In accordance with other official low level clients, the client accepts associative arrays in the form of lua table as parameters.

**Under development**

## Current Features:

1. The following Rest API functions provided:
  - Getting info regarding elasticsearch server
  - Indexing a document
  - Retrieving a document
  - Deleting a document
2. Proper load balancing across all nodes.
3. Multiple selection strategies.
4. Console logging facility.
5. Almost every parameter is configurable.

## Documentation

(Do keep in mind that this repository is currently under development)

1. Clone this repository and `cd` to it.
2. Download and install ``luarocks``. Follow [these](https://github.com/keplerproject/luarocks/wiki/Installation-instructions-for-Unix) steps. Make sure to change lua's version to 5.3 while installation(default is 5.1).
3. Install dependencies:
```
  [sudo] luarocks install elasticsearch-lua-0.0-1.rockspec
```
4. Add the source directory to your lua program's `package.path`.

### Create elasticsearch client instance:

```
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
    params = {
      pingTimeout = 2
    }
  }
```

Full list of `params`:

1. `pingTimeout` : The default timeout of a connection for ping and sniff request.
2. `selector` : The type of selection strategy to be used. Default is `RoundRobinSelector`.
3. `connectionPool` : The type of connection pool to be used. Default is `StaticConnectionPool`.
4. `connectionPoolSettings` : The connection pool settings,
5. `maxRetryCount` : The maximum times to retry if a particular connection fails.
6. `logLevel` : The level of logging to be done. Default is `warning`.

### Getting info of elasticsearch server

```
local data, err = client:info()
```

### Index a document

Everything is represented as a lua table.

```
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

```
data, err = client:get{
  index = "my_index",
  type = "my_type",
  id = "my_doc"
}
```

### Delete a document

```
data, err = client:delete{
  index = "my_index",
  type = "my_type",
  id = "my_doc"
}
```
