--- The Indices class
-- @classmod Indices
-- @author Dhaval Kapil

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Indices = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The transport module
Indices.transport = nil

-------------------------------------------------------------------------------
-- Function to request an endpoint instance for a particular type of request
--
-- @param   endpoint        The string denoting the endpoint
-- @param   params          The parameters to be passed
-- @param   endpointParams  The endpoint params passed while object creation
--
-- @return  table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:requestEndpoint(endpoint, params, endpointParams)
  local Endpoint = require("elasticsearch.endpoints.Indices." .. endpoint)
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
-- Delete Alias function
--
-- @usage
-- params["index"]          = (list) A comma-separated list of index names (supports wildcards); use '_all' for
--       all indices (Required)
--       ["name"]           = (list) A comma-separated list of aliases to delete (supports wildcards); use '_all'
--       to delete all aliases for the specified indices. (Required)
--       ["timeout"]        = (time) Explicit timestamp for the document
--       ["master_timeout"] = (time) Specify timeout for connection to master
--
-- @param    params    The delete alias Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:deleteAlias(params)
  return self:requestEndpoint("DeleteAlias", params)
end

-------------------------------------------------------------------------------
-- Exists Alias function
--
-- @usage
-- params["index"]              = (list) A comma-separated list of index names to filter aliases
--       ["name"]               = (list) A comma-separated list of alias names to return
--       ["ignore_unavailable"] = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]   = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       [open,closed])
--       ["local"]              = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--
-- @param    params    The exists alias Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:existsAlias(params)
  local temp, err = self:requestEndpoint("ExistsAlias", params)
  if err == 200 then
    -- Successfull request
    return true
  elseif err:match("Invalid response code") then
    -- Wrong response code
    return false
  else
    -- Some other error, notify user
    return nil, err
  end
end

-------------------------------------------------------------------------------
-- Get Alias function
--
-- @usage
-- params["index"]              = (list) A comma-separated list of index names to filter aliases
--       ["name"]               = (list) A comma-separated list of alias names to return
--       ["ignore_unavailable"] = (boolean) Whether specified concrete indices should be ignored when unavailable
--       (missing or closed)
--       ["allow_no_indices"]   = (boolean) Whether to ignore if a wildcard indices expression resolves into no
--       concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open,
--       [open,closed])
--       ["local"]              = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--
-- @param    params    The get alias Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:getAlias(params)
  return self:requestEndpoint("GetAlias", params)
end

-------------------------------------------------------------------------------
-- Put Alias function
--
-- @usage
-- params["index"]          = (list) A comma-separated list of index names the alias should point to (supports
--       wildcards); use '_all' to perform the operation on all indices. (Required)
--       ["name"]           = (string) The name of the alias to be created or updated (Required)
--       ["timeout"]        = (time) Explicit timestamp for the document
--       ["master_timeout"] = (time) Specify timeout for connection to master
--       ["body"]           = The settings for the alias, such as 'routing' or 'filter'
--
-- @param    params    The put alias Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:putAlias(params)
  return self:requestEndpoint("PutAlias", params)
end

-------------------------------------------------------------------------------
-- Get Aliases function
--
-- @usage
-- params["index"]   = (list) A comma-separated list of index names to filter aliases
--       ["name"]    = (list) A comma-separated list of alias names to filter
--       ["timeout"] = (time) Explicit operation timeout
--       ["local"]   = (boolean) Return local information, do not retrieve the state from master node (default:
--       false)
--
-- @param    params    The get aliases Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:getAliases(params)
  return self:requestEndpoint("GetAliases", params)
end

-------------------------------------------------------------------------------
-- Update Aliases function
--
-- @usage
-- params["timeout"]        = (time) Request timeout
--       ["master_timeout"] = (time) Specify timeout for connection to master
--       ["body"]           = The definition of 'actions' to perform
--
-- @param    params    The update aliases Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:updateAliases(params)
  return self:requestEndpoint("updateAliases", params)
end

-------------------------------------------------------------------------------
-- Function to check whether an index exists or not
--
-- @usage
-- params["index"] = (list) A comma-separated list of indices to check (Required)
--
-- @param    params    The exists Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:exists(params)
  local temp, err = self:requestEndpoint("Exists", params)
  if err == 200 then
    -- Successfull request
    return true
  elseif err:match("Invalid response code") then
    -- Wrong response code
    return false
  else
    -- Some other error, notify user
    return nil, err
  end
end

-------------------------------------------------------------------------------
-- Function to get an index
--
-- @usage
-- params["index"] = (list) A comma-separated list of indices to check (Required)
--       ["feature"] = (list) A comma-separated list of features to return
--       ["ignore_unavailable"] = (bool) Whether specified concrete indices should be ignored when unavailable (missing or closed)
--       ["allow_no_indices"]   = (bool) Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]   = (enum) Whether to expand wildcard expression to concrete indices that are open, closed or both.
--       ["local"]   = (bool) Return local information, do not retrieve the state from master node (default: false)
--
-- @param    params    The get Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:get(params)
  return self:requestEndpoint("Get", params)
