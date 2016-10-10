-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local CatEndpoint = require "elasticsearch.endpoints.Cat.CatEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Nodes = CatEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Nodes.allowedParams = {
  ["local"] = true,
  ["master_timeout"] = true,
  ["h"] = true,
  ["help"] = true,
  ["v"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Nodes:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Nodes:getUri()
  local uri = "/_cat/nodes"  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Nodes class
-------------------------------------------------------------------------------
function Nodes:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Nodes
