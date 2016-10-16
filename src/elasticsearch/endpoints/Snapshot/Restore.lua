-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local SnapshotEndpoint = require "elasticsearch.endpoints.Snapshot.SnapshotEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Restore = SnapshotEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Restore.allowedParams = {
  ["master_timeout"] = true,
  ["wait_for_completion"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Restore:getMethod()
  return "POST"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Restore:getUri()
  if self.repository == nil then
    return nil, "repository not specified for Restore"
  elseif self.snapshot == nil then
    return nil, "snapshot not specified for Restore"
  end
  local uri = "/_snapshot/" .. self.repository .. "/" .. self.snapshot .. "/_restore"
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Restore class
-------------------------------------------------------------------------------
function Restore:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Restore
