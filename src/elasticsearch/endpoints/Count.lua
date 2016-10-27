-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Count = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Count.allowedParams = {
  ["ignore_unavailable"] = true,
  ["allow_no_indices"] = true,
  ["expand_wildcards"] = true,
  ["min_score"] = true,
  ["source"] = true,
  ["preference"] = true,
  ["routing"] = true,
  ["q"] = true,
  ["df"] = true,
  ["default_operator"] = true,
  ["analyzer"] = true,
  ["lowercase_expanded_terms"] = true,
  ["analyze_wildcard"] = true,
  ["lenient"] = true,
  ["lowercase_expanded_terms"] = true,
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Count:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Count:getUri()
  local uri = ""
  if self.index == nil then
    uri = uri .. "/_all"
  else
    uri = uri .. "/" .. self.index
  end
  if self.type ~= nil then
    uri = uri .. "/" .. self.type
  end
  uri = uri .. "/_count"
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Count class
-------------------------------------------------------------------------------
function Count:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Count
