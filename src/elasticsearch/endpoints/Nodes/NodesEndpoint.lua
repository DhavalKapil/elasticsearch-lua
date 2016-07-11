-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local NodesEndpoint = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The node id
NodesEndpoint.nodeId = nil
-- The metric
NodesEndpoint.metric = nil
-- The index metric
NodesEndpoint.indexMetric = nil

-------------------------------------------------------------------------------
-- Function used to set the params to be sent as GET parameters
--
-- @param   params  The params provided by the user
--
-- @return  string  A string if an error is found otherwise nil
-------------------------------------------------------------------------------
function NodesEndpoint:setParams(params)
  -- Clearing parameters
  self.nodeId = nil
  self.metric = nil
  self.indexMetric = nil
  self.params = {}
  for i, v in pairs(params) do
    if i == "node_id" then
      self.nodeId = v
    elseif i == "metric" then
      self.metric = v
    elseif i == "index_metric" then
      self.indexMetric = v
    else
      local err = self:setAllowedParam(i, v)
      if err ~= nil then
        return err
      end
    end
  end
end

-------------------------------------------------------------------------------
-- Returns an instance of NodesEndpoint class
-------------------------------------------------------------------------------
function NodesEndpoint:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return NodesEndpoint
