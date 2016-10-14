-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local ExistsType = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
ExistsType.allowedParams = {
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
function ExistsType:getMethod()
  return "HEAD"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function ExistsType:getUri()
  if self.index == nil then
    return nil, "index not specified for Exists Type"
  end
  if self.type == nil then
    return nil, "type not specified for Exists Type"
  end
  local uri = "/" .. self.index .. "/" .. self.type
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of ExistsType class
-------------------------------------------------------------------------------
function ExistsType:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return ExistsType
