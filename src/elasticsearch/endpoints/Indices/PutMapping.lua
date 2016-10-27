-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local PutMapping = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
PutMapping.allowedParams = {
  ["timeout"] = true,
  ["master_timeout"] = true,
  ["ignore_conflicts"] = true,
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true,
  ["update_all_types"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function PutMapping:getMethod()
  return "PUT"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function PutMapping:getUri()
  if self.type == nil then
    return nil, "Type not specified for Put Mapping"
  end

  local uri = "/_mapping/" .. self.type

  if self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
    
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of PutMapping class
-------------------------------------------------------------------------------
function PutMapping:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return PutMapping
