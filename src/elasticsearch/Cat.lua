--- The Cat class
-- @classmod Cat
-- @author Dhaval Kapil

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Cat = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The transport module
Cat.transport = nil

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
function Cat:requestEndpoint(endpoint, params, endpointParams)
  local Endpoint = require("elasticsearch.endpoints.Cat." .. endpoint)
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
-- Function to show information about currently configured aliases
--
-- @usage
-- params["name"]           = (list) A comma-separated list of alias names to return
--       ["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["h"]              = (list) Comma-separated list of column names to display
--       ["help"]           = (boolean) Return help information (default: false)
--       ["v"]              = (boolean) Verbose mode. Display column headers (default: false)
--
-- @param    params    The aliases Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:aliases(params)
  return self:requestEndpoint("Aliases", params)
end

-------------------------------------------------------------------------------
-- Function to provide a snapshot about number of shards
--
-- @usage
-- params["node_id"]        = (list) A comma-separated list of node IDs or names to limit the returned information
--       ["bytes"]          = (enum) The unit in which to display byte values (b,k,m,g)
--       ["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["h"]              = (list) Comma-separated list of column names to display
--       ["help"]           = (boolean) Return help information
--       ["v"]              = (boolean) Verbose mode. Display column headers
--
-- @param    params    The allocation Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:allocation(params)
  return self:requestEndpoint("Allocation", params)
end

-------------------------------------------------------------------------------
-- Function to provide quick access to document count of entire cluster, or individual indices
--
-- @usage
-- params["index"]          = (list) A comma-separated list of index names to limit the returned information
--       ["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["h"]              = (list) Comma-separated list of column names to display
--       ["help"]           = (boolean) Return help information (default: false)
--       ["v"]              = (boolean) Verbose mode. Display column headers (default: false) 
--
-- @param    params    The allocation Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:count(params)
  return self:requestEndpoint("Count", params)
end

-------------------------------------------------------------------------------
-- Function to get usage of heap memory
--
-- @usage
-- params["fields"]         = (list) A comma-separated list of fields to return in the output
--       ["bytes"]          = (enum) The unit in which to display byte values (b,k,m,g)
--       ["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["h"]              = (list) Comma-separated list of column names to display
--       ["help"]           = (boolean) Return help information (default: false)
--       ["v"]              = (boolean) Verbose mode. Display column headers (default: false)
--
-- @param    params    The fielddata Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:fielddata(params)
  return self:requestEndpoint("FieldData", params)
end

-------------------------------------------------------------------------------
-- Function to get health
--
-- @usage
-- params["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["h"]              = (list) Comma-separated list of column names to display
--       ["help"]           = (boolean) Return help information (default: false)
--       ["ts"]             = (boolean) Set to false to disable timestamping (default: true)
--       ["v"]              = (boolean) Verbose mode. Display column headers (default: false)
--
-- @param    params    The health Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:health(params)
  return self:requestEndpoint("Health", params)
end

-------------------------------------------------------------------------------
-- Help function
--
-- @usage
-- params["help"] = (boolean) Return help information(default: false)
--
-- @param    params    The help Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:help(params)
  return self:requestEndpoint("Help", params)
end

-------------------------------------------------------------------------------
-- Indices function
--
-- @usage
-- params["index"]          = (list) A comma-separated list of index names to limit the returned information
--       ["bytes"]          = (enum) The unit in which to display byte values (b,k,m,g)
--       ["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["h"]              = (list) Comma-separated list of column names to display
--       ["help"]           = (boolean) Return help information (default: false)
--       ["pri"]            = (boolean) Set to true to return stats only for primary shards (default: false)
--       ["v"]              = (boolean) Verbose mode. Display column headers (default: false)
--
-- @param    params    The indices Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:indices(params)
  return self:requestEndpoint("Indices", params)
end

-------------------------------------------------------------------------------
-- Master function
--
-- @usage
-- params["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["h"]              = (list) Comma-separated list of column names to display
--       ["help"]           = (boolean) Return help information (default: false)
--       ["v"]              = (boolean) Verbose mode. Display column headers (default: false)
--
-- @param    params    The master Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:master(params)
  return self:requestEndpoint("Master", params)
end

-------------------------------------------------------------------------------
-- NodeAttrs function
--
-- @usage
-- params["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["h"]              = (list) Comma-separated list of column names to display
--       ["help"]           = (boolean) Return help information (default: false)
--       ["v"]              = (boolean) Verbose mode. Display column headers (default: false)
--
-- @param    params    The nodeAttrs Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:nodeAttrs(params)
  return self:requestEndpoint("NodeAttrs", params)
end

-------------------------------------------------------------------------------
-- Nodes function
--
-- @usage
-- params["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["h"]              = (list) Comma-separated list of column names to display
--       ["help"]           = (boolean) Return help information (default: false)
--       ["v"]              = (boolean) Verbose mode. Display column headers (default: false)
--
-- @param    params    The nodes Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:nodes(params)
  return self:requestEndpoint("Nodes", params)
end

-------------------------------------------------------------------------------
-- PendingTasks function
--
-- @usage
-- params["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["h"]              = (list) Comma-separated list of column names to display
--       ["help"]           = (boolean) Return help information (default: false)
--       ["v"]              = (boolean) Verbose mode. Display column headers (default: false)
--
-- @param    params    The pendingTasks Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:pendingTasks(params)
  return self:requestEndpoint("PendingTasks", params)
end

-------------------------------------------------------------------------------
-- Plugins function
--
-- @usage
-- params["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["h"]              = (list) Comma-separated list of column names to display
--       ["help"]           = (boolean) Return help information (default: false)
--       ["v"]              = (boolean) Verbose mode. Display column headers (default: false)
--
-- @param    params    The plugins Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:plugins(params)
  return self:requestEndpoint("Plugins", params)
end

-------------------------------------------------------------------------------
-- Recovery function
--
-- @usage
-- params["index"]          = (list) A comma-separated list of index names to limit the returned information
--       ["bytes"]          = (enum) The unit in which to display byte values (b,k,m,g)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["h"]              = (list) Comma-separated list of column names to display
--       ["help"]           = (boolean) Return help information (default: false)
--       ["v"]              = (boolean) Verbose mode. Display column headers (default: false)
--
-- @param    params    The recovery Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:recovery(params)
  return self:requestEndpoint("Recovery", params)
end

-------------------------------------------------------------------------------
-- Repositories function
--
-- @usage
-- params["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["h"]              = (list) Comma-separated list of column names to display
--       ["help"]           = (boolean) Return help information (default: false)
--       ["v"]              = (boolean) Verbose mode. Display column headers (default: false)
--
-- @param    params    The repositories Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:repositories(params)
  return self:requestEndpoint("Repositories", params)
end

-------------------------------------------------------------------------------
-- Segments function
--
-- @usage
-- params["index"] = (list) A comma-separated list of index names to limit the returned information
--       ["h"]     = (list) Comma-separated list of column names to display
--       ["help"]  = (boolean) Return help information (default: false)
--       ["v"]     = (boolean) Verbose mode. Display column headers (default: false)
--
-- @param    params    The segments Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:segments(params)
  return self:requestEndpoint("Segments", params)
end

-------------------------------------------------------------------------------
-- Shards function
--
-- @usage
-- params["index"]          = (list) A comma-separated list of index names to limit the returned information
--       ["bytes"]          = (enum) The unit in which to display byte values
--       ["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["h"]              = (list) Comma-separated list of column names to display
--       ["help"]           = (boolean) Return help information (default: false)
--       ["v"]              = (boolean) Verbose mode. Display column headers (default: false)
--
-- @param    params    The shards Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:shards(params)
  return self:requestEndpoint("Shards", params)
end

-------------------------------------------------------------------------------
-- Snapshots function
--
-- @usage
-- params["repository"]         = (list) Name of repository from which to fetch the snapshot information (Required)
--       ["local"]              = (bool) Return local information, do not retrieve the state from master node
--       (default: false)
--       ["ignore_unavailable"] = (boolean) Set to true to ignore unavailable snapshots (default: false)
--       ["master_timeout"]     = (time) Explicit operation timeout for connection to master node
--       ["h"]                  = (list) Comma-separated list of column names to display
--       ["help"]               = (boolean) Return help information (default: false)
--       ["v"]                  = (boolean) Verbose mode. Display column headers (default: false)
--
-- @param    params    The snapshots Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:snapshots(params)
  return self:requestEndpoint("Snapshots", params)
end

-------------------------------------------------------------------------------
-- Thread pool function
--
-- @usage
-- params["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["h"]              = (list) Comma-separated list of column names to display
--       ["help"]           = (boolean) Return help information (default: false)
--       ["v"]              = (boolean) Verbose mode. Display column headers (default: false)
--       ["full_id"]        = (boolean) Enables displaying the complete node ids (default: false)
--
-- @param    params    The threadPool Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:threadPool(params)
  return self:requestEndpoint("ThreadPool", params)
end

-------------------------------------------------------------------------------
-- @local
-- Returns an instance of Cat class
-------------------------------------------------------------------------------
function Cat:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Cat
