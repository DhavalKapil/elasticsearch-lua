-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local PostUpgrade = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
PostUpgrade.allowedParams = {
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true,
  ["ignore_unavailable"] = true,
  ["wait_for_completion"] = true,
  ["only_ancient_segments"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function PostUpgrade:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function PostUpgrade:getUri()
  local uri = "/_upgrade"

  if self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
  
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of PostUpgrade class
-------------------------------------------------------------------------------
function PostUpgrade:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return PostUpgrade
