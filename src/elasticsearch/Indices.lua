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
-- @return  table     Error or the data recevied from the elasticsearch server
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
-- Function to check whether an index exists or not
--
-- @usage
-- params["index"] = (list) A comma-separated list of indices to check (Required)
--
-- @param    params    The exists Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:exists(params)
  local temp, err = self:requestEndpoint("Exists", params)
  if err == nil then
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:analyze(params)
  return self:requestEndpoint("Analyze", params)
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
-- @return   table     Error or the data recevied from the elasticsearch server
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
-- @return   table     Error or the data recevied from the elasticsearch server
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