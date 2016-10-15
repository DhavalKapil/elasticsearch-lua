-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local IndicesEndpoint = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

IndicesEndpoint.name = nil
IndicesEndpoint.index = nil
IndicesEndpoint.type = nil
IndicesEndpoint.fields = nil
IndicesEndpoint.isSynced = nil
IndicesEndpoint.feature = nil
IndicesEndpoint.metric = nil
IndicesEndpoint.body = nil

-------------------------------------------------------------------------------
-- Function used to set the params to be sent as GET parameters
--
-- @param   params  The params provided by the user
--
-- @return  string  A string if an error is found otherwise nil
-------------------------------------------------------------------------------
function IndicesEndpoint:setParams(params)
  -- Clearing parameters
  self.name = nil
  self.index = nil
  self.type = nil
  self.fields = nil
  self.isSynced = nil
  self.feature = nil
  self.metric = nil
  self.params = {}
  self.body = nil
  for i, v in pairs(params) do
    if i == "name" then
      self.name = v
    elseif i == "index" then
      self.index = v
    elseif i == "type" then
      self.type = v
    elseif i == "fields" then
      self.fields = v
    elseif i == "sync" then
      self.isSynced = v
    elseif i == "feature" then
      self.feature = v
    elseif i == "metric" then
      self.metric = v
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
-- Returns an instance of IndicesEndpoint class
-------------------------------------------------------------------------------
function IndicesEndpoint:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return IndicesEndpoint
