-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local NodesEndpoint = require "elasticsearch.endpoints.Nodes.NodesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Info = NodesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Info.allowedParams = {
  ["flat_settings"] = true,
  ["human"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Info:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Info:getUri()
  local uri = "/_nodes"
  if self.nodeId ~= nil and self.metric ~= nil then
    uri = uri .. "/" .. self.nodeId .. "/" .. self.metric
  elseif self.metric ~= nil then
    uri = uri .. "/" .. self.metric
  elseif self.nodeId ~= nil then
    uri = uri .. "/" .. self.nodeId
  end
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Info class
-------------------------------------------------------------------------------
function Info:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Info
