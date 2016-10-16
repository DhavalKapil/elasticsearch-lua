-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local Endpoint = require "elasticsearch.endpoints.Endpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local SnapshotEndpoint = Endpoint:new()

-------------------------------------------------------------------------------
-- Declaring instance variables
-------------------------------------------------------------------------------

SnapshotEndpoint.repository = nil
SnapshotEndpoint.snapshot = nil
SnapshotEndpoint.body = nil

-------------------------------------------------------------------------------
-- Function used to set the params to be sent as GET parameters
--
-- @param   params  The params provided by the user
--
-- @return  string  A string if an error is found otherwise nil
-------------------------------------------------------------------------------
function SnapshotEndpoint:setParams(params)
  -- Clearing parameters
  self.repository = nil
  self.snapshot = nil
  self.params = {}
  self.body = nil
  for i, v in pairs(params) do
    if i == "repository" then
      self.repository = v
    elseif i == "snapshot" then
      self.snapshot = v
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
-- Returns an instance of SnapshotEndpoint class
-------------------------------------------------------------------------------
function SnapshotEndpoint:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return SnapshotEndpoint
