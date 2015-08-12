-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Client = require "Client"
local helpers = require "helpers"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local elasticsearch = {}

elasticsearch.helpers = helpers

function elasticsearch.client(o)
  return Client:new(o)
end

return elasticsearch