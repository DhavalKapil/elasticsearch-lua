-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local ClearCache = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
ClearCache.allowedParams = {
  ["field_data"] = true,
  ["filter"] = true,
  ["filter_cache"] = true,
  ["filter_keys"] = true,
  ["id"] = true,
  ["id_cache"] = true,
  ["fielddata"] = true,
  ["fields"] = true,
  ["query"] = true,
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true,
  ["index"] = true,
  ["recycler"] = true,
  ["request"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function ClearCache:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function ClearCache:getUri()
  local uri = "/_cache/clear"

  if self.index ~= nil then
    uri = "/" .. self.index .. uri
  end

  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of ClearCache class
-------------------------------------------------------------------------------
function ClearCache:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return ClearCache
