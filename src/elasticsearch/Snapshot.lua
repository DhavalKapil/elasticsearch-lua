--- The Snapshot class
-- @classmod Snapshot
-- @author Dhaval Kapil

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Snapshot = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The transport module
Snapshot.transport = nil

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
function Snapshot:requestEndpoint(endpoint, params, endpointParams)
  local Endpoint = require("elasticsearch.endpoints.Snapshot." .. endpoint)
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
-- Create Repository function
--
-- @usage
-- params["repository"]     = (string) A repository name (Required)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["timeout"]        = (time) Explicit operation timeout
--       ["verify"]         = (boolean) Whether to verify the repository after creation
--       ["body"]           = The repository definition
--
-- @param    params    The createRepository Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Snapshot:createRepository(params)
  return self:requestEndpoint("CreateRepository", params)
end

-------------------------------------------------------------------------------
-- Delete Repository function
--
-- @usage
-- params["repository"]     = (list) A comma-separated list of repository names (Required)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["timeout"]        = (time) Explicit operation timeout
--
-- @param    params    The deleteRepository Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Snapshot:deleteRepository(params)
  return self:requestEndpoint("DeleteRepository", params)
end

-------------------------------------------------------------------------------
-- Get Repository function
--
-- @usage
-- params["repository"]     = (list) A comma-separated list of repository names
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["local"]          = (boolean) Return local information, do not retrieve the state from master node
--       (default: false)
--
-- @param    params    The getRepository Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Snapshot:getRepository(params)
  return self:requestEndpoint("GetRepository", params)
end

-------------------------------------------------------------------------------
-- Create function
--
-- @usage
-- params["repository"]          = (string) A repository name (Required)
--       ["snapshot"]            = (string) A snapshot name (Required)
--       ["master_timeout"]      = (time) Explicit operation timeout for connection to master node
--       ["wait_for_completion"] = (boolean) Should this request wait until the operation has completed before
--       returning (default: false)
--       ["body"]                = The snapshot definition
--
-- @param    params    The create Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Snapshot:create(params)
  return self:requestEndpoint("Create", params)
end

-------------------------------------------------------------------------------
-- Delete function
--
-- @usage
-- params["repository"]     = (string) A repository name (Required)
--       ["snapshot"]       = (string) A snapshot name (Required)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--
-- @param    params    The delete Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Snapshot:delete(params)
  return self:requestEndpoint("Delete", params)
end

-------------------------------------------------------------------------------
-- Get function
--
-- @usage
-- params["repository"]     = (string) A repository name (Required)
--       ["snapshot"]       = (string) A snapshot name (Required)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--
-- @param    params    The get Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Snapshot:get(params)
  return self:requestEndpoint("Get", params)
end

-------------------------------------------------------------------------------
-- Restore function
--
-- @usage
-- params["repository"]          = (string) A repository name (Required)
--       ["snapshot"]            = (string) A snapshot name (Required)
--       ["master_timeout"]      = (time) Explicit operation timeout for connection to master node
--       ["wait_for_completion"] = (boolean) Should this request wait until the operation has completed before
--       returning (default: false)
--       ["body"]                = Details of what to restore
--
-- @param    params    The restore Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Snapshot:restore(params)
  return self:requestEndpoint("Restore", params)
end

-------------------------------------------------------------------------------
-- Status function
--
-- @usage
-- params["repository"]     = (string) A repository name
--       ["snapshot"]       = (list) A comma-separated list of snapshot names
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--
-- @param    params    The status Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Snapshot:status(params)
  return self:requestEndpoint("Status", params)
end

-------------------------------------------------------------------------------
-- Verify Repository function
--
-- @usage
-- params["repository"]     = (string) A repository name (Required)
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["timeout"]        = (time) Explicit operation timeout
--
-- @param    params    The verify repository Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Snapshot:verifyRepository(params)
  return self:requestEndpoint("VerifyRepository", params)
end

-------------------------------------------------------------------------------
-- @local
-- Returns an instance of Snapshot class
-------------------------------------------------------------------------------
function Snapshot:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Snapshot
