-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local PutSettings = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
PutSettings.allowedParams = {
  ["master_timeout"] = true,
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true,
  ["flat_settings"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function PutSettings:getMethod()
  return "PUT"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function PutSettings:getUri()
  local uri = "/_settings"

  if self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
    
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of PutSettings class
-------------------------------------------------------------------------------
function PutSettings:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return PutSettings
