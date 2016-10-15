-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Flush = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Flush.allowedParams = {
  ["force"] = true,
  ["full"] = true,
  ["wait_if_ongoing"] = true,
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Flush:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Flush:getUri()
  local uri = "/_flush"
  if self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
  if self.isSynced == true then
    uri = uri .. "/synced"
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Flush class
-------------------------------------------------------------------------------
function Flush:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Flush
