-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local NodesEndpoint = require "elasticsearch.endpoints.Nodes.NodesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Stats = NodesEndpoint:new()

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
  ["types"] = true
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
  local uri = "/_nodes"
  if self.nodeId ~= nil and self.metric ~= nil and self.indexMetric ~= nil then
    uri = uri .. "/" .. self.nodeId .. "/stats/" .. self.metric .. "/"
          .. self.indexMetric
  elseif self.metric ~= nil and self.indexMetric ~= nil then
    uri = uri .. "/stats/" .. self.metric .. "/" .. self.indexMetric
  elseif self.nodeId ~= nil and self.metric ~= nil then
    uri = uri .. "/" .. self.nodeId .. "/stats/" .. self.metric
  elseif self.metric ~= nil then
    uri = uri .. "/stats/" .. self.metric
  elseif self.nodeId ~= nil then
    uri = uri .. "/" .. self.nodeId .. "/stats"
  else
    uri = uri .. "/stats"
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
