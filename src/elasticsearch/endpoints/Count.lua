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
  "q",
  "ignore_unavailable",
  "allow_no_indices",
  "expand_wildcards",
  "min_score",
  "preference",
  "routing",
  "source",
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
