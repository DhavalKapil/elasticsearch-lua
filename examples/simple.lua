package.path = package.path .. ";../elasticsearch/?.lua"

local elasticsearch = require "elasticsearch"

local client = elasticsearch.client{
  hosts = {
    { 
      protocol = "http",
      host = "localhost",
      port = 9200
    },
    {
      protocol = "http",
      host = "localhost",
      port = 9201
    }
  },
  params = {
    pingTimeout = 2,
    logLevel = "warning"
  }
}

-- Details about client

local data, err = client:info()

if data == nil then
  print(err)
  os.exit()
end
print(data.name)

-- Indexing

data, err = client:index{
  index = "my_index",
  type = "my_type",
  id = "my_doc",
  body = {
    my_key = "my_param"
  }
}

if data == nil then
  print(err)
  os.exit()
end

-- Wait for some time to index
local ntime = os.time() + 1
repeat until os.time() > ntime

print("Successfully indexed")

-- Getting data

data, err = client:get{
  index = "my_index",
  type = "my_type",
  id = "my_doc"
}
if data == nil then
  print(err)
  os.exit()
end
print("Got document with my_key = " .. data._source.my_key)

-- Searching data without a body

data, err = client:search{
  index = "my_index",
  type = "my_type",
  q = "my_key:my_param"
}
if data == nil then
  print(err)
  os.exit()
end
print("Search successfull:")
print("Document id = " .. data.hits.hits[1]._id)

-- Searching data with a body

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
if data == nil then
  print(err)
  os.exit()
end
print("Search successfull:")
print("Document id = " .. data.hits.hits[1]._id)

-- Deleting

data, err = client:delete{
  index = "my_index",
  type = "my_type",
  id = "my_doc"
}
if data == nil then
  print(err)
  os.exit()
end
print("Deleted document")

-- Getting data again

data, err = client:get{
  index = "my_index",
  type = "my_type",
  id = "my_doc"
}
if data == nil then
  print(err)
  os.exit()
end
print(data._source.my_key)