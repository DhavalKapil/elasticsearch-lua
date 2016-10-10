-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local CatEndpoint = require "elasticsearch.endpoints.Cat.CatEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local NodeAttrs = CatEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
NodeAttrs.allowedParams = {
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
function NodeAttrs:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function NodeAttrs:getUri()
  local uri = "/_cat/nodeattrs"  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of NodeAttrs class
-------------------------------------------------------------------------------
function NodeAttrs:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return NodeAttrs
