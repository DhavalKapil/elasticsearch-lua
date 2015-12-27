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
  for i, v in pairs(params) do
    if i == "node_id" then
      self.nodeId = v
    elseif i == "metric" then
      self.metric = v
    elseif i == "index_metric" then
      self.indexMetric = v
    else
      -- Checking whether i is in allowed parameters or not
      -- Current algorithm is n*m, but n and m are very small
      local flag = 0;
      for _, allowedParam in pairs(self.allowedParams) do
        if allowedParam == i then
          flag = 1;
          break;
        end
      end
      if flag == 0 then
        return i .. " is not an allowed parameter"
      end
      self.params[i] = v
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
