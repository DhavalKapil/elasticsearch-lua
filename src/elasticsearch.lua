--- The elasticsearch module
-- @module elasticsearch
-- @author Dhaval Kapil

-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Client = require "elasticsearch.Client"
local helpers = require "elasticsearch.helpers"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local elasticsearch = {}

elasticsearch.helpers = helpers

function elasticsearch.client(o)
  return Client:new(o)
end

return elasticsearch