-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Exists = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Exists.allowedParams = {
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
function Exists:getMethod()
  return "HEAD"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Exists:getUri()
  local uri = ""
  if self.index == nil then
    return nil, "index not specified for Exists"
  else
    uri = uri .. "/" .. self.index
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Exists class
-------------------------------------------------------------------------------
function Exists:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Exists
