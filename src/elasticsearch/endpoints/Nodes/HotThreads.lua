-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local NodesEndpoint = require "elasticsearch.endpoints.Nodes.NodesEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local HotThreads = NodesEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
HotThreads.allowedParams = {
  ["interval"] = true,
  ["snapshots"] = true,
  ["threads"] = true,
  ["type"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function HotThreads:getMethod()
  return "GET"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function HotThreads:getUri()
  local uri = "/_cluster/nodes"
  if self.nodeId ~= nil then
    uri = uri .. "/" .. self.nodeId
  end
  uri = uri .. "/hotthreads"
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of HotThreads class
-------------------------------------------------------------------------------
function HotThreads:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return HotThreads
