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
-- Returns an instance of Snapshot class
-------------------------------------------------------------------------------
function Snapshot:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Snapshot
