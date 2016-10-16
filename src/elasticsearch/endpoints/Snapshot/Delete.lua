-------------------------------------------------------------------------------
-- Importing modules
-------------------------------------------------------------------------------
local SnapshotEndpoint = require "elasticsearch.endpoints.Snapshot.SnapshotEndpoint"

-------------------------------------------------------------------------------
-- Declaring module
-------------------------------------------------------------------------------
local Delete = SnapshotEndpoint:new()

-------------------------------------------------------------------------------
-- Declaring Instance variables
-------------------------------------------------------------------------------

-- The parameters that are allowed to be used in params
Delete.allowedParams = {
  ["master_timeout"] = true
}

-------------------------------------------------------------------------------
-- Function to calculate the http request method
--
-- @return    string    The HTTP request method
-------------------------------------------------------------------------------
function Delete:getMethod()
  return "DELETE"
end

-------------------------------------------------------------------------------
-- Function to calculate the URI
--
-- @return    string    The URI
-------------------------------------------------------------------------------
function Delete:getUri()
  if self.repository == nil then
    return nil, "repository not specified for Delete"
  elseif self.snapshot == nil then
    return nil, "snapshot not specified for Delete"
  end
  local uri = "/_snapshot/" .. self.repository .. "/" .. self.snapshot
  return uri
end

-------------------------------------------------------------------------------
-- Returns an instance of Delete class
-------------------------------------------------------------------------------
function Delete:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Delete
