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
    logLevel = "debug"
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
  index = "myindex2",
  type = "mytype2",
  id = "mydoc2",
  body = {
    my_key = "my_param2"
  }
}

if data == nil then
  print(err)
  os.exit()
end
print("Successfully indexed")

-- Getting data

data, err = client:get{
  index = "myindex2",
  type = "mytype2",
  id = "mydoc2"
}
if data == nil then
  print(err)
  os.exit()
end
print(data._source.my_key)

-- Deleting

data, err = client:delete{
  index = "myindex2",
  type = "mytype2",
  id = "mydoc2"
}
if data == nil then
  print(err)
  os.exit()
end
print("Deleted document")

-- Getting data again

data, err = client:get{
  index = "myindex2",
  type = "mytype2",
  id = "mydoc2"
}
if data == nil then
  print(err)
  os.exit()
end
print(data._source.my_key)