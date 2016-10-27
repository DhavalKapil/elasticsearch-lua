-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local UpdateAliases = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
UpdateAliases.allowedParams = {
  ["timeout"] = true,
  ["master_timeout"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function UpdateAliases:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function UpdateAliases:getUri()
  local uri = "/_aliases"  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of UpdateAliases class
-------------------------------------------------------------------------------
function UpdateAliases:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return UpdateAliases
