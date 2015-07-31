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
    ["Cluster"] = "elasticsearch/Cluster.lua",
    ["Nodes"] = "elasticsearch/Nodes.lua",
    ["Indices"] = "elasticsearch/Indices.lua",
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
    ["endpoints.SearchExists"] = "elasticsearch/endpoints/SearchExists.lua",
    ["endpoints.SearchShards"] = "elasticsearch/endpoints/SearchShards.lua",
    ["endpoints.SearchTemplate"] = "elasticsearch/endpoints/SearchTemplate.lua",
    ["endpoints.Scroll"] = "elasticsearch/endpoints/Scroll.lua",
    ["endpoints.Msearch"] = "elasticsearch/endpoints/Msearch.lua",
    ["endpoints.Index"] = "elasticsearch/endpoints/Index.lua",
    ["endpoints.Info"] = "elasticsearch/endpoints/Info.lua",
    ["endpoints.Ping"] = "elasticsearch/endpoints/Ping.lua",
    ["endpoints.Delete"] = "elasticsearch/endpoints/Delete.lua",
    ["endpoints.Count"] = "elasticsearch/endpoints/Count.lua",
    ["endpoints.Suggest"] = "elasticsearch/endpoints/Suggest.lua",
    ["endpoints.Suggest"] = "elasticsearch/endpoints/Explain.lua",
    ["endpoints.Update"] = "elasticsearch/endpoints/Update.lua",
    ["endpoints.FieldStats"] = "elasticsearch/endpoints/FieldStats.lua",
    ["endpoints.Get"] = "elasticsearch/endpoints/Get.lua",
    ["endpoints.Mget"] = "elasticsearch/endpoints/Mget.lua",
    ["endpoints.Endpoint"] = "elasticsearch/endpoints/Endpoint.lua",

    ["endpoints.Nodes.NodesEndpoint"] = "elasticsearch/endpoints/Nodes/NodesEndpoint.lua",
    ["endpoints.Nodes.Info"] = "elasticsearch/endpoints/Nodes/Info.lua",
    ["endpoints.Nodes.Stats"] = "elasticsearch/endpoints/Nodes/Stats.lua",
    ["endpoints.Nodes.HotThreads"] = "elasticsearch/endpoints/Nodes/HotThreads.lua",
    ["endpoints.Nodes.Shutdown"] = "elasticsearch/endpoints/Nodes/Shutdown.lua",

    ["endpoints.Cluster.Health"] = "elasticsearch/endpoints/Cluster/Health.lua",
    ["endpoints.Cluster.PendingTasks"] = "elasticsearch/endpoints/Cluster/PendingTasks.lua",
    ["endpoints.Cluster.State"] = "elasticsearch/endpoints/Cluster/State.lua",
    ["endpoints.Cluster.Stats"] = "elasticsearch/endpoints/Cluster/Stats.lua",
    ["endpoints.Cluster.GetSettings"] = "elasticsearch/endpoints/Cluster/GetSettings.lua",
    ["endpoints.Cluster.PutSettings"] = "elasticsearch/endpoints/Cluster/PutSettings.lua",
    ["endpoints.Cluster.Reroute"] = "elasticsearch/endpoints/Cluster/Reroute.lua",

    ["endpoints.Indices.Exists"] = "elasticsearch/endpoints/Indices/Exists.lua",
    ["endpoints.Indices.Get"] = "elasticsearch/endpoints/Indices/Get.lua",
    ["endpoints.Indices.Delete"] = "elasticsearch/endpoints/Indices/Delete.lua",
    ["endpoints.Indices.Create"] = "elasticsearch/endpoints/Indices/Create.lua",
    ["endpoints.Indices.Optimize"] = "elasticsearch/endpoints/Indices/Optimize.lua",
    ["endpoints.Indices.Open"] = "elasticsearch/endpoints/Indices/Open.lua",
    ["endpoints.Indices.Close"] = "elasticsearch/endpoints/Indices/Close.lua",
    ["endpoints.Indices.Analyze"] = "elasticsearch/endpoints/Indices/Analyze.lua",
    ["endpoints.Indices.Status"] = "elasticsearch/endpoints/Indices/Status.lua",
    ["endpoints.Indices.Seal"] = "elasticsearch/endpoints/Indices/Seal.lua"
  },
  copy_directories = {"tests"}
}
