-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local GetAliases = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
GetAliases.allowedParams = {
  ["timeout"] = true,
  ["local"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function GetAliases:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function GetAliases:getUri()
  local uri = "/_aliases"

  if self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
  if self.name ~= nil then
    uri = uri .. "/" .. self.name
  end
  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of GetAliases class
-------------------------------------------------------------------------------
function GetAliases:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return GetAliases
