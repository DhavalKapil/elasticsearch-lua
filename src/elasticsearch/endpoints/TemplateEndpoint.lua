-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local TemplateEndpoint = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

TemplateEndpoint.id = nil
TemplateEndpoint.body = nil

-------------------------------------------------------------------------------
-- Function used to set the params to be sent as GET parameters
--
-- @param   params  The params provided by the user
--
-- @return  string  A string if an error is found otherwise nil
-------------------------------------------------------------------------------
function TemplateEndpoint:setParams(params)
  -- Clearing parameters
  self.id = nil
  self.params = {}
  self.body = nil
  for i, v in pairs(params) do
    if i == "id" then
      self.id = v
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
-- Returns an instance of TemplateEndpoint class
-------------------------------------------------------------------------------
function TemplateEndpoint:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return TemplateEndpoint
