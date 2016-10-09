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
--       ["master_timeout"] = (time) Explicit operation timeout for connection to master node
--       ["h"]              = (list) Comma-separated list of column names to display
--
-- @param    params    The stats Parameters
--
-- @return   table     Error or the data received from the elasticsearch server
-------------------------------------------------------------------------------
function Cat:aliases(params)
  return self:requestEndpoint("Aliases", params)
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