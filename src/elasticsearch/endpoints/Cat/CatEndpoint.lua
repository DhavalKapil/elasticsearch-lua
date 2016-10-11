-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local CatEndpoint = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

CatEndpoint.name = nil
CatEndpoint.nodeId = nil
CatEndpoint.index = nil
CatEndpoint.repository = nil
CatEndpoint.fields = nil
CatEndpoint.body = nil

-------------------------------------------------------------------------------
-- Function used to set the params to be sent as GET parameters
--
-- @param   params  The params provided by the user
--
-- @return  string  A string if an error is found otherwise nil
-------------------------------------------------------------------------------
function CatEndpoint:setParams(params)
  -- Clearing parameters
  self.name = nil
  self.node_id = nil
  self.index = nil
  self.repository = nil
  self.fields = nil
  self.params = {}
  self.body = nil
  for i, v in pairs(params) do
    if i == "name" then
      self.name = v
    elseif i == "node_id" then
      self.nodeId = v
    elseif i == "index" then
      self.index = v
    elseif i == "repository" then
      self.repository = v
    elseif i == "fields" then
      self.fields = v
    elseif i == "body" then
      self:setBody(v)
    else
      local err = self:setAllowedParam(i, v)
      if err ~= nil then
        return err
      end
    end
  end
end

-------------------------------------------------------------------------------
-- Returns an instance of CatEndpoint class
-------------------------------------------------------------------------------
function CatEndpoint:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return CatEndpoint
