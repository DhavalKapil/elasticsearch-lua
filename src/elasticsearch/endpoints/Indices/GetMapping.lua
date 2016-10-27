-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local GetMapping = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
GetMapping.allowedParams = {
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true,
  ["wildcard_expansion"] = true,
  ["local"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function GetMapping:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function GetMapping:getUri()
  local uri = "/_mapping"

  if self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
  if self.type ~= nil then
    uri = uri .. "/" .. self.type
  end
  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of GetMapping class
-------------------------------------------------------------------------------
function GetMapping:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return GetMapping
