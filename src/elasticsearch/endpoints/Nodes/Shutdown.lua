-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local NodesEndpoint = require "elasticsearch.endpoints.Nodes.NodesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Shutdown = NodesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Shutdown.allowedParams = {
  ["delay"] = true,
  ["exit"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Shutdown:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Shutdown:getUri()
  if self.nodeId ~= nil then
    return "/_cluster/nodes/" .. self.nodeId .. "/_shutdown"
  end
  return "/_shutdown"
end

-------------------------------------------------------------------------------
-- Returns an instance of Shutdown class
-------------------------------------------------------------------------------
function Shutdown:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Shutdown
