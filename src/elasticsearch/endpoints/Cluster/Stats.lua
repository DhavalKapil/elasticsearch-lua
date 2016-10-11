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
  ["flat_settings"] = true,
  ["human"] = true,
  ["timeouts"] = true
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
  -- Clearing parameters
  self.nodeId = nil
  self.params = {}
  for i, v in pairs(params) do
    if i == "node_id" then
      self.nodeId = v
    elseif i == "body" then
      self:setBody(v)
    else
      local err = self:setAllowedParam(i, v)
      if err ~= nil then
        return err
      end
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
