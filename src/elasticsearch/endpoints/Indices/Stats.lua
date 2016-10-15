-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local IndicesEndpoint = require "elasticsearch.endpoints.Indices.IndicesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Stats = IndicesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Stats.allowedParams = {
  ["completion_fields"] = true,
  ["fielddata_fields"] = true,
  ["fields"] = true,
  ["groups"] = true,
  ["human"] = true,
  ["level"] = true,
  ["types"] = true,
  ["metric"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Stats:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Stats:getUri()
  local uri = "/_stats"
  if self.index ~= nil then
    uri = "/" .. self.index .. uri
  end
  if self.metric ~= nil then
    uri = uri .. "/" .. self.metric
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Stats class
-------------------------------------------------------------------------------
function Stats:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Stats
