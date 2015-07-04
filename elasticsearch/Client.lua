-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Settings = require "Settings"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Client = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The Settings instance
Client.settings = nil

-------------------------------------------------------------------------------
-- Function to request an endpoint instance for a particular type of request
--
-- @param   endpoint  The string denoting the endpoint
-- @param   params    The parameters to be passed
--
-- @return  table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:requestEndpoint(endpoint, params)
  local Endpoint = require("endpoints." .. endpoint)
  local endpoint = Endpoint:new{
    transport = self.settings.transport
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
-- Function to get information regarding the Elasticsearch server
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:info()
  return self:requestEndpoint("Info")
end

-------------------------------------------------------------------------------
-- Function to get a particular document
--
-- @param    params    The search Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:get(params)
  return self:requestEndpoint("Get", params)
end

-------------------------------------------------------------------------------
-- Function to index a particular document
--
-- @param    params    The index Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:index(params)
  return self:requestEndpoint("Index", params)
end

-------------------------------------------------------------------------------
-- Function to delete a particular document
--
-- @param    params    The delete Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:delete(params)
  return self:requestEndpoint("Delete", params)
end

-------------------------------------------------------------------------------
-- Function to search a particular document
--
-- @param    params    The search Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:search(params)
  return self:requestEndpoint("Search", params)
end

-------------------------------------------------------------------------------
-- Function to update a particular document
--
-- @param    params    The update Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:update(params)
  return self:requestEndpoint("Update", params)
end

-------------------------------------------------------------------------------
-- Returns an instance of Client class
-------------------------------------------------------------------------------
function Client:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.hosts = o.hosts or {{}}
  o.params = o.params or {}
  if type(o.hosts) == "table" and o.hosts[1] == nil then
    local temp = o.hosts
    o.hosts = {}
    o.hosts[1] = temp
  end
  o.settings = Settings:new{
    user_hosts = o.hosts,
    user_params = o.params
  }
  return o
end

return Client
