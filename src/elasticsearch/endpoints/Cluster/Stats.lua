-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Stats = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The node id
Stats.nodeId = nil

-- The parameters that are allowed to be used in params
Stats.allowedParams = {
  "flat_settings",
  "human"
}

-------------------------------------------------------------------------------
-- Function used to set the params to be sent as GET parameters
-- Overwrites Endpoint:setParams(params)
--
-- @param   params  The params provided by the user
--
-- @return  string  A string if an error is found otherwise nil
-------------------------------------------------------------------------------
function Stats:setParams(params)
  for i, v in pairs(params) do
    if i == "node_id" then
      self.nodeId = node_id
    elseif i == "body" then
      self:setBody(v)
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
  local uri = "/_cluster/stats"
  if self.nodeId ~= nil then
    uri = uri .. "/nodes/" .. self.nodeId
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
