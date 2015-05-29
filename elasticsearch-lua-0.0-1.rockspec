package = "elasticsearch-lua"
version = "0.0-1"
source = {
  url = "https://github.com/DhavalKapil/elasticsearch-lua"
}
description = {
  summary = "Elasticsearch client for the Lua language",
  detailed = [[
    This is an elasticsearch client written in Lua. Under development.
  ]],
  homepage = "https://github.com/DhavalKapil/elasticsearch-lua",
  license = "MIT"
}
dependencies = {
  "lua ~> 5.1",
  "luasocket",
  "lua-cjson"
}
build = {
  type = "builtin",
  modules = {
    ["elaticsearch"] = "elasticsearch/elasticsearch.lua"
  }
}
