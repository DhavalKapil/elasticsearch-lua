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
-- Returns an instance of Cat class
-------------------------------------------------------------------------------
function Cat:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Cat