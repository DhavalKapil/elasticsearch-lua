package = "elasticsearch"
version = "scm-0"
source = {
  url = "git://github.com/DhavalKapil/elasticsearch-lua",
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
  "lua >= 5.1, < 5.4",
  "luasocket",
  "lua-cjson",
  "lunitx"
}
build = {
  type = "builtin",
  modules = {
    ["elasticsearch"] = "src/elasticsearch.lua",
    ["elasticsearch.Settings"] = "src/elasticsearch/Settings.lua",
    ["elasticsearch.Logger"] = "src/elasticsearch/Logger.lua",
    ["elasticsearch.parser"] = "src/elasticsearch/parser.lua",
    ["elasticsearch.helpers"] = "src/elasticsearch/helpers.lua",
    ["elasticsearch.Client"] = "src/elasticsearch/Client.lua",
    ["elasticsearch.Cluster"] = "src/elasticsearch/Cluster.lua",
    ["elasticsearch.Nodes"] = "src/elasticsearch/Nodes.lua",
    ["elasticsearch.Indices"] = "src/elasticsearch/Indices.lua",
    ["elasticsearch.Transport"] = "src/elasticsearch/Transport.lua",

    ["elasticsearch.connection.Connection"] = "src/elasticsearch/connection/Connection.lua",

    ["elasticsearch.selector.RoundRobinSelector"] = "src/elasticsearch/selector/RoundRobinSelector.lua",
    ["elasticsearch.selector.Selector"] = "src/elasticsearch/selector/Selector.lua",
    ["elasticsearch.selector.StickyRoundRobinSelector"] = "src/elasticsearch/selector/StickyRoundRobinSelector.lua",
    ["elasticsearch.selector.RandomSelector"] = "src/elasticsearch/selector/RandomSelector.lua",

    ["elasticsearch.connectionpool.ConnectionPool"] = "src/elasticsearch/connectionpool/ConnectionPool.lua",
    ["elasticsearch.connectionpool.StaticConnectionPool"] = "src/elasticsearch/connectionpool/StaticConnectionPool.lua",
    ["elasticsearch.connectionpool.SniffConnectionPool"] = "src/elasticsearch/connectionpool/SniffConnectionPool.lua",

    ["elasticsearch.endpoints.Search"] = "src/elasticsearch/endpoints/Search.lua",
    ["elasticsearch.endpoints.SearchExists"] = "src/elasticsearch/endpoints/SearchExists.lua",
    ["elasticsearch.endpoints.SearchShards"] = "src/elasticsearch/endpoints/SearchShards.lua",
    ["elasticsearch.endpoints.SearchTemplate"] = "src/elasticsearch/endpoints/SearchTemplate.lua",
    ["elasticsearch.endpoints.Scroll"] = "src/elasticsearch/endpoints/Scroll.lua",
    ["elasticsearch.endpoints.Msearch"] = "src/elasticsearch/endpoints/Msearch.lua",
    ["elasticsearch.endpoints.Index"] = "src/elasticsearch/endpoints/Index.lua",
    ["elasticsearch.endpoints.Bulk"] = "src/elasticsearch/endpoints/Bulk.lua",
    ["elasticsearch.endpoints.Info"] = "src/elasticsearch/endpoints/Info.lua",
    ["elasticsearch.endpoints.Ping"] = "src/elasticsearch/endpoints/Ping.lua",
    ["elasticsearch.endpoints.Delete"] = "src/elasticsearch/endpoints/Delete.lua",
    ["elasticsearch.endpoints.Count"] = "src/elasticsearch/endpoints/Count.lua",
    ["elasticsearch.endpoints.Suggest"] = "src/elasticsearch/endpoints/Suggest.lua",
    ["elasticsearch.endpoints.Explain"] = "src/elasticsearch/endpoints/Explain.lua",
    ["elasticsearch.endpoints.Update"] = "src/elasticsearch/endpoints/Update.lua",
    ["elasticsearch.endpoints.FieldStats"] = "src/elasticsearch/endpoints/FieldStats.lua",
    ["elasticsearch.endpoints.Get"] = "src/elasticsearch/endpoints/Get.lua",
    ["elasticsearch.endpoints.Mget"] = "src/elasticsearch/endpoints/Mget.lua",
    ["elasticsearch.endpoints.Endpoint"] = "src/elasticsearch/endpoints/Endpoint.lua",

    ["elasticsearch.endpoints.Nodes.NodesEndpoint"] = "src/elasticsearch/endpoints/Nodes/NodesEndpoint.lua",
    ["elasticsearch.endpoints.Nodes.Info"] = "src/elasticsearch/endpoints/Nodes/Info.lua",
    ["elasticsearch.endpoints.Nodes.Stats"] = "src/elasticsearch/endpoints/Nodes/Stats.lua",
    ["elasticsearch.endpoints.Nodes.HotThreads"] = "src/elasticsearch/endpoints/Nodes/HotThreads.lua",
    ["elasticsearch.endpoints.Nodes.Shutdown"] = "src/elasticsearch/endpoints/Nodes/Shutdown.lua",

    ["elasticsearch.endpoints.Cluster.Health"] = "src/elasticsearch/endpoints/Cluster/Health.lua",
    ["elasticsearch.endpoints.Cluster.PendingTasks"] = "src/elasticsearch/endpoints/Cluster/PendingTasks.lua",
    ["elasticsearch.endpoints.Cluster.State"] = "src/elasticsearch/endpoints/Cluster/State.lua",
    ["elasticsearch.endpoints.Cluster.Stats"] = "src/elasticsearch/endpoints/Cluster/Stats.lua",
    ["elasticsearch.endpoints.Cluster.GetSettings"] = "src/elasticsearch/endpoints/Cluster/GetSettings.lua",
    ["elasticsearch.endpoints.Cluster.PutSettings"] = "src/elasticsearch/endpoints/Cluster/PutSettings.lua",
    ["elasticsearch.endpoints.Cluster.Reroute"] = "src/elasticsearch/endpoints/Cluster/Reroute.lua",

    ["elasticsearch.endpoints.Indices.Exists"] = "src/elasticsearch/endpoints/Indices/Exists.lua",
    ["elasticsearch.endpoints.Indices.Get"] = "src/elasticsearch/endpoints/Indices/Get.lua",
    ["elasticsearch.endpoints.Indices.Delete"] = "src/elasticsearch/endpoints/Indices/Delete.lua",
    ["elasticsearch.endpoints.Indices.Create"] = "src/elasticsearch/endpoints/Indices/Create.lua",
    ["elasticsearch.endpoints.Indices.Optimize"] = "src/elasticsearch/endpoints/Indices/Optimize.lua",
    ["elasticsearch.endpoints.Indices.Open"] = "src/elasticsearch/endpoints/Indices/Open.lua",
    ["elasticsearch.endpoints.Indices.Close"] = "src/elasticsearch/endpoints/Indices/Close.lua",
    ["elasticsearch.endpoints.Indices.Analyze"] = "src/elasticsearch/endpoints/Indices/Analyze.lua",
    ["elasticsearch.endpoints.Indices.Refresh"] = "src/elasticsearch/endpoints/Indices/Refresh.lua",
    ["elasticsearch.endpoints.Indices.Status"] = "src/elasticsearch/endpoints/Indices/Status.lua",
    ["elasticsearch.endpoints.Indices.Seal"] = "src/elasticsearch/endpoints/Indices/Seal.lua"
  },
  copy_directories = {"tests"}
}
