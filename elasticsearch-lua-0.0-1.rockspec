package = "elasticsearch-lua"
version = "0.0-1"
source = {
  url = "https://github.com/DhavalKapil/elasticsearch-lua"
}
description = {
  summary = "Lua client for elasticsearch",
  detailed = [[
    This is an elasticsearch client written in lua. It currently is more of a prototype consisting of basic features.
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
  type = "builtin"
}
