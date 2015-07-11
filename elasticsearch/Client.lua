-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Settings = require "Settings"
local Cluster = require "Cluster"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Client = {}

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

-- The Settings instance
Client.settings = nil

-- The cluster instance
Client.cluster = nil;

-------------------------------------------------------------------------------
-- Function to request an endpoint instance for a particular type of request
--
-- @param   endpoint        The string denoting the endpoint
-- @param   params          The parameters to be passed
-- @params  endpointParams  The endpoint params passed while object creation
--
-- @return  table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:requestEndpoint(endpoint, params, endpointParams)
  local Endpoint = require("endpoints." .. endpoint)
  local endpoint = Endpoint:new{
    transport = self.settings.transport,
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
-- Function to get information regarding the Elasticsearch server
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:info()
  return self:requestEndpoint("Info")
end

-------------------------------------------------------------------------------
-- Function to ping to check whether there exists any alive connection to
-- elasticsearch server or not
--
-- @return  boolean   Whether we have any alive connection or not
-------------------------------------------------------------------------------
function Client:ping()
  local temp, err = self:requestEndpoint("Ping")
  return err == nil
end

-------------------------------------------------------------------------------
-- Function to get a particular document
--
-- @param    params    The get Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:get(params)
  return self:requestEndpoint("Get", params)
end

-------------------------------------------------------------------------------
-- Function to check whether a document exists or not
--
-- @param    params    The exists Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:exists(params)
  local temp, err = self:requestEndpoint("Get", params, {
    checkOnlyExistance = true
  })
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
-- Function to get only the _source of a particular document
--
-- @param    params    The get Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:getSource(params)
  return self:requestEndpoint("Get", params, {
    sourceOnly = true
  })
end

-------------------------------------------------------------------------------
-- Function to get multiple document
--
-- @param    params    The mget Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:mget(params)
  return self:requestEndpoint("Mget", params)
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
-- Function to get the count
--
-- @param    params    The count Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:count(params)
  return self:requestEndpoint("Count", params)
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
-- Function to implement the search exists functionality
--
-- @param    params    The searchExists Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:searchExists(params)
  return self:requestEndpoint("SearchExists", params)
end

-------------------------------------------------------------------------------
-- Function to search the shards
--
-- @param    params    The searchShards Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:searchShards(params)
  return self:requestEndpoint("SearchShards", params)
end

-------------------------------------------------------------------------------
-- Function to search the shards
--
-- @param    params    The searchTemplate Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:searchTemplate(params)
  return self:requestEndpoint("SearchTemplate", params)
end

-------------------------------------------------------------------------------
-- Function for scrolled searching
--
-- @param    params    The scroll Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:scroll(params)
  return self:requestEndpoint("Scroll", params)
end

-------------------------------------------------------------------------------
-- Function to clear a scroll
--
-- @param    params    The clearScroll Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:clearScroll(params)
  return self:requestEndpoint("Scroll", params, {
    clear = true;
  })
end

-- Function to search multiple document
--
-- @param    params    The msearch Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:msearch(params)
  return self:requestEndpoint("Msearch", params)
end

-------------------------------------------------------------------------------
-- Function to create an index
--
-- @param    params    The create Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:create(params)
  return self:requestEndpoint("Index", params, {
    createIfAbsent = true
  })
end

-------------------------------------------------------------------------------
-- Function to suggest similar looking terms
--
-- @param    params    The suggest Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:suggest(params)
  return self:requestEndpoint("Suggest", params)
end

-------------------------------------------------------------------------------
-- Function to compute a score explanation for a query and a specific document
--
-- @param    params    The explain Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:explain(params)
  return self:requestEndpoint("Explain", params)
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
-- Function to get the field stats
--
-- @param    params    The fieldStats Parameters
--
-- @return   table     Error or the data recevied from the elasticsearch server
-------------------------------------------------------------------------------
function Client:fieldStats(params)
  return self:requestEndpoint("FieldStats", params)
end

-------------------------------------------------------------------------------
-- Initializes the Client parameters
-------------------------------------------------------------------------------
function Client:setClientParameters()
  self.cluster = self.settings.cluster;
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
  o:setClientParameters()
  return o
end

return Client
