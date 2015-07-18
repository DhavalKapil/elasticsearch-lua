-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Cluster = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The transport module
Cluster.transport = nil

-------------------------------------------------------------------------------
-- Function to request an endpoint instance for a particular type of request
--
-- @param   endpoint        The string denoting the endpoint
-- @param   params          The parameters to be passed
-- @params  endpointParams  The endpoint params passed while object creation
--
-- @return  table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Cluster:requestEndpoint(endpoint, params, endpointParams)
  local Endpoint = require("endpoints.Cluster." .. endpoint)
  local endpoint = Endpoint:new{
    transport = self.transport,
    endpointParams = endpointParams or {}
  }
  if params ~= nil then
    -- Parameters need to be set
    local err = endpoint:setParams(params);
    if err ~= nil then
      -- Some error in setting parameters, return to user
      return nil, err
    end
  end
  -- Making request
  local response, err = endpoint:request()
  if response == nil then
    -- Some error in response, return to user
    return nil, err
  end
  -- Request successful, return body
  return response.body
end

-------------------------------------------------------------------------------
-- Function to get information health of the cluster
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Cluster:health()
  return self:requestEndpoint("Health")
end

-------------------------------------------------------------------------------
-- Function to get a comprehensive state information of the whole cluster
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Cluster:state(params)
  return self:requestEndpoint("State", params)
end

-------------------------------------------------------------------------------
-- Function to retrieve statistics from a cluster wide perspective
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Cluster:stats(params)
  return self:requestEndpoint("Stats", params)
end

-------------------------------------------------------------------------------
-- Function to retrieve the settings of a cluster
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Cluster:getSettings(params)
  return self:requestEndpoint("GetSettings", params)
end

-------------------------------------------------------------------------------
-- Function to put the settings of a cluster
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Cluster:putSettings(params)
  return self:requestEndpoint("PutSettings", params)
end

-------------------------------------------------------------------------------
-- Function to execute cluster reroute allocation commands
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Cluster:reroute(params)
  return self:requestEndpoint("Reroute", params)
end

-------------------------------------------------------------------------------
-- Function to get the list of pending tasks
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Cluster:pendingTasks(params)
  return self:requestEndpoint("PendingTasks", params)
end

-------------------------------------------------------------------------------
-- Returns an instance of Cluster class
-------------------------------------------------------------------------------
function Cluster:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Cluster