-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local GetAlias = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
GetAlias.allowedParams = {
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true,
  ["local"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function GetAlias:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function GetAlias:getUri()
  local uri = "/_alias"

  if self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
  if self.name ~= nil then
    uri = uri .. "/" .. self.name
  end
  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of GetAlias class
-------------------------------------------------------------------------------
function GetAlias:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return GetAlias
