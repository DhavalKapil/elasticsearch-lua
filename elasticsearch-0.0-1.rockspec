package = "elasticsearch"
version = "0.0-1"
source = {
  url = "git://github.com/DhavalKapil/elasticsearch-lua",
  tag = "v0.1"
}
description = {
  summary = "Elasticsearch client for the Lua language",
  detailed = [[
    This is an elasticsearch client written in Lua. Under development.
  ]],
  homepage = "https://github.com/DhavalKapil/elasticsearch-lua",
  license = "Apache 2"
}
dependencies = {
  "lua >= 5.3",
  "luasocket",
  "lua-cjson",
  "lunitx"
}
build = {
  type = "builtin",
  modules = {
    ["elasticsearch"] = "elasticsearch/elasticsearch.lua",
    ["Settings"] = "elasticsearch/Settings.lua",
    ["Logger"] = "elasticsearch/Logger.lua",
    ["parser"] = "elasticsearch/parser.lua",
    ["Client"] = "elasticsearch/Client.lua",
    ["Transport"] = "elasticsearch/Transport.lua",

    ["connection.Connection"] = "elasticsearch/connection/Connection.lua",

    ["selector.RoundRobinSelector"] = "elasticsearch/selector/RoundRobinSelector.lua",
    ["selector.Selector"] = "elasticsearch/selector/Selector.lua",
    ["selector.StickyRoundRobinSelector"] = "elasticsearch/selector/StickyRoundRobinSelector.lua",
    ["selector.RandomSelector"] = "elasticsearch/selector/RandomSelector.lua",


    ["connectionpool.ConnectionPool"] = "elasticsearch/connectionpool/ConnectionPool.lua",
    ["connectionpool.StaticConnectionPool"] = "elasticsearch/connectionpool/StaticConnectionPool.lua",
    ["connectionpool.SniffConnectionPool"] = "elasticsearch/connectionpool/SniffConnectionPool.lua",

    ["endpoints.Search"] = "elasticsearch/endpoints/Search.lua",
    ["endpoints.Index"] = "elasticsearch/endpoints/Index.lua",
    ["endpoints.Info"] = "elasticsearch/endpoints/Info.lua",
    ["endpoints.Delete"] = "elasticsearch/endpoints/Delete.lua",
    ["endpoints.Update"] = "elasticsearch/endpoints/Update.lua",
    ["endpoints.Get"] = "elasticsearch/endpoints/Get.lua",
    ["endpoints.Endpoint"] = "elasticsearch/endpoints/Endpoint.lua"
  },
  copy_directories = {"tests"}
}
