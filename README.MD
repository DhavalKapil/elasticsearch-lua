# elasticsearch-lua

> A simple client for elasticsearch written in lua

## Current features

- Indexing of documents
- Searching within documents using query dsl
- Deletion of documents

## Dependencies

- luasocket
- lua-cjson

## API

Require module and create client

```
elasticsearch = require "elasticsearch"

client = elasticsearch.client({ host = "localhost", port = 9200 })
```

Documents are indexed/searched/deleted by representing them as lua tables

To index:

```
document = {
  index = "test",
  type = "user",
  id = "1",
  body = { 
    name = "vampire",
    developer = true
  }
}
response = client:index(document)
print(response)
```

To search:

```
document = {
  index = "test",
  body = {
    query = {
      query_string = {
        query = 'vampire'
      }
    }
  }
}
response = client:search(document)
print(response)
```

To delete:

```
document = {
  index = "test",
  type = "user",
  id = "1"
}
response = client:delete(document)
print(response)
```
