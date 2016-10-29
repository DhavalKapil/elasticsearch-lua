--- The Cluster class
-- @classmod Cluster
-- @author Dhaval Kapil

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
-- @local
-- Function to request an endpoint instance for a particular type of request
--
-- @param   endpoint        The string denoting the endpoint
-- @param   params          The parameters to be passed
-- @param   endpointParams  The endpoint params passed while object creation
--
-- @return  table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cluster:requestEndpoint(endpoint, params, endpointParams)
  local Endpoint = require("elasticsearch.endpoints.Cluster." .. endpoint)
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
  return response.body, response.statusCode
end

-------------------------------------------------------------------------------
-- Function to get information health of the cluster
--
-- @usage
-- params["index"]                      = (string) Limit the information returned to a specific index
--       ["level"]                      = (enum) Specify the level of detail for returned information
--       ["local"]                      = (boolean) Return local information, do not retrieve the state from master node (default: false)
--       ["master_timeout"]             = (time) Explicit operation timeout for connection to master node
--       ["timeout"]                    = (time) Explicit operation timeout
--       ["wait_for_active_shards"]     = (number) Wait until the specified number of shards is active
--       ["wait_for_nodes"]             = (number) Wait until the specified number of nodes is available
--       ["wait_for_relocating_shards"] = (number) Wait until the specified number of relocating shards is finished
--       ["wait_for_status"]            = (enum) Wait until cluster is in a specific state
--
-- @param    params    The health Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cluster:health(params)
  return self:requestEndpoint("Health", params)
end

-------------------------------------------------------------------------------
-- Function to get a comprehensive state information of the whole cluster
--
-- @usage
-- params["filter_blocks"]          = (boolean) Do not return information about blocks
--       ["filter_index_templates"] = (boolean) Do not return information about index templates
--       ["filter_indices"]         = (list) Limit returned metadata information to specific indices
--       ["filter_metadata"]        = (boolean) Do not return information about indices metadata
--       ["filter_nodes"]           = (boolean) Do not return information about nodes
--       ["filter_routing_table"]   = (boolean) Do not return information about shard allocation ('routing_table' and 'routing_nodes')
--       ["local"]                  = (boolean) Return local information, do not retrieve the state from master node (default: false)
--       ["master_timeout"]         = (time) Specify timeout for connection to master
--
-- @param    params    The state Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cluster:state(params)
  return self:requestEndpoint("State", params)
end

-------------------------------------------------------------------------------
-- Function to retrieve statistics from a cluster wide perspective
--
-- @usage
-- params["flat_settings"]          = (boolean) Return settings in flat format (default: false)
--       ["human"] = (boolean) Whether to return time and byte values in human-readable format.
--
-- @param    params    The stats Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cluster:stats(params)
  return self:requestEndpoint("Stats", params)
end

-------------------------------------------------------------------------------
-- Function to retrieve the settings of a cluster
--
-- @param    params    The getSettings Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cluster:getSettings(params)
  return self:requestEndpoint("GetSettings", params)
end

-------------------------------------------------------------------------------
-- Function to put the settings of a cluster
--
-- @param    params    The putSettings Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cluster:putSettings(params)
  return self:requestEndpoint("PutSettings", params)
end

-------------------------------------------------------------------------------
-- Function to execute cluster reroute allocation commands
--
-- @usage
-- params["dry_run"]         = (boolean) Simulate the operation only and return the resulting state
--       ["filter_metadata"] = (boolean) Don"t return cluster state metadata (default: false)
--       ["body"]            = (boolean) Don"t return cluster state metadata (default: false)
--       ["explain"]         = (boolean) Return an explanation of why the commands can or cannot be executed
--
-- @param    params    The reroute Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cluster:reroute(params)
  return self:requestEndpoint("Reroute", params)
end

-------------------------------------------------------------------------------
-- Function to get the list of pending tasks
--
-- @usage
-- params["local"]   = (bool) Return local information, do not retrieve the state from master node (default: false)
--       ["master_timeout"]  = (time) Specify timeout for connection to master
--
-- @param    params    The pendingTasks Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cluster:pendingTasks(params)
  return self:requestEndpoint("PendingTasks", params)
end

-------------------------------------------------------------------------------
-- @local
-- Returns an instance of Cluster class
-------------------------------------------------------------------------------
function Cluster:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Cluster