end

-------------------------------------------------------------------------------
-- Function to delete indices
--
-- @usage
-- params["index"]   = (list) A comma-separated list of indices to delete; use '_all' or empty string to delete all indices
--       ["timeout"] = (time) Explicit operation timeout
--
-- @param    params    The delete Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:delete(params)
  return self:requestEndpoint("Delete", params)
end

-------------------------------------------------------------------------------
-- Function to create an index
--
-- @usage
-- params["index"]   = (string) The name of the index (Required)
--       ["timeout"] = (time) Explicit operation timeout
--       ["body"]    = (time) Explicit operation timeout
--
-- @param    params    The create Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:create(params)
  return self:requestEndpoint("Create", params)
end

-------------------------------------------------------------------------------
-- Function to optimize an index
--
-- @usage
-- params["index"]                = (list) A comma-separated list of index names; use '_all' or empty string to perform the operation on all indices
--       ["flush"]                = (boolean) Specify whether the index should be flushed after performing the operation (default: true)
--       ["max_num_segments"]     = (number) The number of segments the index should be merged into (default: dynamic)
--       ["only_expunge_deletes"] = (boolean) Specify whether the operation should only expunge deleted documents
--       ["operation_threading"]  = () TODO: ?
--       ["refresh"]              = (boolean) Specify whether the index should be refreshed after performing the operation (default: true)
--       ["wait_for_merge"]       = (boolean) Specify whether the request should block until the merge process is finished (default: true)
--       ["ignore_unavailable"]   = (bool) Whether specified concrete indices should be ignored when unavailable (missing or closed)
--       ["allow_no_indices"]     = (bool) Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]     = (enum) Whether to expand wildcard expression to concrete indices that are open, closed or both.
--
-- @param    params    The optimize Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:optimize(params)
  return self:requestEndpoint("Optimize", params)
end

-------------------------------------------------------------------------------
-- Function to open an index
--
-- @usage
-- params["index"]   = (string) The name of the index (Required)
--       ["timeout"] = (time) Explicit operation timeout
--
-- @param    params    The open Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:open(params)
  return self:requestEndpoint("Open", params)
end

-------------------------------------------------------------------------------
-- Function to close an index
--
-- @usage
-- params["index"]   = (string) The name of the index (Required)
--       ["timeout"] = (time) Explicit operation timeout
--
-- @param    params    The open Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:close(params)
  return self:requestEndpoint("Close", params)
end

-------------------------------------------------------------------------------
-- Function to perform analysis process on a text
--
-- @usage
-- params["index"]        = (string) The name of the index to scope the operation
--       ["analyzer"]     = (string) The name of the analyzer to use
--       ["field"]        = (string) Use the analyzer configured for this field (instead of passing the analyzer name)
--       ["filters"]      = (list) A comma-separated list of filters to use for the analysis
--       ["prefer_local"] = (boolean) With 'true', specify that a local shard should be used if available, with 'false', use a random shard (default: true)
--       ["text"]         = (string) The text on which the analysis should be performed (when request body is not used)
--       ["tokenizer"]    = (string) The name of the tokenizer to use for the analysis
--       ["format"]       = (enum) Format of the output
--       ["body"]         = (enum) Format of the output
--
-- @param    params    The analyze Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:analyze(params)
  return self:requestEndpoint("Analyze", params)
end

-------------------------------------------------------------------------------
-- Function to refresh an index
--
-- @usage
--
-- params["index"]               = (list) A comma-separated list of index names; use '_all' or empty string to perform the operation on all indices
--       ["operation_threading"] = () TODO: ?
--       ["ignore_unavailable"]  = (bool) Whether specified concrete indices should be ignored when unavailable (missing or closed)
--       ["allow_no_indices"]    = (bool) Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes '_all' string or when no indices have been specified)
--       ["expand_wildcards"]    = (enum) Whether to expand wildcard expression to concrete indices that are open, closed or both.
--
-- @param    params    The refresh Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:refresh(params)
  return self:requestEndpoint("Refresh", params)
end

-------------------------------------------------------------------------------
-- Function to get the status of an index
--
-- @usage
-- params["index"]               = (list) A comma-separated list of index names; use '_all' or empty string to perform the operation on all indices
--       ["ignore_indices"]      = (enum) When performed on multiple indices, allows to ignore 'missing' ones
--       ["operation_threading"] = () TODO: ?
--       ["recovery"]            = (boolean) Return information about shard recovery
--       ["snapshot"]            = (boolean) TODO: ?
--
-- @param    params    The status Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:status(params)
  return self:requestEndpoint("Status", params)
end

-------------------------------------------------------------------------------
-- Function to seal an index
--
-- @usage
-- params["index"]   = (string) The name of the index
--
-- @param    params    The seal Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:seal(params)
  return self:requestEndpoint("Seal", params)
end

-------------------------------------------------------------------------------
-- Returns an instance of Indices class
-------------------------------------------------------------------------------
function Indices:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Indices
