--- The elasticsearch module
--
-- Requirements:
--  lua = 5.1
--
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

-------------------------------------------------------------------------------
-- The helper's module
-------------------------------------------------------------------------------
elasticsearch.helpers = helpers

-------------------------------------------------------------------------------
-- Returns an instance of a client object
--
-- @param     params    The params of the client
--
-- @return    table     The client instance
-------------------------------------------------------------------------------
function elasticsearch.client(params)
  return Client:new(params)
end

return elasticsearch
