-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local PutWarmer = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
PutWarmer.allowedParams = {
  ["master_timeout"] = true,
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true,
  ["request_cache"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function PutWarmer:getMethod()
  return "PUT"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function PutWarmer:getUri()
  if self.name == nil then
    return nil, "name not specified for Put Warmer"
  end

  local uri = "/_warmer/" .. self.name
  if self.index ~= nil and self.type ~= nil then
    uri = "/" .. self.index .. "/" .. self.type .. uri
  elseif self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of PutWarmer class
-------------------------------------------------------------------------------
function PutWarmer:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return PutWarmer
