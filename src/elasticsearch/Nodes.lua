--- The Nodes class
-- @classmod Nodes
-- @author Dhaval Kapil

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Nodes = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The transport module
Nodes.transport = nil

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
function Nodes:requestEndpoint(endpoint, params, endpointParams)
  local Endpoint = require("elasticsearch.endpoints.Nodes." .. endpoint)
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
-- Function to retrieve info of a node
--
-- @usage
-- params["node_id"]       = (list) A comma-separated list of node IDs or names to limit the returned information; use '_local' to return information from the node you"re connecting to, leave empty to get information from all nodes
--       ["metric"]        = (list) A comma-separated list of metrics you wish returned. Leave empty to return all.
--       ["flat_settings"] = (boolean) Return settings in flat format (default: false)
--       ["human"]         = (boolean) Whether to return time and byte values in human-readable format.
--
-- @param    params    The stats Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Nodes:info(params)
  return self:requestEndpoint("Info", params)
end

-------------------------------------------------------------------------------
-- Function to retrieve statistics of a node
--
-- @usage
-- params["fields"]        = (list) A comma-separated list of fields for 'fielddata' metric (supports wildcards)
--       ["metric_family"] = (enum) Limit the information returned to a certain metric family
--       ["metric"]        = (enum) Limit the information returned for 'indices' family to a specific metric
--       ["node_id"]       = (list) A comma-separated list of node IDs or names to limit the returned information; use '_local' to return information from the node you"re connecting to, leave empty to get information from all nodes
--       ["all"]           = (boolean) Return all available information
--       ["clear"]         = (boolean) Reset the default level of detail
--       ["fs"]            = (boolean) Return information about the filesystem
--       ["http"]          = (boolean) Return information about HTTP
--       ["indices"]       = (boolean) Return information about indices
--       ["jvm"]           = (boolean) Return information about the JVM
--       ["network"]       = (boolean) Return information about network
--       ["os"]            = (boolean) Return information about the operating system
--       ["process"]       = (boolean) Return information about the Elasticsearch process
--       ["thread_pool"]   = (boolean) Return information about the thread pool
--       ["transport"]     = (boolean) Return information about transport
--
-- @param    params    The stats Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Nodes:stats(params)
  return self:requestEndpoint("Stats", params)
end

-------------------------------------------------------------------------------
-- Function to retrieve current hot threads
--
-- @usage
-- params["node_id"]   = (list) A comma-separated list of node IDs or names to limit the returned information; use '_local' to return information from the node you"re connecting to, leave empty to get information from all nodes
--       ["interval"]  = (time) The interval for the second sampling of threads
--       ["snapshots"] = (number) Number of samples of thread stacktrace (default: 10)
--       ["threads"]   = (number) Specify the number of threads to provide information for (default: 3)
--       ["type"]      = (enum) The type to sample (default: cpu)
--
-- @param    params    The stats Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Nodes:hotThreads(params)
  return self:requestEndpoint("HotThreads", params)
end

-------------------------------------------------------------------------------
-- Function to shutdown nodes
--
-- @usage
-- params["node_id"] = (list) A comma-separated list of node IDs or names to perform the operation on; use '_local' to perform the operation on the node you"re connected to, leave empty to perform the operation on all nodes
--       ["delay"]   = (time) Set the delay for the operation (default: 1s)
--       ["exit"]    = (boolean) Exit the JVM as well (default: true)
--
-- @param    params    The stats Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Nodes:shutdown(params)
  return self:requestEndpoint("Shutdown", params)
end

-------------------------------------------------------------------------------
-- @local
-- Returns an instance of Nodes class
-------------------------------------------------------------------------------
function Nodes:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Nodes