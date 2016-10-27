-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local GetFieldMapping = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
GetFieldMapping.allowedParams = {
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
function GetFieldMapping:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function GetFieldMapping:getUri()
  if self.fields == nil then
    return nil, "Fields not specified for Get Field"
  end
  
  local uri = "/_mapping"

  if self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
  if self.type ~= nil then
    uri = uri .. "/" .. self.type
  end

  uri = uri .. "/field/" .. self.fields
  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of GetFieldMapping class
-------------------------------------------------------------------------------
function GetFieldMapping:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return GetFieldMapping
