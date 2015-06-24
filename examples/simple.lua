package.path = package.path .. ";../elasticsearch/?.lua"

local elasticsearch = require "elasticsearch"

function printTable(tab, ind)
  ind = ind or 2
  for i, v in pairs(tab) do
    for j = 1,ind do
      io.write " "
    end
    io.write(i .. " :")
    if type(v) == "table" then
      print ""
      printTable(v, ind+2)
    else
      print(v)
    end
  end
end

local client = elasticsearch.client{
  hosts = {
    protocol = "http",
    host = "localhost",
    port = 9200
  },
  params = {
    pingTimeout = 2
  }
}

params = {
  index = "myindex2",
  type = "mytype2",
  id = "mydoc2",
  body = {
    my_key = "my_param2"
  }
}

local data = client:index(params)
printTable(data)

params = {
  index = "myindex2",
  type = "mytype2",
  id = "mydoc2"
}

data = client:get(params)
printTable(data)
