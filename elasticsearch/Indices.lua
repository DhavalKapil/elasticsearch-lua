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
-- @params  endpointParams  The endpoint params passed while object creation
--
-- @return  table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:requestEndpoint(endpoint, params, endpointParams)
  local Endpoint = require("endpoints.Indices." .. endpoint)
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
-- Function to check whether an index exists or not
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
-- @param    params    The delete Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Indices:delete(params)
  return self:requestEndpoint("Delete", params)
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