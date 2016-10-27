-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local SearchShards = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
SearchShards.allowedParams = {
  ["preference"] = true,
  ["routing"] = true,
  ["local"] = true,
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function SearchShards:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function SearchShards:getUri()
  if self.index ~= nil and self.type ~= nil then
    return "/" .. self.index .. "/" .. self.type .. "/_search_shards"
  elseif self.index ~= nil and self.type == nil then
    return "/" .. self.index .. "/_search_shards"
  elseif self.index == nil and self.type ~= nil then
    return "/_all/" .. self.type .. "/_search_shards"
  end
  -- Both are nil
  return "/_search_shards"
end

-------------------------------------------------------------------------------
-- Returns an instance of SearchShards class
-------------------------------------------------------------------------------
function SearchShards:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return SearchShards
