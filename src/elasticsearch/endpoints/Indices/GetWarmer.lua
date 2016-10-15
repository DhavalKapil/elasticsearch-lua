-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local GetWarmer = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
GetWarmer.allowedParams = {
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
function GetWarmer:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function GetWarmer:getUri()
  if self.index ~= nil and self.type ~= nil and self.name == nil then
    return nil, "If index and type are specified, then name must also be specified for Get Warmer"
  end

  local uri = "/_warmer"
  if self.name ~= nil then
    uri = uri .. "/" .. self.name
  end
  if self.type ~= nil and self.index ~= nil then
    uri = "/" .. self.index .. "/" .. self.type .. uri
  elseif self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of GetWarmer class
-------------------------------------------------------------------------------
function GetWarmer:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return GetWarmer
